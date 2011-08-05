#import <Foundation/Foundation.h>

#define ARRAY(...)  ([NSArray arrayWithObjects: __VA_ARGS__, nil])

@interface NSArray (YLCollectionAddition) 
- (NSArray *) map: (id (^)(id))f;
- (NSArray *) flatMap: (NSArray *(^)(id))f;

- (void) foreach: (void (^)(id))f;
- (NSArray *) filter: (BOOL (^)(id))condition;
- (NSArray *) filterNot: (BOOL (^)(id))condition;
- (BOOL) forAll: (BOOL (^)(id))condition;
- (BOOL) exists: (BOOL (^)(id))condition;
- (id) head;
- (id) last;
- (NSArray *) tail;

- (NSArray *) take: (NSUInteger)n;
- (NSArray *) takeRight: (NSUInteger)n;
- (NSArray *) takeWhile: (BOOL (^)(id))condition;

- (NSArray *) drop: (NSUInteger)n;
- (NSArray *) dropRight: (NSUInteger)n;
- (NSArray *) dropWhile: (BOOL (^)(id))condition;

- (NSArray *) reverse;

@end