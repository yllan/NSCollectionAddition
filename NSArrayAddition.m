#import "NSArrayAddition.h"

@implementation NSArray (YLCollectionAddition)
- (NSArray *) map: (id (^)(id))f
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        id mapped = f(obj);
        if (mapped) 
            [result addObject: mapped];
    }
    return result;
}

- (NSArray *) flatMap: (NSArray *(^)(id))f
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        NSArray *mapped = f(obj);
        if (mapped) 
            [result addObjectsFromArray: mapped];
    }
    return result;
}

- (void) foreach: (void (^)(id))f
{
    for (id obj in self) f(obj);
}

- (NSArray *) filter: (BOOL (^)(id))condition
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        if (condition(obj))
            [result addObject: obj];
    }
    return result;
}

- (NSArray *) filterNot: (BOOL (^)(id))condition
{
    NSMutableArray *result = [NSMutableArray array];
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

- (id) head 
{
    return ([self count] == 0) ? nil : [self objectAtIndex: 0];
}

- (id) last
{
    return [self lastObject];
}

- (NSArray *) tail
{
    if ([self count] <= 1) return [NSArray array];
    return [self subarrayWithRange: NSMakeRange(1, [self count] - 1)];
}

- (NSArray *) take: (NSUInteger)n
{
    if ([self count] <= n) return [[self copy] autorelease];
    return [self subarrayWithRange: NSMakeRange(0, n)];
}

- (NSArray *) takeRight: (NSUInteger)n
{
    if ([self count] <= n) return [[self copy] autorelease];
    return [self subarrayWithRange: NSMakeRange([self count] - n, n)];
}

- (NSArray *) takeWhile: (BOOL (^)(id))condition
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        if (!condition(obj)) break;
        [result addObject: obj];
    }
    return result;
}

- (NSArray *) drop: (NSUInteger)n
{
    if ([self count] <= n) return [NSArray array];
    return [self subarrayWithRange: NSMakeRange(n, [self count] - n)]; 
}

- (NSArray *) dropRight: (NSUInteger)n
{
    if ([self count] <= n) return [NSArray array];
    return [self subarrayWithRange: NSMakeRange(0, [self count] - n)]; 
}

- (NSArray *) dropWhile: (BOOL (^)(id))condition
{
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger count = [self count];
    NSUInteger idx = 0;
    for (idx = 0; idx < count; idx++) {
        if (!condition([self objectAtIndex: idx])) break;
    }
    for (; idx < count; idx++) {
        [result addObject: [self objectAtIndex: idx]];
    }
    return result;
}

- (NSArray *) reverse
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in [self reverseObjectEnumerator]) 
        [result addObject: obj];
    return  result;
}


- (NSArray *) grouped: (NSUInteger)size
{
    if (size == 0) return nil;
    if (size >= [self count]) return ARRAY(self);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSUInteger index = 0; index < [self count]; index += size) {
        [resultArray addObject: [self subarrayWithRange: NSMakeRange(index, MIN([self count] - index, size))]];
    }
    return resultArray;
}

- (NSDictionary *) groupBy: (id (^)(id))discriminator
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id element in self) {
        id key = discriminator(element);
        NSMutableArray *sameGroup = [result objectForKey: key] ?: [NSMutableArray array];
        [sameGroup addObject: element];
        [result setObject: sameGroup forKey: key];
    }
    return result;
}

- (void) slidingWithSize: (NSUInteger)size block: (void (^)(NSArray *subArray))block
{
    [self slidingWithSize: size step: 1 block: block];
}

- (void) slidingWithSize: (NSUInteger)size step: (NSUInteger)step block: (void (^)(NSArray *subArray))block
{
    if (step == 0 || [self count] == 0) return;
    
    NSUInteger total = [self count];
    NSUInteger idx = 0;
    NSUInteger length = MIN(size, total - idx);

    do {        
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        block([self subarrayWithRange: NSMakeRange(idx, length)]);
        [pool drain];
        
        if (idx + step < total && idx + length < total) {
            idx += step;
            length = MIN(size, total - idx);
        } else {
            break;
        }
    } while (YES);
}

- (id) min: (NSComparisonResult (^)(id, id))comparator
{
    if ([self count] == 0) return nil;
    if ([self count] == 1) return [self objectAtIndex: 0];
    
    id currentMin = [self objectAtIndex: 0];
    for (id element in self) {
        if (comparator(element, currentMin) == NSOrderedAscending) 
            currentMin = element;
    }
    return currentMin;
}

- (id) max: (NSComparisonResult (^)(id, id))comparator
{
    if ([self count] == 0) return nil;
    if ([self count] == 1) return [self objectAtIndex: 0];
    
    id currentMax = [self objectAtIndex: 0];
    for (id element in self) {
        if (comparator(element, currentMax) == NSOrderedDescending) 
            currentMax = element;
    }
    return currentMax;
}

@end