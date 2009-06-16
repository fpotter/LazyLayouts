
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLLayout : NSObject {
}

/**
 * Subclasses of LLLayout should fill in this method with their
 * layout algorithm.
 */
- (void)layoutSubviews:(UIView *)view;

/**
 * Subclasses of LLLayout should fill in this method with 
 */
- (CGSize)computeSizeForView:(UIView *)view withAvailableSize:(CGSize)availableSize;

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
