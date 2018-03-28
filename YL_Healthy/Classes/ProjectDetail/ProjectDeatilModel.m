//
//  ProjectDeatilModel.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ProjectDeatilModel.h"

@implementation ProjectDeatilModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"device_list":[ProjectDeviceModel class],
             @"work_list":[ProjectIncidentModel class]
             };
}
@end
