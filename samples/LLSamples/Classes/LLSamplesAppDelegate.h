
#import <UIKit/UIKit.h>

@class LLSamplesViewController;

@interface LLSamplesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LLSamplesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LLSamplesViewController *viewController;

@end

