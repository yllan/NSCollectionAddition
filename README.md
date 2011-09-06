NSCollectionAddition
====================
NSCollectionAddition adds convenient/functional methods (most were stolen from Scala's collection) to NSCollection classes by using preprocessor / obj-c block syntax that makes development easier. For example, 

`[NSArray arrayWithObjects: @"First", @"Second", @"Third", nil]` becomes `ARRAY(@"First", @"Second", @"Third")`

and filter paths with suffix ".jpg" and then upload 5 photos at most in a batch could be writen without using NSPredicate/boilerplate for-loop and index arithmetic like this:

    [[array filter: ^(NSString *path) { return [path hasSuffix: @".jpg"]; }] 
        grouped: 5 block: ^(NSArray *atMostFiveJPEGs) { [flickr uploadPictures: atMostFiveJPEGs]; }];

**NOTE**: NSCollectionAddition should be able to compile with or without Automatic Reference Counting.


Installation
--------------------
1. Add Git submodule to your project: `git submodule add git://github.com/yllan/NSCollectionAddition.git NSColletionAddition`
1. Drag NSCollectionAddition/NSCollectionAddition to your Xcode project.
1. Include `NSCollectionAddition.h` in your *{ProjectName}-Prefix.pch* (so that you don't have to include in every file using this extensions).

License
--------------------
NSCollectionAddition is released under New BSD License.

Usage
====================
NSCollection contains C macros from [MACollectionUtilities](https://github.com/mikeash/MACollectionUtilities) that simplifies the collection creatuin and scala inspired functional methods.

Creation Macros
--------------------
* `ARRAY(a, b, c)` == `[NSArray arrayWithObjects: a, b, c, nil]`  
* `DICT(k1, v1, k2, v2)` == `[NSDictionary dictionaryWithObjectsAndKeys: v1, k1, v2, k2, nil]`
* `SET(a, b, c)` == `[NSSet setWithObjects: a, b, c, nil]`

Methods
--------------------
You can check the [UnitTest.m](https://github.com/yllan/NSCollectionAddition/blob/master/UnitTest/UnitTest.m) for the usage and expected behavior of each methods.

**Transform**

* `map:`
* `flatMap:`
* `reverse`

**Iterate**

* `foreach:`

**Select**

* `filter:`
* `filterNot:`

**Test**

* `forAll:`
* `exists:`

**Subrange**

* `head`
* `last`
* `tail`
* `take:`
* `takeRight:`
* `takeWhile:`
* `drop:`
* `dropRight:`
* `dropWhile:`

**Partition**

* `grouped:`
* `grouped: block:`
* `groupBy:`
* `slidingWithSize:`
* `slidingWithSize: block:`
* `slidingWithSize: step:`
* `slidingWithSize: step: block:`

**Min/Max**

* `min:`
* `max:`

**Reduce**

* `reduce:`
* `reduceLeft:`
* `reduceRight:`

*To Be Explained*

