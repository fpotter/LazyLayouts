
#import "LazyLayouts/LLLayout.h"

@implementation LLLayout

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

- (void)layoutSubviews:(UIView *)view {
}

- (CGSize)computeSizeForView:(UIView *)view withAvailableSize:(CGSize)availableSize {
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