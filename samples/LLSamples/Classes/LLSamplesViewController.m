
#import "LLSamplesViewController.h"
#import <LazyLayouts/LazyLayouts.h>
#import <LazyLayouts/UIViewAdditions.h>

@implementation LLSamplesViewController

- (void)loadView {
  UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
  container.backgroundColor = [UIColor yellowColor];
  container.layout = [LLVerticalLayout layoutWithSpacing:30];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];  
  label.text = @"Left Aligned";  
  label.backgroundColor = [UIColor clearColor];
  label.layoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignLeft];
  
  [container addSubview:label];
  
  UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];  
  label2.text = @"Center Aligned";  
  label2.backgroundColor = [UIColor clearColor];
  label2.layoutParams = [LLVerticalLayoutParams paramsWithAlignment:LLVerticalLayoutAlignCenter];
  
  [container addSubview:label2];
  
  container.frame = CGRectMake(0, 50, container.frame.size.width, container.frame.size.height);
  
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
