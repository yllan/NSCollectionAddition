#import <Foundation/Foundation.h>


@interface NSObject (YLAddition) 
- (id) map: (id (^)(id))f;
- (void) foreach: (void (^)(id))f;
- (id) filter: (BOOL (^)(id))condition;
- (id) filterNot: (BOOL (^)(id))condition;
- (BOOL) forAll: (BOOL (^)(id))condition;
- (BOOL) exists: (BOOL (^)(id))condition;
- (id) head;
- (id) last;
@end
