#import "NSArrayAddition.h"

#if __has_feature(objc_arc) == 1
    #define AUTORELEASE_POOL_START      @autoreleasepool {
    #define AUTORELEASE_POOL_END        }
#else
    #define AUTORELEASE_POOL_START      NSAutoreleasePool *pool = [NSAutoreleasePool new];
    #define AUTORELEASE_POOL_END        [pool drain];
#endif

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
    if ([self count] <= n) {
#if __has_feature(objc_arc) == 1
        return [self copy];
#else
        return [[self copy] autorelease];
#endif
    }
    return [self subarrayWithRange: NSMakeRange(0, n)];
}

- (NSArray *) takeRight: (NSUInteger)n
{
    if ([self count] <= n) {
#if __has_feature(objc_arc) == 1
        return [self copy];
#else
        return [[self copy] autorelease];
#endif
    }
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
    if (size == 0) {
        NSException *exception = [NSException exceptionWithName: @"GroupWithZeroException" reason: @"Cannot group with zero size" userInfo: nil];
        @throw exception;
    }
    if ([self count] == 0) return [NSArray array];
    if (size >= [self count]) return ARRAY(self);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSUInteger index = 0; index < [self count]; index += size) {
        [resultArray addObject: [self subarrayWithRange: NSMakeRange(index, MIN([self count] - index, size))]];
    }
    return resultArray;
}

- (void) grouped: (NSUInteger)size block: (void (^)(NSArray *groupedArray))block
{
    if (size == 0) {
        NSException *exception = [NSException exceptionWithName: @"GroupWithZeroException" reason: @"Cannot group with zero size" userInfo: nil];
        @throw exception;        
    }
    
    if ([self count] == 0) return;
    if (size >= [self count]) {
        block(self);
        return;
    }
    
    for (NSUInteger index = 0; index < [self count]; index += size) {
        AUTORELEASE_POOL_START
        block([self subarrayWithRange: NSMakeRange(index, MIN([self count] - index, size))]);
        AUTORELEASE_POOL_END
    }
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

- (NSArray *) slidingWithSize: (NSUInteger)size
{
    return [self slidingWithSize: size step: 1];
}

- (NSArray *) slidingWithSize: (NSUInteger)size step: (NSUInteger)step
{
    if (size == 0) {
        NSException *e = [NSException exceptionWithName: @"SlideWithZeroSizeExcepition" reason: @"Cannot sliding with zero size" userInfo: nil];
        @throw e;
    }
    if (step == 0) {
        NSException *e = [NSException exceptionWithName: @"SlideWithZeroStepExcepition" reason: @"Cannot sliding with zero step" userInfo: nil];
        @throw e;
    }
    
    if ([self count] == 0) return [NSArray array];
    
    NSUInteger total = [self count];
    NSUInteger idx = 0;
    NSUInteger length = MIN(size, total - idx);
    NSMutableArray *result = [NSMutableArray array];
    do {        
        [result addObject: [self subarrayWithRange: NSMakeRange(idx, length)]];
        
        if (idx + step < total && idx + length < total) {
            idx += step;
            length = MIN(size, total - idx);
        } else {
            break;
        }
    } while (YES);
    return result;
}

- (void) slidingWithSize: (NSUInteger)size block: (void (^)(NSArray *subArray))block
{
    [self slidingWithSize: size step: 1 block: block];
}

- (void) slidingWithSize: (NSUInteger)size step: (NSUInteger)step block: (void (^)(NSArray *subArray))block
{
    if (size == 0) {
        NSException *e = [NSException exceptionWithName: @"SlideWithZeroSizeExcepition" reason: @"Cannot sliding with zero size" userInfo: nil];
        @throw e;
    }
    if (step == 0) {
        NSException *e = [NSException exceptionWithName: @"SlideWithZeroStepExcepition" reason: @"Cannot sliding with zero step" userInfo: nil];
        @throw e;
    }
    
    if ([self count] == 0) return;
    
    NSUInteger total = [self count];
    NSUInteger idx = 0;
    NSUInteger length = MIN(size, total - idx);

    do {        
        AUTORELEASE_POOL_START
        block([self subarrayWithRange: NSMakeRange(idx, length)]);
        AUTORELEASE_POOL_END
        
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

// identical to reduceLeft
- (id) reduce: (id (^)(id lastCalulatedResult, id nextElement))op
{
    if ([self count] == 0) {
        NSException *e = [NSException exceptionWithName: @"ReduceWithEmptyExcepition" reason: @"Cannot reduce with empty array" userInfo: nil];
        @throw e;
    } else {
        id lastCaluclatedResult = [self objectAtIndex: 0];
        for (id element in [self drop: 1]) {
            lastCaluclatedResult = op(lastCaluclatedResult, element);
        }
        return lastCaluclatedResult;
    }
}

- (id) reduceLeft: (id (^)(id lastCalulatedResult, id nextElement))op
{
    if ([self count] == 0) {
        NSException *e = [NSException exceptionWithName: @"ReduceLeftWithEmptyExcepition" reason: @"Cannot reduceLeft with empty array" userInfo: nil];
        @throw e;
    } else {
        id lastCaluclatedResult = [self objectAtIndex: 0];
        for (id element in [self drop: 1]) {
            lastCaluclatedResult = op(lastCaluclatedResult, element);
        }
        return lastCaluclatedResult;
    }
}

- (id) reduceRight: (id (^)(id nextElement, id lastCalulatedResult))op
{
    if ([self count] == 0) {
        NSException *e = [NSException exceptionWithName: @"ReduceRightWithEmptyExcepition" reason: @"Cannot reduceRight with empty array" userInfo: nil];
        @throw e;
    } else {
        id lastCaluclatedResult = [self lastObject];
        for (id element in [[self dropRight: 1] reverseObjectEnumerator]) {
            lastCaluclatedResult = op(element, lastCaluclatedResult);
        }
        return lastCaluclatedResult;
    }
}

@end