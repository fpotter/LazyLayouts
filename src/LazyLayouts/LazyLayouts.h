
#import "LazyLayouts/LLVerticalLayoutView.h"
#import "LazyLayouts/LLHorizontalLayoutView.h"

//#ifdef DEBUG
#define LLLOG NSLog
//#else
//#define LLLOG    
//#endif

#define LLLOGRECT(rect) \
LLLOG(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
rect.size.width, rect.size.height)

#define LLLOGPOINT(pt) \
LLLOG(@"%s x=%f, y=%f", #pt, pt.x, pt.y)

#define LLLOGSIZE(size) \
LLLOG(@"%s w=%f, h=%f", #size, size.width, size.height)

