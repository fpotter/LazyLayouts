
#import <UIKit/UIKit.h>
#import "LLLayoutView.h"

typedef enum LLVerticalLayoutAlign {
  LLVerticalLayoutAlignLeft,
  LLVerticalLayoutAlignRight,
  LLVerticalLayoutAlignCenter,
} LLVerticalLayoutAlign;

@interface LLVerticalLayoutView : LLLayoutView {
  NSInteger _spacing;
}

@property (nonatomic, assign) NSInteger spacing;

- (void)addSubview:(UIView *)subview 
             align:(LLVerticalLayoutAlign)align;

- (void)addSubview:(UIView *)subview 
             align:(LLVerticalLayoutAlign)align
           margins:(UIEdgeInsets)margins;  

- (void)addSubview:(UIView *)subview 
             align:(LLVerticalLayoutAlign)align 
           margins:(UIEdgeInsets)margins 
         fillWidth:(BOOL)fillWidth 
        fillHeight:(BOOL)fillHeight;

@end

@interface LLVerticalLayoutParams : LLLayoutParams {
  LLVerticalLayoutAlign _align;
}

@property (nonatomic, assign) LLVerticalLayoutAlign align;

@end
