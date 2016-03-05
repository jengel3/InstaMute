#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "InstaHelper.h"
#import "IGHeaders.h"
#import "substrate.h"

@implementation InstaHelper
+ (IGRootViewController *)rootViewController {
  AppDelegate *igDelegate = [UIApplication sharedApplication].delegate;
  return (IGRootViewController *)((IGShakeWindow *)igDelegate.window).rootViewController;
}

+ (UIViewController *)currentController {
  IGRootViewController *rootController = [InstaHelper rootViewController];
  return rootController.topMostViewController;
}

+ (IGUser *)currentUser {
  return [%c(IGAuthHelper) currentUser];
}
@end