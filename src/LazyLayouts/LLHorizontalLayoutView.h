
#import <UIKit/UIKit.h>
#import "LLLayoutView.h"

typedef enum LLHorizontalLayoutAlign {
  LLHorizontalLayoutAlignTop,
  LLHorizontalLayoutAlignMiddle,
  LLHorizontalLayoutAlignBottom,
} LLHorizontalLayoutAlign;

@interface LLHorizontalLayoutView : LLLayoutView {
  NSInteger _spacing;
}

@property (nonatomic, assign) NSInteger spacing;

- (void)addSubview:(UIView *)subview 
             align:(LLHorizontalLayoutAlign)align;

- (void)addSubview:(UIView *)subview 
             align:(LLHorizontalLayoutAlign)align
           margins:(UIEdgeInsets)margins;  

- (void)addSubview:(UIView *)subview 
             align:(LLHorizontalLayoutAlign)align 
           margins:(UIEdgeInsets)margins 
         fillWidth:(BOOL)fillWidth 
        fillHeight:(BOOL)fillHeight;

@end

@interface LLHorizontalLayoutParams : LLLayoutParams {
  LLHorizontalLayoutAlign _align;
}

@property (nonatomic, assign) LLHorizontalLayoutAlign align;

@end
