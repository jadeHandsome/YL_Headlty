//
//  NewAddWorkDetailViewController.h
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/6/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "BaseViewController.h"
#import "ProjectDeatilModel.h"
@interface NewAddWorkDetailViewController : BaseViewController
@property (nonatomic, strong) ProjectDeatilModel *oldModel;
@property (nonatomic, strong) NSString *proCode;
@property (nonatomic, strong) NSString *vcType;
@end
