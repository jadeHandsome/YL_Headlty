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
@property (nonatomic, strong) NSString *real_name;//名字
@property (nonatomic, strong) NSString *nick_name;//昵称
@property (nonatomic, strong) NSString *sex;//性别   1女 2男
@property (nonatomic, strong) NSString *birthday;//生日

@end
