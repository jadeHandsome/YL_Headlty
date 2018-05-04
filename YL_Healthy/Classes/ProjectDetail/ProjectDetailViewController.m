//
//  ProjectDetailViewController.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectDeatilModel.h"
#import "AddWorkViewController.h"
#import "UseDetailViewController.h"
#import "AddDeviceProjectListViewController.h"
@interface ProjectDetailViewController ()
@property (nonatomic, strong) ProjectDeatilModel *currentModel;
@property (nonatomic, strong) UIScrollView *mainScoll;
@property (nonatomic, strong) UILabel *statuLabel;
@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.view.backgroundColor = LRRGBColor(245, 245, 245);
    self.navigationItem.title = @"项目详情";
}
- (void)viewWillAppear:(BOOL)animated {
    [self getData];
}
- (void)setUp {
    if (!self.currentModel) {
        return;
    }
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    self.mainScoll = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScoll];
    [self.mainScoll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *contans = [[UIView alloc]init];
    [self.mainScoll addSubview:contans];
    [contans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScoll);
        make.width.equalTo(self.mainScoll.mas_width);
    }];
    UIView *topView = [[UIView alloc]init];
    [contans addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contans);
        if ([self.currentModel.project_type isEqualToString:@"0"]) {
            make.height.equalTo(@(45 * 4));
        } else {
            make.height.equalTo(@(45 * 8));
        }
    }];
    topView.backgroundColor = [UIColor whiteColor];
    [self addHeader:topView];
    UIView *bottomView = [[UIView alloc]init];
    [contans addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(contans);
    }];
    if ([self.currentModel.project_type isEqualToString:@"0"]) {
        //设备项目
        [self setUpdeviceProject:bottomView];
    } else {
        //事件项目
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWork)];
        [self setUpWorkProject:bottomView];
    }
}
- (void)addWork {
    //添加工作记录
    AddWorkViewController *add = [[AddWorkViewController alloc]init];
    add.proCode = self.projectCode;
    [self.navigationController pushViewController:add animated:YES];
}
- (void)addHeader:(UIView *)superView {
    NSInteger count = 0;
    NSArray *titleArray = nil;
    NSArray *detailArray = nil;
    if ([self.currentModel.project_type isEqualToString:@"0"]) {
        titleArray = @[@"项目名称",@"项目编号",@"公司名称",@"完成天数"];
        detailArray = @[self.currentModel.project_name,self.currentModel.project_code,self.currentModel.company_name,self.currentModel.finish_days];
        count = 4;
    } else {
        titleArray = @[@"项目名称",@"项目编号",@"项目类型",@"开始时间",@"结束时间",@"项目区域",@"项目负责人",@"市场人员"];
        detailArray = @[self.currentModel.project_name,self.currentModel.project_code,self.currentModel.project_type,self.currentModel.start_time,self.currentModel.finish_time,self.currentModel.project_area ? self.currentModel.project_area : @"",self.currentModel.project_leader ? self.currentModel.project_leader : @"",self.currentModel.market_user ? self.currentModel.market_user : @""];
        count = 8;
    }
    UIView *temp =  superView;
    
    for (int i = 0; i < count; i ++) {
        UIView *sub = [[UIView alloc]init];
        [superView addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(superView);
            make.height.equalTo(@45);
        }];
        UILabel *titleLabel = [[UILabel alloc]init];
        [sub addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sub.mas_left).with.offset(15);
            make.centerY.equalTo(sub.mas_centerY);
        }];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = titleArray[i];
        UILabel *detailLabel = [[UILabel alloc]init];
        [sub addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sub.mas_right).with.offset(-15);
            make.centerY.equalTo(sub.mas_centerY);
        }];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.text = detailArray[i];
        UIView *line = [[UIView alloc]init];
        [sub addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(sub);
            make.height.equalTo(@1);
        }];
        line.backgroundColor = COLOR(220, 220, 220, 1);
        temp = sub;
    }
    
}
#pragma -- mark 布局设备项目
- (void)setUpdeviceProject:(UIView *)superView {
//    superView.backgroundColor = [UIColor whiteColor];
    UIView *switchView = [[UIView alloc]init];
    switchView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:switchView];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(10);
        make.left.right.equalTo(superView);
        make.height.equalTo(@45);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    [switchView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchView.mas_left).with.offset(15);
        make.centerY.equalTo(switchView.mas_centerY);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"完成状态";
    UILabel *switchBtn = [[UILabel alloc]init];
    [switchView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(switchView.mas_right).with.offset(-15);
        make.centerY.equalTo(switchView.mas_centerY);
    }];
    _statuLabel = switchBtn;
    switchBtn.font = [UIFont systemFontOfSize:14];
    [switchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusChanged)]];
//    [switchBtn addTarget:self action:@selector(statusChange:) forControlEvents:UIControlEventValueChanged];
    switchView.backgroundColor = [UIColor whiteColor];
    
//    switchBtn.on = self.currentModel.finish_state.integerValue;
    switchBtn.text = [KRBaseTool intToStau:self.currentModel.finish_state.integerValue];
    UIImageView *right = [[UIImageView alloc]init];
    [switchView addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(switchView.mas_right).with.offset(-15);
        make.centerY.equalTo(switchView.mas_centerY);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    right.contentMode = UIViewContentModeScaleAspectFit;
    [switchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(right.mas_left).with.offset(-5);
        make.centerY.equalTo(switchView.mas_centerY);
    }];
    right.image = [UIImage imageNamed:@"ic_right_black"];
    UIView *line = [[UIView alloc]init];
    [switchView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(switchView);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(222, 222, 222);
    NSInteger deviceCount = self.currentModel.device_use_list.count;
    UIView *temp = switchView;
    for (int i = 0; i < deviceCount; i ++) {
        UIView *deviceView = [[UIView alloc]init];
        [superView addSubview:deviceView];
        [deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom).with.offset(45);
            make.left.right.equalTo(superView);
//            if (i == deviceCount - 1) {
//                make.bottom.equalTo(superView.mas_bottom);
//            }
        }];
        temp = deviceView;
        [self setDevice:deviceView withData:self.currentModel.device_use_list[i]];
        UILabel *typeLabel = [[UILabel alloc]init];
        [superView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).with.offset(15);
            make.height.equalTo(@45);
            make.bottom.equalTo(deviceView.mas_top);
        }];
        typeLabel.text = self.currentModel.device_use_list[i].deviceName;
        typeLabel.textColor = [UIColor redColor];
        typeLabel.font = [UIFont systemFontOfSize:14];
    }
    UIView *subView = [[UIView alloc]init];
    [superView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom);
        make.height.equalTo(@45);
        make.left.right.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
    UIButton *leftBtn = [[UIButton alloc]init];
    [subView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(subView);
        make.width.equalTo(@(SCREEN_WIDTH * 0.5));
    }];
    UIButton *rightBtn = [[UIButton alloc]init];
    [subView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(subView);
        make.height.equalTo(@45);
        make.width.equalTo(@(SCREEN_WIDTH * 0.5));
    }];
    [leftBtn setTitle:@"添加使用记录" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(addWorks) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"查看使用记录" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(gotoDetail) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineC = [[UIView alloc]init];
    [subView addSubview:lineC];
    [lineC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(subView);
        make.width.equalTo(@1);
        make.centerX.equalTo(subView.mas_centerX);
    }];
    lineC.backgroundColor = LRRGBColor(233, 233, 233);
    subView.backgroundColor = [UIColor whiteColor];
}
- (void)addWorks {
    AddDeviceProjectListViewController *add = [AddDeviceProjectListViewController new];
    add.oldModel = self.currentModel;
    add.proCode = self.projectCode;
    add.vcType = @"1";
    [self.navigationController pushViewController:add animated:YES];
}
- (void)setDevice:(UIView *)deviceView withData:(ProjectInfo *)infoModel {
//    UIView *topView = nil;
//    NSArray *proArray = nil;
//    if ([deviceModel.device_type isEqualToString:@"0"]) {
//        //外出设备
//        topView = [self addCellStylewithtitleText:@"外出设备" detailText:deviceModel.device_name];
//        NSDictionary *wendu = @{@"title":@"温度：",@"uniT":@"°C",@"detail":deviceModel.use_temperature,@"image":@"温度计"};
//        NSDictionary *qiya = @{@"title":@"气压：",@"uniT":@"Pa",@"detail":deviceModel.use_pressure,@"image":@"气压"};
//        NSDictionary *shidu = @{@"title":@"湿度：",@"uniT":@"%rh",@"detail":deviceModel.use_humidity,@"image":@"湿度"};
//        NSDictionary *fengsu = @{@"title":@"风速：",@"uniT":@"mph",@"detail":deviceModel.use_wind_speed,@"image":@"风速"};
//        proArray = @[wendu,qiya,shidu,fengsu];
//    } else if ([deviceModel.device_type isEqualToString:@"1"]) {
//        //实验设备
//        topView = [self addCellStylewithtitleText:@"实验设备" detailText:deviceModel.device_name];
//        NSDictionary *wendu = @{@"title":@"温度：",@"uniT":@"°C",@"detail":deviceModel.use_temperature,@"image":@"温度计"};
//        NSDictionary *shidu = @{@"title":@"湿度：",@"uniT":@"%rh",@"detail":deviceModel.use_humidity,@"image":@"湿度"};
//        proArray = @[wendu,shidu];
//    } else {
//        //化学试剂
//        topView = [self addCellStylewithtitleText:@"化学试剂" detailText:deviceModel.device_name];
//        NSDictionary *liang = @{@"title":@"使用量：",@"uniT":@"",@"detail":deviceModel.use_amount,@"image":@"温度计"};
//        proArray = @[liang];
//    }
//    [deviceView addSubview:topView];
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(deviceView);
//        make.height.equalTo(@45);
//    }];
//    deviceView.backgroundColor = [UIColor whiteColor];
//    UIView *bottomView = [[UIView alloc]init];
//    [deviceView addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.height.equalTo(@((proArray.count + 1) / 2 * 45 + 45));
//        make.height.equalTo(@(0.0001));
//        make.left.right.equalTo(deviceView);
//        make.top.equalTo(topView.mas_bottom);
//        make.bottom.equalTo(deviceView);
//    }];
//    bottomView.hidden = YES;
//    bottomView.backgroundColor = [UIColor whiteColor];
//    UIView *temp = nil;
//    for (int i = 0; i < proArray.count; i ++) {
//        NSDictionary *dic = proArray[i];
//        UIView *proView = [self propertyViewWith:dic[@"title"] image:dic[@"image"] unit:dic[@"uniT"] detail:dic[@"detail"]];
//        [bottomView addSubview:proView];
//        [proView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (i == 0) {
//                make.top.equalTo(bottomView.mas_top);
//                make.left.equalTo(bottomView.mas_left).with.offset(15);
//            } else if (i == 1) {
//                make.top.equalTo(bottomView.mas_top);
//                make.left.equalTo(bottomView.mas_left).with.offset(SCREEN_WIDTH * 0.5);
//            } else if (i == 2) {
//                make.top.equalTo(bottomView.mas_top).with.offset(45);
//                make.left.equalTo(bottomView.mas_left).with.offset(15);
//            } else {
//                make.top.equalTo(bottomView.mas_top).with.offset(45);
//                make.left.equalTo(bottomView.mas_left).with.offset(SCREEN_WIDTH * 0.5);
//            }
//            make.width.equalTo(@((SCREEN_WIDTH - 30) * 0.5));
//            make.height.equalTo(@45);
//        }];
//        temp = proView;
//
//    }
//
//    UIView *nameView = [self addCellStylewithtitleText:@"设备使用人" detailText:deviceModel.use_name];
//    [bottomView addSubview:nameView];
//    UIView *line1 = [[UIView alloc]init];
//    [nameView addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(nameView);
//        make.height.equalTo(@1);
//    }];
//    line1.backgroundColor = LRRGBColor(222, 222, 222);
//    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(temp.mas_bottom);
//        make.height.equalTo(@45);
//        make.left.right.equalTo(bottomView);
//    }];
    
    UIView *temp = deviceView;
    for (int i = 0; i < infoModel.device_list.count; i ++) {
        UIView *proView = [self addCellStylewithtitleText:infoModel.device_list[i].device_name detailText:infoModel.device_list[i].device_code];
        proView.backgroundColor = [UIColor whiteColor];
        [deviceView addSubview:proView];
        [proView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(deviceView);
            make.height.equalTo(@45);
            if (i == infoModel.device_list.count - 1) {
                make.bottom.equalTo(deviceView);
            }
        }];
        temp = proView;
        
    }
    
}
- (UIView *)propertyViewWith:(NSString *)title image:(NSString *)imageName unit:(NSString *)uniT detail:(NSString *)detail {
    UIView *proper = [[UIView alloc]init];
    UIImageView *headImageView = [[UIImageView alloc]init];
    [proper addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(proper.mas_left);
        make.width.equalTo(@50);
        make.top.bottom.equalTo(proper);
    }];
    headImageView.image = [UIImage imageNamed:imageName];
    headImageView.contentMode = UIViewContentModeCenter;
    UILabel *proTitle = [[UILabel alloc]init];
    [proper addSubview:proTitle];
    [proTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right);
        make.centerY.equalTo(proper.mas_centerY);
    }];
    proTitle.font = [UIFont systemFontOfSize:14];
    proTitle.text = [NSString stringWithFormat:@"%@%@%@",title,detail,uniT];
    return proper;
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
#pragma -- mark 布局事件项目
- (void)setUpWorkProject:(UIView *)superView {
//    superView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [self addCellStylewithtitleText:@"工作记录：" detailText:nil];
    topView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(10);
        make.left.right.equalTo(superView);
        make.height.equalTo(@45);
    }];
    UIView *temp = topView;
    for (int i = 0; i < self.currentModel.work_list.count; i ++) {
        UIView *workView = [self workView:self.currentModel.work_list[i].work_date content:self.currentModel.work_list[i].work_info];
        [superView addSubview:workView];
        [workView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.right.equalTo(superView);
            if (i == self.currentModel.work_list.count - 1) {
                make.bottom.equalTo(superView.mas_bottom);
            }
        }];
        temp = workView;
        
    }
}
- (UIView *)workView:(NSString *)time content:(NSString *)content {
    UIView *workView = [[UIView alloc]init];
    workView.backgroundColor = [UIColor whiteColor];
    UILabel *timeLabel = [[UILabel alloc]init];
    [workView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workView.mas_top).with.offset(0);
        make.left.equalTo(workView.mas_left).with.offset(15);
        make.height.equalTo(@45);
        
    }];
    timeLabel.text = time;
    timeLabel.font = [UIFont systemFontOfSize:14];
    UIView *line = [[UIView alloc]init];
    [workView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workView.mas_left);
        make.top.equalTo(timeLabel.mas_bottom);
        make.right.equalTo(workView.mas_right);
        make.height.equalTo(@1);
    }];
//    line.backgroundColor = LRRGBColor(222, 222, 222);
    UILabel *contentLabel = [[UILabel alloc]init];
    [workView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workView.mas_left).with.offset(15);
        make.right.equalTo(workView.mas_right).with.offset(-15);
        make.top.equalTo(line.mas_bottom).with.offset(10);
        make.bottom.equalTo(workView.mas_bottom).with.offset(-10);
    }];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    UIView *line1 = [[UIView alloc]init];
    [workView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(workView);
        make.height.equalTo(@1);
    }];
    line1.backgroundColor = LRRGBColor(222, 222, 222);
    return workView;
}
- (void)gotoDetail {
    AddDeviceProjectListViewController *add = [AddDeviceProjectListViewController new];
//    add.oldModel = self.currentModel;
    add.proCode = self.projectCode;
    add.vcType = @"2";
    [self.navigationController pushViewController:add animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)statusChanged {
    NSArray *titleArray = @[@"已采样",@"已完成实验",@"已完成报告",@"已存档"];
    [KRBaseTool showAlert:@"请选择完成状态" with_Controller:self with_titleArr:titleArray withShowType:UIAlertControllerStyleActionSheet with_Block:^(int index) {
        NSDictionary *params = @{@"project_code":self.projectCode,@"finish_state":@(index)};
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/updatefinishstate" params:params withModel:nil complateHandle:^(id showdata, NSString *error) {
            if (!error) {
                _statuLabel.text = titleArray[index];
                [self showHUDWithText:@"更改状态成功"];
                
            }
        }];
    }];
    
}
- (void)statusChange:(UISwitch *)sender {
    NSDictionary *params = @{@"project_code":self.projectCode,@"finish_state":sender.on?@"1":@"0"};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/updatefinishstate" params:params withModel:nil complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            [self showHUDWithText:@"更改状态成功"];
        }
    }];
}
//获取项目详情
- (void)getData {
    
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/getdetail" params:@{@"project_code":self.projectCode?self.projectCode:@""} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.currentModel = [ProjectDeatilModel modelWithDictionary:showdata];
        [self setUp];
    }];
}



@end
