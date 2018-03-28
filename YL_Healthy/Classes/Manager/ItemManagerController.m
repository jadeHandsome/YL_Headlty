//
//  ItemManagerController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/27.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ItemManagerController.h"
#import "ItemCell.h"
@interface ItemManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ItemManagerController
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"项目管理";
    [self popOut];
    [self search];
    self.tableView.rowHeight = 120;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemCell"];
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMore)];
    // Do any additional setup after loading the view from its nib.
}

- (void)getMore{
    self.page ++;
    [self searchAction];
}

- (void)search {
    self.page = 1;
    [self searchAction];
}


- (void)searchAction {
    NSDictionary *params = @{@"project_name":@"",@"page":@(self.page),@"rows":@20};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/query" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            if (self.page == 1) {
                self.dataArr = [showdata[@"project_list"] mutableCopy];
            }
            else{
                [self.dataArr addObjectsFromArray:showdata];
            }
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
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.itemName.text = dic[@"project_name"];
    cell.itemTime.text = dic[@"start_time"];
    if ([dic[@"project_type"] isEqualToString:@"0"]) {
        cell.days.hidden = NO;
        cell.completeSwitch.hidden = NO;
        cell.daysText.hidden = NO;
        cell.days.text = [NSString stringWithFormat:@"%ld",[dic[@"finish_days"] integerValue]];
        cell.completeSwitch.on = [dic[@"finish_state"] isEqualToString:@"1"] ? YES : NO;
    }
    else{
        cell.days.hidden = YES;
        cell.completeSwitch.hidden = YES;
        cell.daysText.hidden = YES;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)addItem:(UIButton *)sender {
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
