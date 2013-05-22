//
//  ParseHelperMacros.h
//  VBiOSUtils
//
//  Created by Viktor Benei on 3/13/13.
//  Copyright (c) 2013 Viktor Benei. All rights reserved.
//

#ifndef VBiOSUtils_ParseHelperMacros_h
#define VBiOSUtils_ParseHelperMacros_h

/*! Returns NSNull if the object is nil. Helper for NSArray and NSDictionary which cannot hold 'nil' objects only NSNull ones.
*/
#define NSNULL_IF_NIL(o) (o == nil ? [NSNull null] : o)

#define TYPE_CHECK(o, c) ([o isKindOfClass:[c class]] ? (c *)o : nil)

#endif
