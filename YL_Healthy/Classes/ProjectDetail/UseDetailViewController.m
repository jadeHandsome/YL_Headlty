//
//  UseDetailViewController.m
//  YL_Healthy
//
//  Created by 李金霞 on 2018/5/1.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "UseDetailViewController.h"
#import "ProjectDeatilModel.h"

@interface UseDetailViewController ()
@property (nonatomic, strong) UIScrollView *mainScoll;
@end

@implementation UseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUp];
    [self getDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUp {
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
    
    UIView *bottomView = [[UIView alloc]init];
    [contans addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contans.mas_top);
        make.left.right.bottom.equalTo(contans);
    }];

    [self setUpdeviceProject:bottomView];
    
}
#pragma -- mark 布局设备项目
- (void)setUpdeviceProject:(UIView *)superView {

    NSInteger deviceCount = self.deviceList.count;
    UIView *temp = superView;
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
//        [self setDevice:deviceView withData:self.currentModel.device_user_list[i]];
        UILabel *typeLabel = [[UILabel alloc]init];
        [superView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).with.offset(15);
            make.height.equalTo(@45);
            make.bottom.equalTo(deviceView.mas_top);
        }];
//        typeLabel.text = self.currentModel.device_user_list[i].typeName;
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
    [leftBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"查看使用记录" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
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
- (void)getDetail {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/getdeviceuserecordlist" params:@{@"project_code":self.proCode?self.proCode:@""} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
//        self.currentModel = [ProjectDeatilModel modelWithDictionary:showdata];
        [self setUp];
    }];
}
@end
