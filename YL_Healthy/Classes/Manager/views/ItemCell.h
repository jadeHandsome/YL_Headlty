//
//  ItemCell.h
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^switchBlock) (BOOL);
@interface ItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemTime;
@property (weak, nonatomic) IBOutlet UILabel *days;
@property (weak, nonatomic) IBOutlet UISwitch *completeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *daysText;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *proCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (nonatomic, strong) switchBlock block;
@property (nonatomic, strong) UIViewController *vc;
@end
