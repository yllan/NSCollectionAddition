#import "NSArrayAddition.h"

#if __has_feature(objc_arc) == 1
    #define AUTORELEASE_POOL_START      @autoreleasepool {
    #define AUTORELEASE_POOL_END        }
#else
    #define AUTORELEASE_POOL_START      NSAutoreleasePool *pool = [NSAutoreleasePool new];
    #define AUTORELEASE_POOL_END        [pool drain];
#endif

@implementation NSArray (YLCollectionAddition)
- (NSArray *) map: (id (^)(id element))f
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        id mapped = f(obj);
        if (mapped) 
            [result addObject: mapped];
    }
    return result;
}

- (NSArray *) flatMap: (NSArray *(^)(id element))f
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        AUTORELEASE_POOL_START
        NSArray *mapped = f(obj);
        if (mapped) 
            [result addObjectsFromArray: mapped];
        AUTORELEASE_POOL_END
    }
    return result;
}

- (void) foreach: (void (^)(id element))f
{
    for (id obj in self) {
        AUTORELEASE_POOL_START
        f(obj);
        AUTORELEASE_POOL_END
    }
}

- (NSArray *) filter: (BOOL (^)(id element))condition
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        AUTORELEASE_POOL_START
        if (condition(obj))
            [result addObject: obj];
        AUTORELEASE_POOL_END
    }
    return result;
}

- (NSArray *) filterNot: (BOOL (^)(id element))condition
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        AUTORELEASE_POOL_START
        if (!condition(obj))
            [result addObject: obj];
        AUTORELEASE_POOL_END
    }
    return result;
}

- (BOOL) forAll: (BOOL (^)(id element))condition
{
    for (id obj in self) {
        BOOL passTest = YES;
        AUTORELEASE_POOL_START
        passTest = condition(obj);
        AUTORELEASE_POOL_END

        if (!passTest) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) exists: (BOOL (^)(id element))condition
{
    for (id obj in self) {
        BOOL passTest = NO;
        AUTORELEASE_POOL_START
        passTest = condition(obj);
        AUTORELEASE_POOL_END

        if (passTest)
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

- (NSArray *) takeWhile: (BOOL (^)(id element))condition
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        BOOL passTest = NO;
        AUTORELEASE_POOL_START
        passTest = condition(obj);
        AUTORELEASE_POOL_END
        if (!passTest) break;
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

- (NSArray *) dropWhile: (BOOL (^)(id element))condition
{
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger count = [self count];
    NSUInteger idx = 0;
    for (idx = 0; idx < count; idx++) {
        BOOL passTest = NO;
        AUTORELEASE_POOL_START
        passTest = condition([self objectAtIndex: idx]);
        AUTORELEASE_POOL_END
        if (!passTest) break;
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

- (NSDictionary *) groupBy: (id (^)(id element))discriminator
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

- (id) min: (NSComparisonResult (^)(id elementA, id elementB))comparator
{
    if ([self count] == 0) return nil;
    if ([self count] == 1) return [self objectAtIndex: 0];
    
    id currentMin = [self objectAtIndex: 0];
    for (id element in self) {
        BOOL elementSmallerThanCurrentMin = NO;
        AUTORELEASE_POOL_START
        elementSmallerThanCurrentMin = (comparator(element, currentMin) == NSOrderedAscending);
        AUTORELEASE_POOL_END
        if (elementSmallerThanCurrentMin) 
            currentMin = element;
    }
    return currentMin;
}

- (id) max: (NSComparisonResult (^)(id elementA, id elementB))comparator
{
    if ([self count] == 0) return nil;
    if ([self count] == 1) return [self objectAtIndex: 0];
    
    id currentMax = [self objectAtIndex: 0];
    for (id element in self) {
        BOOL elementLargerThanCurrentMax = NO;
        AUTORELEASE_POOL_START
        elementLargerThanCurrentMax = (comparator(element, currentMax) == NSOrderedDescending);
        AUTORELEASE_POOL_END
        if (elementLargerThanCurrentMax) 
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

- (void) parForeach: (void (^)(id element))f
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (id element in self) {
        dispatch_group_async(group, queue, ^{
            AUTORELEASE_POOL_START
            f(element);
            AUTORELEASE_POOL_END
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
}

- (NSArray *) parMap: (id (^)(id element))f
{
    if ([self count] == 0) return [NSArray array];
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSUInteger idx = 0;
    for (id element in self) {
        dispatch_group_async(group, queue, ^{
            id mappedObj;
            AUTORELEASE_POOL_START
            mappedObj = f(element);
            if (mappedObj) {
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                [results setObject: mappedObj forKey: [NSNumber numberWithUnsignedInteger: idx]];
                dispatch_semaphore_signal(semaphore);
            }
            AUTORELEASE_POOL_END
        });
        idx++;
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger total = [self count];

    for (idx = 0; idx < total; idx++) {
        id mappedObj = [results objectForKey: [NSNumber numberWithUnsignedInteger: idx]];
        if (mappedObj) {
            [resultArray addObject: mappedObj];
        }
    }
    
    return resultArray;
}

- (NSArray *) parFlatMap: (NSArray *(^)(id element))f
{
    if ([self count] == 0) return [NSArray array];
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    NSUInteger idx = 0;
    for (id element in self) {
        dispatch_group_async(group, queue, ^{
            id mappedObj;
            AUTORELEASE_POOL_START            
            mappedObj = f(element);
            if ([mappedObj count] > 0) {
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                [results setObject: mappedObj forKey: [NSNumber numberWithUnsignedInteger: idx]];
                dispatch_semaphore_signal(semaphore);
            }
            AUTORELEASE_POOL_END
        });
        idx++;
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);

    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger total = [self count];
    
    for (idx = 0; idx < total; idx++) {
        id mappedArray = [results objectForKey: [NSNumber numberWithUnsignedInteger: idx]];
        if (mappedArray) {
            [resultArray addObjectsFromArray: mappedArray];
        }
    }
    return resultArray;    
}

@end