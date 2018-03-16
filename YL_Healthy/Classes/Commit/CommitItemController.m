//
//  CommitItemController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "CommitItemController.h"
#import "CommitDeviceController.h"
@interface CommitItemController ()
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UITextField *comNameField;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UISwitch *completeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation CommitItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"项目信息";
    LRViewBorderRadius(self.nextBtn, 22.5, 0, ThemeColor);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)chooseDay:(id)sender {
}
- (IBAction)nextAction:(UIButton *)sender {
    CommitDeviceController *deviceVC = [CommitDeviceController new];
    [self.navigationController pushViewController:deviceVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
