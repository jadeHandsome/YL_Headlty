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
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deviceCell"];
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
    [self.tableView tableViewDisplayWitMsg:@"暂无设备" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"deviceCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.section][@"device_name"];
    cell.detailTextLabel.text = self.dataArr[indexPath.section][@"device_code"];
    for (UIView *sub in cell.subviews) {
        if (sub.tag == 100) {
            [sub removeFromSuperview];
            
        }
        
    }
    UIView *line = [[UIView alloc]init];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(cell);
        make.left.equalTo(cell.mas_left).with.offset(15);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(222, 222, 222);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
