
#import <UIKit/UIKit.h>
#import "LazyLayouts.h"

@class LLLayout;
@class LLLayoutParams;

@interface UIView (LLAdditions)

@property (nonatomic, retain) LLLayout *lazyLayout;
@property (nonatomic, retain) LLLayoutParams *lazyLayoutParams;

@end
