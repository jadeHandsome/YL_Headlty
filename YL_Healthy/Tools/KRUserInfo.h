//
//  KRUserInfo.h
//  Dntrench
//
//  Created by kupurui on 16/10/18.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface KRUserInfo : NSObject
singleton_interface(KRUserInfo)
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *username;//名字
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic, strong) NSString *phone;//电话
@property (nonatomic, strong) NSString *email;//邮箱
@property (nonatomic, strong) NSString *alias;//昵称
@property (nonatomic, strong) NSString *payPoints;//积分商城积分
@property (nonatomic, strong) NSNumber *sex;//性别
@property (nonatomic, strong) NSString *birthday;//生日
@property (nonatomic, strong) NSNumber *userMoney;//余额
@property (nonatomic, strong) NSString *rankPoints;//会员等级积分
@property (nonatomic, strong) NSString *regTime;//注册时间
@property (nonatomic, strong) NSString *lastLogin;//最后登录时间
@property (nonatomic, strong) NSString *lastIp;//最后登录IP
@property (nonatomic, strong) NSString *parentId;//推荐人ID
@property (nonatomic, strong) NSNumber *isRealname;//是否实名
@property (nonatomic, assign) BOOL isValidated;//用户状态
@property (nonatomic, strong) NSString *created;//创建时间
@property (nonatomic, strong) NSString *updated;//更新时间
@property (nonatomic, strong) NSString *deviceId;//用户城市
@property (nonatomic, strong) NSNumber *rentState;//租租状态
@property (nonatomic, strong) NSString *headImgurl;//用户头像
@property (nonatomic, assign) BOOL isPass;//审核状态

@end
