
#import "LLHorizontalLayoutView.h"
#import "LazyLayouts.h"

@implementation LLHorizontalLayoutView

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
  return [LLHorizontalLayoutParams class];
}

- (void)addSubview:(UIView *)subview {
  // Add a subview with the default parameters.
  [self addSubview:subview
             align:LLHorizontalLayoutAlignTop
           margins:UIEdgeInsetsZero
         fillWidth:NO
        fillHeight:NO];
}

- (void)addSubview:(UIView *)subview 
             align:(LLHorizontalLayoutAlign)align {
  LLHorizontalLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.align = align;
  [super addSubview:subview withParams:params];
}

- (void)addSubview:(UIView *)subview 
             align:(LLHorizontalLayoutAlign)align
           margins:(UIEdgeInsets)margins {
  LLHorizontalLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.align = align;
  params.margins = margins;
  [super addSubview:subview withParams:params];
}

- (void)addSubview:(UIView *)subview 
             align:(LLHorizontalLayoutAlign)align 
           margins:(UIEdgeInsets)margins 
         fillWidth:(BOOL)fillWidth 
        fillHeight:(BOOL)fillHeight {
  LLHorizontalLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.align = align;
  params.margins = margins;
  params.expandToFillWidth = fillWidth;
  params.fillHeight = fillHeight;
  [super addSubview:subview withParams:params];
}

- (CGSize)layoutSubviews:(NSArray *)subviews withAvailableSize:(CGSize)availableSize updatePositions:(BOOL)updatePositions {
  
  // This will determine the width of our layout
  int sumOfWidths = 0;
  // This will determine the height of our layout
  int maxSubviewHeight = 0;
  
  int subviewCount = subviews.count;
  CGSize subviewSizes[subviewCount];
  
  for (int i = 0; i < subviewCount; i++) {    
    UIView *subview = [subviews objectAtIndex:i];

    if (subview.hidden) {
      continue;
    }    
    
    LLHorizontalLayoutParams *params = (LLHorizontalLayoutParams *)[self layoutParamsForSubview:subview];
    
    int availableWidthForSubview = 
    availableSize.width -
    sumOfWidths - 
    (params.margins.left + params.margins.right);
    
    int availableHeightForSubview =
    availableSize.height - (params.margins.top + params.margins.bottom);
    
    CGSize subviewSize = [self sizeForSubview:subview withAvailableSize:CGSizeMake(availableWidthForSubview, availableHeightForSubview)];
    
    sumOfWidths += (subviewSize.width + params.margins.left + params.margins.right);
    maxSubviewHeight = MAX(subviewSize.height + params.margins.top + params.margins.bottom, maxSubviewHeight);
    
    if ((i + 1) < subviewCount) {
      sumOfWidths += _spacing;
    }
    
    subviewSizes[i] = subviewSize;
  }
  
  CGSize layoutSize = CGSizeMake(sumOfWidths, maxSubviewHeight);
  
  if (updatePositions) {  
    int xPos = 0;
    for (int i = 0; i < subviewCount; i++) {      
      UIView *subview = [subviews objectAtIndex:i];
      
      if (subview.hidden) {
        continue;
      }      
      
      LLHorizontalLayoutParams *params = (LLHorizontalLayoutParams *)[self layoutParamsForSubview:subview];
      
      CGSize subviewSize = subviewSizes[i];
      
      CGRect subviewFrame = subview.frame;
      subviewFrame.size.width = subviewSize.width;
      subviewFrame.size.height = subviewSize.height;
      subview.frame = subviewFrame;
      
      int yPos;
      
      if (params.align == LLHorizontalLayoutAlignTop) {
        yPos = params.margins.top;
      } else if (params.align == LLHorizontalLayoutAlignBottom) {
        yPos = layoutSize.height - subviewSize.height - params.margins.bottom;
      } else if (params.align == LLHorizontalLayoutAlignMiddle) {
        yPos = round((layoutSize.height / 2) - (subviewSize.height / 2));
      }
      
      subview.frame = CGRectMake(xPos + params.margins.left, yPos, subviewSize.width, subviewSize.height);
      xPos += params.margins.left + subviewSize.width + params.margins.right;
      
      if ((i + 1) < subviewCount) {
        xPos += _spacing;
      }
    }
  }
  
  return layoutSize;
}


@end

@implementation LLHorizontalLayoutParams

@synthesize align = _align;

- (id)init {
  if (self = [super init]) {
    self.align = LLHorizontalLayoutAlignTop;
  }
  return self;
}

@end
