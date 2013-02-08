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
#import <PXEngine/PXEngine.h>

#import "ICDRootClass.h"
#import "MappingProvider.h"
#import "ViewController.h"
#import "NSString+HTML.h"
#import "NSString+HTMLStrip.h"
#import "TableCell.h"

#define ROOT_URL  @"http://apps.who.int/classifications/icd10/browse/2010/en/JsonGetRootConcepts"
#define CHILD_URL @"http://apps.who.int/classifications/icd10/browse/2010/en/JsonGetChildrenConcepts?ConceptId=%@"


@interface ViewController ()
@property (nonatomic, strong) NSArray *codes;
@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"ICD 2010";
    self.navigationController.navigationBar.styleId = @"navigationBar";
    self.tableView.separatorColor = [UIColor colorWithRed:0.820 green:0.832 blue:0.842 alpha:1.000];

    [SVProgressHUD show];
    if (self.passedID == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [self loadICDCodesWithoutKVC];
        });
    } else {
        [self setButtons];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [self loadICDCodesWithoutKVCWithID:self.passedID];
        });
    }
    
}

- (void)loadICDCodesWithoutKVCWithID:(NSString *)passedID
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider ICDRootClassMapping];
    RKResponseDescriptor *descriptor = [RKResponseDescriptor
                                        responseDescriptorWithMapping:mapping
                                        pathPattern:nil
                                        keyPath:nil
                                        statusCodes:statusCodeSet];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CHILD_URL, passedID]];
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

#pragma mark - Scaffold
- (void)setButtons {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.styleId = [NSString stringWithFormat:@"leftNavButton"];
    button.styleClass = @"leftNavButton";
    button.frame = CGRectMake(0,0,100,25);
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    NSUInteger numberOfVCs = [self.navigationController.viewControllers count];
    ViewController *vc = self.navigationController.viewControllers[numberOfVCs-1];
    NSString *title = vc.passedID;
    [button setTitle:title forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.codes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:nil options:nil];
        for (UIView *view in views) {
            cell = (TableCell *)view;
            cell.styleClass = @"tableViewCell";
            ICDRootClass *rootClass = [self.codes objectAtIndex:indexPath.row];
            NSString *cleanName = [[rootClass.name stringByRemovingNewLinesAndWhitespace] stringByStrippingHTML];
            NSLog(@"Clean (%@)", cleanName);
            cell.idLabel.text = rootClass.icdID;
            cell.detailLabel.text = cleanName;
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewController *vc = [[ViewController alloc] init];
    vc.passedID = [[self.codes objectAtIndex:indexPath.row] icdID];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
