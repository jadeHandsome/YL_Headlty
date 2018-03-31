//
//  AddWorkViewController.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/31.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "AddWorkViewController.h"
#import "KRMyTextView.h"
@interface AddWorkViewController ()
@property (weak, nonatomic) IBOutlet UIView *textViewBack;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet KRMyTextView *textView;
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation AddWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加工作记录";
    self.textView.myPlaceholder = @"点击输入工作内容";
    [self setDateView];
    LRViewBorderRadius(self.textViewBack, 2, 1, LRRGBColor(240, 240, 240));
}
- (IBAction)timeClick:(id)sender {
    [self.view endEditing:YES];
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
//    self.selectMonth = nil;
    UILabel *titlesLabel = [[UILabel alloc]init];
    [self.dateView addSubview:titlesLabel];
    titlesLabel.font = [UIFont systemFontOfSize:15];
    titlesLabel.text = @"选择日期";
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
       self.timeLabel.text = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date];
       
    }
    
}
- (IBAction)finishClick:(id)sender {
    if ([self.timeLabel.text isEqualToString:@"请选择时间"]) {
        [self showHUDWithText:@"请选择时间"];
        return;
    }
    if (self.textView.text.length == 0) {
        [self showHUDWithText:@"请输入工作内容"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"project_code"] = self.proCode;
    param[@"work_date"] = self.timeLabel.text;
    param[@"work_info"] = self.textView.text;
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/saveworkinfo" params:param withModel:nil complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        [self showHUDWithText:@"添加成功"];
        [self performSelector:@selector(popOutAction) withObject:nil afterDelay:1];
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
