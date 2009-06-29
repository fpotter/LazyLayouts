
#import "TestHelper.h"
#import <LazyLayouts/LazyLayouts.h>

@interface HorizontalLayoutViewTest : GHTestCase {
  NSAutoreleasePool *_pool;
}
@end

@implementation HorizontalLayoutViewTest

- (void)setUp {  
  _pool = [[NSAutoreleasePool alloc] init];
}

- (void)tearDown {
  [_pool release];
}

- (void)testCanLayoutBoxesVertically {
  LLHorizontalLayoutView *view = [[[LLHorizontalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(40, 0, 40, 40), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(80, 0, 40, 40), @"");  
}

- (void)testLayoutCanResizeToFitSubviews {
  LLHorizontalLayoutView *view = [[[LLHorizontalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 120, 40), @"View should resize to fit children");
}


@end
