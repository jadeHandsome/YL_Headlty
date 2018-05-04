//
//  ProjectDeviceModel.h
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectDeviceModel : NSObject
@property (nonatomic, strong) NSString *device_code;//设备编号
@property (nonatomic, strong) NSString *device_name;//设备名称
@property (nonatomic, strong) NSString *device_type;//设备类型
@property (nonatomic, strong) NSString *use_temperature;//使用温度
@property (nonatomic, strong) NSString *use_humidity;//使用湿度
@property (nonatomic, strong) NSString *use_pressure;//使用气压
@property (nonatomic, strong) NSString *use_wind_speed;//使用风速
@property (nonatomic, strong) NSString *use_amount;//使用量
@property (nonatomic, strong) NSString *use_name;//使用人
@property (nonatomic, strong) NSString *check_parameter;//检测参数
@property (nonatomic, strong) NSString *ID;//id
@end
