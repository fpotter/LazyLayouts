
#import "GHUnit.h"

#define GHAssertEqualRects(a1, a2, description, ...) \
do { \
@try {\
id a1value = NSStringFromCGRect(a1); \
id a2value = NSStringFromCGRect(a2); \
if (a1value == a2value) continue; \
if ([a1value isKindOfClass:[NSString class]] && \
[a2value isKindOfClass:[NSString class]] && \
[a1value compare:a2value options:0] == NSOrderedSame) continue; \
[self failWithException:[NSException failureInEqualityBetweenObject: a1value \
andObject: a2value \
inFile: [NSString stringWithUTF8String:__FILE__] \
atLine: __LINE__ \
withDescription: GHComposeString(description, ##__VA_ARGS__)]]; \
}\
@catch (id anException) {\
[self failWithException:[NSException failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
exception:anException \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
withDescription:GHComposeString(description, ##__VA_ARGS__)]]; \
}\
} while(0)
