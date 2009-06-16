
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
  LLLayoutParams *params = view.layoutParams;
  if ([params isKindOfClass:[LLVerticalLayoutParams class]]) {
    return (LLVerticalLayoutParams *)view.layoutParams;
  } else {
    return [[[LLVerticalLayoutParams alloc] init] autorelease];
  }
}

- (CGSize)computeSizeForView:(UIView *)view withAvailableSize:(CGSize)availableSize {
  
  NSLog(@"Compute got called!");
  
  CGSize sizeThatFits = CGSizeZero;
  
  int subviewCount = view.subviews.count;
  for (int i = 0; i < subviewCount; i++) {
    UIView *subview = [view.subviews objectAtIndex:i];
    LLVerticalLayoutParams *params = getVerticalLayoutParamsOrDefaults(subview);
    
    CGSize subviewSize = subview.frame.size;
    
    if (subviewSize.width == 0 && subviewSize.height == 0) {
      subviewSize = [subview sizeThatFits:
                     CGSizeMake(availableSize.width - params.margins.left - params.margins.right, NSIntegerMax)];
    }
    
    sizeThatFits.width = MAX(subviewSize.width, availableSize.width);
    sizeThatFits.height += (subviewSize.height + params.margins.top + params.margins.bottom);
    
    if ((i + 1) < subviewCount) {
      sizeThatFits.height += self.spacing;
    }
  }
  
  return sizeThatFits;  
}

- (void)layoutSubviews:(UIView *)view {
  CGSize size = view.frame.size;
  
  int y = 0;

  int subviewCount = view.subviews.count;
  for (int i = 0; i < subviewCount; i++) {
    UIView *subview = [view.subviews objectAtIndex:i];

    LLVerticalLayoutParams *params = getVerticalLayoutParamsOrDefaults(subview);
    
    CGRect frame = subview.frame;
        
    // If the caller hasn't defined a size for this guy yet, just
    // do the right thing and sizeToFit
    if (frame.size.width == 0 || frame.size.height == 0) {
      CGSize newSize = [subview sizeThatFits:
                        CGSizeMake(size.width - params.margins.left - params.margins.right, NSIntegerMax)];
      frame.size.width = newSize.width;
      frame.size.height = newSize.height;
    }
    
    if (params.expandToFillWidth) {
      frame.size.width = (size.width - params.margins.left - params.margins.right);
    }
    
    if (params.align == LLVerticalLayoutAlignLeft) {
      frame.origin.x = params.margins.left;      
    } else if (params.align == LLVerticalLayoutAlignRight) {
      frame.origin.x = MAX(0, (size.width - params.margins.right - frame.size.width));
    } else if (params.align == LLVerticalLayoutAlignCenter) {
      frame.origin.x = MAX(0, round((size.width / 2) - (frame.size.width / 2)));
    }
    
    frame.origin.y = y + params.margins.top;
    
    subview.frame = frame;
    
    y += params.margins.top + frame.size.height + params.margins.bottom;
    
    if ((i + 1) < subviewCount) {
      y += self.spacing;
    }
  }  
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

+ (LLVerticalLayoutParams *)paramsWithAlignment:(LLVerticalLayoutAlign)align {
  LLVerticalLayoutParams *params = [[LLVerticalLayoutParams alloc] init];
  params.align = align;
  return [params autorelease];
}

@end

