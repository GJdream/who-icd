//
//  MappingProvider.h
//  who-icd
//
//  Created by E. Kevin Hall on 2/7/13.
//  Copyright (c) 2013 E. Kevin Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MappingProvider : NSObject

+ (RKMapping *)ICDRootClassMapping;

@end
