//
//  AddDeviceProjectListViewController.h
//  YL_Healthy
//
//  Created by 李金霞 on 2018/5/2.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "BaseViewController.h"
#import "ProjectDeatilModel.h"
@interface AddDeviceProjectListViewController : BaseViewController
@property (nonatomic, strong) ProjectDeatilModel *oldModel;
@property (nonatomic, strong) NSString *proCode;
@property (nonatomic, strong) NSString *vcType;
@end
