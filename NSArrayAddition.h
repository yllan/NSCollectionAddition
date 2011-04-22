#import <Foundation/Foundation.h>

@interface NSArray (YLAddition) 
- (NSArray *) map: (id (^)(id))f;
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


@end