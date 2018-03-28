//
//  SettingController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "SettingController.h"
#import "ChangePwdController.h"
#import "AboutController.h"
@interface SettingController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"设置";
    LRViewBorderRadius(self.logoutBtn, 25, 1, COLOR(248, 109, 81, 1));
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)changePwd:(UITapGestureRecognizer *)sender {
    ChangePwdController *changePwdVC = [ChangePwdController new];
    [self.navigationController pushViewController:changePwdVC animated:YES];
}
- (IBAction)aboutUs:(UITapGestureRecognizer *)sender {
    AboutController *aboutVC = [AboutController new];
    [self.navigationController pushViewController:aboutVC animated:YES];
}
- (IBAction)logout:(UIButton *)sender {
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
