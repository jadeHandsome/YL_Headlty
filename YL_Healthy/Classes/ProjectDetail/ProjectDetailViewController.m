//
//  ProjectDetailViewController.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectDeatilModel.m"
@interface ProjectDetailViewController ()
@property (nonatomic, strong) ProjectDeatilModel *currentModel;
@property (nonatomic, strong) UIScrollView *mainScoll;
@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.view.backgroundColor = LRRGBColor(245, 245, 245);
}
- (void)setUp {
    if (!self.currentModel) {
        return;
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
            make.height.equalTo(@(45 * 3));
        } else {
            make.height.equalTo(@(45 * 4));
        }
    }];
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
        [self setUpWorkProject:bottomView];
    }
}
- (void)addHeader:(UIView *)superView {
    NSInteger count = 0;
    NSArray *titleArray = nil;
    NSArray *detailArray = nil;
    if ([self.currentModel.project_type isEqualToString:@"0"]) {
        titleArray = @[@"项目名称",@"公司名称",@"完成天数"];
        detailArray = @[self.currentModel.project_name,self.currentModel.company_name,self.currentModel.finish_days];
        count = 3;
    } else {
        titleArray = @[@"项目名称",@"公司名称",@"开始时间",@"结束时间"];
        detailArray = @[self.currentModel.project_name,self.currentModel.company_name,self.currentModel.start_time,self.currentModel.finish_time];
        count = 4;
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
    }
    
}
#pragma -- mark 布局设备项目
- (void)setUpdeviceProject:(UIView *)superView {
    superView.backgroundColor = [UIColor whiteColor];
    UIView *switchView = [[UIView alloc]init];
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
    UISwitch *switchBtn = [[UISwitch alloc]init];
    [switchView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(switchView.mas_right).with.offset(-15);
        make.centerY.equalTo(switchView.mas_centerY);
    }];
    switchBtn.on = self.currentModel.finish_state.integerValue;
    NSInteger deviceCount = self.currentModel.device_list.count;
    UIView *temp = switchView;
    for (int i = 0; i < deviceCount; i ++) {
        UIView *deviceView = [[UIView alloc]init];
        [superView addSubview:deviceView];
        [deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom).with.offset(10);
            make.left.right.equalTo(superView);
            if (i == deviceCount - 1) {
                make.bottom.equalTo(superView.mas_bottom);
            }
        }];
        temp = deviceView;
        [self setDevice:deviceView withData:self.currentModel.device_list[i]];
    }
    
}
- (void)setDevice:(UIView *)deviceView withData:(ProjectDeviceModel *)deviceModel {
    UIView *topView = nil;
    NSArray *proArray = nil;
    if ([deviceModel.device_type isEqualToString:@"0"]) {
        //外出设备
        topView = [self addCellStylewithtitleText:@"外出设备" detailText:deviceModel.device_name];
        NSDictionary *wendu = @{@"title":@"温度：",@"uniT":@"°C",@"detail":deviceModel.use_temperature,@"image":@"温度计"};
        NSDictionary *qiya = @{@"title":@"气压：",@"uniT":@"Pa",@"detail":deviceModel.use_pressure,@"image":@"气压"};
        NSDictionary *shidu = @{@"title":@"湿度：",@"uniT":@"%rh",@"detail":deviceModel.use_humidity,@"image":@"湿度"};
        NSDictionary *fengsu = @{@"title":@"风速：",@"uniT":@"mph",@"detail":deviceModel.use_wind_speed,@"image":@"风速"};
        proArray = @[wendu,qiya,shidu,fengsu];
    } else if ([deviceModel.device_type isEqualToString:@"1"]) {
        //实验设备
        topView = [self addCellStylewithtitleText:@"实验设备" detailText:deviceModel.device_name];
        NSDictionary *wendu = @{@"title":@"温度：",@"uniT":@"°C",@"detail":deviceModel.use_temperature,@"image":@"温度计"};
        NSDictionary *shidu = @{@"title":@"湿度：",@"uniT":@"%rh",@"detail":deviceModel.use_humidity,@"image":@"湿度"};
        proArray = @[wendu,shidu];
    } else {
        //化学试剂
        topView = [self addCellStylewithtitleText:@"化学试剂" detailText:deviceModel.device_name];
        NSDictionary *liang = @{@"title":@"使用量：",@"uniT":@"°C",@"detail":deviceModel.use_amount,@"image":@"温度计"};
        proArray = @[liang];
    }
    [deviceView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(deviceView);
        make.height.equalTo(@45);
    }];
    UIView *bottomView = [[UIView alloc]init];
    [deviceView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((proArray.count / 2 + 1) * 120));
        make.left.right.equalTo(deviceView);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.equalTo(deviceView);
    }];
    for (int i = 0; i < proArray.count; i ++) {
        NSDictionary *dic = proArray[i];
        UIView *proView = [self propertyViewWith:dic[@"title"] image:dic[@"image"] unit:dic[@"uniT"] detail:dic[@"detail"]];
        [bottomView addSubview:proView];
        [proView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(bottomView.mas_top);
                make.left.equalTo(bottomView.mas_left).with.offset(15);
                
            } else if (i == 1) {
                make.top.equalTo(bottomView.mas_top);
                make.left.equalTo(bottomView.mas_left).with.offset(SCREEN_WIDTH * 0.5);
            } else if (i == 2) {
                make.top.equalTo(bottomView.mas_top).with.offset(120);
                make.left.equalTo(bottomView.mas_left).with.offset(15);
            } else {
                make.top.equalTo(bottomView.mas_top).with.offset(120);
                make.left.equalTo(bottomView.mas_left).with.offset(SCREEN_WIDTH * 0.5);
            }
            make.width.equalTo(@((SCREEN_WIDTH - 30) * 0.5));
            make.height.equalTo(@120);
        }];
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
    superView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [self addCellStylewithtitleText:@"事件列表" detailText:nil];
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
    line.backgroundColor = LRRGBColor(222, 222, 222);
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
    return workView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
