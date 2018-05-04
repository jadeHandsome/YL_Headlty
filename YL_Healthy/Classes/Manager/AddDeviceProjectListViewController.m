//
//  AddDeviceProjectListViewController.m
//  YL_Healthy
//
//  Created by 李金霞 on 2018/5/2.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "AddDeviceProjectListViewController.h"
#import "DeviceInfoView.h"
@interface AddDeviceProjectListViewController ()
@property (nonatomic, strong) UIScrollView *scollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSArray *outDevices;
@property (nonatomic, strong) NSArray *chemicalDevices;
@property (nonatomic, strong) NSArray *experimentDevices;
@property (nonatomic, strong) NSArray *experimentUnits;
@property (nonatomic, strong) UILabel *selectUnitLabel;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, assign) DeviceType type;
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *timeBtn;
@property (nonatomic, strong) NSArray *detailModel;
@end

@implementation AddDeviceProjectListViewController
{
    NSArray *outArray;
    NSArray *shiyanArray;
    NSArray *shijiArray;
    NSMutableArray *allTextField;
    NSMutableArray *chooseOut;
    NSMutableArray *chooseShiYan;
    NSMutableArray *chooseShiji;

}
- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}
- (NSArray *)outDevices{
    if (!_outDevices) {
        _outDevices = @[@{@"icon":@"温度计",@"title":@"温度",@"unit":@"℃"},
                        @{@"icon":@"气压",@"title":@"气压",@"unit":@"Pa"},
                        @{@"icon":@"湿度",@"title":@"湿度",@"unit":@"%rh"},
                        @{@"icon":@"风速",@"title":@"风速",@"unit":@"mph"}];
    }
    return _outDevices;
}

- (NSArray *)chemicalDevices{
    if (!_chemicalDevices) {
        _chemicalDevices = @[@{@"icon":@"气压",@"title":@"量",@"unit":@"单位"}];
    }
    return _chemicalDevices;
}

- (NSArray *)experimentDevices{
    if (!_experimentDevices) {
        _experimentDevices = @[@{@"icon":@"温度计",@"title":@"温度",@"unit":@"℃"},
                               @{@"icon":@"湿度",@"title":@"湿度",@"unit":@"%rh"}];
        
    }
    return _experimentDevices;
}
- (NSArray *)experimentUnits{
    if (!_experimentUnits) {
        _experimentUnits = @[@"ml",@"l",@"g",@"kg"];
    }
    return _experimentUnits;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRGBColor(233, 233, 233);
    chooseShiji = [NSMutableArray array];
    chooseShiYan = [NSMutableArray array];
    chooseOut = [NSMutableArray array];
    allTextField = [NSMutableArray array];
    if ([self.vcType isEqualToString:@"1"]) {
        //添加
        for (ProjectInfo *info in self.oldModel.device_use_list) {
            if ([info.deviceName isEqualToString:@"外出设备"]) {
                outArray = [info.device_list modelToJSONObject];
            } else if ([info.deviceName isEqualToString:@"实验设备"]) {
                shiyanArray = [info.device_list modelToJSONObject];
            } else if ([info.deviceName isEqualToString:@"化学试剂"]) {
                shijiArray = [info.device_list modelToJSONObject];
            }
        }
        self.navigationItem.title = @"添加记录";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
        [self setUp];
        [self setDateView];
    } else {
        //详情
        self.navigationItem.title = @"使用记录";
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(shaiClick)];
        [self getData];
//        self.view.userInteractionEnabled = NO;
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    if ([self.vcType isEqualToString:@"1"]) {
        [KRBaseTool showAlert:@"点击设备选择当天使用的设备" with_Controller:self with_titleArr:@[@"确定"] withShowType:UIAlertControllerStyleAlert with_Block:^(int index) {
            
        }];
    }
}
- (void)setTextInput {
    for (UITextField *sender in allTextField) {
        if (sender.tag >= 100 && sender.tag < 1000) {
            //外出设备
            if (sender.tag == 100) {
                sender.text = self.dic[@"out_use_temperature"];
            } else if (sender.tag == 101) {
                sender.text = self.dic[@"out_use_pressure"];
            } else if (sender.tag == 102) {
                sender.text = self.dic[@"out_use_humidity"];
            } else if (sender.tag == 103) {
                sender.text = self.dic[@"out_use_wind_speed"];
            }
        }
        if (sender.tag == 1000) {
            //化学试剂
            sender.text = self.dic[@"shiji_use_amount"];
        }
        if (sender.tag >= 10000) {
            //实验设备
            
            if (sender.tag == 10000) {
                sender.text = self.dic[@"shiYan_use_temperature"];
            } else if (sender.tag == 10001) {
                sender.text = self.dic[@"shiYan_use_humidity"];
            }
        }
        if (sender.tag == 10888) {
            //检测参数
            sender.text = self.dic[@"canshu_use"];
        }
        if (sender.tag == 877) {
            //外出人员
            sender.text = self.dic[@"out_use_person"];
        }
        if (sender.tag == 1777) {
            //化学试剂人员
            sender.text = self.dic[@"shiji_use_person"];
        }
        if (sender.tag == 10777) {
            //实验使用人员
            sender.text = self.dic[@"shiyan_use_person"];
        }
    }
    
}
- (void)shaiClick {
    //筛选
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.detailModel) {
        [array addObject:[KRBaseTool timeWithTimeIntervalString:dic[@"create_time"] andFormate:@"yyyy-MM-dd"]];
    }
    [KRBaseTool showAlert:@"选择时间查看" with_Controller:self with_titleArr:array withShowType:UIAlertControllerStyleActionSheet with_Block:^(int index) {
        [self resetData:index];
    }];
    
    
}
- (void)resetData:(NSInteger)index {
    NSDictionary *dic = self.detailModel[index];
    for (NSDictionary *info in dic[@"date_list"]) {
        if ([info[@"device_type"] integerValue] == 0) {
            outArray = info[@"device_list"];
            self.dic[@"out_use_temperature"] = info[@"use_temperature"];
            self.dic[@"out_use_pressure"] = info[@"use_pressure"];
            self.dic[@"out_use_humidity"] = info[@"use_humidity"];
            self.dic[@"out_use_wind_speed"] = info[@"use_wind_speed"];
            self.dic[@"out_use_person"] = info[@"use_name"];
        } else if ([info[@"device_type"] integerValue] == 2) {
            shiyanArray = info[@"device_list"];
            self.dic[@"shiji_use_amount"] = info[@"use_amount"];
            self.dic[@"shiji_use_person"] = info[@"use_name"];
        } else if ([info[@"device_type"] integerValue] == 1) {
            shijiArray = info[@"device_list"];
            self.dic[@"shiYan_use_temperature"] = info[@"use_temperature"];
            self.dic[@"shiYan_use_humidity"] = info[@"use_humidity"];
            self.dic[@"shiyan_use_person"] = info[@"use_name"];
            self.dic[@"canshu_use"] = info[@"check_parameter"];
        }
    }
    self.dic[@"create_time"] = [KRBaseTool timeWithTimeIntervalString:dic[@"create_time"] andFormate:@"yyyy-MM-dd"];
    
    [self setUp];
    [self setTextInput];
}
- (void)doneClick {
    if (![self checkIsFull]) {
        [self showHUDWithText:@"请填写完整"];
        return;
    }
    NSMutableArray *result = [NSMutableArray array];
    if (chooseOut.count > 0) {
        //外出设备
        NSMutableString *mutStr = [NSMutableString string];
        for (NSNumber *num in chooseOut) {
            if ([chooseOut indexOfObject:num] == chooseOut.count - 1) {
                [mutStr appendString:[NSString stringWithFormat:@"%@",outArray[num.integerValue][@"id"]]];
            } else {
                [mutStr appendString:[NSString stringWithFormat:@"%@,",outArray[num.integerValue][@"id"]]];
            }
            
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"device_type"] = @"0";
        dic[@"device_project_ids"] = mutStr;
        dic[@"use_temperature"] = self.dic[@"out_use_temperature"];
        dic[@"use_humidity"] = self.dic[@"out_use_humidity"];
        dic[@"use_pressure"] = self.dic[@"out_use_pressure"];
        dic[@"use_wind_speed"] = self.dic[@"out_use_wind_speed"];
        dic[@"use_name"] = self.dic[@"out_use_person"];
        [result addObject:dic];
    }
    if (chooseShiji.count > 0) {
      //试剂
        NSMutableString *mutStr = [NSMutableString string];
        for (NSNumber *num in chooseShiji) {
            if ([chooseShiji indexOfObject:num] == chooseShiji.count - 1) {
                [mutStr appendString:[NSString stringWithFormat:@"%@",shijiArray[num.integerValue][@"id"]]];
            } else {
                [mutStr appendString:[NSString stringWithFormat:@"%@,",shijiArray[num.integerValue][@"id"]]];
            }
            
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"device_type"] = @"2";
        dic[@"device_project_ids"] = mutStr;
        dic[@"use_amount"] = self.dic[@"shiji_use_amount"];
        dic[@"use_name"] = self.dic[@"shiji_use_person"];
        [result addObject:dic];
    }
    if (chooseShiYan.count > 0) {
        //实验
        NSMutableString *mutStr = [NSMutableString string];
        for (NSNumber *num in chooseShiYan) {
            if ([chooseShiYan indexOfObject:num] == chooseShiYan.count - 1) {
                [mutStr appendString:[NSString stringWithFormat:@"%@",shiyanArray[num.integerValue][@"id"]]];
            } else {
                [mutStr appendString:[NSString stringWithFormat:@"%@,",shiyanArray[num.integerValue][@"id"]]];
            }
            
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"device_type"] = @"1";
        dic[@"device_project_ids"] = mutStr;
        dic[@"use_temperature"] = self.dic[@"shiYan_use_temperature"];
        dic[@"use_humidity"] = self.dic[@"shiYan_use_humidity"];
        dic[@"check_parameter"] = self.dic[@"canshu_use"];
        dic[@"use_name"] = self.dic[@"shiyan_use_person"];
        [result addObject:dic];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"project_code"] = self.proCode;
    param[@"create_time"] = [self.timeBtn titleForState:UIControlStateNormal];
    param[@"date_list"] = [result copy];
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/adddeviceuserecord" params:param withModel:nil complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return;
        }
        [self showHUDWithText:@"添加成功"];
        [self performSelector:@selector(pop) withObject:nil afterDelay:1];
    }];
}
- (BOOL)checkIsFull {
    if ([[self.timeBtn titleForState:UIControlStateNormal] isEqualToString:@"点击选择"]) {
        return NO;
    }
//    NSArray *array = [self.dic allKeys];
    NSMutableArray *mut = [NSMutableArray array];
    if (chooseOut.count > 0) {
        [mut addObject:@"out_use_temperature"];
        [mut addObject:@"out_use_humidity"];
        [mut addObject:@"out_use_pressure"];
        [mut addObject:@"out_use_wind_speed"];
        [mut addObject:@"out_use_person"];
        if (self.dic[@"out_use_person"]) {
            if ([self.dic[@"out_use_person"] length] == 0) {
                return NO;
            }
        }
        
    }
    if (chooseShiji.count > 0) {
        [mut addObject:@"shiji_use_amount"];
        [mut addObject:@"shiji_use_person"];
        if (self.dic[@"shiji_use_person"]) {
            if ([self.dic[@"shiji_use_person"] length] == 0) {
                return NO;
            }
        }
    }
    if (chooseShiYan.count > 0) {
        [mut addObject:@"shiYan_use_temperature"];
        [mut addObject:@"shiYan_use_humidity"];
        [mut addObject:@"canshu_use"];
        [mut addObject:@"shiyan_use_person"];
        if (self.dic[@"shiyan_use_person"]) {
            if ([self.dic[@"shiyan_use_person"] length] == 0) {
                return NO;
            }
        }
    }
    for (NSString *str in mut) {
        if (![[self.dic allKeys] containsObject:str]) {
            return NO;
        }
        if ([self.dic[str] length] == 0) {
            return NO;
        }
    }
    return YES;
}
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
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
        [self.timeBtn setTitle:[KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date] forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.timeLabel.text = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date];
        
        
    }
    
}
- (void)setUp {
    if (self.scollView) {
        [self.scollView removeFromSuperview];
        self.scollView = nil;
        [self.container removeFromSuperview];
        self.container = nil;
    }
    self.scollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scollView];
    [self.scollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.container = [[UIView alloc]init];
    [self.scollView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scollView);
        make.width.equalTo(self.scollView);
    }];
    
    
    [self setNedDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNedDisplay {
    for (UIView *sub in self.container.subviews) {
        if (sub == self.container) {
            continue;
        }
        [sub removeFromSuperview];
    }
    
    
    UIView *timeView = [[UIView alloc]init];
    [self.container addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.container);
        make.height.equalTo(@45);
    }];
    timeView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    [timeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeView.mas_left).with.offset(15);
        make.centerY.equalTo(timeView.mas_centerY);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"时间";
    UIButton *timeBtn = [[UIButton alloc]init];
    [timeView addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeView.mas_right).with.offset(-15);
        make.centerY.equalTo(timeView.mas_centerY);
    }];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.timeBtn =  timeBtn;
    [timeBtn setTitleColor:LRRGBColor(169, 169, 169) forState:UIControlStateNormal];
    [timeBtn setTitle:@"点击选择" forState:UIControlStateNormal];
    [timeBtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.vcType isEqualToString:@"2"]) {
        [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [timeBtn setTitle:self.dic[@"create_time"] forState:UIControlStateNormal];
        timeBtn.userInteractionEnabled = NO;
    }
    UIView *temp = timeView;
    if (outArray.count > 0) {
        UIView *sub = [self setDeViceWith:outArray type:OutDevice];
        [self.container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == self.container) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(self.container);
            
        }];
        temp = sub;
    }
    if (shiyanArray.count > 0) {
        UIView *sub = [self setDeViceWith:shiyanArray type:ExperimentDevice];
        [self.container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == self.container) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(self.container);
            
        }];
        temp = sub;
    }
    if (shijiArray.count > 0) {
        UIView *sub = [self setDeViceWith:shijiArray type:ChemicalDevice];
        [self.container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == self.container) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            
            make.left.right.equalTo(self.container);
            
        }];
        temp = sub;
    }
    UIView *sub = [[UIView alloc]init];
    [self.container addSubview:sub];
    [sub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom);
        make.left.right.equalTo(self.container);
        make.height.equalTo(@10);
        make.bottom.equalTo(self.container.mas_bottom);
    }];
//    [temp mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (temp == self.container) {
//            make.top.equalTo(temp.mas_top);
//        } else {
//            make.top.equalTo(temp.mas_bottom);
//        }
//
//        make.left.right.equalTo(self.container);
//        make.bottom.equalTo(self.container.mas_bottom).with.offset(-10);
//    }];
//    self.temp = temp;
//    [self.addBtn removeFromSuperview];
//    self.addBtn = nil;
//    [self.container addSubview:self.addBtn];
    
}
- (void)timeClick {
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
- (UIView *)setDeViceWith:(NSArray *)array type:(DeviceType)type{
    UIView *deviceView = [[UIView alloc]init];
    UILabel *titleLabel = [[UILabel alloc]init];
    [deviceView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(deviceView);
        make.left.equalTo(deviceView.mas_left).with.offset(15);
        make.height.equalTo(@45);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor redColor];
    NSInteger tag = 0;
    NSInteger baseTag = 0;
    if (type == OutDevice) {
        titleLabel.text = @"外出设备";
        tag = 0;
        baseTag = 100;
    } else if (type == ChemicalDevice) {
        titleLabel.text = @"化学试剂";
        tag = 1;
        baseTag = 1000;
    } else {
        titleLabel.text = @"实验设备";
        tag = 2;
        baseTag = 10000;
    }
    NSArray *arr;
    switch (tag) {
        case 0:
            arr = self.outDevices;
            break;
        case 1:
            arr = self.chemicalDevices;
            break;
        case 2:
            arr = self.experimentDevices;
            break;
        default:
            break;
    }
    UIView *centerView = [[UIView alloc]init];
    [deviceView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.equalTo(@(40 * ((arr.count + 1) /2) + (((arr.count + 1) /2)) * 15 + (tag == 2 ? 90 : 45)));
        make.left.right.equalTo(deviceView);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    
    UIView *temp = titleLabel;
    
    
    for (int i = 0; i < arr.count; i ++) {
        UIView *view = [[UIView alloc] init];
        [centerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 2 == 0) {
                make.left.equalTo(centerView).offset(15);
                make.top.equalTo(temp.mas_bottom).offset(15);
            }
            else{
                make.left.equalTo(temp.mas_right).offset(15);
                make.top.equalTo(temp.mas_top);
            }
            make.height.mas_equalTo(40);
            make.width.mas_equalTo((SIZEWIDTH - 45) / 2);
        }];
        temp = view;
        NSDictionary *dic = arr[i];
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dic[@"icon"]]];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view);
            make.height.width.mas_equalTo(15);
        }];
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:14];
        title.text = dic[@"title"];
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage.mas_right).offset(2);
            make.centerY.equalTo(view.mas_centerY);
        }];
        UIView *container = [[UIView alloc] init];
        
        
        
        [view addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(5);
            make.right.equalTo(view);
            make.height.mas_equalTo(38);
            make.centerY.equalTo(view.mas_centerY);
        }];
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.font = [UIFont systemFontOfSize:14];
        unitLabel.text = dic[@"unit"];
        unitLabel.textAlignment = NSTextAlignmentRight;
        if (tag == 1) {
            self.selectUnitLabel = unitLabel;
            unitLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *unitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unitChoose)];
            if ([self.vcType isEqualToString:@"1"]) {
                [unitLabel addGestureRecognizer:unitTap];
            } else {
                unitLabel.text = @"";
            }
            
        }
        [container addSubview:unitLabel];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(container).offset(-2);
            make.centerY.equalTo(container.mas_centerY);
            make.width.mas_equalTo(30);
        }];
        UITextField *field = [[UITextField alloc] init];
        field.tag = baseTag + i;
        field.font = [UIFont systemFontOfSize:14];
//        field.tag = i;
        
        [field addTarget:self action:@selector(fieldChange:) forControlEvents:UIControlEventEditingChanged];
        if (tag == 1) {
            [field addTarget:self action:@selector(fieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        }
        [allTextField addObject:field];
        if ([self.vcType isEqualToString:@"1"]) {
            LRViewBorderRadius(container, 5, 1, [UIColor groupTableViewBackgroundColor]);
        } else {
            field.userInteractionEnabled = NO;
            field.textAlignment = NSTextAlignmentRight;
        }
        [container addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(5);
            make.top.bottom.equalTo(container);
            make.right.equalTo(unitLabel.mas_left).offset(-5);
        }];
    }
    if (tag == 2) {
        {
            UIView *canshuView = [[UIView alloc]init];
            [centerView addSubview:canshuView];
            [canshuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(temp.mas_bottom);
                make.left.right.equalTo(centerView);
                make.height.equalTo(@45);
            }];
            UILabel *titlelabel = [[UILabel alloc]init];
            [canshuView addSubview:titlelabel];
            [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(canshuView.mas_left).with.offset(15);
                make.centerY.equalTo(canshuView.mas_centerY);
            }];
            titlelabel.font = [UIFont systemFontOfSize:14];
            titlelabel.text = @"检测参数";
            
            UITextField *canshuTex = [[UITextField alloc]init];
            [canshuView addSubview:canshuTex];
            [allTextField addObject:canshuTex];
            canshuTex.font = [UIFont systemFontOfSize:14];
            [canshuTex mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(canshuView.mas_right).with.offset(-15);
                make.height.equalTo(@30);
                make.centerY.equalTo(canshuView.mas_centerY);
            }];
            [canshuTex addTarget:self action:@selector(fieldChange:) forControlEvents:UIControlEventEditingChanged];
            canshuTex.tag = 888 + baseTag;
            canshuTex.textAlignment = NSTextAlignmentRight;
            canshuTex.placeholder = @"输入检测参数";
            if ([self.vcType isEqualToString:@"2"]) {
                canshuTex.userInteractionEnabled = NO;
            }
            UIView *line = [[UIView alloc]init];
            [canshuView addSubview:line];
            line.backgroundColor = LRRGBColor(233, 233, 233);
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.equalTo(canshuView);
                make.height.equalTo(@1);
            }];
            temp = canshuView;
            
        }
    }
    
        UIView *canshuView = [[UIView alloc]init];
        [centerView addSubview:canshuView];
        [canshuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.right.equalTo(centerView);
            make.height.equalTo(@45);
        }];
        UILabel *titlelabel = [[UILabel alloc]init];
        [canshuView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(canshuView.mas_left).with.offset(15);
            make.centerY.equalTo(canshuView.mas_centerY);
        }];
        titlelabel.font = [UIFont systemFontOfSize:14];
        titlelabel.text = @"使用人员";
        UITextField *canshuTex = [[UITextField alloc]init];
        [canshuView addSubview:canshuTex];
    [allTextField addObject:canshuTex];
    if ([self.vcType isEqualToString:@"2"]) {
        canshuTex.userInteractionEnabled = NO;
    }
        [canshuTex mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(canshuView.mas_right).with.offset(-15);
            make.height.equalTo(@30);
            make.centerY.equalTo(canshuView.mas_centerY);
        }];
    [canshuTex addTarget:self action:@selector(fieldChange:) forControlEvents:UIControlEventEditingChanged];
    canshuTex.tag = baseTag + 777;
        canshuTex.textAlignment = NSTextAlignmentRight;
        canshuTex.placeholder = @"输入使用人员用逗号隔开";
        canshuTex.font = [UIFont systemFontOfSize:14];
        UIView *line = [[UIView alloc]init];
        [canshuView addSubview:line];
        line.backgroundColor = LRRGBColor(233, 233, 233);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(canshuView);
            make.height.equalTo(@1);
        }];
        
    temp = canshuView;
//    UIView *lineView1 = [[UIView alloc] init];
//    lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.lineView = lineView1;
//    [self addSubview:lineView1];
//    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(1);
//        make.top.equalTo(temp.mas_bottom).offset(15);
//    }];
//    [self addPesronUI];
    
    
    UIView *bottomV = [[UIView alloc]init];
    [deviceView addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom);
        make.height.equalTo(@(45 * (array.count)));
        make.left.right.equalTo(deviceView);
        make.bottom.equalTo(deviceView.mas_bottom);
    }];
    bottomV.backgroundColor = [UIColor whiteColor];
    for (int i= 0; i < array.count; i ++) {
        UIView *sub = [self addCellStylewithtitleText:array[i][@"device_name"] detailText:array[i][@"device_code"]];
        [bottomV addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.right.equalTo(bottomV);
            make.height.equalTo(@45);
        }];
        if ([self.vcType isEqualToString:@"1"]) {
            UITapGestureRecognizer *lo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDevice:)];
            [sub addGestureRecognizer:lo];
        }
        
        if (type == OutDevice) {
            sub.tag = i + 100;
        } else if (type == ChemicalDevice) {
            sub.tag = i + 1000;
        } else {
            sub.tag = i + 10000;
        }
        
        
//        [sub addGestureRecognizer:lo];
        temp = sub;
    }
//    UIView *add = [[UIView alloc]init];
//    [bottomV addSubview:add];
//    [add mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(temp.mas_bottom);
//        make.left.right.equalTo(bottomV);
//        make.height.equalTo(@45);
//    }];
//    UIButton *addBtn = [[UIButton alloc]init];
//    [add addSubview:addBtn];
//    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(add);
//    }];
//    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
//    addBtn.tag = type;
//    [addBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
//    [addBtn addTarget:self action:@selector(addDevice:) forControlEvents:UIControlEventTouchUpInside];
    return deviceView;
}
- (void)clickDevice:(UITapGestureRecognizer *)longSender {
    if (longSender.view.tag >= 100 && longSender.view.tag < 1000) {
        //外出
        UIView *sub = longSender.view;
        
        if ([chooseOut containsObject:@(longSender.view.tag - 100)]) {
            [chooseOut removeObject:@(longSender.view.tag - 100)];
            sub.backgroundColor = [UIColor whiteColor];
            for (UILabel *subs in sub.subviews) {
                if ([subs isKindOfClass:[UILabel class]]) {
                    subs.textColor = [UIColor blackColor];
                }
            }
        } else {
            [chooseOut addObject:@(longSender.view.tag - 100)];
            sub.backgroundColor = ThemeColor;
            for (UILabel *subs in sub.subviews) {
                if ([subs isKindOfClass:[UILabel class]]) {
                    subs.textColor = [UIColor whiteColor];
                }
            }
        }
        
    } else if (longSender.view.tag >= 1000 && longSender.view.tag < 10000) {
        //化学
        UIView *sub = longSender.view;
        
        if ([chooseShiji containsObject:@(longSender.view.tag - 1000)]) {
            [chooseShiji removeObject:@(longSender.view.tag - 1000)];
            sub.backgroundColor = [UIColor whiteColor];
            for (UILabel *subs in sub.subviews) {
                if ([subs isKindOfClass:[UILabel class]]) {
                    subs.textColor = [UIColor blackColor];
                }
            }
        } else {
            [chooseShiji addObject:@(longSender.view.tag - 1000)];
            sub.backgroundColor = ThemeColor;
            for (UILabel *subs in sub.subviews) {
                if ([subs isKindOfClass:[UILabel class]]) {
                    subs.textColor = [UIColor whiteColor];
                }
            }
        }
    } else if (longSender.view.tag >= 10000) {
        //实验
        UIView *sub = longSender.view;
        
        if ([chooseShiYan containsObject:@(longSender.view.tag - 10000)]) {
            [chooseShiYan removeObject:@(longSender.view.tag - 10000)];
            sub.backgroundColor = [UIColor whiteColor];
            for (UILabel *subs in sub.subviews) {
                if ([subs isKindOfClass:[UILabel class]]) {
                    subs.textColor = [UIColor blackColor];
                }
            }
        } else {
            [chooseShiYan addObject:@(longSender.view.tag - 10000)];
            sub.backgroundColor = ThemeColor;
            for (UILabel *subs in sub.subviews) {
                if ([subs isKindOfClass:[UILabel class]]) {
                    subs.textColor = [UIColor whiteColor];
                }
            }
        }
    }
}
- (void)fieldChange:(UITextField *)sender{
    if (sender.tag >= 100 && sender.tag < 1000) {
        //外出设备
        if (sender.tag == 100) {
            self.dic[@"out_use_temperature"] = sender.text;
        } else if (sender.tag == 101) {
            self.dic[@"out_use_pressure"] = sender.text;
        } else if (sender.tag == 102) {
            self.dic[@"out_use_humidity"] = sender.text;
        } else if (sender.tag == 103) {
            self.dic[@"out_use_wind_speed"] = sender.text;
        }
    }
    if (sender.tag == 1000) {
        //化学试剂
       self.dic[@"shiji_use_amount"] = [NSString stringWithFormat:@"%@%@",sender.text,self.selectUnitLabel.text];
    }
    if (sender.tag >= 10000) {
        //实验设备
        
        if (sender.tag == 10000) {
            self.dic[@"shiYan_use_temperature"] = sender.text;
        } else if (sender.tag == 10001) {
            self.dic[@"shiYan_use_humidity"] = sender.text;
        }
    }
    if (sender.tag == 10888) {
        //检测参数
        self.dic[@"canshu_use"] = sender.text;
    }
    if (sender.tag == 877) {
        //外出人员
        self.dic[@"out_use_person"] = sender.text;
    }
    if (sender.tag == 1777) {
        //化学试剂人员
        self.dic[@"shiji_use_person"] = sender.text;
    }
    if (sender.tag == 10777) {
        //实验使用人员
        self.dic[@"shiyan_use_person"] = sender.text;
    }
//    NSInteger tag = sender.tag;
//    if (tag == -1) {
//        self.dic[@"检测参数字段"] = sender.text;
//    }
//    else if (tag >= 0 && tag <= 3) {
//        if (self.type == OutDevice) {
//            if (tag == 0) {
//                self.dic[@"use_temperature"] = sender.text;
//            }
//            else if (tag == 1) {
//                self.dic[@"use_pressure"] = sender.text;
//            }
//            else if (tag == 2) {
//                self.dic[@"use_humidity"] = sender.text;
//            }
//            else {
//                self.dic[@"use_wind_speed"] = sender.text;
//            }
//        }
//        else if (self.type == ChemicalDevice) {
//            self.dic[@"use_amount"] = [NSString stringWithFormat:@"%@%@",sender.text,self.selectUnitLabel.text];
//        }
//        else {
//            if (tag == 0) {
//                self.dic[@"use_temperature"] = sender.text;
//            }
//            else {
//                self.dic[@"use_humidity"] = sender.text;
//            }
//        }
//    }
//    else {
////        [self.persons replaceObjectAtIndex:sender.tag - 4 withObject:sender.text];
////        NSMutableString *str = [NSMutableString string];
////        for (NSString *name in self.persons) {
////            [str appendFormat:@"%@,",name];
////        }
////        self.dic[@"use_name"] = str;
//    }
}
- (void)fieldBegin:(UITextField *)sender{
    
    if ([self.selectUnitLabel.text isEqualToString:@"单位"]) {
        [self unitChoose];
        return;
    }
}
- (void)unitChoose{
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"单位" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *unit in self.experimentUnits) {
        [alert addAction:[self creatAction:unit]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
- (UIAlertAction *)creatAction:(NSString *)title{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectUnitLabel.text = title;
    }];
    return action;
}
- (UIView *)addCellStylewithtitleText:(NSString *)title detailText:(NSString *)detailText {
    UIView *titleView = [[UIView alloc]init];
    UIView *line = [[UIView alloc]init];
    [titleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(titleView);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(222, 222, 222);
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(15);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    UILabel *detailLabel = [[UILabel alloc]init];
    [titleView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView.mas_right).with.offset(-15);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.text = detailText;
    return titleView;
}
- (void)getData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/getdeviceuserecordlist" params:@{@"project_code":self.proCode} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.detailModel = [showdata[@"device_use_list"] copy];
        if (showdata) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(shaiClick)];
        }
        if (self.detailModel > 0) {
            [self resetData:0];
        }
        
    }];
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
