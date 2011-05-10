#import "NSObjectAddition.h"


@implementation NSObject (YLAddition)
- (NSArray *) map: (id (^)(id))f
{
    return f(self);
}

- (void) foreach: (void (^)(id))f
{
    f(self);
}

- (id) filter: (BOOL (^)(id))condition
{
    return condition(self) ? self : nil;
}

- (id) filterNot: (BOOL (^)(id))condition
{
    return (!condition(self)) ? self : nil;    
}

- (BOOL) forAll: (BOOL (^)(id))condition
{
    return condition(self);}

- (BOOL) exists: (BOOL (^)(id))condition
{
    return condition(self);
}

- (id) head 
{
    return self;
}

- (id) last
{
    return self;
}

@end
