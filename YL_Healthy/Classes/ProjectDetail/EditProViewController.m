//
//  EditProViewController.m
//  YL_Healthy
//
//  Created by 李金霞 on 2018/5/6.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "EditProViewController.h"

@interface EditProViewController ()
@property (weak, nonatomic) IBOutlet UITextField *proNameTexyfiel;
@property (weak, nonatomic) IBOutlet UITextField *proCode;
@property (weak, nonatomic) IBOutlet UITextField *compantName;
@property (weak, nonatomic) IBOutlet UITextField *daysInput;

@end

@implementation EditProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改项目信息";
    self.proNameTexyfiel.text = self.oldModel.project_name;
    self.proCode.text = self.oldModel.project_code;
    self.compantName.text = self.oldModel.company_name;
    self.daysInput.text = self.oldModel.finish_days;
}
- (IBAction)saveClick:(id)sender {
    if (self.proNameTexyfiel.text.length == 0) {
        [self showHUDWithText:@"请输入项目名称"];
        return;
    }
    if (self.proCode.text.length == 0) {
        [self showHUDWithText:@"请输入项目编号"];
        return;
    }
    if (self.compantName.text.length == 0) {
        [self showHUDWithText:@"请输入公司名称"];
        return;
    }
    if (self.daysInput.text.length == 0) {
        [self showHUDWithText:@"请输入完成天数"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (![self.proCode.text isEqualToString:self.oldModel.project_code]) {
        param[@"new_project_code"] = self.proCode.text;
    }
    param[@"old_project_code"] = self.oldModel.project_code;
    param[@"project_name"] = self.proNameTexyfiel.text;
    param[@"company_name"] = self.compantName.text;
    param[@"finish_days"] = self.daysInput.text;
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/updateprojectbaseinfo" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [self showHUDWithText:@"修成成功"];
        [self performSelector:@selector(pop) withObject:nil afterDelay:1];
        
    }];
}
- (void)pop {
    if (![self.proCode.text isEqualToString:self.oldModel.project_code]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
