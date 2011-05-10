#import <Foundation/Foundation.h>


#define IDARRAY(...) (id []){ __VA_ARGS__ }
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))
#define DICT(...) _DictionaryWithIDArray(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

NSDictionary *_DictionaryWithIDArray(id *array, NSUInteger count);