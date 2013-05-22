#import "Kiwi.h"

#import "NSDictionary+KeyPath.h"

SPEC_BEGIN(NSDictionary_KeyPath)

context(@"base context with test dataDict", ^{
    __block id dataDict = nil;
    
    beforeAll(^{ // Occurs once
        dataDict = @{
                     @"ui_settings": @{
                             @"navbar" : @{
                                     @"background-color": [UIColor redColor],
                                     @"cell_height": @44
                                     }
                             },
                     @"social-settings": @{
                             @"facebook" : @{
                                     @"auth-id": @"fb-auth id"
                                     },
                             @"twitter" : @{
                                     @"auth-id": @"twitter auth id"
                                     }
                             },
                     @"simple key": @"and a simple value"
                     };
    });
    
    describe(@"objectForKeyPath", ^{
        
        it(@"should return nil if the path cannot be resolved (key(s) missing)", ^{
            id resultObj = [dataDict objectForKeyPath:@"ui_settings/doesnt-exists"];
            [resultObj shouldBeNil];
            
            resultObj = [dataDict objectForKeyPath:@"ui_settings/navbar/cell_height/doesnt-exists/another-step"];
            [resultObj shouldBeNil];
        });
        
        it(@"should return proper result if the key exists but no slash present in the key-path", ^{
            id resultObj = [dataDict objectForKeyPath:@"simple key"];
            [[resultObj should] equal:@"and a simple value"];
        });
        
        it(@"should return nil if key-path doesn't contain slash and the key doesn't exist at root", ^{
            id resultObj = [dataDict objectForKeyPath:@"doesnt-exist"];
            [resultObj shouldBeNil];
        });
        
        it(@"should return the proper object for some simple valid key-pathes", ^{
            id resultObj = [dataDict objectForKeyPath:@"ui_settings/navbar"];
            [[resultObj should] beKindOfClass:[NSDictionary class]];
            
            resultObj = [dataDict objectForKeyPath:@"ui_settings/navbar/cell_height"];
            [[theValue([resultObj integerValue]) should] equal:theValue(44)];
            
            resultObj = [dataDict objectForKeyPath:@"ui_settings/navbar/background-color"];
            [[resultObj should] beKindOfClass:[UIColor class]];
        });
        
        it(@"should ignore multiple slashes like some//path - should be the same as some/path", ^{
            id resultObj = [dataDict objectForKeyPath:@"social-settings//facebook///auth-id"];
            [[resultObj should] equal:@"fb-auth id"];
        });
        
        it(@"should ignore leading and trailing slashes like /some/path or some/path/ - both should be the same as some/path", ^{
            id resultObj = [dataDict objectForKeyPath:@"/social-settings/twitter/auth-id"];
            [[resultObj should] equal:@"twitter auth id"];
            
            resultObj = [dataDict objectForKeyPath:@"social-settings/twitter/auth-id/"];
            [[resultObj should] equal:@"twitter auth id"];
        });
        
        it(@"should return the dictionary itself if only the root slash is provided", ^{
            id resultObj = [dataDict objectForKeyPath:@"/"];
            [[resultObj should] equal:dataDict];
            
            resultObj = [dataDict objectForKeyPath:@"//"];
            [[resultObj should] equal:dataDict];
        });
        
        it(@"should return nil if the key-path is nil or empty", ^{
            id resultObj = [dataDict objectForKeyPath:@""];
            [resultObj shouldBeNil];
            
            resultObj = [dataDict objectForKeyPath:nil];
            [resultObj shouldBeNil];
        });
    });
    
    describe(@"objectForKeyPath", ^{
        it(@"should return the same value as objectForKeyPath for simple key-path", ^{
            id resultObj = [dataDict objectForKeyPathPattern:@"social-settings//facebook///auth-id"];
            [[resultObj should] equal:@"fb-auth id"];
            
            resultObj = [dataDict objectForKeyPathPattern:@"simple key"];
            [[resultObj should] equal:@"and a simple value"];
            
            resultObj = [dataDict objectForKeyPathPattern:@"doesnt-exist"];
            [resultObj shouldBeNil];
            
            resultObj = [dataDict objectForKeyPathPattern:@"/"];
            [[resultObj should] equal:dataDict];
        });
        
        it(@"should return merged dictionary for a merger key-path-pattern", ^{
            id resultObj = [dataDict objectForKeyPathPattern:@"ui_settings+social-settings"];
            [[theValue([resultObj[@"navbar"][@"cell_height"] integerValue]) should] equal:theValue(44)];
            [[resultObj[@"facebook"][@"auth-id"] should] equal:@"fb-auth id"];
            
            
            resultObj = [dataDict objectForKeyPathPattern:@"ui_settings/navbar+social-settings/facebook"];
            [[theValue([resultObj[@"cell_height"] integerValue]) should] equal:theValue(44)];
            [[resultObj[@"auth-id"] should] equal:@"fb-auth id"];
        });
        
        it(@"should return nil if the pattern contains invalid path(es)", ^{
            id resultObj = [dataDict objectForKeyPathPattern:@"ui_settings/navbar+invalid"];
            [resultObj shouldBeNil];
        });
        
        it(@"should return nil if the pattern contains a path which leads to a non dictionary result", ^{
            id resultObj = [dataDict objectForKeyPathPattern:@"ui_settings/navbar/background-color+invalid"];
            [resultObj shouldBeNil];
        });
    });
});

SPEC_END