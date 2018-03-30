//
//  DeviceInfoView.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/15.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "DeviceInfoView.h"
#import "DeviceChooseController.h"
@interface DeviceInfoView()
@property (nonatomic, strong) NSArray *outDevices;
@property (nonatomic, strong) NSArray *chemicalDevices;
@property (nonatomic, strong) NSArray *experimentDevices;
@property (nonatomic, strong) NSArray *experimentUnits;
@property (nonatomic, strong) NSMutableArray *persons;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *personView;
@property (nonatomic, assign) DeviceType type;
@property (nonatomic, strong) UILabel *selectUnitLabel;
@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UILabel *deviceCodeLabel;
@end



@implementation DeviceInfoView

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


- (NSMutableArray *)persons{
    if (!_persons) {
        _persons = @[@""].mutableCopy;
    }
    return _persons;
}


- (instancetype)initWith:(DeviceType)type{
    if (self = [super init]) {
        self.type = type;
        self.dic[@"device_type"] = self.type == OutDevice ? @"0" : self.type == ChemicalDevice ? @"2" : @"1";
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = [UIColor whiteColor];
    UIView *deviceContainer = [[UIView alloc] init];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseDevice)];
    [deviceContainer addGestureRecognizer:tapGR];
    [self addSubview:deviceContainer];
    [deviceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    UILabel *deviceTitle = [[UILabel alloc] init];
    deviceTitle.font = [UIFont systemFontOfSize:14];
    deviceTitle.text = self.type == OutDevice ? @"外出设备" : self.type == ChemicalDevice ? @"化学试剂" : @"实验设备";
    [deviceContainer addSubview:deviceTitle];
    [deviceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceContainer).offset(15);
        make.centerY.equalTo(deviceContainer.mas_centerY);
    }];
    UILabel *deviceLabel = [[UILabel alloc] init];
    deviceLabel.text = @"请选择";
    deviceLabel.textAlignment = NSTextAlignmentRight;
    deviceLabel.font = [UIFont systemFontOfSize:14];
    self.deviceLabel = deviceLabel;
    [deviceContainer addSubview:deviceLabel];
    [deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(deviceContainer);
        make.right.equalTo(deviceContainer).offset(-15);
        make.left.equalTo(deviceTitle.mas_right).offset(15);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [deviceContainer addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceContainer).offset(15);
        make.bottom.right.equalTo(deviceContainer);
        make.height.mas_equalTo(1);
    }];
    UIView *deviceCodeContainer = [[UIView alloc] init];
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseDevice)];
    [deviceCodeContainer addGestureRecognizer:tapGR1];
    [self addSubview:deviceCodeContainer];
    [deviceCodeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(deviceContainer.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    UILabel *deviceCodeTitle = [[UILabel alloc] init];
    deviceCodeTitle.font = [UIFont systemFontOfSize:14];
    deviceCodeTitle.text = @"设备编号";
    [deviceCodeContainer addSubview:deviceCodeTitle];
    [deviceCodeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceCodeContainer).offset(15);
        make.centerY.equalTo(deviceCodeContainer.mas_centerY);
    }];
    UILabel *deviceCodeLabel = [[UILabel alloc] init];
    deviceCodeLabel.text = @"请选择";
    deviceCodeLabel.textAlignment = NSTextAlignmentRight;
    deviceCodeLabel.font = [UIFont systemFontOfSize:14];
    self.deviceCodeLabel = deviceCodeLabel;
    [deviceCodeContainer addSubview:deviceCodeLabel];
    [deviceCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(deviceCodeContainer);
        make.right.equalTo(deviceCodeContainer).offset(-15);
        make.left.equalTo(deviceCodeTitle.mas_right).offset(15);
    }];
    UIView *deviceCodeLineView = [[UIView alloc] init];
    deviceCodeLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [deviceCodeContainer addSubview:deviceCodeLineView];
    [deviceCodeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceCodeContainer).offset(15);
        make.bottom.right.equalTo(deviceCodeContainer);
        make.height.mas_equalTo(1);
    }];
    UIView *temp = deviceCodeContainer;
    NSArray *arr;
    switch (self.type) {
        case OutDevice:
            arr = self.outDevices;
            break;
        case ChemicalDevice:
            arr = self.chemicalDevices;
            break;
        case ExperimentDevice:
            arr = self.experimentDevices;
            break;
        default:
            break;
    }
    for (int i = 0; i < arr.count; i ++) {
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 2 == 0) {
                make.left.equalTo(self).offset(15);
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
        LRViewBorderRadius(container, 5, 1, [UIColor groupTableViewBackgroundColor]);
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
        if (self.type == ChemicalDevice) {
            self.selectUnitLabel = unitLabel;
            unitLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *unitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unitChoose)];
            [unitLabel addGestureRecognizer:unitTap];
        }
        [container addSubview:unitLabel];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(container).offset(-2);
            make.centerY.equalTo(container.mas_centerY);
            make.width.mas_equalTo(30);
        }];
        UITextField *field = [[UITextField alloc] init];
        field.font = [UIFont systemFontOfSize:14];
        field.tag = i;
        [field addTarget:self action:@selector(fieldChange:) forControlEvents:UIControlEventEditingChanged];
        [container addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(5);
            make.top.bottom.equalTo(container);
            make.right.equalTo(unitLabel.mas_left).offset(-5);
        }];
    }
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.lineView = lineView1;
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(temp.mas_bottom).offset(15);
    }];
    [self addPesronUI];
    
}

- (void)addPesronUI{
    [self.personView removeFromSuperview];
    UIView *view = [[UIView alloc] init];
    self.personView = view;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.lineView);
    }];
    UIView *temp = view;
    for (int i = 0; i < self.persons.count; i ++) {
        UIView *nameContainer = [[UIView alloc] init];
        [view addSubview:nameContainer];
        [nameContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(45);
            if (i == 0) {
                make.top.equalTo(temp);
            }
            else{
                make.top.equalTo(temp.mas_bottom);
            }
        }];
        UILabel *nameTitle = [[UILabel alloc] init];
        nameTitle.font = [UIFont systemFontOfSize:14];
        nameTitle.text = @"使用设备人";
        [nameContainer addSubview:nameTitle];
        [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameContainer).offset(15);
            make.centerY.equalTo(nameContainer.mas_centerY);
            make.width.mas_equalTo(100);
        }];
        UITextField *nameField = [[UITextField alloc] init];
        nameField.placeholder = @"请输入";
        nameField.textAlignment = NSTextAlignmentRight;
        nameField.font = [UIFont systemFontOfSize:14];
        nameField.tag = i + 4;
        nameField.text = self.persons[i];
        [nameContainer addSubview:nameField];
        [nameField addTarget:self action:@selector(fieldChange:) forControlEvents:UIControlEventEditingChanged];
        [nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(nameContainer);
            make.right.equalTo(nameContainer).offset(-15);
            make.left.equalTo(nameTitle.mas_right).offset(15);
        }];
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [nameContainer addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameContainer).offset(15);
            make.bottom.right.equalTo(nameContainer);
            make.height.mas_equalTo(1);
        }];
        temp = nameContainer;
    }
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setTitle:@"添加使用人" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [addBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom);
        make.left.right.equalTo(view);
        make.height.mas_offset(45);
    }];
    UIView *garyView = [[UIView alloc] init];
    garyView.backgroundColor = COLOR(245, 245, 245, 1);
    [view addSubview:garyView];
    [garyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addBtn.mas_bottom);
        make.left.right.equalTo(view);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(view);
    }];
}

- (void)addPerson{
    [self.persons addObject:@""];
    [self addPesronUI];
}


- (void)unitChoose{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"单位" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *unit in self.experimentUnits) {
        [alert addAction:[self creatAction:unit]];
    }
    [self.vc presentViewController:alert animated:YES completion:nil];
}

- (UIAlertAction *)creatAction:(NSString *)title{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectUnitLabel.text = title;
    }];
    return action;
}

- (void)chooseDevice {
    DeviceChooseController *chooseVC = [DeviceChooseController new];
    chooseVC.deviceType =  self.type == OutDevice ? @"0" : self.type == ChemicalDevice ? @"2" : @"1";
    chooseVC.block = ^(NSDictionary *dic) {
        self.deviceLabel.text = dic[@"device_name"];
        self.deviceCodeLabel.text = dic[@"device_code"];
        self.dic[@"device_name"] = dic[@"device_name"];
        self.dic[@"device_code"] = dic[@"device_code"];
    };
    [self.vc.navigationController pushViewController:chooseVC animated:YES];
}

- (void)fieldChange:(UITextField *)sender{
    NSInteger tag = sender.tag;
    if (tag >= 0 && tag <= 3) {
        if (self.type == OutDevice) {
            if (tag == 0) {
                self.dic[@"use_temperature"] = sender.text;
            }
            else if (tag == 1) {
                self.dic[@"use_pressure"] = sender.text;
            }
            else if (tag == 2) {
                self.dic[@"use_humidity"] = sender.text;
            }
            else {
                self.dic[@"use_wind_speed"] = sender.text;
            }
        }
        else if (self.type == ChemicalDevice) {
            if ([self.selectUnitLabel.text isEqualToString:@"单位"]) {
                [self unitChoose];
                return;
            }
            else{
                self.dic[@"use_amount"] = [NSString stringWithFormat:@"%@%@",sender.text,self.selectUnitLabel.text];
            }
        }
        else {
            if (tag == 0) {
                self.dic[@"use_temperature"] = sender.text;
            }
            else {
                self.dic[@"use_humidity"] = sender.text;
            }
        }
    }
    else {
        [self.persons replaceObjectAtIndex:sender.tag - 4 withObject:sender.text];
        NSMutableString *str = [NSMutableString string];
        for (NSString *name in self.persons) {
            [str appendFormat:@"%@,",name];
        }
        self.dic[@"use_name"] = str;
    }
}

- (BOOL)cheakIsReady {
    BOOL isReady = YES;
    NSArray *keys = [self.dic allKeys];
    if (![keys containsObject:@"device_name"]) {
        isReady = NO;
    }
    if (![keys containsObject:@"device_code"]) {
        isReady = NO;
    }
    if (![keys containsObject:@"use_name"]) {
        isReady = NO;
    }
    if (self.type == OutDevice) {
        if (![keys containsObject:@"use_temperature"]) {
            isReady = NO;
        }
        if (![keys containsObject:@"use_humidity"]) {
            isReady = NO;
        }
        if (![keys containsObject:@"use_pressure"]) {
            isReady = NO;
        }
        if (![keys containsObject:@"use_wind_speed"]) {
            isReady = NO;
        }
    }
    else if (self.type == ChemicalDevice) {
        if (![keys containsObject:@"use_amount"]) {
            isReady = NO;
        }
    }
    else {
        if (![keys containsObject:@"use_temperature"]) {
            isReady = NO;
        }
        if (![keys containsObject:@"use_humidity"]) {
            isReady = NO;
        }
    }
    return isReady;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
