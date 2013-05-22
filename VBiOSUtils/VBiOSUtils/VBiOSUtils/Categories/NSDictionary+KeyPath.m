//
//  NSDictionary+KeyPath.m
//  VBiOSUtils
//
//  Created by Viktor Benei on 5/22/13.
//  Copyright (c) 2013 Viktor Benei. All rights reserved.
//

#import "NSDictionary+KeyPath.h"

@implementation NSDictionary (KeyPath)

- (id)objectForKeyPath:(NSString *)keyPath
{
    if( keyPath == nil || [keyPath length] < 1 ) {
        return nil;
    }
    NSArray *keyPathComponents = [keyPath componentsSeparatedByString:@"/"];
    if( [keyPathComponents count] < 1 ) {
        return nil;
    }
    
    __block id pathStepStack = self;
    [keyPathComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if( [obj length] < 1 ) { return; }
        if( ![pathStepStack respondsToSelector:@selector(objectForKey:)] ) {
            pathStepStack = nil;
            *stop = YES;
        }
        else {
            pathStepStack = [pathStepStack objectForKey:obj];
        }
    }];
    
    return pathStepStack;
}

- (id)objectForKeyPathPattern:(NSString *)keyPathPattern
{
    if( keyPathPattern == nil || [keyPathPattern length] < 1 ) {
        return nil;
    }
    NSArray *keyPathesFromPattern = [keyPathPattern componentsSeparatedByString:@"+"];
    if( [keyPathesFromPattern count] < 1 ) {
        return nil;
    }
    
    if( [keyPathesFromPattern count] == 1 ) {
        return [self objectForKeyPath:keyPathesFromPattern[0]];
    }
    
    __block NSMutableArray *keyPathResults = [NSMutableArray new];
    __block BOOL isInvalidKeyPathFound = NO;
    [keyPathesFromPattern enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id keyPathResult = [self objectForKeyPath:obj];
        if( keyPathResult == nil || ![keyPathResult isKindOfClass:[NSDictionary class]] ) {
            NSLog(@"Invalid key-path, nil or not a dictionary: %@", obj);
            isInvalidKeyPathFound = YES;
            *stop = YES;
            return;
        } else {
            [keyPathResults addObject:keyPathResult];
        }
    }];
    
    if( isInvalidKeyPathFound ) {
        return nil;
    }
    
    // merge
    __block NSMutableDictionary *mergedDict = [NSMutableDictionary new];
    __block BOOL isMergeFailed = NO;
    [keyPathResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if( [mergedDict objectForKey:key] != nil ) {
                // already contains
                isMergeFailed = YES;
                *stop = YES;
                NSLog(@"Key already stored - cannot complete merge");
            }
            else {
                [mergedDict setObject:obj forKey:key];
            }
        }];
        if( isMergeFailed ) { *stop = YES; return; }
    }];
        
    if( isMergeFailed ) {
        return nil;
    }
    return mergedDict;
}

@end
