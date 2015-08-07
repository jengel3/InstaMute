#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "substrate.h"

@interface IGUser : NSObject
	@property (strong, nonatomic) NSString *username;
@end

@interface IGPost : NSObject
	@property (strong, nonatomic) IGUser *user;
@end

@interface IGFeedItem : IGPost
-(id)description;
-(BOOL)isHidden;
-(id)getMediaId;
-(void)setIsHidden:(BOOL)hidden;
-(id)initWithCoder:(id)fp8;
@end

@interface AppDelegate : NSObject
- (void)startMainAppWithMainFeedSource:(id)source animated:(BOOL)animated;
- (id)window; 
@end

@interface IGMainFeedViewController
-(BOOL)shouldHideFeedItem:(id)fp8;
@end

@interface IGViewController : UIViewController
@end

@interface IGUserDetailViewController : IGViewController
-(void)actionSheetDismissedWithButtonTitled:(NSString *)title;
-(IGUser *)user;
@end

@interface IGRootViewController : UIViewController

- (id)topMostViewController;

@end

@interface IGShakeWindow : UIWindow

- (id)rootViewController;

@end

@interface IGActionSheet
- (void)addButtonWithTitle:(NSString *)title style:(int)style;
@end
