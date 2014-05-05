#import "NSDictionaryAddition.h"

NSDictionary *_DictionaryWithFlatArray(NSArray *array)
{
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *objs = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [array count] / 2; i++) {
        [keys addObject: [array objectAtIndex: i * 2]];
        [objs addObject: [array objectAtIndex: i * 2 + 1]];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys];
}

@implementation NSDictionary (YLCollectionAddition)

- (NSDictionary *) dictionaryByAddDictionary: (NSDictionary *)anotherDictionary
{
    NSMutableDictionary *result = [self mutableCopy];
    for (NSString *key in anotherDictionary.allKeys) {
        result[key] = anotherDictionary[key];
    }
    return [result copy];
}

@end