//
//  NSString+HTMLStrip.m
//  who-icd
//
//  Created by E. Kevin Hall on 2/7/13.
//  Copyright (c) 2013 E. Kevin Hall. All rights reserved.
//

#import "NSString+HTMLStrip.h"

@implementation NSString (HTMLStrip)

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy] ;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [[s stringByReplacingCharactersInRange:r withString:@""]
                stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return s;
}

@end
