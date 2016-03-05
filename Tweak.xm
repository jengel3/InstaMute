#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "substrate.h"
#import "IGHeaders.h"
#import "InstaHelper.h"

static NSMutableArray *muted = nil;
BOOL enabled = YES;

static NSString *instaMute = @"Mute";
static NSString *instaUnmute = @"Unmute";
static NSString *prefsLoc = @"/User/Library/Preferences/com.jake0oo0.instamute.plist";

static void initPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] init];
	NSMutableArray *vals = [[NSMutableArray alloc] init];
	[prefs setValue:@YES forKey:@"enabled"];
	[prefs setValue:vals forKey:@"muted_users"];
	[prefs writeToFile:prefsLoc atomically:NO];
}

static void loadPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];

	if (!muted) {
		muted = [[NSMutableArray alloc] init];
	}
	if (prefs) {
		enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
		[muted removeAllObjects];
		[muted addObjectsFromArray:[prefs objectForKey:@"muted_users"]];
	} else {
		initPrefs();
		loadPrefs();
	}

	[prefs release];
}

%group instaHooks

%hook IGFeedViewController_DEPRECATED
- (void)reloadWithNewObjects:(NSArray*)items context:(id)arg2 synchronus:(char)arg3 forceAnimated:(char)arg4 completionBlock:(/*^block*/id)arg5 {
if (!enabled) return %orig;
BOOL isMainFeed = [self isKindOfClass:[%c(IGMainFeedViewController) class]];
if (!isMainFeed) return %orig;

NSArray *final = [self getMutedList:items];

return %orig(final, arg2, arg3, arg4, arg5);
}

- (void)reloadWithNewObjects:(NSArray*)items {
  if (!enabled) return %orig;
  BOOL isMainFeed = [self isKindOfClass:[%c(IGMainFeedViewController) class]];
  if (!isMainFeed) return %orig;

  NSArray *final = [self getMutedList:items];
  return %orig(final);
}


%new
- (NSArray*)getMutedList:(NSArray*)items {
  NSMutableArray *origCopy = [items mutableCopy];

  NSMutableArray *toRemove = [[NSMutableArray alloc] init];
  for (IGFeedItem *item in items) {
    BOOL contains = [muted containsObject:item.user.username];
    if (contains) {
      [toRemove addObject:item];
    }
  }

  for (IGFeedItem *removable in toRemove) {
    [origCopy removeObject:removable];
  }

  return [origCopy copy];
}
%end

%hook IGActionSheetCallbackProxy
-(void)actionSheetDismissedWithButtonTitled:(NSString*)title {
  if (enabled) {
    UIViewController *currentController = [InstaHelper currentController];
    BOOL isProfileView = [currentController isKindOfClass:[%c(IGUserDetailViewController) class]];
    if (isProfileView) {
      IGUserDetailViewController *userView = (IGUserDetailViewController *) currentController;
      if ([title isEqualToString:instaMute]) {
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
        [muted addObject:userView.user.username];
        [prefs setValue:muted forKey:@"muted_users"];
        [prefs writeToFile:prefsLoc atomically:NO];
        return;
      } else if ([title isEqualToString:instaUnmute]) {
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
        [muted removeObject:userView.user.username];
        [prefs setValue:muted forKey:@"muted_users"];
        [prefs writeToFile:prefsLoc atomically:NO];
        return;
      }
    }
  }
  %orig;
}
%end

%hook IGActionSheet
- (void)show {
  if (enabled) {
    UIViewController *currentController = [InstaHelper currentController];

    BOOL isProfileView = [currentController isKindOfClass:[%c(IGUserDetailViewController) class]];
    BOOL isWebView = [currentController isKindOfClass:[%c(IGWebViewController) class]];
    IGUserDetailViewController *userView = (IGUserDetailViewController *) currentController;

    if (isProfileView && !isWebView && !self.titleLabel.text) {
      IGUser *current = [InstaHelper currentUser];
      if ([current.username isEqualToString:userView.user.username]) return %orig;
      if ([muted containsObject:userView.user.username]) {
        [self addButtonWithTitle:instaUnmute style:0 image:nil accessibilityIdentifier:nil];
      } else {
       [self addButtonWithTitle:instaMute style:0 image:nil accessibilityIdentifier:nil];
     }
   }
 }
 %orig;
}
%end

%hook IGUserDetailViewController
- (void)actionSheetDismissedWithButtonTitled:(NSString *)title {
  if (enabled) {
    if ([title isEqualToString:instaMute]) {
      NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
      [muted addObject:self.user.username];
      [prefs setValue:muted forKey:@"muted_users"];
      [prefs writeToFile:prefsLoc atomically:NO];
    } else if ([title isEqualToString:instaUnmute]) {
      NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
      [muted removeObject:self.user.username];
      [prefs setValue:muted forKey:@"muted_users"];
      [prefs writeToFile:prefsLoc atomically:NO];
    } else {
      %orig;
    }
  } else {
    %orig;
  }
}
%end




// %hook IGActionSheet

// - (void)show {
//  	AppDelegate *igDelegate = [UIApplication sharedApplication].delegate;
//  	IGRootViewController *rootViewController = (IGRootViewController *)((IGShakeWindow *)igDelegate.window).rootViewController;
//  	UIViewController *currentController = rootViewController.topMostViewController;

//  	BOOL isProfileView = [currentController isKindOfClass:[%c(IGUserDetailViewController) class]];

//  	if (isProfileView) {
//  		IGUserDetailViewController *userView = (IGUserDetailViewController *) currentController;
//  		if ([muted containsObject:userView.user.username]) {
//  			[self addButtonWithTitle:instaUnmute style:0];
//  		} else {
//  			[self addButtonWithTitle:instaMute style:0];
//  		}
// 	}

// 	%orig();
// }

// %end

// %hook IGMainFeedViewController
// -(BOOL)shouldHideFeedItem:(IGFeedItem *)item {
// 	if ([muted containsObject:item.user.username]) {
// 		return YES;
// 	} else {
// 		return %orig;
// 	}
// }
// %end

// %hook IGUserDetailViewController
// -(void)actionSheetDismissedWithButtonTitled:(NSString *)title {
// 	if ([title isEqualToString:instaMute]) {
// 		NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
// 	    NSMutableArray *keys = [prefs objectForKey:@"muted_users"];
// 	    [keys addObject:self.user.username];
// 	    [prefs setValue:keys forKey:@"muted_users"];
// 	    [prefs writeToFile:prefsLoc atomically:NO];
// 		loadPrefs();
// 	} else if ([title isEqualToString:instaUnmute]) {
// 		NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsLoc];
// 	    NSMutableArray *keys = [prefs objectForKey:@"muted_users"];
// 	    [keys removeObject:self.user.username];
// 	    [prefs setValue:keys forKey:@"muted_users"];
// 	    [prefs writeToFile:prefsLoc atomically:NO];
// 		loadPrefs();
// 	} else {
// 		%orig;
// 	}
// }
// %end

%end

%ctor {
	loadPrefs();
	%init(instaHooks);
}