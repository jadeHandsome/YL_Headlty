//
//  ProjectDetailViewController.m
//  YL_Healthy
//
//  Created by 曾洪磊 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectDeatilModel.m"
@interface ProjectDetailViewController ()
@property (nonatomic, strong) ProjectDeatilModel *currentModel;
@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}
- (void)setUp {
    if (!self.currentModel) {
        return;
    }
    [self setHead];
    if ([self.currentModel.project_type isEqualToString:@"0"]) {
        //设备项目
        [self setUpdeviceProject];
    } else {
        //事件项目
        [self setUpWorkProject];
    }
}
- (void)setHead {
    
}
#pragma -- mark 布局设备项目
- (void)setUpdeviceProject {
    
}
#pragma -- mark 布局事件项目
- (void)setUpWorkProject {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取项目详情
- (void)getData {
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/getdetail" params:@{@"project_code":self.projectCode?self.projectCode:@""} withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata == nil) {
            return ;
        }
        self.currentModel = [ProjectDeatilModel modelWithDictionary:showdata];
        [self setUp];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
