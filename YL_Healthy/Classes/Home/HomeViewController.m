//
//  HomeViewController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/14.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "HomeViewController.h"
#import "CommitItemController.h"
#import "SettingController.h"
#import "ItemSearchController.h"
#import "ItemManagerController.h"
#import "AddManagerProViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优量健康";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commitInfo:(UIButton *)sender {
    CommitItemController *commitVC = [CommitItemController new];
    [self.navigationController pushViewController:commitVC animated:YES];
}
- (IBAction)itemSearch:(UIButton *)sender {
    ItemSearchController *searchVC = [ItemSearchController new];
    searchVC.type = @"";
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (IBAction)commitItem:(UIButton *)sender {
    AddManagerProViewController *addManager = [AddManagerProViewController new];
    [self.navigationController pushViewController:addManager animated:YES];
}

- (IBAction)itemManager:(UIButton *)sender {
    ItemManagerController *managerVC = [ItemManagerController new];
    
    [self.navigationController pushViewController:managerVC animated:YES];
}
- (void)setting{
    SettingController *settingVC = [SettingController new];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
