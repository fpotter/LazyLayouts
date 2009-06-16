
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
