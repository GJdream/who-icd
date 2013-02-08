//
//  TableCell.h
//  who-icd
//
//  Created by E. Kevin Hall on 2/8/13.
//  Copyright (c) 2013 E. Kevin Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
