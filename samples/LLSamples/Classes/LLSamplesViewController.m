
#import "LLSamplesViewController.h"
#import <LazyLayouts/LazyLayouts.h>
#import <LazyLayouts/UIViewAdditions.h>

static UIView *topArea = nil;
static UIView *container = nil;

@implementation LLSamplesViewController



- (void)addView {
  NSLog(@"Here!");
  topArea.frame = CGRectMake(topArea.frame.origin.x, topArea.frame.origin.y, topArea.frame.size.width, topArea.frame.size.height + 10);
  [self.view layoutIfNeeded];
  [self.view setNeedsDisplay];
}

- (void)loadView {
  
  container = [[[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)] autorelease];
  container.backgroundColor = [UIColor yellowColor];
  container.lazyLayout = [LLVerticalLayout layout];
  container.lazyLayout.resizeToFitSubviews = NO;
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//  button.titleLabel.text = @"Click Me";
  //button.frame = CGRectMake(10, 10, 80, 30);
  [button addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
  [container addSubview:button];
  
  topArea = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  topArea.backgroundColor = [UIColor lightGrayColor];
  topArea.lazyLayout = [LLVerticalLayout layout];
  [container addSubview:topArea];
  
  UIView *boxOne = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxOne.backgroundColor = [UIColor redColor];
  boxOne.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft];
  [topArea addSubview:boxOne];
  
  UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];  
  leftLabel.text = @"Left Aligned alsdkjflkasdf l;kadfjs;lkjasldkf l;kadjsflkjasdkljf ;lakdjsfl;kadjsf ;lkadjsflkjasdf l;kadjsflkjasdf lk;adjsflkjasdf lkajsdflkjasdlfkj ;lkasdjflkjasdfj ;lkadfjslkajsdfkllladfjs lk;adsflkjasdljf";  
  leftLabel.numberOfLines = 0;
  leftLabel.lineBreakMode = UILineBreakModeWordWrap;
  leftLabel.backgroundColor = [UIColor redColor];
  leftLabel.textColor = [UIColor whiteColor];
  leftLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft
margins:UIEdgeInsetsZero
expandToFillWidth:YES
                                                        expandToFillHeight:NO];
  [leftLabel sizeToFit];
  [topArea addSubview:leftLabel];
  
  UIView *boxTwo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxTwo.backgroundColor = [UIColor blueColor];  
  boxTwo.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter];
  [topArea addSubview:boxTwo];
  
  UIView *boxThree = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
  boxThree.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter];
  boxThree.backgroundColor = [UIColor greenColor];
  [topArea addSubview:boxThree];
  

//  UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
//  leftLabel.text = @"Left Aligned";  
//  leftLabel.backgroundColor = [UIColor redColor];
//  leftLabel.textColor = [UIColor whiteColor];
//  leftLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft];  
//  [topArea addSubview:leftLabel];
//  
//  UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
//  centerLabel.text = @"Center Aligned";  
//  centerLabel.backgroundColor = [UIColor blueColor];
//  centerLabel.textColor = [UIColor whiteColor];
//  centerLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter];  
//  [topArea addSubview:centerLabel];
//  
//  UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
//  rightLabel.text = @"Right Aligned";
//  rightLabel.backgroundColor = [UIColor purpleColor];
//  rightLabel.textColor = [UIColor whiteColor];
//  rightLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignRight
//margins:UIEdgeInsetsMake(-10, 0, 0, 0)
//expandToFillWidth:NO
//                                                         expandToFillHeight:NO];
//  [topArea addSubview:rightLabel];
//  
//  
//    
//  [container addSubview:topArea];
//
//  UIView *middleArea = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//  middleArea.backgroundColor = [UIColor orangeColor];
//  middleArea.lazyLayout = [LLVerticalLayout layout];
//  
//  UILabel *labelWithMargin = [[UILabel alloc] initWithFrame:CGRectZero];  
//  labelWithMargin.text = @"Label with top/left margin of 10";  
//  labelWithMargin.backgroundColor = [UIColor redColor];
//  labelWithMargin.textColor = [UIColor whiteColor];
//  labelWithMargin.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter
//                                                                    margins:UIEdgeInsetsMake(10, 10, 10, 10)
//                                                          expandToFillWidth:NO
//                                                         expandToFillHeight:NO];
//  [middleArea addSubview:labelWithMargin];
//  
//  UILabel *expandLabelWithMargin = [[UILabel alloc] initWithFrame:CGRectZero];  
//  expandLabelWithMargin.text = @"Label expanded to fill width";  
//  expandLabelWithMargin.backgroundColor = [UIColor redColor];
//  expandLabelWithMargin.textColor = [UIColor whiteColor];
//  expandLabelWithMargin.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft
//                                                                         margins:UIEdgeInsetsMake(10, 10, 0, 0)
//                                                               expandToFillWidth:YES
//                                                              expandToFillHeight:NO];
//  
//  [middleArea addSubview:expandLabelWithMargin];
//  
//  [container addSubview:middleArea];
  
  
  self.view = container;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

@end
