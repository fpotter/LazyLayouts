
#import "TestHelper.h"
#import "LazyLayouts.h"

//#define AssertRectsAreEqual(a1, a2) \
//  GHAssertEquals( \
//    NSStringFromCGRect(a1), \
//    NSStringFromCGRect(a2), \
//    @"Expect rects to be equal!");


@interface VerticalLayoutTest : GHTestCase {}
  NSAutoreleasePool *_pool;
@end

@implementation VerticalLayoutTest

- (void)setUp {  
  _pool = [[NSAutoreleasePool alloc] init];
}

- (void)tearDown {
  [_pool release];
}

- (void)testCanLayoutBoxesVertically {
  UIView *view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  view.lazyLayout = [LLVerticalLayout layout];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];

  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 40, 120), view.frame,
                     @"Parent should grow to encompass the children.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 40, 40, 40), boxTwo.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 80, 40, 40), boxThree.frame, @"");  
}

- (void)testCanLayoutBoxesVerticallyWithSpacing {
  UIView *view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  view.lazyLayout = [LLVerticalLayout layoutWithSpacing:10];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 40, 140), view.frame,
                     @"Parent should have the correct spacing.");

  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 50, 40, 40), boxTwo.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 100, 40, 40), boxThree.frame, @"");
}

- (void)testCanLayoutBoxesVerticallyWithAlignment {
  UIView *view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  view.lazyLayout = [LLVerticalLayout layout];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxOne.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxTwo.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxThree.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignRight];
  [view addSubview:boxThree];
  
  // This guy will be the largest, and will decide how big the whole view becomes.
  UIView *bigBox = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)] autorelease];
  [view addSubview:bigBox];
  
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 120, 160), view.frame,
                     @"Parent should have the correct spacing.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"Should be left aligned");
  GHAssertEqualRects(CGRectMake(40, 40, 40, 40), boxTwo.frame, @"Should be center aligned");
  GHAssertEqualRects(CGRectMake(80, 80, 40, 40), boxThree.frame, @"Should be right aligned");
  GHAssertEqualRects(CGRectMake(0, 120, 120, 40), bigBox.frame, @"Should strecth along the bottom");
}

- (void)testCanLayoutBoxesWithMargins {
  UIView *view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  view.lazyLayout = [LLVerticalLayout layout];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxOne.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft
                                                                margins:UIEdgeInsetsMake(10, 10, 10, 10)
                                                      expandToFillWidth:NO
                                                     expandToFillHeight:NO];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxTwo.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft];
  [view addSubview:boxTwo];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 60, 100), view.frame,
                     @"Parent should have the correct spacing.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(CGRectMake(10, 10, 40, 40), boxOne.frame, @"Should be indented a bit because of the margin");
  GHAssertEqualRects(CGRectMake(0, 60, 40, 40), boxTwo.frame, @"");
}

@end