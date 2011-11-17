#import <Foundation/Foundation.h>

#define DICT(...) _DictionaryWithFlatArray([NSArray arrayWithObjects: __VA_ARGS__, nil])

NSDictionary *_DictionaryWithFlatArray(NSArray *array);