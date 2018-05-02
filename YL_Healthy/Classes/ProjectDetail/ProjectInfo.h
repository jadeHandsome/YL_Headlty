//
//  ProjectInfo.h
//  YL_Healthy
//
//  Created by 李金霞 on 2018/5/1.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDeviceModel.h"
@interface ProjectInfo : NSObject
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSArray<ProjectDeviceModel *> *devicelist;

@end
