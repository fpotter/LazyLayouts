
#import "LazyLayouts/UIViewAdditions.h"
#import </usr/include/objc/objc-class.h>
#import "MethodSwizzle.h"

volatile static NSMutableDictionary *generationIndices = nil;
volatile static NSMutableDictionary *classToSuperclassDict = nil;
volatile static NSMutableDictionary *instanceIDToIvars = nil;
static NSMutableSet *swizzledClasses = nil;
volatile static BOOL needToSwizzleMethods = YES;

void LLMethodSwizzle(Class c, SEL orig, SEL new) {
  
    NSLog(@"Swizzle %s -> %s", sel_getName(orig), sel_getName(new));
  MethodSwizzle(c, orig, new);
  

  /*
  Method origMethod = class_getInstanceMethod(c, orig);
  Method newMethod = class_getInstanceMethod(c, new);
  
  NSLog(@"Swizzle %s -> %s", sel_getName(orig), sel_getName(new));
  
	if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
    class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	} else {
		method_exchangeImplementations(origMethod, newMethod);
	}
*/
}

/*!
 We have to maintain an index into which level of the class hiearchy we're
 working on, and we have to do it for each individual instance.
 */
NSString *GetKeyForInstanceAndSelector(id self, SEL sel) {
  return [NSString stringWithFormat:@"%@_%s", [NSValue valueWithPointer:self], sel_getName(sel)];
}

int GetGeneration(NSString *generationKey) {
  NSNumber *number = [generationIndices objectForKey:generationKey];
  
  if (number) {
    return [number intValue];
  } else {
    return 0;
  }
}

void IncrementGeneration(NSString *generationKey) {  
  NSLog(@"Incremented for %@", generationKey);
  int incremented = GetGeneration(generationKey) + 1;
  
  [generationIndices setObject:[NSNumber numberWithInt:incremented] 
                        forKey:generationKey];
}

void DecrementGeneration(NSString *generationKey) {
  NSLog(@"Decremented for %@", generationKey);  
  int decremented = GetGeneration(generationKey) - 1;
  
  if (decremented == 0) {
    [generationIndices removeObjectForKey:generationKey];
  } else {
    [generationIndices setObject:[NSNumber numberWithInt:decremented] 
                          forKey:generationKey];
  }
}

void LLSuperSwizzle(Class c, SEL orig, IMP methodImp) {
  NSString *selectorName = [NSString stringWithFormat:@"__%s_%s", class_getName(c), sel_getName(orig)];
  
  if ([selectorName isEqualToString:@"__UITextEffectsWindow___UITextEffectsWindow_layoutSubviews"]) {
    NSLog(@"whatever");
  }
  
  SEL newSelector = sel_registerName([selectorName cStringUsingEncoding:[NSString defaultCStringEncoding]]);
  
  if (!class_addMethod(c, newSelector, methodImp, "v@:")) {
    NSLog(@"no good!");
  }
  
  NSLog(@"Adding selector %@ on %@", selectorName, c);
  
  LLMethodSwizzle(c, orig, newSelector);  
}

/*!
 Returns true if A inherits from B at some point down the line, or if A is B.
 */
BOOL LLClassDescendsFromClass(Class a, Class b) {
  
  if (strcmp(class_getName(a), class_getName(b)) == 0) {
    return NO;
  }
  
  // Not really sure how to test for equality other than the compaire
  // their names...
  
  for (;;) {    
    if (strcmp(class_getName(a), class_getName(b)) == 0) {
      // We found it!
      return YES;
    }
    
    a = class_getSuperclass(a);
    
    if (a == nil) {
      // We wen't all the way down, and didn't find B as an ancestor.
      break;
    }
  }
  
  return NO;
}

void LLSwizzleAllClassesInDictionary(NSDictionary *dict, SEL selector, IMP implementation) {
  for (NSString *className in [dict allKeys]) {
    LLSuperSwizzle(NSClassFromString(className), selector, implementation);
  }
}

NSMutableDictionary *GetDictionaryOfClassesToSuperclasses(Class requiredAncestor) {
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
  
  int numClasses = objc_getClassList(NULL, 0);  
  
  // Get a list of every class registered with Objective-C
  Class *classes = malloc(sizeof(Class) * numClasses);  
  objc_getClassList(classes, numClasses);
  
  // Loop through them all, recording the class and its super class
  for (int i = 0; i < numClasses; i++) {
    Class c = classes[i];
    
    if (LLClassDescendsFromClass(c, requiredAncestor)) {      
      NSString *className = [NSString stringWithCString:class_getName(c)];
      
      if (![className isEqualToString:@"_NSZombie_"]) {
        Class superClass = class_getSuperclass(c);
        
        if (superClass) {          
          NSString *superClassName = [NSString stringWithCString:class_getName(superClass)];
          NSLog(@">>>>>> %@ -- %@", className, superClassName);
          [dict setObject:superClassName forKey:className];
        }
      }
    }
  }
  
  free(classes);  
  return dict;
}

void LLCallOriginalImpFromSwizzler(id self, SEL cmd, int generationIndex, NSString *generationKey) {
  NSString *className = [NSString stringWithCString:class_getName([self class])];
  
  // Figure out which ancestor we're currently in...
  for (int i = 0; i < generationIndex; i++) {    
    className = (NSString *)[classToSuperclassDict objectForKey:className];
  }
  
  NSString *selectorName = [NSString stringWithFormat:@"__%@_%s", NSClassFromString(className), sel_getName(cmd)];
  SEL sel = sel_registerName([selectorName cStringUsingEncoding:[NSString defaultCStringEncoding]]);
  
  NSLog(@"Calling %@ on %@", selectorName, self);
  
  IncrementGeneration(generationKey);
  objc_msgSend(self, sel);  
  DecrementGeneration(generationKey);
}

@interface UIView (LLAdditions_Private)
- (id)LL__instanceID;
@end

void LL__deallocSwizzler(id self, SEL cmd) {
  NSString *generationKey = GetKeyForInstanceAndSelector(self, cmd);
  int generation = GetGeneration(generationKey);
  
  if (generation == 0) {
    // This is the top-most level
    [instanceIDToIvars removeObjectForKey:[((UIView *) self) LL__instanceID]];
    if ([instanceIDToIvars count] == 0) {    
      [instanceIDToIvars release];
      instanceIDToIvars = nil;
    }
  }
  
  LLCallOriginalImpFromSwizzler(self, cmd, generation, generationKey);
}

void LL__layoutSubviewsSwizzler(id self, SEL cmd) {
  
  if ([[NSString stringWithCString:sel_getName(cmd)] hasPrefix:@"__"]) {
    NSLog(@"not cool!");
  }
  
  NSString *generationKey = GetKeyForInstanceAndSelector(self, cmd);
  int generation = GetGeneration(generationKey);
  
  if (generation == 0) {
    // When the generation is 0, it means we're acting on the top-most level.
    UIView *viewSelf = ((UIView *) self);
    LLLayout *layout = [viewSelf lazyLayout];
    if (layout != nil) {
      [layout layoutSubviews:viewSelf withAvailableSize:viewSelf.frame.size];
    }    
  }
  
  // Always give the class a chance to do its own layout
  LLCallOriginalImpFromSwizzler(self, cmd, generation, generationKey);
}

@implementation UIView (LLAdditions)

- (id)LL__instanceID {
  return [NSValue valueWithPointer:self];
}

- (NSMutableDictionary *)LL__ivars {
  NSMutableDictionary *ivars;
  
  if (needToSwizzleMethods) {
    //LLSwizzleAllUIViewDescendents();
    swizzledClasses = [[NSMutableSet alloc] initWithCapacity:0];
    generationIndices = [[NSMutableDictionary alloc] initWithCapacity:0];
    classToSuperclassDict = [GetDictionaryOfClassesToSuperclasses([UIView class]) retain];
    
//    LLSwizzleAllClassesInDictionary(classToSuperclassDict, @selector(dealloc), (IMP) LL__deallocSwizzler);
//    LLSwizzleAllClassesInDictionary(classToSuperclassDict, @selector(layoutSubviews), (IMP) LL__layoutSubviewsSwizzler);
    
    Class c = [UIView class];
    
//    LLMethodSwizzle(c,
//                    @selector(layoutSubviews),
//                    @selector(LL__layoutSubviewsSwizzler));
//    
    LLMethodSwizzle(c,
                    @selector(sizeThatFits:),
                    @selector(LL__sizeThatFits:));
    
    LLMethodSwizzle(c,
                    @selector(didAddSubview:),
                    @selector(LL__didAddSubview:));
    
    LLMethodSwizzle(c,
                    @selector(didMoveToSuperview),
                    @selector(LL__didMoveToSuperview));
    
    LLMethodSwizzle(c,
                    @selector(setFrame:),
                    @selector(LL__setFrame:));
    
    
    needToSwizzleMethods = NO;
  }
  
  if (![swizzledClasses containsObject:[[self class] description]]) {
    [swizzledClasses addObject:[[self class] description]];
    LLSuperSwizzle([self class], @selector(dealloc), (IMP) LL__deallocSwizzler);
    LLSuperSwizzle([self class], @selector(layoutSubviews), (IMP) LL__layoutSubviewsSwizzler);
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

//- (void)LL__deallocSwizzler {
//  [instanceIDToIvars removeObjectForKey:[self LL__instanceID]];
//  if ([instanceIDToIvars count] == 0) {    
//    [instanceIDToIvars release];
//    instanceIDToIvars = nil;
//  }
//  
//  // Call the original dealloc
//  [self LL__deallocSwizzler];
//}

//- (void)LL__layoutSubviewsSwizzler {
//
//  LLLayout *layout = self.lazyLayout;
//  if (layout != nil) {
//    [layout layoutSubviews:self withAvailableSize:self.frame.size];
//  } else {
//    [self LL__layoutSubviewsSwizzler];
//  }
//}

- (CGSize)LL__sizeThatFits:(CGSize)size {
  return [self layoutView:size];
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
