
#import "LazyLayouts/LLLayout.h"

@implementation LLLayout

@synthesize resizeToFitSubviews = _resizeToFitSubviews;

- (id)init {
  if (self = [super init]) {
    _resizeToFitSubviews = YES;
  }
  return self;
}

- (CGSize)layoutSubviews:(UIView *)view withAvailableSize:(CGSize)availableSize {
  return CGSizeZero;
}

@end

@implementation LLLayoutParams

@synthesize margins = _margins, expandToFillWidth = _expandToFillWidth,
  expandToFillHeight = _expandToFillHeight;

- (id)init {
  if (self = [super init]) {
    self.margins = UIEdgeInsetsZero;
    self.expandToFillWidth = NO;
    self.expandToFillHeight = NO;    
  }
  return self;
}

@end