#import "Kiwi.h"

#import "ParseHelperMacros.h"

SPEC_BEGIN(ParseHelperMacros)

describe(@"NSNULL_IF_NIL", ^{
    it(@"should return NSNull if the object is nil", ^{
        NSString *testObj = nil;
        id safeCastedObject = NSNULL_IF_NIL(testObj);
        [[safeCastedObject should] beKindOfClass:[NSNull class]];
    });
    
    it(@"should return NSNull if the object is NSNull", ^{
        id safeCastedObject = NSNULL_IF_NIL([NSNull null]);
        [[safeCastedObject should] beKindOfClass:[NSNull class]];
    });
    
    it(@"should return the same object if the object is not nil", ^{
        NSString *testObj = @"not nil";
        id safeCastedObject = NSNULL_IF_NIL(testObj);
        [safeCastedObject shouldNotBeNil];
        [[safeCastedObject should] beKindOfClass:[NSString class]];
        [[safeCastedObject should] equal:testObj];
    });
});

describe(@"TYPE_CHECKED", ^{
    it(@"should return nil if the object's class is not the expected one", ^{
        NSString *testObj = @"string";
        id resultObj = TYPE_CHECKED(testObj, NSDictionary);
        [resultObj shouldBeNil];
    });
    
    it(@"should return the same object if the object's class is not the expected one", ^{
        NSString *testObj = @"string";
        id resultObj = TYPE_CHECKED(testObj, NSString);
        [resultObj shouldNotBeNil];
        [[resultObj should] beKindOfClass:[NSString class]];
        [[resultObj should] equal:testObj];
    });
});

SPEC_END