//
//  DeviceChooseController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/29.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "DeviceChooseController.h"

@interface DeviceChooseController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation DeviceChooseController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.page = 1;
    self.navigationItem.title = @"设备选择";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deviceCell"];
    [self requestData];
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMore)];
    // Do any additional setup after loading the view from its nib.
}

- (void)getMore{
    self.page ++;
    [self requestData];
}


- (void)requestData {
    NSDictionary *params = @{@"device_type":self.deviceType,@"page":@(self.page),@"rows":@100};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"device/query" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            [self.dataArr addObjectsFromArray:showdata[@"device_list"]];
            [self.tableView reloadData];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row][@"device_name"];
    cell.detailTextLabel.text = self.dataArr[indexPath.row][@"device_code"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.block(self.dataArr[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
