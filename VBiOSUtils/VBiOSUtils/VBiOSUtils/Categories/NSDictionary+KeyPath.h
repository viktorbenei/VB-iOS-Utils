//
//  NSDictionary+KeyPath.h
//  VBiOSUtils
//
//  Created by Viktor Benei on 5/22/13.
//  Copyright (c) 2013 Viktor Benei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KeyPath)

/*! Returns an object for a key-path (defines nested keys)
 
    Example: the key-path "one/two/three" defines a walk-through in the dictionary:
        - get the object for key 'one'
        - on this object get object for key 'two'
        - on this object get object for key 'three' and return it
 
    Dictionary requirements:
        - The dictionary should NOT contain keys with '/' (slash) character!
*/
- (id)objectForKeyPath:(NSString *)keyPath;

/*! Returns an object for a key-path-pattern
 
    A key-path-pattern is similar to a simple key-path but can contain '+' (plus) characters
        which will be a merge of the key pathes
    Example: "ui-settings/navbar+social-settings/some-social-network"
        - this will get the value of "ui-settings/navbar+social"
        - and the value of "social-settings/some-social-network"
        - and return them in a merged Dictionary
 
    If the key-path-pattern is not a simple key-path the returned result will always be an NSDictionary
 
    Dictionary requirements:
        - The dictionary should NOT contain keys with '/' (slash) character!
        - The dictionary should NOT contain keys with '+' (plus) character!
        - merged key-path defined parts (the objects defined by the key-path) should not have the same keys!
            -> example: people/address and cars/registered-address probably both will have common fields/keys and will overwrite each others values for the matching keys!
*/
- (id)objectForKeyPathPattern:(NSString *)keyPathPattern;

@end
