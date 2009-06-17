
#import "LazyLayouts/LLVerticalLayout.h"
#import "LazyLayouts/UIViewAdditions.h"

@implementation LLVerticalLayout

@synthesize spacing = _spacing;

+ (LLVerticalLayout *)layout {
  return [LLVerticalLayout layoutWithSpacing:0];
}

+ (LLVerticalLayout *)layoutWithSpacing:(NSInteger)spacing {
  LLVerticalLayout *layout = [[LLVerticalLayout alloc] init];
  layout.spacing = spacing;
  return [layout autorelease];
}

LLVerticalLayoutParams *getVerticalLayoutParamsOrDefaults(UIView *view) {
  LLLayoutParams *params = view.lazyLayoutParams;
  if ([params isKindOfClass:[LLVerticalLayoutParams class]]) {
    return (LLVerticalLayoutParams *)view.lazyLayoutParams;
  } else {
    return [[[LLVerticalLayoutParams alloc] init] autorelease];
  }
}

- (CGSize)layoutSubviews:(UIView *)view withAvailableSize:(CGSize)availableSize {
  
  LLLOG(@"%@ > layoutSubviews > view = %@ , availableSize = %fx%f",
        self,
        view,
        availableSize.width,
        availableSize.height);
  
  // This will determine the height of our layout
  int sumOfHeights = 0;
  // This will determine the width of our layout
  int maxSubviewWidth = 0;
  
  int subviewCount = view.subviews.count;
  
  for (int i = 0; i < subviewCount; i++) {    
    UIView *subview = [view.subviews objectAtIndex:i];
    LLVerticalLayoutParams *params = getVerticalLayoutParamsOrDefaults(subview);
    
    int availableHeightForSubview = 
      availableSize.height -
      sumOfHeights - 
      (params.margins.top + params.margins.bottom);
    
    int availableWidthForSubview =
      availableSize.width - (params.margins.left + params.margins.right);
    
    [subview layoutView:CGSizeMake(availableWidthForSubview, availableHeightForSubview)];

    CGSize subviewSize = subview.frame.size;

    sumOfHeights += (subviewSize.height + params.margins.top + params.margins.bottom);
    maxSubviewWidth = MAX(subviewSize.width + params.margins.left + params.margins.right, maxSubviewWidth);
  }
  
  CGSize layoutSize = CGSizeMake(maxSubviewWidth, sumOfHeights);
  
  LLLayoutParams *params = view.lazyLayoutParams;
  
  if (params != nil && params.expandToFillWidth) {
    layoutSize.width = availableSize.width;
  }
  
  if (params != nil && params.expandToFillHeight) {
    layoutSize.height = availableSize.height;
  }
  
  
  int yPos = 0;
  for (int i = 0; i < subviewCount; i++) {
    UIView *subview = [view.subviews objectAtIndex:i];
    LLVerticalLayoutParams *params = getVerticalLayoutParamsOrDefaults(subview);
    
    CGSize subviewSize = subview.frame.size;
    int xPos;
    
    if (params.align == LLVerticalLayoutAlignLeft) {
      xPos = params.margins.left;
    } else if (params.align == LLVerticalLayoutAlignRight) {
      xPos = layoutSize.width - subviewSize.width - params.margins.right;
    } else if (params.align == LLVerticalLayoutAlignCenter) {
      xPos = round((layoutSize.width / 2) - (subviewSize.width / 2));
    }
    
    subview.frame = CGRectMake(xPos, yPos + params.margins.top, subviewSize.width, subviewSize.height);
    yPos += params.margins.top + subviewSize.height + params.margins.bottom;
  }
  
  // Update our own dimensions
  if (self.resizeToFitSubviews) {
    CGRect frame = view.frame;
    frame.size.width = layoutSize.width;
    frame.size.height = layoutSize.height;
    view.frame = frame;
  }

  return layoutSize;
}

@end

@implementation LLVerticalLayoutParams

@synthesize align = _align;

- (id)init {
  if (self = [super init]) {
    self.align = LLVerticalLayoutAlignLeft;
  }
  return self;
}

+ (LLVerticalLayoutParams *)paramsWithAlignment:(LLVerticalLayoutAlign)align 
                                        margins:(UIEdgeInsets)margins 
                              expandToFillWidth:(BOOL)expandToFillWidth
                              expandToFillHeight:(BOOL)expandToFillHeight
{
  LLVerticalLayoutParams *params = [[LLVerticalLayoutParams alloc] init];
  params.align = align;
  params.margins = margins;
  params.expandToFillWidth = expandToFillWidth;
  return [params autorelease];
}

+ (LLVerticalLayoutParams *)paramsWithAlignment:(LLVerticalLayoutAlign)align {
  LLVerticalLayoutParams *params = [[LLVerticalLayoutParams alloc] init];
  params.align = align;
  return [params autorelease];
}

@end

