
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
                    @selector(didMoveToSuperview),
                    @selector(LL__didMoveToSuperview));
    
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
  if (layout != nil) {
    [layout layoutSubviews:self withAvailableSize:self.frame.size];
  } else {
    [self LL__layoutSubviewsSwizzler];
  }
}

- (CGSize)LL__sizeThatFits:(CGSize)size {
  return [self layoutView:size];
}

- (void)LL__didAddSubview:(UIView *)subview {
  // Call the original implementation.
  [self LL__didAddSubview:subview];
}

- (void)LL__didMoveToSuperview {
  
  // If the receiver gets added to a view that has a layout manager, then the dimensions
  // of that view may need to change.
  if (self.superview != nil && self.superview.lazyLayout != nil) {
    [self.superview setNeedsLayout];
  }
  
  [self LL__didMoveToSuperview];
}

- (void)LL__setFrame:(CGRect)frame {
  [self LL__setFrame:frame];
  
  // If we belong to a layout, then we should tell the layout manager to
  // redo the layout
  if (self.superview != nil && self.superview.lazyLayout != nil) {
    [self.superview layoutIfNeeded];
  }
}

- (CGSize)layoutView:(CGSize)availableSize {
  
  LLLayout *layout = self.lazyLayout;
  LLLayoutParams *params = self.lazyLayoutParams;
  
  BOOL isLayoutOrChildOfALayout =
    (layout != nil) ||
    (params != nil) ||
    (self.superview != nil && self.superview.lazyLayout != nil);
  
  if (!isLayoutOrChildOfALayout) {
    // We don't do anything to the dimensions since they've not opted into any
    // of our layout magic.
    return [self LL__sizeThatFits:availableSize];
  } else {
    
    CGSize size;
    
    if (layout) {
      size = [layout layoutSubviews:self withAvailableSize:availableSize];
    } else {
      // We don't have a layout, but we have some layout params that may affect
      // our bounds.      
      size = [self LL__sizeThatFits:availableSize];      
    }
    
    if (params.expandToFillWidth) {
      size.width = MAX(size.width, availableSize.width);
    }

    if (params.expandToFillHeight) {
      size.height = MAX(size.height, availableSize.height);
    }
    
    return size;
  }
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
