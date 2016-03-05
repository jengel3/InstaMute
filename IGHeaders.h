#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface IGUser : NSObject
@property (strong, nonatomic) NSString *username;
@end


@interface IGAuthHelper : NSObject
@property (nonatomic, retain) IGUser *currentUser;
@end

@interface IGAuthenticatedUser
@property (copy) NSString *pk;
@end

@interface IGPost : NSObject
@property (strong, nonatomic) IGUser *user;
@end


@interface IGFeedItem : IGPost
@end

@interface IGFeedViewController_DEPRECATED : UIViewController
@property (assign,nonatomic) int feedLayout;
- (void)handleDidDisplayFeedItem:(IGFeedItem*)item;
- (id)arrayOfCellsWithClass:(Class)clazz inSection:(int)sec;
- (void)setFeedLayout:(int)arg1;
- (int)feedLayout;
- (id)initWithFeedNetworkSource:(id)arg1 feedLayout:(int)arg2 showsPullToRefresh:(BOOL)arg3;
- (void)startVideoForCellMovingOnScreen;
- (id)videoCellForAutoPlay;
- (BOOL)isDeviceSupportAlwaysAutoPlay;
- (void)reloadWithNewObjects:(NSArray*)arg1 ;
- (void)actionSheetDismissedWithButtonTitled:(NSString*)arg1 ;
- (void)reloadWithNewObjects:(NSArray*)arg1 context:(id)arg2 synchronus:(char)arg3 forceAnimated:(char)arg4 completionBlock:(/*^block*/id)arg5 ;
- (void)reloadWithCurrentObjectsAnimated:(char)arg1 ;
- (NSArray*)getMutedList:(NSArray*)items;
@end

@interface IGFeedViewController : UIViewController
@property (assign,nonatomic) int feedLayout;
- (void)handleDidDisplayFeedItem:(IGFeedItem*)item;
- (id)arrayOfCellsWithClass:(Class)clazz inSection:(int)sec;
- (void)setFeedLayout:(int)arg1;
- (int)feedLayout;
- (id)initWithFeedNetworkSource:(id)arg1 feedLayout:(int)arg2 showsPullToRefresh:(BOOL)arg3;
- (void)startVideoForCellMovingOnScreen;
- (id)videoCellForAutoPlay;
- (BOOL)isDeviceSupportAlwaysAutoPlay;
- (void)reloadWithNewObjects:(NSArray*)arg1 ;
- (void)actionSheetDismissedWithButtonTitled:(NSString*)arg1 ;
- (void)reloadWithNewObjects:(NSArray*)arg1 context:(id)arg2 synchronus:(char)arg3 forceAnimated:(char)arg4 completionBlock:(/*^block*/id)arg5 ;
- (void)reloadWithCurrentObjectsAnimated:(char)arg1;
- (NSArray*)getMutedList:(NSArray*)items;
@end


@interface IGUserDetailHeaderView : UIView
@end

@interface IGUserDetailViewController : UIViewController
@property(retain, nonatomic) IGUserDetailHeaderView *headerView;
- (void)actionSheetDismissedWithButtonTitled:(NSString *)title;
- (IGUser *)user;
@end

@interface IGActionSheet : UIActionSheet
@property (nonatomic, retain) NSMutableArray *buttons; 
@property (nonatomic, retain) UILabel *titleLabel;  
+ (void)hideImmediately;
- (void)addButtonWithTitle:(NSString *)title style:(int)style;
- (void)buttonWithTitle:(NSString *)title style:(int)style;
- (void)setActionDelegate:(id)arg1 ;
- (void)addButtonWithTitle:(id)arg1 style:(int)arg2 image:(id)arg3 accessibilityIdentifier:(id)arg4 ;
+ (int)tag;
+ (void)setTag:(int)arg1;
- (void)hideAndReset;
@end

@interface IGActionSheetCallbackProxy
- (void)setCallback:(id)arg1 ;
+ (id)delegateWithCallback:(/*^block*/id)arg1 ;
- (void)actionSheetDismissedWithButtonTitled:(NSString*)arg1 ;
- (void)actionSheetFinishedHiding;
@end

@interface IGRootViewController : UIViewController
- (id)topMostViewController;
@end

@interface AppDelegate : NSObject
- (void)startMainAppWithMainFeedSource:(id)source animated:(BOOL)animated;
- (void)applicationDidEnterBackground:(id)arg1;
- (id)window;
- (id)navigationController;
- (BOOL)application:(id)arg1 handleOpenURL:(id)arg2;
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
- (void)application:(id)arg1 didReceiveRemoteNotification:(id)arg2 fetchCompletionHandler:(/*^block*/id)arg3;
- (void)application:(id)arg1 didReceiveRemoteNotification:(id)arg2;
- (void)application:(id)arg1 handleActionWithIdentifier:(id)arg2 forRemoteNotification:(id)arg3 completionHandler:(/*^block*/id)arg4;
@end

@interface IGShakeWindow : UIWindow
- (id)rootViewController;
@end