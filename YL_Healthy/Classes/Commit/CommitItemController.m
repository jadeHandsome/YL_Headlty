//
//  CommitItemController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "CommitItemController.h"
#import "CommitDeviceController.h"
#import "CommitSuccessController.h"
@interface CommitItemController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UITextField *comNameField;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UISwitch *completeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *projectCodeField;
@property (weak, nonatomic) IBOutlet UITextField *daysTextField;

@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end

@implementation CommitItemController
{
    NSInteger statu;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"项目信息";
    self.comNameField.delegate = self;
    LRViewBorderRadius(self.nextBtn, 22.5, 0, ThemeColor);
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSArray *titleArray = @[@"评价检测",@"定期检测",@"委托检测"];
    [KRBaseTool showAlert:@"请选择检测类型" with_Controller:self with_titleArr:titleArray withShowType:UIAlertControllerStyleActionSheet with_Block:^(int index) {
        self.comNameField.text = titleArray[index];
    }];
    return NO;
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
        [self showHUDWithText:@"请输入检测类型"];
        return;
    }
    if ([self cheakIsNull:self.daysTextField.text]) {
        [self showHUDWithText:@"请输入完成天数"];
        return;
    }
    if ([self.statuLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithText:@"请选择完成状态"];
        return;
    }
    NSDictionary *params = @{@"project_name":self.itemNameField.text,@"company_name":self.comNameField.text,@"project_code":self.projectCodeField.text,@"finish_days":@(self.daysTextField.text.integerValue),@"finish_state":@(statu)};
    CommitDeviceController *deviceVC = [CommitDeviceController new];
    deviceVC.preParams = params;
//    NSMutableArray *mut = [NSMutableArray array];
//    [mut addObjectsFromArray:outArray];
//    [mut addObjectsFromArray:shijiArray];
//    [mut addObjectsFromArray:shiyanArray];
    NSMutableDictionary *param1 = [NSMutableDictionary dictionaryWithDictionary:params];
    param1[@"device_list"] = @[];
    param1[@"project_type"] = @"0";
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/saveinfo" params:param1 withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            CommitSuccessController *successVC = [CommitSuccessController new];
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }];
//    [self.navigationController pushViewController:deviceVC animated:YES];
}
- (IBAction)chooseStatus:(id)sender {
    NSArray *titleArray = @[@"已采样",@"已完成实验",@"已完成报告",@"已存档"];
    [KRBaseTool showAlert:@"请选择完成状态" with_Controller:self with_titleArr:titleArray withShowType:UIAlertControllerStyleActionSheet with_Block:^(int index) {
        self.statuLabel.text = titleArray[index];
        self.statuLabel.textColor = [UIColor blackColor];
        statu = index;
    }];
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
