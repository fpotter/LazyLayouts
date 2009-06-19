
#import <Three20/Three20.h>
#import "TestHelper.h"
#import "LazyLayouts.h"

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

- (void)testExpandToFillWidthUsesTheGivenSizeAsTheMinimumWidth {
  UIView *view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  view.lazyLayout = [LLVerticalLayout layout];
  
  // Because we've set some real bounds here, our view could expand to fill
  // more width but should never come out smaller than this.
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxOne.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft
                                                                margins:UIEdgeInsetsZero
                                                      expandToFillWidth:YES
                                                     expandToFillHeight:NO];
  [view addSubview:boxOne];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), view.frame,
                     @"There's no more space to expand to, so just take the size of the child.");
}

- (void)testCanAdjustSizeOfViewWithinLayout {
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
  
  // Make boxTwo grow its hight by 20
  CGRect frame = boxTwo.frame;
  frame.size.height = 60;
  boxTwo.frame = frame;
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 40, 140), view.frame,
                     @"Parent should enlarge.");
  
  // Locations should have shifted...
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 40, 40, 60), boxTwo.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 100, 40, 40), boxThree.frame, @"");  
}

- (void)testAdjustingSizeOfViewAutomaticallyForcesALayout {
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
  
  // Make boxTwo grow its hight by 20
  CGRect frame = boxTwo.frame;
  frame.size.height = 60;
  boxTwo.frame = frame;
  
  // Just by setting the frame above, all the dimension should have change.
  
  GHAssertEqualRects(CGRectMake(0, 0, 40, 140), view.frame,
                     @"Parent should enlarge.");
  
  // Locations should have shifted...
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 40, 40, 60), boxTwo.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 100, 40, 40), boxThree.frame, @"");  
}

- (void)testLayoutViewsAreResizedToFitTheirChildren {
  // We set some specific dimensions here...
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  view.lazyLayout = [LLVerticalLayout layout];
//  view.lazyLayout.resizeToFitSubviews = NO;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];

  // This should destroy the existing dimensions on this view
  [view layoutIfNeeded];
  
  GHAssertEqualRects(CGRectMake(0, 0, 40, 120), view.frame,
                     @"Parent should grow to encompass the children.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 40, 40, 40), boxTwo.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 80, 40, 40), boxThree.frame, @"");
}

- (void)testLayoutViewsCanOptToNotBeResizedByTheirChildren {
  // We set some specific dimensions here...
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  view.lazyLayout = [LLVerticalLayout layout];
  
  // Don't resize me!
  view.lazyLayout.resizeToFitSubviews = NO;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];

  // Things should stay the same
  GHAssertEqualRects(CGRectMake(0, 0, 320, 480), view.frame,
                     @"Parent should grow to encompass the children.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 40, 40, 40), boxTwo.frame, @"");
  GHAssertEqualRects(CGRectMake(0, 80, 40, 40), boxThree.frame, @"");
}

- (void)testCanNestSomeLayouts {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  view.lazyLayout = [LLVerticalLayout layout];
  view.lazyLayout.resizeToFitSubviews = NO;
  
  UIView *nestedView = [[UIView alloc] initWithFrame:CGRectZero];
  nestedView.lazyLayout = [LLVerticalLayout layout];
  [view addSubview:nestedView];
    
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [nestedView addSubview:boxOne];
  
  [view layoutIfNeeded];

  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), nestedView.frame,
                     @"Parent should grow to encompass the children.");

  GHAssertEqualRects(CGRectMake(0, 0, 40, 40), boxOne.frame,
                     @"Child should be in the right spot");
}


@end