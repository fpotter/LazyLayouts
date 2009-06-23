
#import "TestHelper.h"
#import <LazyLayouts/LazyLayouts.h>

@interface MyView : UIView

@end

@implementation MyView

- (CGSize)sizeThatFits:(CGSize)size {
  LLLOG(@"sizeThatFits:");
  LLLOGSIZE(size);
  return [super sizeThatFits:size];
}

@end


@interface VerticalLayoutViewTest : GHTestCase {
  NSAutoreleasePool *_pool;
}
@end

@implementation VerticalLayoutViewTest

- (void)setUp {  
  _pool = [[NSAutoreleasePool alloc] init];
}

- (void)tearDown {
  [_pool release];
}

- (void)testCanLayoutBoxesVertically {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 40, 40, 40), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(0, 80, 40, 40), @"");  
}

- (void)testLayoutCanResizeToFitSubviews {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 40, 120), @"View should resize to fit children");
}

- (void)testSizeThatFitsReturnsCorrectSize {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  GHAssertEqualSizes([view sizeThatFits:CGSizeZero], CGSizeMake(40, 120), @"Size should take into account children");
}

- (void)testSizeToFitWorks {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view sizeToFit];
  
  GHAssertEqualSizes(view.frame.size, CGSizeMake(40, 120), @"Size should take into account children");
}


- (void)testSizeToFitDoesntChangePositionsOfChildren {
  
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view sizeToFit];
  
  GHAssertEqualSizes(view.frame.size, CGSizeMake(40, 120), @"Size should take into account children");
  
  // Everything should still be where it was...
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(0, 0, 40, 40), @"");  
}

- (void)testCanLayoutBoxesVerticallyWithSpacing {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  view.spacing = 10;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 40, 140), 
                     @"Parent should have the correct spacing.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 50, 40, 40), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(0, 100, 40, 40), @"");
}

- (void)testCanLayoutBoxesVerticallyWithAlignment {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne align:LLVerticalLayoutAlignLeft];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo align:LLVerticalLayoutAlignCenter];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree align:LLVerticalLayoutAlignRight];
  
  // This guy will be the largest, and will decide how big the whole view becomes.
  UIView *bigBox = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)] autorelease];
  [view addSubview:bigBox];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 120, 160), 
                     @"Parent should have the correct spacing.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"Should be left aligned");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(40, 40, 40, 40), @"Should be center aligned");
  GHAssertEqualRects(boxThree.frame, CGRectMake(80, 80, 40, 40), @"Should be right aligned");
  GHAssertEqualRects(bigBox.frame, CGRectMake(0, 120, 120, 40), @"Should strecth along the bottom");
}

- (void)testCanLayoutBoxesWithMargins {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne margins:UIEdgeInsetsMake(10, 10, 10, 10)];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 60, 100), 
                     @"Parent should have the correct spacing.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(10, 10, 40, 40), @"Should be indented a bit because of the margin");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 60, 40, 40), @"");
}

//- (void)testExpandToFillWidthUsesTheGivenSizeAsTheMinimumWidth {
//  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)] autorelease];
//  
//  // Because we've set some real bounds here, our view could expand to fill
//  // more width but should never come out smaller than this.
//  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];  
//  [view addSubview:boxOne align:LLVerticalLayoutAlignLeft margins:UIEdgeInsetsZero fillWidth:YES fillHeight:NO];
//  
//  [view layoutIfNeeded];
//  
//  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 40, 40), 
//                     @"There's no more space to expand to, so just take the size of the child.");
//}

- (void)testCanAdjustSizeOfViewWithinLayout {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 40, 120), 
                     @"Parent should grow to encompass the children.");
  
  // Make boxTwo grow its hight by 20
  CGRect frame = boxTwo.frame;
  frame.size.height = 60;
  boxTwo.frame = frame;
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 40, 140), 
                     @"Parent should enlarge.");
  
  // Locations should have shifted...
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 40, 40, 60), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(0, 100, 40, 40), @"");  
}

- (void)testLayoutViewsCanOptToBeResizedToFitTheirChildren {
  // We set some specific dimensions here...
  LLVerticalLayoutView *view = [[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  view.resizeToFitSubviews = YES;
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  // This should destroy the existing dimensions on this view
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 40, 120), 
                     @"Parent should grow to encompass the children.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 40, 40, 40), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(0, 80, 40, 40), @"");
}

- (void)testLayoutViewsAreNotResizedByTheirChildrenByDefault {
  // We set some specific dimensions here...
  LLVerticalLayoutView *view = [[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  // Things should stay the same
  GHAssertEqualRects(view.frame, CGRectMake(0, 0, 320, 480), 
                     @"Parent should grow to encompass the children.");
  
  // Each box should still be the same size, and be in the right spot.
  GHAssertEqualRects(boxOne.frame, CGRectMake(0, 0, 40, 40), @"");
  GHAssertEqualRects(boxTwo.frame, CGRectMake(0, 40, 40, 40), @"");
  GHAssertEqualRects(boxThree.frame, CGRectMake(0, 80, 40, 40), @"");
}

- (void)testViewsCanExpandToFillWidth {
  LLVerticalLayoutView *view = [[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  UIView *box = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:box align:LLVerticalLayoutAlignLeft margins:UIEdgeInsetsZero fillWidth:YES fillHeight:NO];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(box.frame, CGRectMake(0, 0, 320, 40), 
                     @"Child should expand to fill width");
}

- (void)testViewsCanExpandToFillHeight {
  LLVerticalLayoutView *view = [[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  UIView *box = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:box align:LLVerticalLayoutAlignLeft margins:UIEdgeInsetsZero fillWidth:NO fillHeight:YES];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(box.frame, CGRectMake(0, 0, 40, 480), 
                     @"Child should expand to fill height");
}

- (void)testViewsCanExpandToFillWidthAndHeight {
  LLVerticalLayoutView *view = [[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  UIView *box = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:box align:LLVerticalLayoutAlignLeft margins:UIEdgeInsetsZero fillWidth:YES fillHeight:YES];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(box.frame, CGRectMake(0, 0, 320, 480),
                     @"Child should expand to fill width & height");
}

- (void)testLayoutsCanBeNestedAndChildCanExpandToFillTheRootViewsWidth {
  LLVerticalLayoutView *grandparent = [[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  LLVerticalLayoutView *parent = [[LLVerticalLayoutView alloc] initWithFrame:CGRectZero];
  parent.resizeToFitSubviews = YES;
  
  [grandparent addSubview:parent];
  
  UIView *box = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  // Set margins of top:1, left:2, bottom:3, right:4
  [parent addSubview:box align:LLVerticalLayoutAlignLeft margins:UIEdgeInsetsMake(1, 2, 3, 4) fillWidth:YES fillHeight:YES];
  
  [grandparent layoutIfNeeded];
  
  GHAssertEqualRects(box.frame, CGRectMake(2, 1, 320 - 6, 480 - 4),
                     @"Child should expand to fill width & height minus margins");
  
  GHAssertEqualRects(parent.frame, CGRectMake(0, 0, 320, 480),
                     @"Child should expand to fill width & height");
}

- (void)testBackgroundViewFrameIsSameAsLayoutFrame {
  LLVerticalLayoutView *view = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  view.resizeToFitSubviews = YES;
  view.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxOne];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  [view addSubview:boxThree];
  
  [view layoutIfNeeded];
  
  GHAssertEqualRects(view.backgroundView.frame, CGRectMake(0, 0, 40, 120), 
                     @"Background view should fill all the space");

}

- (void)testLayoutWithoutDimensionedParentWillUseScreenSizeToDetermineAvailableSpace {
  // When a layout doesn't have a parent, is set to resize to its subviews, there's no
  // way to know how much space is actually available.  In that case, the layout library will
  // just assume the whole screen is available.  This consistent with Apple's documentation
  // for sizeToFit
  
  // A good test case for this is UILabel.  If you have a multi-line UILabel and call sizeThatFits
  // on it with <0, 0>, the label will just appear as a single line.  If you give it proper bounds
  // (e.g. a width of 320), then you'll get the right dimensions.

  UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  label.lineBreakMode = UILineBreakModeWordWrap;
  label.numberOfLines = 0;
  label.font = [UIFont systemFontOfSize:14.0];
  label.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nulla magna, non pellentesque metus. Cras magna nisl, tincidunt vel sollicitudin nec, placerat a nibh. Mauris pellentesque auctor volutpat. Etiam venenatis felis accumsan lacus iaculis porttitor eu ut elit. Proin quam tellus, ultricies eget euismod non, pulvinar quis mauris.";
  label.textAlignment = UITextAlignmentCenter;
  
  LLVerticalLayoutView *container = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  container.resizeToFitSubviews = YES;
  [container addSubview:label];
  
  [container layoutIfNeeded];
  
  GHAssertEqualRects(label.frame, CGRectMake(0, 0, 320, 126), 
                     @"Label should wrap to fit constraints");  
  
  GHAssertEqualRects(container.frame, CGRectMake(0, 0, 320, 126), 
                     @"");  
  
}

- (void)testLayoutWithDimensionedParentWillUseParentToDetermineAvailableSpace {
  // When a layout does have a parent, we should get an accurate available size
  
  // A good test case for this is UILabel.  If you have a multi-line UILabel and call sizeThatFits
  // on it with <0, 0>, the label will just appear as a single line.  If you give it proper bounds
  // (e.g. a width of 320), then you'll get the right dimensions.
  
  UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  label.lineBreakMode = UILineBreakModeWordWrap;
  label.numberOfLines = 0;
  label.font = [UIFont systemFontOfSize:14.0];
  label.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vitae nulla magna, non pellentesque metus. Cras magna nisl, tincidunt vel sollicitudin nec, placerat a nibh. Mauris pellentesque auctor volutpat. Etiam venenatis felis accumsan lacus iaculis porttitor eu ut elit. Proin quam tellus, ultricies eget euismod non, pulvinar quis mauris.";
  label.textAlignment = UITextAlignmentCenter;
  
  LLVerticalLayoutView *parent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  parent.resizeToFitSubviews = YES;
  [parent addSubview:label];
  
  LLVerticalLayoutView *grandParent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 200, 1000)] autorelease];
  grandParent.resizeToFitSubviews = NO;
  [grandParent addSubview:parent];
  
  
  [grandParent layoutIfNeeded];
  
  GHAssertEqualRects(label.frame, CGRectMake(0, 0, 198, 216), 
                     @"Label should wrap to fit constraints");  
  
  GHAssertEqualRects(parent.frame, CGRectMake(0, 0, 198, 216), 
                     @"");  
  
}

- (void)testViewCanDeriveAvailableSizeFromFirstFixedSizeParentWhichIsALayout {
  
  UIView *child = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];

  LLVerticalLayoutView *parent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  parent.resizeToFitSubviews = YES;
  [parent addSubview:child margins:UIEdgeInsetsZero fillWidth:YES fillHeight:YES];
  
  LLVerticalLayoutView *grandParent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  grandParent.resizeToFitSubviews = YES;
  [grandParent addSubview:parent];
  
  
  LLVerticalLayoutView *greatGrandParent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)] autorelease];
  greatGrandParent.resizeToFitSubviews = NO;
  [greatGrandParent addSubview:grandParent];
  
  [greatGrandParent layoutIfNeeded];

  // The first fixed size layout parent is the great grand parent, so the child (and its containers) should
  // fill the the great greant parent's size.
  GHAssertEqualRects(child.frame, CGRectMake(0, 0, 200, 200), @"Child should expand.");
  GHAssertEqualRects(parent.frame, CGRectMake(0, 0, 200, 200), @"Parent should expand.");
  GHAssertEqualRects(grandParent.frame, CGRectMake(0, 0, 200, 200), @" should expand.");
}

- (void)testViewCanDeriveAvailableSizeFromFirstFixedSizeParentWhichIsNotALayout {
  
  UIView *child = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  
  LLVerticalLayoutView *parent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  parent.resizeToFitSubviews = YES;
  [parent addSubview:child margins:UIEdgeInsetsZero fillWidth:YES fillHeight:YES];
  
  LLVerticalLayoutView *grandParent = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  grandParent.resizeToFitSubviews = YES;
  [grandParent addSubview:parent];
  
  
  UIView *greatGrandParent = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)] autorelease];
  [greatGrandParent addSubview:grandParent];
  
  [greatGrandParent layoutIfNeeded];
  
  // The first fixed size layout parent is the great grand parent, so the child (and its containers) should
  // fill the the great greant parent's size.
  GHAssertEqualRects(child.frame, CGRectMake(0, 0, 200, 200), @"Child should expand.");
  GHAssertEqualRects(parent.frame, CGRectMake(0, 0, 200, 200), @"Parent should expand.");
  GHAssertEqualRects(grandParent.frame, CGRectMake(0, 0, 200, 200), @" should expand.");
}

@end
