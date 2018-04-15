//
//  AddManagerProViewController.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/31.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "AddManagerProViewController.h"

@interface AddManagerProViewController ()
@property (weak, nonatomic) IBOutlet UITextField *proNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *proCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *proTypeTextField;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *selectMonth;
@property (weak, nonatomic) IBOutlet UITextField *areaTetxtInput;
@property (weak, nonatomic) IBOutlet UITextField *fuzerenTextField;
@property (weak, nonatomic) IBOutlet UITextField *shichangTextField;
@property (nonatomic, strong) UILabel *titlesLabel;
@end

@implementation AddManagerProViewController
{
    NSInteger timeTag;
}
- (IBAction)startTimeClick:(id)sender {
    [self.view endEditing:YES];
    timeTag = 0;
    self.titlesLabel.text = @"选择开始时间";
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.dateView.frame;
        if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
            rect.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
//            self.tableView.scrollEnabled = NO;
        }
        else {
            rect.origin.y = [UIScreen mainScreen].bounds.size.height;
//            self.tableView.scrollEnabled = YES;
        }
        self.dateView.frame = rect;
    }];
}
- (IBAction)endTimeClick:(id)sender {
    [self.view endEditing:YES];
    timeTag = 1;
    self.titlesLabel.text = @"选择结束时间";
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.dateView.frame;
        if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
            rect.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
            //            self.tableView.scrollEnabled = NO;
        }
        else {
            rect.origin.y = [UIScreen mainScreen].bounds.size.height;
            //            self.tableView.scrollEnabled = YES;
        }
        self.dateView.frame = rect;
    }];
}
- (void)setDateView {
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    _dateView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 315)];
    _dateView.backgroundColor = LRRGBColor(80, 164, 105);
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, 270)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [NSDate date];
    _datePicker.date = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 2];
    _datePicker.backgroundColor = [UIColor whiteColor];
    UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 45)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    cancle.titleLabel.textColor = [UIColor whiteColor];
    cancle.titleLabel.font = [UIFont systemFontOfSize:15];
    cancle.backgroundColor = [UIColor clearColor];
    cancle.tag = 100;
    [cancle addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 50, 0, 50, 45)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.tag = 101;
    button.titleLabel.textColor = [UIColor whiteColor];
    UIView *linview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    linview.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
    [self.dateView addSubview:linview];
    UIView *linview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 1)];
    linview1.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
    [self.dateView addSubview:linview1];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateView addSubview:button];
    [self.dateView addSubview:cancle];
    [self.dateView addSubview:self.datePicker];
    [self.view addSubview:self.dateView];
    self.selectMonth = nil;
    UILabel *titlesLabel = [[UILabel alloc]init];
    _titlesLabel = titlesLabel;
    [self.dateView addSubview:titlesLabel];
    titlesLabel.font = [UIFont systemFontOfSize:15];
//    titlesLabel.text = @"选择日期";
    titlesLabel.textColor = [UIColor whiteColor];
    [titlesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.top.equalTo(self.dateView.mas_top);
        make.centerX.equalTo(self.dateView.mas_centerX);
        make.width.lessThanOrEqualTo(@250);
    }];
}
- (void)selected:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.dateView.frame;
        if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
            rect.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
        }
        else {
            rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        }
        self.dateView.frame = rect;
    }];
    if (sender.tag == 101) {
        if (timeTag == 0) {
            self.startTimeLabel.text = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date];
        } else {
            self.endTimeLabel.text = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date];
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"添加项目";
    [self setDateView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)finishClick:(id)sender {
    if (self.proNameTextField.text.length == 0) {
        [self showHUDWithText:@"请输入项目名称"];
        return;
    }
    if (self.proCodeTextField.text.length == 0) {
        [self showHUDWithText:@"请输入项目编号"];
        return;
    }
    if (self.proTypeTextField.text.length == 0) {
        [self showHUDWithText:@"请输入项目类型"];
        return;
    }
    if ([self.startTimeLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithText:@"请选择开始时间"];
        return;
    }
    if ([self.endTimeLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithText:@"请选择结束时间"];
        return;
    }
    if (self.areaTetxtInput.text.length == 0) {
        [self showHUDWithText:@"请输入项目区域"];
        return;
    }
    if (self.fuzerenTextField.text.length == 0) {
        [self showHUDWithText:@"请输入项目负责人"];
        return;
    }
    if (self.shichangTextField.text.length == 0) {
        [self showHUDWithText:@"请输入市场人员"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"project_name"] = self.proNameTextField.text;
    param[@"project_code"] = self.proCodeTextField.text;
    param[@"project_type"] = self.proTypeTextField.text;
    param[@"start_time"] = [self.startTimeLabel.text stringByAppendingString:@" 00:00:00"];
    param[@"finish_time"] = [self.endTimeLabel.text stringByAppendingString:@" 00:00:00"];
    param[@"project_area"] = self.areaTetxtInput.text;
    param[@"project_leader"] = self.fuzerenTextField.text;
    param[@"market_user"] = self.shichangTextField.text;
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/saveinfo" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            [self showHUDWithText:@"添加成功"];
            [self performSelector:@selector(popOutAction) withObject:nil afterDelay:1];
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
