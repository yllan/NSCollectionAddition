#import <Foundation/Foundation.h>

#define SET(...)  ([NSSet setWithObjects: __VA_ARGS__, nil])

@interface NSSet (YLCollectionAddition)
- (NSSet *) map: (id (^)(id))f;
- (void) foreach: (void (^)(id))f;
- (NSSet *) filter: (BOOL (^)(id))condition;
- (NSSet *) filterNot: (BOOL (^)(id))condition;
- (BOOL) forAll: (BOOL (^)(id))condition;
- (BOOL) exists: (BOOL (^)(id))condition;
@end
