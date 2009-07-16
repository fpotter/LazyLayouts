
#import "LLVerticalLayoutView.h"
#import "LazyLayouts.h"

@implementation LLVerticalLayoutView

@synthesize spacing = _spacing;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _spacing = 0;
  }
  return self;
}

- (void)dealloc {
    [super dealloc];
}

- (Class)paramsClass {
  return [LLVerticalLayoutParams class];
}

- (void)addSubview:(UIView *)subview {
  // Add a subview with the default parameters.
  [self addSubview:subview
             align:LLVerticalLayoutAlignLeft
           margins:UIEdgeInsetsZero
         fillWidth:NO
        fillHeight:NO];
}

- (void)addSubview:(UIView *)subview 
             align:(LLVerticalLayoutAlign)align {
  LLVerticalLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.align = align;
  [super addSubview:subview withParams:params];
}

- (void)addSubview:(UIView *)subview 
             align:(LLVerticalLayoutAlign)align
           margins:(UIEdgeInsets)margins {
  LLVerticalLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.align = align;
  params.margins = margins;
  [super addSubview:subview withParams:params];
}

- (void)addSubview:(UIView *)subview 
             align:(LLVerticalLayoutAlign)align 
           margins:(UIEdgeInsets)margins 
         fillWidth:(BOOL)fillWidth 
        fillHeight:(BOOL)fillHeight {
  LLVerticalLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.align = align;
  params.margins = margins;
  params.expandToFillWidth = fillWidth;
  params.fillHeight = fillHeight;
  [super addSubview:subview withParams:params];
}

- (CGSize)layoutSubviews:(NSArray *)subviews withAvailableSize:(CGSize)availableSize updatePositions:(BOOL)updatePositions {
  
  // This will determine the height of our layout
  int sumOfHeights = 0;
  // This will determine the width of our layout
  int maxSubviewWidth = 0;
  
  int subviewCount = subviews.count;
  CGSize subviewSizes[subviewCount];
  
  for (int i = 0; i < subviewCount; i++) {    
    UIView *subview = [subviews objectAtIndex:i];
    
    if (subview.hidden) {
      continue;
    }
    
    LLVerticalLayoutParams *params = (LLVerticalLayoutParams *)[self layoutParamsForSubview:subview];
    
    int availableHeightForSubview = 
    availableSize.height -
    sumOfHeights - 
    (params.margins.top + params.margins.bottom);
    
    int availableWidthForSubview =
    availableSize.width - (params.margins.left + params.margins.right);
    
    CGSize subviewSize = [self sizeForSubview:subview withAvailableSize:CGSizeMake(availableWidthForSubview, availableHeightForSubview)];
        
    sumOfHeights += (subviewSize.height + params.margins.top + params.margins.bottom);
    maxSubviewWidth = MAX(subviewSize.width + params.margins.left + params.margins.right, maxSubviewWidth);
    
    if ((i + 1) < subviewCount) {
      sumOfHeights += _spacing;
    }
    
    subviewSizes[i] = subviewSize;
  }
  
  CGSize layoutSize = CGSizeMake(maxSubviewWidth, sumOfHeights);
  
  if (updatePositions) {  
    int yPos = 0;
    for (int i = 0; i < subviewCount; i++) {
      UIView *subview = [subviews objectAtIndex:i];
      
      if (subview.hidden) {
        continue;
      }      
      
      LLVerticalLayoutParams *params = (LLVerticalLayoutParams *)[self layoutParamsForSubview:subview];
      
      CGSize subviewSize = subviewSizes[i];
      
      CGRect subviewFrame = subview.frame;
      subviewFrame.size.width = subviewSize.width;
      subviewFrame.size.height = subviewSize.height;
      subview.frame = subviewFrame;
      
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
      
      if ((i + 1) < subviewCount) {
        yPos += _spacing;
      }
    }
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

@end
