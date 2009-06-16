
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

- (id)PRE__instanceID {
  return [NSValue valueWithPointer:self];
}

- (NSMutableDictionary *)PRE__ivars {
  NSMutableDictionary *ivars;
  
  if (needToSwizzleMethods) {
    LLMethodSwizzle([UIView class], 
                  @selector(dealloc), 
                  @selector(PRE__deallocSwizzler));
    
    LLMethodSwizzle([UIView class],
                  @selector(layoutSubviews),
                  @selector(PRE__layoutSubviewsSwizzler));
    
    LLMethodSwizzle([UIView class],
                  @selector(sizeThatFits:),
                  @selector(PRE__sizeThatFits:));
    
    LLMethodSwizzle([UIView class],
                  @selector(didAddSubview:),
                  @selector(PRE__didAddSubview:));
        
    needToSwizzleMethods = NO;
  }
  
  if (instanceIDToIvars == nil) {
    instanceIDToIvars = [[NSMutableDictionary alloc] init];
  }
  
  ivars = [instanceIDToIvars objectForKey:[self PRE__instanceID]];
  if (ivars == nil) {
    ivars = [NSMutableDictionary dictionary];
    [instanceIDToIvars setObject:ivars forKey:[self PRE__instanceID]];
  }
  
  return ivars;
}

- (void)PRE__deallocSwizzler {
  [instanceIDToIvars removeObjectForKey:[self PRE__instanceID]];
  if ([instanceIDToIvars count] == 0) {    
    [instanceIDToIvars release];
    instanceIDToIvars = nil;
  }
  
  // Call the original dealloc
  [self PRE__deallocSwizzler];
}

- (void)PRE__layoutSubviewsSwizzler {
  
  LLLayout *layout = self.lazyLayout;
  
  if (layout) {
    [layout layoutSubviews:self];
  }
  
  // Call the original implementation.
  [self PRE__layoutSubviewsSwizzler];
}

- (CGSize)PRE__sizeThatFits:(CGSize)size {
  
  LLLayout *layout = self.lazyLayout;
  
  if (layout) {
    return [layout computeSizeForView:self withAvailableSize:size];
  }
  
  // Call the original implementation.
  return [self PRE__sizeThatFits:size];
}

- (void)PRE__didAddSubview:(UIView *)subview {
  
  LLLayout *layout = self.lazyLayout;
  
  if (layout && layout.resizeToFitSubviews) {
    // Automatically resize our dimensions when a new view is added.
    [self sizeToFit];
  }
  
  // Call the original implementation.
  [self PRE__didAddSubview:subview];
}

- (LLLayout *)lazyLayout {
  return [[self PRE__ivars] objectForKey:@"layout"];
}

- (void)setLazyLayout:(LLLayout *)layout {
  [[self PRE__ivars] setObject:layout forKey:@"layout"];
}

- (LLLayoutParams *)lazyLayoutParams {
  return [[self PRE__ivars] objectForKey:@"layoutParams"];  
}

- (void)setLazyLayoutParams:(LLLayoutParams *)layoutParams {
  [[self PRE__ivars] setObject:layoutParams forKey:@"layoutParams"];
}

@end
