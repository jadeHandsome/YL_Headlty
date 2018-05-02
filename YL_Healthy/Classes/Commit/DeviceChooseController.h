//
//  DeviceChooseController.h
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/29.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SelectBlock)(NSArray *);
@interface DeviceChooseController : BaseViewController
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) SelectBlock block;
@property (nonatomic, strong) NSArray *oldArray;
@end
