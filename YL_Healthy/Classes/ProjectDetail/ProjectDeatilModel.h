//
//  ProjectDeatilModel.h
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDeviceModel.h"
#import "ProjectIncidentModel.h"
@interface ProjectDeatilModel : NSObject
@property (nonatomic, strong) NSString *project_name;//项目名字
@property (nonatomic, strong) NSString *project_code;//项目编号
@property (nonatomic, strong) NSString *project_type;//项目类型
@property (nonatomic, strong) NSString *company_name;//公司名称
@property (nonatomic, strong) NSString *finish_days;//完成天数
@property (nonatomic, strong) NSString *finish_state;//完成状态
@property (nonatomic, strong) NSString *finish_time;//完成时间
@property (nonatomic, strong) NSString *start_time;//开始时间
@property (nonatomic, strong) NSArray<ProjectDeviceModel *> *device_list;//设备列表
@property (nonatomic, strong) NSArray<ProjectIncidentModel *> *work_list;//事件列表


@end
