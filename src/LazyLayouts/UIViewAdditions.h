
#import <UIKit/UIKit.h>
#import "LazyLayouts.h"

@class LLLayout;
@class LLLayoutParams;

@interface UIView (LLAdditions)

@property (nonatomic, retain) LLLayout *layout;
@property (nonatomic, retain) LLLayoutParams *layoutParams;

@end
