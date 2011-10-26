#import <Foundation/Foundation.h>

#define ARRAY(...)  ([NSArray arrayWithObjects: __VA_ARGS__, nil])

@interface NSArray (YLCollectionAddition) 
- (NSArray *) map: (id (^)(id element))f;
- (NSArray *) flatMap: (NSArray *(^)(id element))f;

- (void) foreach: (void (^)(id element))f;
- (NSArray *) filter: (BOOL (^)(id element))condition;
- (NSArray *) filterNot: (BOOL (^)(id element))condition;
- (BOOL) forAll: (BOOL (^)(id element))condition;
- (BOOL) exists: (BOOL (^)(id element))condition;
- (id) head;
- (id) last;
- (NSArray *) tail;

- (NSArray *) take: (NSUInteger)n;
- (NSArray *) takeRight: (NSUInteger)n;
- (NSArray *) takeWhile: (BOOL (^)(id element))condition;

- (NSArray *) drop: (NSUInteger)n;
- (NSArray *) dropRight: (NSUInteger)n;
- (NSArray *) dropWhile: (BOOL (^)(id element))condition;

- (NSArray *) reverse;

/* Partitions elements in fixed size array. */
- (NSArray *) grouped: (NSUInteger)size;
/* Iterate version */
- (void) grouped: (NSUInteger)size block: (void (^)(NSArray *groupedArray))block;
/* Partitions this into a dictionary of arrays of elements by a discriminator function. */
- (NSDictionary *) groupBy: (id (^)(id element))discriminator;

/* Create an successive subarray in a sliding window of size */
- (NSArray *) slidingWithSize: (NSUInteger)size;
- (NSArray *) slidingWithSize: (NSUInteger)size step: (NSUInteger)step;
/* Iterate through a sliding window of size */
- (void) slidingWithSize: (NSUInteger)size block: (void (^)(NSArray *subArray))block;
- (void) slidingWithSize: (NSUInteger)size step: (NSUInteger)step block: (void (^)(NSArray *subArray))block;

- (id) min: (NSComparisonResult (^)(id elementA, id elementB))comparator;
- (id) max: (NSComparisonResult (^)(id elementA, id elementB))comparator;

- (id) reduce: (id (^)(id lastCalulatedResult, id nextElement))op;
- (id) reduceLeft: (id (^)(id lastCalulatedResult, id nextElement))op;
- (id) reduceRight: (id (^)(id nextElement, id lastCalulatedResult))op;

- (void) parForeach: (void (^)(id element))f;
- (NSArray *) parMap: (id (^)(id element))f;
- (NSArray *) parFlatMap: (NSArray *(^)(id element))f;
@end