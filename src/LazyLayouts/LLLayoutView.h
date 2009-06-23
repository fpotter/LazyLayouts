
#import <UIKit/UIKit.h>

@class LLLayoutParams;

@interface LLLayoutView : UIView {
  BOOL _resizeToFitSubviews;
  NSMutableDictionary *_layoutParams;
  UIView *_backgroundView;
}

@property (nonatomic, assign) BOOL resizeToFitSubviews;
@property (nonatomic, retain) UIView *backgroundView;

/**
 * Adds a view and associated layout parameters to the internal list of views.
 * Ultimately, ever LLLayout implementation calls this method with the subview
 * and the Layout-specific params object.
 */
- (void)addSubview:(UIView *)subview withParams:(LLLayoutParams *)params;

- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins;
- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins fillWidth:(BOOL)fillWidth;
- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins fillHeight:(BOOL)fillHeight;
- (void)addSubview:(UIView *)subview margins:(UIEdgeInsets)margins fillWidth:(BOOL)fillWidth fillHeight:(BOOL)fillHeight;


/**
 * Returns the layout parameters assigned to the given subview
 */
- (LLLayoutParams *)layoutParamsForSubview:(UIView *)subview;

/**
 * LLLayout implementations should override this implementation to implement
 * their own layout.
 *
 * This method always returns the amount of space required to fit every child.
 *
 * When updatePositions is false, the layout should not change any frames.
 */
- (CGSize)layoutSubviews:(NSArray *)subviews withAvailableSize:(CGSize)availableSize updatePositions:(BOOL)updatePositions;

- (CGSize)sizeForSubview:(UIView *)subview withAvailableSize:(CGSize)availableSize;

- (Class)paramsClass;

@end

@interface LLLayoutParams : NSObject {
@private
  UIEdgeInsets _margins;  
  BOOL _expandToFillWidth;
  BOOL _expandToFillHeight;
}

@property (nonatomic, assign) UIEdgeInsets margins;
@property (nonatomic, assign) BOOL expandToFillWidth;
@property (nonatomic, assign) BOOL fillHeight;

@end