
#import "LLSamplesViewController.h"
#import <LazyLayouts/LazyLayouts.h>

@implementation LLSamplesViewController

- (void)loadView {
  
  LLVerticalLayoutView *container = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)] autorelease];
  container.backgroundColor = [UIColor yellowColor];
  container.resizeToFitSubviews = NO;
  
  LLVerticalLayoutView *topArea = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  topArea.backgroundColor = [UIColor lightGrayColor];

  UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
  leftLabel.text = @"Left Aligned";  
  leftLabel.backgroundColor = [UIColor redColor];
  leftLabel.textColor = [UIColor whiteColor];  
  [leftLabel sizeToFit];

  [topArea addSubview:leftLabel align:LLVerticalLayoutAlignLeft];
  
  UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
  centerLabel.text = @"Center Aligned";  
  centerLabel.backgroundColor = [UIColor blueColor];
  centerLabel.textColor = [UIColor whiteColor];
  [centerLabel sizeToFit];

  [topArea addSubview:centerLabel align:LLVerticalLayoutAlignCenter];

  
  UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];  
  rightLabel.text = @"Right Aligned";  
  rightLabel.backgroundColor = [UIColor purpleColor];
  rightLabel.textColor = [UIColor whiteColor];
  
  [topArea addSubview:rightLabel align:LLVerticalLayoutAlignRight];
    
  [container addSubview:topArea];

  LLVerticalLayoutView *middleArea = [[[LLVerticalLayoutView alloc] initWithFrame:CGRectZero] autorelease];
  middleArea.backgroundColor = [UIColor orangeColor];
  
  UILabel *labelWithMargin = [[UILabel alloc] initWithFrame:CGRectZero];  
  labelWithMargin.text = @"Label with top/left margin of 10";  
  labelWithMargin.backgroundColor = [UIColor redColor];
  labelWithMargin.textColor = [UIColor whiteColor];

  [middleArea addSubview:labelWithMargin align:LLVerticalLayoutAlignCenter margins:UIEdgeInsetsMake(10, 10, 10, 10)];
  
  UILabel *expandLabelWithMargin = [[UILabel alloc] initWithFrame:CGRectZero];  
  expandLabelWithMargin.text = @"Label expanded to fill width";  
  expandLabelWithMargin.backgroundColor = [UIColor redColor];
  expandLabelWithMargin.textColor = [UIColor whiteColor];
  [middleArea addSubview:labelWithMargin align:LLVerticalLayoutAlignCenter margins:UIEdgeInsetsMake(10, 10, 10, 10) fillWidth:YES fillHeight:NO];
  
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
