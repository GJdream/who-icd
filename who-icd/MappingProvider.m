//
//  MappingProvider.m
//  who-icd
//
//  Created by E. Kevin Hall on 2/7/13.
//  Copyright (c) 2013 E. Kevin Hall. All rights reserved.
//

#import "MappingProvider.h"
#import "ICDRootClass.h"

@implementation MappingProvider

+ (RKMapping *)ICDRootClassMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ICDRootClass class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"ID" : @"icdID",
        @"html" : @"name"
     }];
    return mapping;
}

@end
