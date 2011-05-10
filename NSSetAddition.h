#import <Foundation/Foundation.h>

@interface NSSet (YLAddition)
- (NSSet *) map: (id (^)(id))f;
- (void) foreach: (void (^)(id))f;
- (NSSet *) filter: (BOOL (^)(id))condition;
- (NSSet *) filterNot: (BOOL (^)(id))condition;
- (BOOL) forAll: (BOOL (^)(id))condition;
- (BOOL) exists: (BOOL (^)(id))condition;
@end
