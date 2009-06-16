
#import "LazyLayouts/UIViewAdditions.h"
#import </usr/include/objc/objc-class.h>

void MethodSwizzle(Class c, SEL orig, SEL new) {
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
    MethodSwizzle([UIView class], 
                  @selector(dealloc), 
                  @selector(PRE__deallocSwizzler));
    
    MethodSwizzle([UIView class],
                  @selector(layoutSubviews),
                  @selector(PRE__layoutSubviewsSwizzler));
    
    MethodSwizzle([UIView class],
                  @selector(sizeThatFits:),
                  @selector(PRE__sizeThatFits:));
    
    MethodSwizzle([UIView class],
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
  
  LLLayout *layout = self.layout;
  
  if (layout) {
    [layout layoutSubviews:self];
  }
  
  // Call the original implementation.
  [self PRE__layoutSubviewsSwizzler];
}

- (CGSize)PRE__sizeThatFits:(CGSize)size {
  
  LLLayout *layout = self.layout;
  
  if (layout) {
    return [layout computeSizeForView:self withAvailableSize:size];
  }
  
  // Call the original implementation.
  return [self PRE__sizeThatFits:size];
}

- (void)PRE__didAddSubview:(UIView *)subview {
  
  LLLayout *layout = self.layout;
  
  if (layout) {
    // Automatically resize our dimensions when a new view is added.
    // NOTE: It may be too expensive to call this each time.
    [self sizeToFit];
  }
  
  // Call the original implementation.
  [self PRE__didAddSubview:subview];
}


- (LLLayout *)layout {
  return [[self PRE__ivars] objectForKey:@"layout"];
}

- (void)setLayout:(LLLayout *)layout {
  [[self PRE__ivars] setObject:layout forKey:@"layout"];
}

- (LLLayoutParams *)layoutParams {
  return [[self PRE__ivars] objectForKey:@"layoutParams"];  
}

- (void)setLayoutParams:(LLLayoutParams *)layoutParams {
  [[self PRE__ivars] setObject:layoutParams forKey:@"layoutParams"];
}

@end
