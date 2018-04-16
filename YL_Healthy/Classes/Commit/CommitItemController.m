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
@property (weak, nonatomic) IBOutlet UILabel *cpmpleteLabel;
@property (nonatomic, strong) NSString *finish_state;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *projectCodeField;
@property (weak, nonatomic) IBOutlet UITextField *daysTextField;

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
    if ([self cheakIsNull:self.daysTextField.text]) {
        [self showHUDWithText:@"请输入完成天数"];
        return;
    }
    if ([self.cpmpleteLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithText:@"请选择完成状态"];
        return;
    }
    NSDictionary *params = @{@"project_name":self.itemNameField.text,@"company_name":self.comNameField.text,@"project_code":self.projectCodeField.text,@"finish_days":@(self.daysTextField.text.integerValue),@"finish_state":self.finish_state};
    CommitDeviceController *deviceVC = [CommitDeviceController new];
    deviceVC.preParams = params;
    [self.navigationController pushViewController:deviceVC animated:YES];
}
- (IBAction)completeState:(UITapGestureRecognizer *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"完成状态" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"已采样" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cpmpleteLabel.text = @"已采样";
        self.finish_state = @"1";
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"已完成实验" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cpmpleteLabel.text = @"已完成实验";
        self.finish_state = @"2";
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"已完成报告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cpmpleteLabel.text = @"已完成报告";
        self.finish_state = @"3";
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"已存档" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cpmpleteLabel.text = @"已存档";
        self.finish_state = @"4";
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
