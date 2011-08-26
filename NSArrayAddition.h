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

/* Partitions elements in fixed size array. */
- (NSArray *) grouped: (NSUInteger)size;
/* Partitions this into a dictionary of arrays of elements by a discriminator function. */
- (NSDictionary *) groupBy: (id (^)(id))discriminator;

/* Iterate through a sliding window of size */
- (void) slidingWithSize: (NSUInteger)size block: (void (^)(NSArray *subArray))block;
- (void) slidingWithSize: (NSUInteger)size step: (NSUInteger)step block: (void (^)(NSArray *subArray))block;

- (id) min: (NSComparisonResult (^)(id, id))comparator;
- (id) max: (NSComparisonResult (^)(id, id))comparator;

@end