//
//  ViewController.m
//  who-icd
//
//  Created by E. Kevin Hall on 2/7/13.
//  Copyright (c) 2013 E. Kevin Hall. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <NVSlideMenuController/NVSlideMenuController.h>

#import "ICDRootClass.h"
#import "MappingProvider.h"
#import "ViewController.h"
#import "NSString+HTML.h"
#import "NSString+HTMLStrip.h"

#define ROOT_URL @"http://apps.who.int/classifications/icd10/browse/2010/en/JsonGetRootConcepts"

@interface ViewController ()
@property (nonatomic, strong) NSArray *codes;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD show];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadICDCodesWithoutKVC];
    });
}

- (void)loadICDCodesWithoutKVC
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider ICDRootClassMapping];
    RKResponseDescriptor *descriptor = [RKResponseDescriptor
                                        responseDescriptorWithMapping:mapping
                                        pathPattern:nil
                                        keyPath:nil
                                        statusCodes:statusCodeSet];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:ROOT_URL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[descriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        assert([NSThread isMainThread]);
        self.codes = mappingResult.array;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Request Failed"];
    }];
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.styles.count;
    return [self.codes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        ICDRootClass *rootClass = [self.codes objectAtIndex:indexPath.row];
        NSString *cleanName = [[rootClass.name stringByRemovingNewLinesAndWhitespace] stringByStrippingHTML];
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:16]];
        [cell.textLabel setLineBreakMode:NSLineBreakByCharWrapping];
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",
                               rootClass.icdID,
                               cleanName];
    }
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 75.0f;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
