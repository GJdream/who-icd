//
//  main.m
//  who-icd
//
//  Created by E. Kevin Hall on 2/7/13.
//  Copyright (c) 2013 E. Kevin Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PXEngine/PXEngine.h>
#import "PXEngineLicense.h"
#import "AppDelegate.h"

int main(int argc, char *argv[])
{    
    @autoreleasepool {
        [PXEngine licenseKey:PX_ENGINE_LICENSE_KEY forUser:PX_ENGINE_LICENSE_EMAIL];
        [PXStylesheet currentApplicationStylesheet].monitorChanges = YES;
        NSLog(@"CSS Path: %@", [PXStylesheet currentApplicationStylesheet].filePath);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
