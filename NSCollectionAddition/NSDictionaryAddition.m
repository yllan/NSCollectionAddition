#import "NSDictionaryAddition.h"

NSDictionary *_DictionaryWithIDArray(id *array, NSUInteger count)
{
    id keys[count];
    id objs[count];
    
    for(NSUInteger i = 0; i < count; i++)
    {
        keys[i] = array[i * 2];
        objs[i] = array[i * 2 + 1];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}