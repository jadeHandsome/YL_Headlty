//
//  LoginViewController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "BaseNaviViewController.h"
#import "CompleteInfoController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *accountContainer;
@property (weak, nonatomic) IBOutlet UIView *pwdContainer;
@property (weak, nonatomic) IBOutlet UIButton *remenberPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation LoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LRViewBorderRadius(self.accountContainer, 22.5, 1, ThemeColor);
    LRViewBorderRadius(self.pwdContainer, 22.5, 1, ThemeColor);
    LRViewBorderRadius(self.loginBtn, 22.5, 1, ThemeColor);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)remenberPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)loginAction:(UIButton *)sender {
    CompleteInfoController *completeVC = [CompleteInfoController new];
    BaseNaviViewController *navi = [[BaseNaviViewController alloc] initWithRootViewController:completeVC];
    [self presentViewController:navi animated:YES completion:nil];
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
