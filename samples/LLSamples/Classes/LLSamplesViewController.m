
#import "LLSamplesViewController.h"
#import <LazyLayouts/LazyLayouts.h>
#import <LazyLayouts/UIViewAdditions.h>

@implementation LLSamplesViewController

- (void)loadView {
  
  UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)] autorelease];
  container.backgroundColor = [UIColor yellowColor];
  container.lazyLayout = [LLVerticalLayout layout];
  container.lazyLayout.resizeToFitSubviews = NO;
  
  UIView *topArea = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  topArea.backgroundColor = [UIColor lightGrayColor];
  topArea.lazyLayout = [LLVerticalLayout layout];

  UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
  leftLabel.text = @"Left Aligned";  
  leftLabel.backgroundColor = [UIColor redColor];
  leftLabel.textColor = [UIColor whiteColor];
  leftLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft];  
  [topArea addSubview:leftLabel];
  
  UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
  centerLabel.text = @"Center Aligned";  
  centerLabel.backgroundColor = [UIColor blueColor];
  centerLabel.textColor = [UIColor whiteColor];
  centerLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter];  
  [topArea addSubview:centerLabel];
  
  UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
  rightLabel.text = @"Right Aligned";  
  rightLabel.backgroundColor = [UIColor purpleColor];
  rightLabel.textColor = [UIColor whiteColor];
  rightLabel.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignRight];  
  [topArea addSubview:rightLabel];
    
  [container addSubview:topArea];

  UIView *middleArea = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  middleArea.backgroundColor = [UIColor orangeColor];
  middleArea.lazyLayout = [LLVerticalLayout layout];
  
  UILabel *labelWithMargin = [[UILabel alloc] initWithFrame:CGRectZero];  
  labelWithMargin.text = @"Label with top/left margin of 10";  
  labelWithMargin.backgroundColor = [UIColor redColor];
  labelWithMargin.textColor = [UIColor whiteColor];
  labelWithMargin.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter
                                                                    margins:UIEdgeInsetsMake(10, 10, 10, 10)
                                                          expandToFillWidth:NO
                                                         expandToFillHeight:NO];
  [middleArea addSubview:labelWithMargin];
  
  UILabel *expandLabelWithMargin = [[UILabel alloc] initWithFrame:CGRectZero];  
  expandLabelWithMargin.text = @"Label expanded to fill width";  
  expandLabelWithMargin.backgroundColor = [UIColor redColor];
  expandLabelWithMargin.textColor = [UIColor whiteColor];
  expandLabelWithMargin.lazyLayoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft
                                                                         margins:UIEdgeInsetsMake(10, 10, 0, 0)
                                                               expandToFillWidth:YES
                                                              expandToFillHeight:NO];
  
  [middleArea addSubview:expandLabelWithMargin];
  
  [container addSubview:middleArea];
  
  
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
