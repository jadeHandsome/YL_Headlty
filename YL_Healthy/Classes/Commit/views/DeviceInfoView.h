//
//  DeviceInfoView.h
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/15.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DeviceType) {
    OutDevice = 0,
    ChemicalDevice,
    ExperimentDevice,
};
@interface DeviceInfoView : UIView
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) NSMutableDictionary *dic;
- (instancetype)initWith:(DeviceType)type;
- (BOOL)cheakIsReady;
@end
