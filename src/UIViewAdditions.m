
#import "LazyLayouts/UIViewAdditions.h"
#import </usr/include/objc/objc-class.h>

void LLMethodSwizzle(Class c, SEL orig, SEL new) {
  Method origMethod = class_getInstanceMethod(c, orig);
  Method newMethod = class_getInstanceMethod(c, new);
  
	if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
    class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	} else {
		method_exchangeImplementations(origMethod, newMethod);
	}
}

static NSMutableDictionary *instanceIDToIvars = nil;
static BOOL needToSwizzleMethods = YES;

@implementation UIView (LLAdditions)

- (id)LL__instanceID {
  return [NSValue valueWithPointer:self];
}

- (NSMutableDictionary *)LL__ivars {
  NSMutableDictionary *ivars;
  
  if (needToSwizzleMethods) {
    LLMethodSwizzle([UIView class], 
                  @selector(dealloc), 
                  @selector(LL__deallocSwizzler));
    
    LLMethodSwizzle([UIView class],
                  @selector(layoutSubviews),
                  @selector(LL__layoutSubviewsSwizzler));
    
    LLMethodSwizzle([UIView class],
                  @selector(sizeThatFits:),
                  @selector(LL__sizeThatFits:));
    
    LLMethodSwizzle([UIView class],
                  @selector(didAddSubview:),
                  @selector(LL__didAddSubview:));
    
    LLMethodSwizzle([UIView class],
                    @selector(setFrame:),
                    @selector(LL__setFrame:));    
    
    needToSwizzleMethods = NO;
  }
  
  if (instanceIDToIvars == nil) {
    instanceIDToIvars = [[NSMutableDictionary alloc] init];
  }
  
  ivars = [instanceIDToIvars objectForKey:[self LL__instanceID]];
  if (ivars == nil) {
    ivars = [NSMutableDictionary dictionary];
    [instanceIDToIvars setObject:ivars forKey:[self LL__instanceID]];
  }
  
  return ivars;
}

- (void)LL__deallocSwizzler {
  [instanceIDToIvars removeObjectForKey:[self LL__instanceID]];
  if ([instanceIDToIvars count] == 0) {    
    [instanceIDToIvars release];
    instanceIDToIvars = nil;
  }
  
  // Call the original dealloc
  [self LL__deallocSwizzler];
}

- (void)LL__layoutSubviewsSwizzler {

  LLLayout *layout = self.lazyLayout;
  
  if (layout != nil && layout.resizeToFitSubviews == NO) {
    // If resizeToFitSubviews is false, then it means we have a concrete size.
    [layout layoutSubviews:self withAvailableSize:self.frame.size];    
  }
  
  // Call the original implementation.
  [self LL__layoutSubviewsSwizzler];
}

- (CGSize)LL__sizeThatFits:(CGSize)size {
  LLLOG(@"sizeThatFits > width = %f, height = %f", size.width, size.height);
  LLLayout *layout = self.lazyLayout;
  
  if (layout) {
    // If a layout has been configured, then we need to run through it if we're
    // going to be able to determine our dimensions.
    //
    // NOTE: Calling layoutSubviews actually moves/sizes stuff!  This is different
    // from how sizeThatFits normally works.
    return [layout layoutSubviews:self withAvailableSize:size];
  }
  
  // Call the original implementation.
  return [self LL__sizeThatFits:size];
}

- (void)LL__didAddSubview:(UIView *)subview {
  LLLOG(@"didAddSubview > %@", subview);
  LLLayout *layout = self.lazyLayout;
  
  if (layout && layout.resizeToFitSubviews) {
    // With every addition, our bounds can change...
    [self setNeedsLayout];
  }

  // Call the original implementation.
  [self LL__didAddSubview:subview];
}

- (void)LL__setFrame:(CGRect)frame {
  LLLOG(@"setFrame > x = %f y = %f width = %f height = %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
  
  // TODO: Changing the width / height of a view that belongs to layout
  // should cause the rest of that layout to resize.
  
  [self LL__setFrame:frame];
}

- (void)layoutView:(CGSize)availableSize {
  LLLOG(@"layoutView > width = %f height = %f", availableSize.width, availableSize.height);
  
  // Calling sizeThatFits on a view that's been configured with a LazyLayout
  // has the effect of calling layoutView
  CGSize sizeThatFits = [self sizeThatFits:availableSize];
  
  LLLayoutParams *params = self.lazyLayoutParams;
  
  if (params != nil) {
    if (params.expandToFillWidth) {
      sizeThatFits.width = availableSize.width;
    }
    
    if (params.expandToFillHeight) {
      sizeThatFits.height = availableSize.height;
    }
  }
  
  CGRect frame = self.frame;
  frame.size.width = sizeThatFits.width;
  frame.size.height = sizeThatFits.height;
  self.frame = frame;
  
  LLLOG(@"Setting size: width = %f, height = %f", self.frame.size.width, self.frame.size.height);
}

- (LLLayout *)lazyLayout {
  return [[self LL__ivars] objectForKey:@"layout"];
}

- (void)setLazyLayout:(LLLayout *)layout {
  [[self LL__ivars] setObject:layout forKey:@"layout"];
}

- (LLLayoutParams *)lazyLayoutParams {
  return [[self LL__ivars] objectForKey:@"layoutParams"];  
}

- (void)setLazyLayoutParams:(LLLayoutParams *)layoutParams {
  [[self LL__ivars] setObject:layoutParams forKey:@"layoutParams"];
}

@end
