//
//  UnitTest.m
//  UnitTest
//
//  Created by Yung-Luen Lan on 8/31/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import "UnitTest.h"
#import "NSCollectionAddition.h"

@implementation UnitTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testMap
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *mapped = [origin map: ^(id s) { return [s stringByAppendingString: @"1"]; }];
    
    NSArray *supposedResult = [NSArray arrayWithObjects: @"a1", @"b1", @"c1", nil];
    STAssertEqualObjects(mapped, supposedResult, @"map creates a new array with the results of applying block to each object.");
}

- (void) testFlatMap
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", @"d", @"e", nil];
    NSArray *flatMapped = [origin flatMap: ^(id s) { 
        if ([s isEqualToString: @"a"]) {
            return [NSArray arrayWithObject: @"a1"]; // single
        } else if ([s isEqualToString: @"b"]) {
            return [NSArray arrayWithObjects: @"b1", @"b2", @"b3", nil]; // multiple
        } else if ([s isEqualToString: @"c"]) {
            return [NSArray array]; // zero
        } else if ([s isEqualToString: @"d"]) {
            return nil; // nil
        } else if ([s isEqualToString: @"e"]) {
            return [NSArray arrayWithObjects: @"end", nil];
        }
        return [NSArray array]; 
    }];
    
    NSArray *supposedResult = [NSArray arrayWithObjects: @"a1", @"b1", @"b2", @"b3", @"end", nil];
    STAssertEqualObjects(flatMapped, supposedResult, @"flatMap builds a new collection by applying a function to all elements of this list and concatenating the results.");
}

- (void) testForeach
{
    NSArray *array = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSMutableArray *result = [NSMutableArray array];
    [array foreach: ^(NSString *s) {
        [result addObject: s];
    }];
    STAssertEqualObjects(array, result, @"foreach iterate all the elements with block in order.");
}

- (void) testFilter
{
    NSArray *origin = [NSArray arrayWithObjects: @"bill", @"alice", @"allen", @"acer", @"cindy", nil];
    NSArray *mapped = [origin filter: ^(id s) { return [s hasPrefix: @"al"]; }];
    
    NSArray *supposedResult = [NSArray arrayWithObjects: @"alice", @"allen", nil];
    STAssertEqualObjects(mapped, supposedResult, @"filter select the objects passed the condition.");
}

- (void) testFilterNot
{
    NSArray *origin = [NSArray arrayWithObjects: @"bill", @"alice", @"allen", @"acer", @"cindy", nil];
    NSArray *mapped = [origin filterNot: ^(id s) { return [s hasPrefix: @"al"]; }];
    
    NSArray *supposedResult = [NSArray arrayWithObjects: @"bill", @"acer", @"cindy", nil];
    STAssertEqualObjects(mapped, supposedResult, @"filterNot select the objects doesn't passed the condition.");
}

- (void) testForAll
{
    NSArray *positiveCase = [NSArray arrayWithObjects: @"1", @"3", @"5", @"7", @"9", nil];
    NSArray *negativeCase = [NSArray arrayWithObjects: @"1", @"3", @"4", @"5", @"7", nil];
    
    STAssertTrue([positiveCase forAll: ^(id s) {return (BOOL)([s intValue] & 0x01);}], @"forAll test if all the objects passed the condition.");
    STAssertFalse([negativeCase forAll: ^(id s) {return (BOOL)([s intValue] & 0x01);}], @"forAll test if all the objects passed the condition.");
}

- (void) testExists
{
    NSArray *negativeCase = [NSArray arrayWithObjects: @"1", @"3", @"5", @"7", @"9", nil];
    NSArray *positiveCase = [NSArray arrayWithObjects: @"1", @"3", @"4", @"5", @"7", nil];
    
    STAssertTrue([positiveCase exists: ^(id s) {return (BOOL)([s intValue] % 2 == 0);}], @"forAll test if all the objects passed the condition.");
    STAssertFalse([negativeCase exists: ^(id s) {return (BOOL)([s intValue] % 2 == 0);}], @"forAll test if all the objects passed the condition.");
}

- (void) testHead
{
    NSArray *a = [NSArray arrayWithObjects: @"1", @"2", @"3", nil];
    STAssertEqualObjects([a head], @"1", @"head returns the first object of an array.");
    
    STAssertNil([[NSArray array] head], @"head of an empty array is nil.");
}

- (void) testLast
{
    NSArray *a = [NSArray arrayWithObjects: @"1", @"2", @"3", nil];
    STAssertEqualObjects([a last], @"3", @"last returns the first object of an array.");
    
    STAssertNil([[NSArray array] last], @"last of an empty array is nil.");
}

- (void) testTail
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *tail = [origin tail];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"b", @"c", nil];
    
    STAssertEqualObjects(tail, supposedResult, @"tail returns all objects except the first.");
    STAssertEqualObjects([[NSArray arrayWithObject: @"b"] tail], [NSArray array], @"if [self count] <= 1, tails return empty array.");
    STAssertEqualObjects([[NSArray array] tail], [NSArray array], @"if [self count] <= 1, tails return empty array.");
}

- (void) testTake
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"a", @"b", nil];
    STAssertEqualObjects([origin take: 2], supposedResult, @"take selects first n elements.");
    
    STAssertEqualObjects([origin take: 4], origin, @"if the receiver has less than n elements, return all elements.");
}

- (void) testTakeRight
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"b", @"c", nil];
    STAssertEqualObjects([origin takeRight: 2], supposedResult, @"takeRight selects last n elements.");
    
    STAssertEqualObjects([origin takeRight: 4], origin, @"if the receiver has less than n elements, return all elements.");
}

- (void) testTakeWhile
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"3", @"5", @"6", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"1", @"3", @"5", nil];
    STAssertEqualObjects([origin takeWhile: ^(id s) { return (BOOL)([s intValue] % 2 == 1);}], supposedResult, @"takeWhile takes longest prefix of elements that satisfy a predicate.");
    
    STAssertEqualObjects([origin takeWhile: ^(id s) {return YES;}], origin, @"returns all elements if every object passes the predicate.");
    STAssertEqualObjects([origin takeWhile: ^(id s) {return NO;}], [NSArray array], @"returns empty if the first object doesn't pass the predicate.");
    
}

- (void) testDrop
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"c", nil];
    STAssertEqualObjects([origin drop: 2], supposedResult, @"drop selects all elements except first n ones.");
    
    STAssertEqualObjects([origin drop: 4], [NSArray array], @"if the receiver has less than n elements, return empty array.");
}

- (void) testDropRight
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"a", nil];
    STAssertEqualObjects([origin dropRight: 2], supposedResult, @"dropRight selects all elements except last n ones.");
    
    STAssertEqualObjects([origin dropRight: 4], [NSArray array], @"if the receiver has less than n elements, return empty array.");
}

- (void) testDropWhile
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"3", @"5", @"6", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"6", nil];
    STAssertEqualObjects([origin dropWhile: ^(id s) { return (BOOL)([s intValue] % 2 == 1);}], supposedResult, @"takeWhile takes longest prefix of elements that satisfy a predicate.");
    
    STAssertEqualObjects([origin dropWhile: ^(id s) {return YES;}], [NSArray array], @"returns empty array if every object passes the predicate.");
    STAssertEqualObjects([origin dropWhile: ^(id s) {return NO;}], origin, @"returns all elements if the first object doesn't pass the predicate.");
    
}

- (void) testReverse
{
    NSArray *origin = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSArray *supposedResult = [NSArray arrayWithObjects: @"c", @"b", @"a", nil];
    
    STAssertEqualObjects([origin reverse], supposedResult, @"Create a new array with reverse order.");
}

- (void) testGrouped
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSArray *supposedResult3 = [NSArray arrayWithObjects: [NSArray arrayWithObjects: @"1", @"2", @"3", nil], [NSArray arrayWithObjects: @"4", @"5", @"6", nil], [NSArray arrayWithObjects: @"7", @"8", @"9", nil], nil];
    NSArray *supposedResult4 = [NSArray arrayWithObjects: [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", nil], [NSArray arrayWithObjects: @"5", @"6", @"7", @"8", nil], [NSArray arrayWithObject: @"9"], nil];
    
    STAssertThrows([origin grouped: 0], @"Grouped to 0 with result an exception.");
    
    STAssertEqualObjects([[NSArray array] grouped: 1], [NSArray array], @"empty array will become empty array.");

    STAssertEqualObjects([origin grouped: 3], supposedResult3, @"grouped the array with size 3");
    STAssertEqualObjects([origin grouped: 4], supposedResult4, @"grouped the array with size 4");
    STAssertEqualObjects([origin grouped: 10], [NSArray arrayWithObject: origin], @"grouped with size >= [origin length], it should equals to an array of origin array.");    
}

- (void) testGroupedBlock
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];

    STAssertThrows([origin grouped: 0 block: ^(NSArray *groupedArray) {
        STFail(@"group with size 0 should not be execute!");
    }], @"Grouped to 0 with result an exception.");

    [[NSArray array] grouped: 1 block: ^(NSArray *groupedArray) {
        STAssertEqualObjects(groupedArray, [NSArray array], @"should be empty array");
    }];
    
    
    for (NSUInteger size = 1; size < 15; size++) {
        NSMutableArray *result = [NSMutableArray array];
        [origin grouped: size block: ^(NSArray *groupedArray) {
            [result addObject: groupedArray];
        }];
        STAssertEqualObjects(result, [origin grouped: size], @"Iterate the grouped block in order");
    }
}


- (void) testGroupBy
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"2", @"3", nil];
    NSDictionary *supposedResult = [NSDictionary dictionaryWithObjectsAndKeys: [NSArray arrayWithObjects: @"1", @"3", nil], @"odd", [NSArray arrayWithObject: @"2"], @"even", nil];
    
    NSDictionary *result = [origin groupBy: ^(NSString *s) {
        return ([s intValue] % 2 == 0) ? @"even" : @"odd";
    }];
    STAssertEqualObjects(result, supposedResult, @"Partitions elements into a dictionary of arrays of elements by a discriminator function");
}

- (void) testSlidingWithSize
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", nil];
    NSArray *emptyArray = [NSArray array];
    
    STAssertThrows([origin slidingWithSize: 0], @"Sliding with size 0 with throws exception.");
    STAssertEqualObjects([emptyArray slidingWithSize: 1], emptyArray, @"Sliding with empty array results empty array.");
    
    NSArray *supposedResult3 = [NSArray arrayWithObjects: [NSArray arrayWithObjects: @"1", @"2", @"3", nil], [NSArray arrayWithObjects: @"2", @"3", @"4", nil], [NSArray arrayWithObjects: @"3", @"4", @"5", nil], nil];
    STAssertEqualObjects([origin slidingWithSize: 3], supposedResult3, @"Sliding with size < [self length] should produce an array consists of ([self length] - size + 1) successive subarrays.");
    
    STAssertEqualObjects([origin slidingWithSize: 5], [NSArray arrayWithObject: origin], @"Sliding with size >= [self length] should result an array containing self.");
}

- (void) testSlidingWithSizeStep
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", nil];
    NSArray *emptyArray = [NSArray array];
    
    STAssertThrows([origin slidingWithSize: 0 step: 1], @"Sliding with size 0 with throws exception.");
    STAssertThrows([origin slidingWithSize: 1 step: 0], @"Sliding with step 0 with throws exception.");

    STAssertEqualObjects([emptyArray slidingWithSize: 1 step: 2], emptyArray, @"Sliding with empty array results empty array.");
    
    NSArray *supposedResult32 = [NSArray arrayWithObjects: [NSArray arrayWithObjects: @"1", @"2", @"3", nil], [NSArray arrayWithObjects: @"3", @"4", @"5", nil], nil];
    STAssertEqualObjects([origin slidingWithSize: 3 step: 2], supposedResult32, @"Sliding with step will produce successive subarrays where their begin index jump [step] until some of their last element reach the end of origin array.");
    
    NSArray *supposedResult43 = [NSArray arrayWithObjects: [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", nil], [NSArray arrayWithObjects: @"4", @"5", nil], nil];

    STAssertEqualObjects([origin slidingWithSize: 4 step: 3], supposedResult43, @"Sliding with step will produce successive subarrays where their begin index jump [step] until some of their last element reach the end of origin array. The last subarray could be smaller than size.");
}

- (void) testSlidingWithSizeStepBlock
{
    NSArray *origin = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSArray *emptyArray = [NSArray array];
    
    STAssertThrows([origin slidingWithSize: 0 step: 1 block: ^(NSArray *slidedArray) {
        STFail(@"Should not get called with size 0");
    }], @"Sliding with size 0 with throws exception.");
    STAssertThrows([origin slidingWithSize: 1 step: 0 block: ^(NSArray *slidedArray) {
        STFail(@"Should not get called with step 0");
    }], @"Sliding with step 0 with throws exception.");
    
    [emptyArray slidingWithSize: 1 step: 2 block: ^(NSArray *subArray) {
        STFail(@"Should not get called with empty array");        
    }];
    
    for (NSUInteger size = 1; size < 10; size++) {
        for (NSUInteger step = 1; step < 10; step++) {
            NSMutableArray *result = [NSMutableArray array];
            [origin slidingWithSize: size step: step block:^(NSArray *subArray) {
                [result addObject: subArray];
            }];
            STAssertEqualObjects(result, [origin slidingWithSize: size step: step], @"Should iterate [self slidingWithSize: size step: step] in order.");
        }
    }
}

- (void) testMin
{
    NSComparisonResult (^comparator)(NSString *a, NSString *b) = ^(NSString *a, NSString *b) {
        return [a compare: b];
    };
    
    STAssertNil([[NSArray array] min: comparator], @"The min of empty array is nil.");

    STAssertEqualObjects([[NSArray arrayWithObject: @"OnlyMe"] min: comparator], @"OnlyMe", @"The min of array with only one element is that element.");
    
    NSArray *origin = [NSArray arrayWithObjects: @"8", @"3", @"6", @"4", @"1", @"5", @"7", @"9", @"2", nil];
    STAssertEqualObjects([origin min: comparator], @"1", @"Find the min in the array");
}

- (void) testMax
{
    NSComparisonResult (^comparator)(NSString *a, NSString *b) = ^(NSString *a, NSString *b) {
        return [a compare: b];
    };
    
    STAssertNil([[NSArray array] max: comparator], @"The max of empty array is nil.");
    
    STAssertEqualObjects([[NSArray arrayWithObject: @"OnlyMe"] max: comparator], @"OnlyMe", @"The max of array with only one element is that element.");
    
    NSArray *origin = [NSArray arrayWithObjects: @"8", @"3", @"6", @"4", @"1", @"5", @"7", @"9", @"2", nil];
    STAssertEqualObjects([origin max: comparator], @"9", @"Find the max in the array");
}

@end
