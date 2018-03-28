//
//  CompleteInfoController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "CompleteInfoController.h"
#import "KRDatePicker.h"
#import "BaseNaviViewController.h"
#import "HomeViewController.h"
@interface CompleteInfoController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UIButton *nvBtn;
@property (weak, nonatomic) IBOutlet UIButton *nanBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation CompleteInfoController

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"完善信息";
    LRViewBorderRadius(self.sureBtn, 10, 0, ThemeColor);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)genderAction:(UIButton *)sender {
    self.preBtn.selected = NO;
    sender.selected = !sender.selected;
    self.preBtn = sender;
}
- (IBAction)chooseDate:(id)sender {
    KRDatePicker *picker = [[NSBundle mainBundle] loadNibNamed:@"KRDatePicker" owner:self options:nil].lastObject;
    picker.block = ^(NSDate *date) {
        NSString *dateStr = [self.formatter stringFromDate:date];
        self.dateLabel.text = dateStr;
        self.dateLabel.textColor = [UIColor blackColor];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
}
- (IBAction)sureAction:(UIButton *)sender {
    HomeViewController *homeVC = [HomeViewController new];
    BaseNaviViewController *navi = [[BaseNaviViewController alloc] initWithRootViewController:homeVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
//    if ([self cheakIsNull:self.nameField.text]) {
//        [self showHUDWithText:@"请输入姓名"];
//        return;
//    }
//    if ([self cheakIsNull:self.nickField.text]) {
//        [self showHUDWithText:@"请输入昵称"];
//        return;
//    }
//    if ([self.dateLabel.text isEqualToString:@"请选择"]) {
//        [self showHUDWithText:@"请选择生日"];
//        return;
//    }
//    if (!self.preBtn) {
//        [self showHUDWithText:@"请选择性别"];
//        return;
//    }
//    NSString *sex = self.preBtn == self.nanBtn ? @"2" : @"1";
//    NSDictionary *params = @{@"real_name":self.nameField.text,@"nick_name":self.nickField.text,@"birthday":self.dateLabel.text,@"sex":sex};
//    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"user/infoupdate" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
//        if (showdata) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
//            dic[@"token"] = SharedKRUserInfo.token;
//            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [SharedKRUserInfo setValuesForKeysWithDictionary:dic];
//            HomeViewController *homeVC = [HomeViewController new];
//            BaseNaviViewController *navi = [[BaseNaviViewController alloc] initWithRootViewController:homeVC];
//            [UIApplication sharedApplication].keyWindow.rootViewController = navi;
//        }
//    }];
    
    
    
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
