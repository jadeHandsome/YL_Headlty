//
//  ChangePwdController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ChangePwdController.h"

@interface ChangePwdController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdField;
@property (weak, nonatomic) IBOutlet UITextField *surePwdField;

@end

@implementation ChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sure)];
    // Do any additional setup after loading the view from its nib.
}

- (void)sure{
    if ([self cheakIsNull:self.oldPwdField.text]) {
        [self showHUDWithText:@"请输入原密码"];
        return;
    }
    if ([self cheakIsNull:self.NewPwdField.text]) {
        [self showHUDWithText:@"请输入新密码"];
        return;
    }
    if (![self.NewPwdField.text isEqualToString:self.surePwdField.text]) {
        [self showHUDWithText:@"两次密码不一致"];
        return;
    }
    NSDictionary *params = @{@"old_psw":self.oldPwdField.text,@"new_psw":self.NewPwdField.text};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"user/updatepsw" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            [self showHUDWithText:@"修改成功"];
            [self performSelector:@selector(popOutAction) withObject:nil afterDelay:1.0];
        }
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
