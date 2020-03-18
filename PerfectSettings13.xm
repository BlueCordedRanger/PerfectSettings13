#import "PerfectSettings13.h"

#import <Cephei/HBPreferences.h>

static HBPreferences *pref;
static BOOL disableEdgeToEdgeCells;
static BOOL circleIcons;

// ------------------------- BETTER SETTINGS UI -------------------------

%group disableEdgeToEdgeCellsGroup

	%hook PSListController

	- (void)setEdgeToEdgeCells: (BOOL)arg
	{
		%orig(NO);
	}

	- (BOOL)_isRegularWidth
	{
		return YES;
	}

	%end

%end

// ------------------------- CIRCLE ICONS -------------------------

%group circleIconsGroup

	%hook PSTableCell

	- (void)layoutSubviews
	{
		%orig;

		if(self && self.imageView && self.imageView.layer)
		{
			self.imageView.layer.cornerRadius = 14.5; // full width = 29
			self.imageView.layer.masksToBounds = YES;
		}
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectsettings13prefs"];

		[pref registerBool: &disableEdgeToEdgeCells default: YES forKey: @"disableEdgeToEdgeCells"];
		[pref registerBool: &circleIcons default: YES forKey: @"circleIcons"];

		if(disableEdgeToEdgeCells) %init(disableEdgeToEdgeCellsGroup);
		if(circleIcons) %init(circleIconsGroup);
	}
}