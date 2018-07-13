//
//  NewAddWorkDetailViewController.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/6/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "NewAddWorkDetailViewController.h"
#import "DeviceInfoView.h"
#import "DeviceChooseController.h"
#import "LYSDatePickerController.h"
@interface InputModel : NSObject
@property (nonatomic, strong) UITextField *canshuInputTextField;
@property (nonatomic, strong) UITextField *userNameInput;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *devieCode;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) UITextField *use_wind_speedInput;
@property (nonatomic, strong) UITextField *use_pressureInput;
@property (nonatomic, strong) UITextField *use_humidityInput;
@property (nonatomic, strong) UITextField *use_temperatureInput;
@property (nonatomic, strong) UITextField *use_amountInput;
@end
@implementation InputModel
@end
@interface NewAddWorkDetailViewController ()
@property (nonatomic, strong) UIScrollView *scollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSArray *outDevices;
@property (nonatomic, strong) NSArray *chemicalDevices;
@property (nonatomic, strong) NSArray *experimentDevices;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSArray *experimentUnits;
@property (nonatomic, strong) UILabel *selectUnitLabel;
@property (nonatomic, assign) DeviceType type;
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *timeBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSArray *detailModel;
@property (nonatomic, strong) UIView *temp;
@property (nonatomic, strong) NSMutableArray *viewsArr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSDate *chooseDate;
@property (nonatomic, strong) LYSDatePickerController *datePickers;
@end

@implementation NewAddWorkDetailViewController
{
    NSArray *outArray;
    NSArray *shiyanArray;
    NSArray *shijiArray;
    NSMutableArray *allTextField;
    NSMutableArray *chooseOut;
    NSMutableArray *chooseShiYan;
    NSMutableArray *chooseShiji;
    NSArray *hasArray;
    NSMutableArray *allInputModel;
    NSArray *lastAllInputModel;
}
- (NSMutableArray *)viewsArr{
    if (!_viewsArr) {
        _viewsArr = [NSMutableArray array];
    }
    return _viewsArr;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn setTitle:@"添加设备" forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"添加1"] forState:UIControlStateNormal];
        [addBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
        LRViewBorderRadius(addBtn, 22.5, 1, ThemeColor);
        _addBtn = addBtn;
        [self.container addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.temp.mas_bottom).offset(10);
            make.left.equalTo(self.container).offset(15);
            make.right.equalTo(self.container).offset(-15);
            make.bottom.equalTo(self.container).offset(-40);
            make.height.mas_offset(45);
        }];
        if ([self.vcType isEqualToString:@"2"]) {
            _addBtn.hidden = YES;
        }
    }
    return _addBtn;
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
    allInputModel = [NSMutableArray array];
    self.view.backgroundColor = LRRGBColor(233, 233, 233);
    hasArray = [NSArray array];
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(shaiClick)];
        [self getData];
        //        self.view.userInteractionEnabled = NO;
    }
    //    [self setUp];
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
    outArray = nil;
    self.dic = [NSMutableDictionary dictionary];
    shijiArray = nil;
    shiyanArray = nil;
    NSMutableArray *allInputArrays = [NSMutableArray array];
    NSDictionary *dic = self.detailModel[index];
    for (NSDictionary *info in dic[@"date_list"]) {
        if ([info[@"device_type"] integerValue] == 0) {
            outArray = info[@"device_list"];
            for (NSDictionary *dics in outArray) {
                InputModel *model = [InputModel new];
                model.devieCode = dics[@"device_code"];
                model.deviceName = dics[@"device_name"];
                model.type = [info[@"device_type"] integerValue];
                UITextField *nameInput = [UITextField new];
                nameInput.text = dics[@"use_name"];
                UITextField *canshuInput = [UITextField new];
                canshuInput.text = dics[@"check_parameter"];
                UITextField *use_amountInput = [UITextField new];
                use_amountInput.text = info[@"use_amount"];
                UITextField *useWindInput = [UITextField new];
                useWindInput.text = info[@"use_wind_speed"];
                UITextField *usePressInput = [UITextField new];
                usePressInput.text = info[@"use_pressure"];
                UITextField *useHumInput = [UITextField new];
                useHumInput.text = info[@"use_humidity"];
                UITextField *userTempInput = [UITextField new];
                userTempInput.text = info[@"use_temperature"];
                model.userNameInput = nameInput;
                model.canshuInputTextField = canshuInput;
                model.use_amountInput = use_amountInput;
                model.use_humidityInput = useHumInput;
                model.use_temperatureInput = userTempInput;
                model.use_pressureInput = usePressInput;
                model.use_wind_speedInput = useWindInput;
                [allInputArrays addObject:model];
            }
            self.dic[@"out_use_temperature"] = info[@"use_temperature"];
            self.dic[@"out_use_pressure"] = info[@"use_pressure"];
            self.dic[@"out_use_humidity"] = info[@"use_humidity"];
            self.dic[@"out_use_wind_speed"] = info[@"use_wind_speed"];
            self.dic[@"out_use_person"] = info[@"use_name"];
        } else if ([info[@"device_type"] integerValue] == 2) {
            shijiArray = info[@"device_list"];
            for (NSDictionary *dics in shijiArray) {
                InputModel *model = [InputModel new];
                model.devieCode = dics[@"device_code"];
                model.deviceName = dics[@"device_name"];
                model.type = [info[@"device_type"] integerValue];
                UITextField *nameInput = [UITextField new];
                nameInput.text = dics[@"use_name"];
                UITextField *canshuInput = [UITextField new];
                canshuInput.text = dics[@"check_parameter"];
                UITextField *use_amountInput = [UITextField new];
                use_amountInput.text = info[@"use_amount"];
                UITextField *useWindInput = [UITextField new];
                useWindInput.text = info[@"use_wind_speed"];
                UITextField *usePressInput = [UITextField new];
                usePressInput.text = info[@"use_pressure"];
                UITextField *useHumInput = [UITextField new];
                useHumInput.text = info[@"use_humidity"];
                UITextField *userTempInput = [UITextField new];
                userTempInput.text = info[@"use_temperature"];
                model.userNameInput = nameInput;
                model.canshuInputTextField = canshuInput;
                model.use_amountInput = use_amountInput;
                model.use_humidityInput = useHumInput;
                model.use_temperatureInput = userTempInput;
                model.use_pressureInput = usePressInput;
                model.use_wind_speedInput = useWindInput;
                [allInputArrays addObject:model];
            }
            self.dic[@"shiji_use_amount"] = info[@"use_amount"];
            self.dic[@"shiji_use_person"] = info[@"use_name"];
        } else if ([info[@"device_type"] integerValue] == 1) {
            shiyanArray = info[@"device_list"];
            for (NSDictionary *dics in shiyanArray) {
                InputModel *model = [InputModel new];
                model.devieCode = dics[@"device_code"];
                model.deviceName = dics[@"device_name"];
                model.type = [info[@"device_type"] integerValue];
                UITextField *nameInput = [UITextField new];
                nameInput.text = dics[@"use_name"];
                UITextField *canshuInput = [UITextField new];
                canshuInput.text = dics[@"check_parameter"];
                UITextField *use_amountInput = [UITextField new];
                use_amountInput.text = info[@"use_amount"];
                UITextField *useWindInput = [UITextField new];
                useWindInput.text = info[@"use_wind_speed"];
                UITextField *usePressInput = [UITextField new];
                usePressInput.text = info[@"use_pressure"];
                UITextField *useHumInput = [UITextField new];
                useHumInput.text = info[@"use_humidity"];
                UITextField *userTempInput = [UITextField new];
                userTempInput.text = info[@"use_temperature"];
                model.userNameInput = nameInput;
                model.canshuInputTextField = canshuInput;
                model.use_amountInput = use_amountInput;
                model.use_humidityInput = useHumInput;
                model.use_temperatureInput = userTempInput;
                model.use_pressureInput = usePressInput;
                model.use_wind_speedInput = useWindInput;
                [allInputArrays addObject:model];
            }
            self.dic[@"shiYan_use_temperature"] = info[@"use_temperature"];
            self.dic[@"shiYan_use_humidity"] = info[@"use_humidity"];
            self.dic[@"shiyan_use_person"] = info[@"use_name"];
            self.dic[@"canshu_use"] = info[@"check_parameter"];
        }
    }
    allInputModel = [allInputArrays mutableCopy];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currentDate = [dateFormat stringFromDate:self.chooseDate];
//    [timeBtn setTitle:currentDate forState:UIControlStateNormal];
    self.dic[@"create_time"] = [KRBaseTool timeWithTimeIntervalString:dic[@"create_time"] andFormate:@"yyyy-MM-dd"];
    
    [self setUp];
    //    [self setTextInput];
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
- (void)setNedDisplay {
    for (UIView *sub in self.container.subviews) {
        if (sub == self.container) {
            continue;
        }
        [sub removeFromSuperview];
    }
    //    if ([self.vcType isEqualToString:@"1"]) {
    lastAllInputModel = [allInputModel copy];
    [allInputModel removeAllObjects];
    //    }
    
    
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
    if (self.chooseDate) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [dateFormat stringFromDate:self.chooseDate];
        [timeBtn setTitle:currentDate forState:UIControlStateNormal];
        [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [timeBtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.vcType isEqualToString:@"2"]) {
        [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [timeBtn setTitle:self.dic[@"create_time"] forState:UIControlStateNormal];
        timeBtn.userInteractionEnabled = NO;
    }
    
    UIView *temp = timeView;
    if ([hasArray containsObject:@"1"] || outArray.count > 0) {
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
    if ([hasArray containsObject:@"2"] || shiyanArray.count > 0) {
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
    if ([hasArray containsObject:@"3"] || shijiArray.count > 0) {
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
    self.temp = temp;
    [self.addBtn removeFromSuperview];
    self.addBtn = nil;
    [self reloadInput];
    [self.container addSubview:self.addBtn];
    
}
- (void)reloadInput {
    for (InputModel *model in allInputModel) {
        for (InputModel *model1 in lastAllInputModel) {
            if ([model.devieCode isEqualToString:model1.devieCode]) {
                model.userNameInput.text = model1.userNameInput.text;
                model.use_wind_speedInput.text = model1.use_wind_speedInput.text;
                model.use_pressureInput.text = model1.use_pressureInput.text;
                model.use_humidityInput.text = model1.use_humidityInput.text;
                model.use_temperatureInput.text = model1.use_temperatureInput.text;
                model.use_amountInput.text = model1.use_amountInput.text;
                model.canshuInputTextField.text = model1.canshuInputTextField.text;
            }
        }
    }
}
- (UIView *)setDeViceWith:(NSArray *)array type:(DeviceType)type {
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
        make.height.equalTo(@(40 * ((arr.count + 1) /2) + (((arr.count + 1) /2)) * 15));
        make.left.right.equalTo(deviceView);
    }];
    centerView.backgroundColor = [UIColor whiteColor];
    
    UIView *temp = titleLabel;
    NSMutableArray *mutInput = [NSMutableArray array];
    
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
        [mutInput addObject:field];
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
    UIView *bottomV = [[UIView alloc]init];
    bottomV.backgroundColor = [UIColor whiteColor];
    [deviceView addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom);
        make.height.equalTo(@((45 + (tag == 2 ? 90 : 45)) * (array.count) + ([self.vcType isEqualToString:@"1"] ? 45 : 0)));
        make.left.right.equalTo(deviceView);
        make.bottom.equalTo(deviceView.mas_bottom);
    }];
    for (int i= 0; i < array.count; i ++) {
        InputModel *model = [InputModel new];
        if (tag == OutDevice) {
            //外出
            model.use_temperatureInput = mutInput[0];
            model.use_pressureInput = mutInput[1];
            model.use_humidityInput = mutInput[2];
            model.use_wind_speedInput = mutInput[3];
        } else if (type == ChemicalDevice) {
            //化学
            model.use_amountInput = mutInput[0];
            
        } else {
            //实验
            model.use_temperatureInput = mutInput[1];
            model.use_humidityInput = mutInput[0];
        }
        UIView *inputView = [[UIView alloc]init];
        [bottomV addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.right.equalTo(bottomV);
            //            make.height.equalTo(@((tag == 2 ? (45 + 90) : 90) - ([self.vcType isEqualToString:@"2"] ? 45 :0)));
            make.height.equalTo(@((tag == 2 ? (45 + 90) : 90)));
        }];
        UIView *sub = [self addCellStylewithtitleText:array[i][@"device_name"] detailText:array[i][@"device_code"]];
        model.devieCode = array[i][@"device_code"];
        [inputView addSubview:sub];
        [sub viewWithTag:100].backgroundColor = [UIColor clearColor];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(inputView.mas_top);
            make.left.right.equalTo(bottomV);
            make.height.equalTo(@45);
        }];
        if ([self.vcType isEqualToString:@"1"]) {
            //            UITapGestureRecognizer *lo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDevice:)];
            //            [sub addGestureRecognizer:lo];
        }
        
        if (type == OutDevice) {
            sub.tag = i + 100;
        } else if (type == ChemicalDevice) {
            sub.tag = i + 1000;
        } else {
            sub.tag = i + 10000;
        }
        UIView *canshuInput = nil;
        
        if (tag == 2) {
            canshuInput = [[UIView alloc]init];
            [inputView addSubview:canshuInput];
            [canshuInput mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sub.mas_bottom);
                make.left.right.equalTo(centerView);
                make.height.equalTo(@45);
            }];
            UILabel *titlelabel = [[UILabel alloc]init];
            [canshuInput addSubview:titlelabel];
            [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(canshuInput.mas_left).with.offset(15);
                make.centerY.equalTo(canshuInput.mas_centerY);
            }];
            titlelabel.font = [UIFont systemFontOfSize:14];
            titlelabel.text = @"检测参数";
            
            UITextField *canshuTex = [[UITextField alloc]init];
            [canshuInput addSubview:canshuTex];
            [allTextField addObject:canshuTex];
            canshuTex.font = [UIFont systemFontOfSize:14];
            [canshuTex mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(canshuInput.mas_right).with.offset(-15);
                make.height.equalTo(@30);
                make.centerY.equalTo(canshuInput.mas_centerY);
            }];
            [canshuTex addTarget:self action:@selector(fieldChange:) forControlEvents:UIControlEventEditingChanged];
            canshuTex.tag = 888 + baseTag;
            canshuTex.textAlignment = NSTextAlignmentRight;
            canshuTex.placeholder = @"输入检测参数";
            model.canshuInputTextField = canshuTex;
            if ([self.vcType isEqualToString:@"2"]) {
                canshuTex.userInteractionEnabled = NO;
            }
            UIView *line = [[UIView alloc]init];
            [canshuInput addSubview:line];
            line.backgroundColor = LRRGBColor(233, 233, 233);
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.equalTo(inputView);
                make.height.equalTo(@1);
            }];
        }
        UIView *canshuView = [[UIView alloc]init];
        [inputView addSubview:canshuView];
        [canshuView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (canshuInput) {
                make.top.equalTo(canshuInput.mas_bottom);
            } else {
                make.top.equalTo(sub.mas_bottom);
            }
            
            make.left.right.equalTo(inputView);
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
        model.userNameInput = canshuTex;
        model.type = tag;
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
        
        
        [allInputModel addObject:model];
        
        //        [sub addGestureRecognizer:lo];
        temp = inputView;
    }
    UIView *add = [[UIView alloc]init];
    [bottomV addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom);
        make.left.right.equalTo(bottomV);
        make.height.equalTo(@45);
    }];
    UIButton *addBtn = [[UIButton alloc]init];
    [add addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(add);
    }];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.tag = type;
    [addBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addDevice:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.vcType isEqualToString:@"2"]) {
        addBtn.hidden = YES;
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
- (UIView *)addCellStylewithtitleText:(NSString *)title detailText:(NSString *)detailText {
    UIView *titleView = [[UIView alloc]init];
    UIView *line = [[UIView alloc]init];
    line.tag = 100;
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
- (void)addDevice{
    __block DeviceType type;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备类型" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"外出设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = OutDevice;
        NSMutableArray *mut = [hasArray mutableCopy];
        if ([mut containsObject:@"1"]) {
            return ;
        }
        [mut addObject:@"1"];
        hasArray = [mut copy];
        [self setNedDisplay];
        //        [self addDeviceWith:type];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"实验设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = ChemicalDevice;
        NSMutableArray *mut = [hasArray mutableCopy];
        if ([mut containsObject:@"2"]) {
            return ;
        }
        [mut addObject:@"2"];
        hasArray = [mut copy];
        [self setNedDisplay];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"化学试剂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = ExperimentDevice;
        NSMutableArray *mut = [hasArray mutableCopy];
        if ([mut containsObject:@"3"]) {
            return ;
        }
        [mut addObject:@"3"];
        hasArray = [mut copy];
        [self setNedDisplay];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (void)addDevice:(UIButton *)sender {
    DeviceChooseController *chooseVC = [DeviceChooseController new];
    
    chooseVC.deviceType =  sender.tag == OutDevice ? @"0" : sender.tag == ChemicalDevice ? @"2" : @"1";
    if ([chooseVC.deviceType isEqualToString:@"0"]) {
        chooseVC.oldArray = outArray;
    } else if ([chooseVC.deviceType isEqualToString:@"1"]) {
        chooseVC.oldArray = shiyanArray;
    } else {
        chooseVC.oldArray = shijiArray;
    }
    __weak typeof(self) weakSelf = self;
    chooseVC.block = ^(NSArray *dic) {
        if (sender.tag == OutDevice) {
            outArray = [dic copy];
        } else if (sender.tag == ChemicalDevice) {
            shijiArray = [dic copy];
        } else {
            shiyanArray = [dic copy];
        }
        [weakSelf setNedDisplay];
        //        self.deviceLabel.text = dic[@"device_name"];
        //        self.deviceCodeLabel.text = dic[@"device_code"];
        //        self.dic[@"device_name"] = dic[@"device_name"];
        //        self.dic[@"device_code"] = dic[@"device_code"];
    };
    [self.navigationController pushViewController:chooseVC animated:YES];
}
- (void)addDeviceWith:(DeviceType)type{
    DeviceInfoView *infoView = [[DeviceInfoView alloc] initWith:type];
    infoView.vc = self;
    [self.container addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.temp.mas_bottom);
    }];
    [self.viewsArr addObject:infoView];
    self.temp = infoView;
    [self.addBtn removeFromSuperview];
    self.addBtn = nil;
    [self.container addSubview:self.addBtn];
    
    //    UIView *deviceView = [[UIView alloc]init];
    //    UILabel *titleLabel = [[UILabel alloc]init];
    //    [deviceView addSubview:titleLabel];
    //    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.right.equalTo(deviceView);
    //        make.left.equalTo(deviceView.mas_left).with.offset(15);
    //        make.height.equalTo(@45);
    //    }];
    //    titleLabel.font = [UIFont systemFontOfSize:14];
    //    titleLabel.textColor = [UIColor redColor];
    //    if (type == OutDevice) {
    //        titleLabel.text = @"外出设备";
    //    } else if (type == ChemicalDevice) {
    //        titleLabel.text = @"实验设备";
    //    } else {
    //        titleLabel.text = @"化学试剂";
    //    }
    //    UIView *bottomV = [[UIView alloc]init];
    //    [deviceView addSubview:bottomV];
    //    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(titleLabel.mas_bottom);
    //        make.height.equalTo(@(45 * array.count));
    //        make.left.right.equalTo(deviceView);
    //    }]
    
}
- (void)timeClick {
    self.datePickers = [[LYSDatePickerController alloc] init];
    self.datePickers.headerView.backgroundColor = [UIColor colorWithRed:84/255.0 green:150/255.0 blue:242/255.0 alpha:1];
    self.datePickers.indicatorHeight = 1;
    self.datePickers.delegate = self;
    self.datePickers.headerView.centerItem.textColor = [UIColor whiteColor];
    self.datePickers.headerView.leftItem.textColor = [UIColor whiteColor];
    self.datePickers.headerView.rightItem.textColor = [UIColor whiteColor];
    self.datePickers.pickHeaderHeight = 40;
    self.datePickers.pickType = LYSDatePickerTypeDay;
    self.datePickers.minuteLoop = YES;
    self.datePickers.headerView.showTimeLabel = YES;
    self.datePickers.weakDayType = LYSDatePickerWeakDayTypeUSShort;
    self.datePickers.showWeakDay = YES;
    if (![[self.timeBtn titleForState:UIControlStateNormal] isEqualToString:@"点击选择"]) {
        [self.datePickers setSelectDate:self.chooseDate];
    }
    __weak typeof(self) weakSelf = self;
    [self.datePickers setDidSelectDatePicker:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [dateFormat stringFromDate:date];
        [weakSelf.timeBtn setTitle:currentDate forState:UIControlStateNormal];
        weakSelf.chooseDate = date;
        [weakSelf.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [weakSelf.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        textField.text = currentDate;
        //        textField.myDate = date;
    }];
    [self.datePickers showDatePickerWithController:self];
}
- (void)setDateView {
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    _dateView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 315)];
    _dateView.backgroundColor = LRRGBColor(80, 164, 105);
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, 270)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
//    _datePicker.minimumDate = [NSDate date];
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
        self.timeStr = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date];
        [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        self.timeLabel.text = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd" withDate:self.datePicker.date];
        
        
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
- (void)doneClick {
    if (![self checkIsFull]) {
        [self showHUDWithText:@"请填写完整"];
        return;
    }
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *outArray = [NSMutableArray array];
    NSMutableArray *shiyanArray = [NSMutableArray array];
    NSMutableArray *shijiArray = [NSMutableArray array];
    for (InputModel *model in allInputModel) {
        if (model.type == 0) {
            [outArray addObject:model];
        } else if (model.type == 1) {
            [shijiArray addObject:model];
        } else {
            [shiyanArray addObject:model];
        }
    }
    if (outArray.count > 0) {
        //外出设备
        NSMutableArray *deviceList = [NSMutableArray array];
        for (InputModel *model in outArray) {
            NSDictionary *dic = @{@"device_code":model.devieCode,@"use_name":model.userNameInput.text,@"check_parameter":(model.canshuInputTextField.text.length == 0 ? @"" : model.canshuInputTextField.text)};
            [deviceList addObject:dic];
        }
        InputModel *tempModel = outArray[0];
        NSMutableString *mutStr = [NSMutableString string];
        for (InputModel *model in outArray) {
            if ([outArray indexOfObject:model] == outArray.count - 1) {
                [mutStr appendString:[NSString stringWithFormat:@"%@",model.devieCode]];
            } else {
                [mutStr appendString:[NSString stringWithFormat:@"%@,",model.devieCode]];
            }
            
        }
        NSMutableString *nameMut = [NSMutableString string];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"device_type"] = @"0";
        //        dic[@"device_project_ids"] = mutStr;
        dic[@"use_temperature"] = tempModel.use_temperatureInput.text;
        dic[@"use_humidity"] = tempModel.use_humidityInput.text;
        dic[@"use_pressure"] = tempModel.use_pressureInput.text;
        dic[@"use_wind_speed"] = tempModel.use_wind_speedInput.text;
        //        dic[@"use_name"] = tempModel.userNameInput.text;
        dic[@"device_list"] = deviceList;
        [result addObject:dic];
    }
    if (shijiArray.count > 0) {
        //试剂
        NSMutableArray *deviceList = [NSMutableArray array];
        for (InputModel *model in shijiArray) {
            NSDictionary *dic = @{@"device_code":model.devieCode,@"use_name":model.userNameInput.text,@"check_parameter":(model.canshuInputTextField.text.length == 0 ? @"" : model.canshuInputTextField.text)};
            [deviceList addObject:dic];
        }
        InputModel *tempModel = shijiArray[0];
        NSMutableString *mutStr = [NSMutableString string];
        for (InputModel *model in shijiArray) {
            if ([shijiArray indexOfObject:model] == shijiArray.count - 1) {
                [mutStr appendString:[NSString stringWithFormat:@"%@",model.devieCode]];
            } else {
                [mutStr appendString:[NSString stringWithFormat:@"%@,",model.devieCode]];
            }
            
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"device_type"] = @"2";
        //        dic[@"device_project_ids"] = mutStr;
        dic[@"use_amount"] = tempModel.use_amountInput.text;
        dic[@"device_list"] = deviceList;
        //        dic[@"use_name"] = tempModel.userNameInput.text;
        [result addObject:dic];
    }
    if (shiyanArray.count > 0) {
        //实验
        NSMutableArray *deviceList = [NSMutableArray array];
        for (InputModel *model in shiyanArray) {
            NSDictionary *dic = @{@"device_code":model.devieCode,@"use_name":model.userNameInput.text,@"check_parameter":(model.canshuInputTextField.text.length == 0 ? @"" : model.canshuInputTextField.text)};
            [deviceList addObject:dic];
        }
        InputModel *tempModel = shiyanArray[0];
        NSMutableString *mutStr = [NSMutableString string];
        for (InputModel *model in shiyanArray) {
            if ([shiyanArray indexOfObject:model] == chooseShiYan.count - 1) {
                [mutStr appendString:[NSString stringWithFormat:@"%@",model.devieCode]];
            } else {
                [mutStr appendString:[NSString stringWithFormat:@"%@,",model.devieCode]];
            }
            
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"device_type"] = @"1";
        //        dic[@"device_project_ids"] = mutStr;
        dic[@"use_temperature"] = tempModel.use_temperatureInput.text;
        dic[@"use_humidity"] = tempModel.use_humidityInput.text;
        //        dic[@"check_parameter"] = tempModel.canshuInputTextField.text;
        //        dic[@"use_name"] = tempModel.userNameInput.text;
        [result addObject:dic];
        dic[@"device_list"] = deviceList;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"project_code"] = self.proCode;
    param[@"create_time"] = [self.timeBtn titleForState:UIControlStateNormal];
    param[@"date_list"] = [result copy];
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/adddeviceuserecord" params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return;
        }
        [self showHUDWithText:@"添加成功"];
        [self performSelector:@selector(pop) withObject:nil afterDelay:1];
    }];
}
- (BOOL)checkIsFull {
    if ([[self.timeBtn titleForState:UIControlStateNormal] isEqualToString:@"点击选择"]) {
        //        [self showHUDWithText:@"请选择时间"];
        return NO;
    }
    for (InputModel *model in allInputModel) {
        if (model.type == 0) {
            //外出
            if (model.use_temperatureInput.text.length == 0 || model.userNameInput.text.length == 0 || model.use_pressureInput.text.length == 0 || model.use_humidityInput.text.length == 0 || model.use_wind_speedInput.text.length == 0) {
                return NO;
            }
        } else if (model.type == 1) {
            //化学
            if (model.use_amountInput.text.length == 0 || model.userNameInput.text.length == 0) {
                return NO;
            }
        } else {
            //实验
            if (model.canshuInputTextField.text.length == 0 || model.userNameInput.text.length == 0 || model.use_temperatureInput.text.length == 0 || model.use_humidityInput.text.length == 0) {
                return NO;
            }
        }
    }
    return YES;
}
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
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
