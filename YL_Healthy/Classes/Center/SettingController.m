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
#import "LoginViewController.h"
#import "KRDatePicker.h"
@interface SettingController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *nanBtn;
@property (weak, nonatomic) IBOutlet UIButton *nvBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation SettingController
- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"设置";
    LRViewBorderRadius(self.logoutBtn, 25, 1, COLOR(248, 109, 81, 1));
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.nickField.text = SharedKRUserInfo.nick_name;
    self.nameField.text = SharedKRUserInfo.real_name;
    if ([SharedKRUserInfo.sex isEqualToString:@"1"]) {
        self.nvBtn.selected = YES;
        self.preBtn = self.nvBtn;
    }
    else{
        self.nanBtn.selected = YES;
        self.preBtn = self.nanBtn;
    }
    self.dateLabel.text = SharedKRUserInfo.birthday;
    // Do any additional setup after loading the view from its nib.
}

- (void)save{
    if ([self cheakIsNull:self.nickField.text]) {
        [self showHUDWithText:@"请输入昵称"];
        return;
    }
    if ([self cheakIsNull:self.nameField.text]) {
        [self showHUDWithText:@"请输入姓名"];
        return;
    }
    NSString *sex = self.preBtn == self.nanBtn ? @"2" : @"1";
    NSDictionary *params = @{@"real_name":self.nameField.text,@"nick_name":self.nickField.text,@"birthday":self.dateLabel.text,@"sex":sex};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"user/infoupdate" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
            dic[@"token"] = SharedKRUserInfo.token;
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SharedKRUserInfo setValuesForKeysWithDictionary:dic];
            [self showHUDWithText:@"保存成功"];
        }
    }];
}

- (IBAction)sex:(UIButton *)sender {
    self.preBtn.selected = NO;
    sender.selected = YES;
    self.preBtn = sender;
}

- (IBAction)chooseDate:(UITapGestureRecognizer *)sender {
    KRDatePicker *picker = [[NSBundle mainBundle] loadNibNamed:@"KRDatePicker" owner:self options:nil].lastObject;
    picker.block = ^(NSDate *date) {
        NSString *dateStr = [self.formatter stringFromDate:date];
        self.dateLabel.text = dateStr;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
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
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"user/logout" params:nil withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
            SharedKRUserInfo.token = nil;
            LoginViewController *loginVC = [LoginViewController new];
            [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
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
