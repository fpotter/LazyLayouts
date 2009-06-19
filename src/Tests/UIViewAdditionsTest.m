
#import <Three20/Three20.h>
#import "TestHelper.h"
#import "LazyLayouts.h"

@interface UIViewAdditionsTest : GHTestCase {}
  NSAutoreleasePool *_pool;
@end

@implementation UIViewAdditionsTest

- (void)setUp {  
  _pool = [[NSAutoreleasePool alloc] init];
}

- (void)tearDown {
  [_pool release];
}

- (void)testSizeThatFitsHonorsExpandToFillWidth {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  view.lazyLayoutParams = [[LLLayoutParams alloc] init];
  view.lazyLayoutParams.expandToFillWidth = YES;
  
  CGSize size = [view sizeThatFits:CGSizeMake(100, 100)];
  
  GHAssertEqualSizes(CGSizeMake(100, 0), size, @"View should have expanded.");
}

- (void)testSizeThatFitsHonorsExpandToFillHeight {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  view.lazyLayoutParams = [[LLLayoutParams alloc] init];
  view.lazyLayoutParams.expandToFillHeight = YES;
  
  CGSize size = [view sizeThatFits:CGSizeMake(100, 100)];
  
  GHAssertEqualSizes(CGSizeMake(0, 100), size, @"View should have expanded.");
}

- (void)testSizeThatFitsHonorsExpandToFillWidthAndHeight {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  view.lazyLayoutParams = [[LLLayoutParams alloc] init];
  view.lazyLayoutParams.expandToFillWidth = YES;  
  view.lazyLayoutParams.expandToFillHeight = YES;
  
  CGSize size = [view sizeThatFits:CGSizeMake(100, 100)];
  
  GHAssertEqualSizes(CGSizeMake(100, 100), size, @"View should have expanded.");
}

- (void)testSizeThatFitsUsesTheCurrentDimensionsAsMinimums {
  // We start with a 50x50 square.  Even if turn on fill in both directions,
  // we can never end up with a box smaller than 50x50 even if the available space
  // is less.
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  view.lazyLayoutParams = [[LLLayoutParams alloc] init];
  view.lazyLayoutParams.expandToFillWidth = YES;
  view.lazyLayoutParams.expandToFillHeight = YES;
  
  // We give it a space that's too small
  CGSize size = [view sizeThatFits:CGSizeMake(0, 0)];
  
  GHAssertEqualSizes(CGSizeMake(50, 50), size, @"Size should stay the same");
}

- (void)testSizeThatFitsActsAsNormalWhenThereAreNoParams {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  
  CGSize size = [view sizeThatFits:CGSizeMake(100, 100)];
  
  GHAssertEqualSizes(CGSizeMake(0, 0), size, @"View should not have expanded.");  
}

@end
