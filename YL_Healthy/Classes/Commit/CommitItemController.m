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
@property (weak, nonatomic) IBOutlet UITextField *projectCodeField;

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
    if ([self cheakIsNull:self.itemNameField.text]) {
        [self showHUDWithText:@"请输入项目名称"];
        return;
    }
    if ([self cheakIsNull:self.projectCodeField.text]) {
        [self showHUDWithText:@"请输入项目编号"];
        return;
    }
    if ([self cheakIsNull:self.comNameField.text]) {
        [self showHUDWithText:@"请输入公司名称"];
        return;
    }
    if ([self.daysLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithText:@"请选择完成天数"];
        return;
    }
    NSDictionary *params = @{@"project_name":self.itemNameField.text,@"company_name":self.comNameField.text,@"project_code":self.projectCodeField.text,@"finish_days":@(self.daysLabel.text.integerValue),@"finish_state":self.completeSwitch.state ? @"1" : @"0"};
    CommitDeviceController *deviceVC = [CommitDeviceController new];
    deviceVC.preParams = params;
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
