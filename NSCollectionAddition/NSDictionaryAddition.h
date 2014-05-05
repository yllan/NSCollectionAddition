#import <Foundation/Foundation.h>

#define DICT(...) _DictionaryWithFlatArray([NSArray arrayWithObjects: __VA_ARGS__, nil])

NSDictionary *_DictionaryWithFlatArray(NSArray *array);

@interface NSDictionary (YLCollectionAddition)
- (NSDictionary *) dictionaryByAddDictionary: (NSDictionary *)anotherDictionary;
@end
