
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLLayout : NSObject {
  BOOL _resizeToFitSubviews;
}

@property (nonatomic, assign) BOOL resizeToFitSubviews;

/**
 * Subclasses of LLLayout should implement this method to calculate their dimensions
 * and position/size their children accordingly.
 *
 * NOTE: The last thing you do in layoutSubviews should always be to set the frame.
 */
- (CGSize)layoutSubviews:(UIView *)view withAvailableSize:(CGSize)availableSize;

@end

@interface LLLayoutParams : NSObject {
@private
  UIEdgeInsets _margins;  
  BOOL _expandToFillWidth;
  BOOL _expandToFillHeight;
}

@property (nonatomic, assign) UIEdgeInsets margins;
@property (nonatomic, assign) BOOL expandToFillWidth;
@property (nonatomic, assign) BOOL expandToFillHeight;

@end
