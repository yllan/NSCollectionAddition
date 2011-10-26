#import "NSSetAddition.h"


@implementation NSSet (YLCollectionAddition)
- (NSSet *) map: (id (^)(id))f
{
    NSMutableSet *result = [NSMutableSet set];
    for (id obj in self) {
        id mapped = f(obj);
        if (mapped) 
            [result addObject: mapped];
    }
    return result;
}

- (void) foreach: (void (^)(id))f
{
    for (id obj in self) f(obj);
}

- (NSSet *) filter: (BOOL (^)(id))condition
{
    NSMutableSet *result = [NSMutableSet set];
    for (id obj in self) {
        if (condition(obj))
            [result addObject: obj];
    }
    return result;
}

- (NSSet *) filterNot: (BOOL (^)(id))condition
{
    NSMutableSet *result = [NSMutableSet set];
    for (id obj in self) {
        if (!condition(obj))
            [result addObject: obj];
    }
    return result;
}

- (BOOL) forAll: (BOOL (^)(id))condition
{
    for (id obj in self) {
        if (!condition(obj))
            return NO;
    }
    return YES;
}

- (BOOL) exists: (BOOL (^)(id))condition
{
    for (id obj in self) {
        if (condition(obj))
            return YES;
    }
    return NO;
}

- (NSSet *) setByRemovingObject: (id)obj
{
    NSMutableSet *result = [self mutableCopy];
    [result removeObject: obj];
    return [result autorelease];
}

- (NSSet *) setByRemovingObjectsFromSet: (NSSet *)set
{
    NSMutableSet *result = [self mutableCopy];
    [result minusSet: set];
    return [result autorelease];    
}

- (NSSet *) setByRemovingObjectsFromArray: (NSArray *)array
{
    NSMutableSet *result = [self mutableCopy];
    [result minusSet: [NSSet setWithArray: array]];
    return [result autorelease];
}

@end
