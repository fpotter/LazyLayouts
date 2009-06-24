
#import "LLLayoutView.h"
#import "LazyLayouts.h"

@implementation LLLayoutView

@synthesize resizeToFitSubviews = _resizeToFitSubviews, backgroundView = _backgroundView;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _resizeToFitSubviews = NO;
    _layoutParams = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
  }
  return self;
}

- (Class)paramsClass {
  return [LLLayoutParams class];
}

- (void)setBackgroundView:(UIView *)view {  
  if (view == _backgroundView) {
    return;
  }

  [_backgroundView removeFromSuperview];
  [_backgroundView release];

  _backgroundView = [view retain];  
  [self addSubview:_backgroundView];
}

- (NSArray *)subviewsWithoutBackgroundView {
  if (self.backgroundView == nil) {
    return self.subviews;
  } else {
    NSMutableArray *subviews = [NSMutableArray arrayWithCapacity:(self.subviews.count - 1)];
    
    for (UIView *subview in self.subviews) {
      if (subview != _backgroundView) {
        [subviews addObject:subview];
      }
    }
    
    return subviews;
  }
}

- (CGSize)availableSizeForChildren {
  if (_resizeToFitSubviews) {
    if (self.superview == nil) {
      // When a layout doesn't have a parent, is set to resize to its subviews, there's no
      // way to know how much space is actually available.  In that case, the layout library will
      // just assume the whole screen is available.  This consistent with Apple's documentation
      // for sizeToFit
      return CGSizeMake(320, 480);
    } else {
      // Look to our parent for our available size.
      return self.superview.frame.size;
    }
  } else {
    // We're fixed size - our size was set via setFrame or in our initializer
    return self.frame.size;
  }
}

- (void)layoutSubviews {
  CGSize sizeConsumed = [self layoutSubviews:[self subviewsWithoutBackgroundView] withAvailableSize:[self availableSizeForChildren] updatePositions:YES];
  
  if (_resizeToFitSubviews) {
    CGRect frame = self.frame;
    frame.size.width = sizeConsumed.width;
    frame.size.height = sizeConsumed.height;
    self.frame = frame;
  }
  
  if (_backgroundView != nil) {
    // Background view should always expand to match the dimensions of the layout view.
    _backgroundView.frame = self.bounds;    
    // And, it should of course be in the background!
    [self sendSubviewToBack:_backgroundView];
  }
}

- (CGSize)layoutSubviews:(NSArray *)subviews withAvailableSize:(CGSize)availableSize updatePositions:(BOOL)updatePositions {
  return CGSizeZero;
}

- (CGSize)sizeThatFits:(CGSize)size {  
  return [self layoutSubviews:[self subviewsWithoutBackgroundView] withAvailableSize:size updatePositions:NO];
}

- (void)setFrame:(CGRect)frame {
  CGRect oldFrame = self.frame;  
  [super setFrame:frame];
  
  // If our frame changes, then it can affect the size of our parent.  It's nice
  // to tell them what's up with us.
  if (self.superview != nil && !CGRectEqualToRect(oldFrame, frame)) {
    [self.superview setNeedsLayout];
  }
}
    
- (void)dealloc {
  [super dealloc];
  [_layoutParams release];
}

- (void)addSubview:(UIView *)subview withParams:(LLLayoutParams *)params {
  [super addSubview:subview];
  [_layoutParams setObject:params forKey:[NSValue valueWithPointer:subview]];
}

- (void)willRemoveSubview:(UIView *)subview {
  [super willRemoveSubview:subview];
  [_layoutParams removeObjectForKey:[NSValue valueWithPointer:subview]];
}

- (LLLayoutParams *)layoutParamsForSubview:(UIView *)subview {
  return (LLLayoutParams *)[_layoutParams objectForKey:[NSValue valueWithPointer:subview]];
}

- (CGSize)sizeForSubview:(UIView *)subview withAvailableSize:(CGSize)availableSize {
  
  CGSize size = [subview sizeThatFits:availableSize];
  
  LLLayoutParams *params = [self layoutParamsForSubview:subview];
  
  if (params.expandToFillWidth) {
    size.width = MAX(size.width, availableSize.width);
  }
  
  if (params.fillHeight) {
    size.height = MAX(size.height, availableSize.height);
  }
  
  return size;
}

- (void)addSubview:(UIView *)subview 
           margins:(UIEdgeInsets)margins {
  LLLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.margins = margins;
  [self addSubview:subview withParams:params];
}

- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins fillWidth:(BOOL)fillWidth {
  LLLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.margins = margins;
  params.expandToFillWidth = fillWidth;
  [self addSubview:subview withParams:params];
}

- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins fillHeight:(BOOL)fillHeight {
  LLLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.margins = margins;
  params.fillHeight = fillHeight;
  [self addSubview:subview withParams:params];  
}

- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins fillWidth:(BOOL)fillWidth fillHeight:(BOOL)fillHeight {
  LLLayoutParams *params = [[[[self paramsClass] alloc] init] autorelease];
  params.margins = margins;
  params.expandToFillWidth = fillWidth;
  params.fillHeight = fillHeight;
  [self addSubview:subview withParams:params];    
}

@end

@implementation LLLayoutParams

@synthesize margins = _margins, expandToFillWidth = _expandToFillWidth,
fillHeight = _expandToFillHeight;

- (id)init {
  if (self = [super init]) {
    self.margins = UIEdgeInsetsZero;
    self.expandToFillWidth = NO;
    self.fillHeight = NO;    
  }
  return self;
}

@end
