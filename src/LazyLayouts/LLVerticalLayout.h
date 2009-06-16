
#import <Foundation/Foundation.h>
#import "LLLayout.h"

typedef enum LLVerticalLayoutAlign {
  LLVerticalLayoutAlignLeft,
  LLVerticalLayoutAlignRight,
  LLVerticalLayoutAlignCenter,
} LLVerticalLayoutAlign;

@interface LLVerticalLayout : LLLayout {
  NSInteger _spacing;
}

@property (nonatomic, assign) NSInteger spacing;

/**
 * Returns the default vertical layout with no vertical spacing.
 */
+ (LLVerticalLayout *)layout;

/**
 * Returns a vertical layout with a given spacing.
 */
+ (LLVerticalLayout *)layoutWithSpacing:(NSInteger)spacing;

@end

@interface LLVerticalLayoutParams : LLLayoutParams {
  LLVerticalLayoutAlign _align;
}

@property (nonatomic, assign) LLVerticalLayoutAlign align;

+ (LLVerticalLayoutParams *)paramsWithAlignment:(LLVerticalLayoutAlign)align;

@end
