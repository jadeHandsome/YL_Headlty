//
//  ItemManagerController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/27.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ItemManagerController.h"
#import "ItemCell.h"
#import "ProjectDetailViewController.h"
@interface ItemManagerController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ItemManagerController
{
    NSString *tempProjectName;
    NSString *tempProjectNumber;
}
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
    [self search];
    self.tableView.rowHeight = 120;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemCell"];
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMore)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProject)];
    // Do any additional setup after loading the view from its nib.
}
- (void)addProject {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加项目" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (self.recordName && ![self.recordName isEqualToString:@""]) {
//            self.saveType = TypeMP3;
//            NSDate *localDate = [NSDate date]; //获取当前时间
//            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
//            self.recordName = [AudioTool getFilePathWithDirectoryName:@"Result" FileName:[NSString stringWithFormat:@"%@%@.m4a",timeSp,self.recordName]];
//            [self save];
//        }
//        else{
//            [self saveAction:nil];
//        }
        NSLog(@"\n项目名字:%@\n项目编号:%@",tempProjectName,tempProjectNumber);
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        tempProjectName = nil;
        tempProjectNumber = nil;
    }];
    
    [alert addAction:actionDone];
    [alert addAction:actionCancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入项目名字";
        textField.delegate = self;
        textField.tag = 100;
        [textField addTarget:self action:@selector(textChange:)forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入项目编号";
        textField.delegate = self;
        textField.tag = 101;
        [textField addTarget:self action:@selector(textChange:)forControlEvents:UIControlEventEditingChanged];
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (void)textChange:(UITextField *)input {
    if (input.tag == 101) {
        tempProjectNumber = input.text;
    } else if (input.tag == 100) {
        tempProjectName = input.text;
    }
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
    NSDictionary *params = @{@"page":@(self.page),@"rows":@20,@"project_name":@""};
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/query" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            if (self.page == 1) {
                self.dataArr = [showdata[@"project_list"] mutableCopy];
            }
            else{
                if ([showdata[@"project_list"] count]) {
                    [self.dataArr addObjectsFromArray:showdata[@"project_list"]];
                }
            }
            [self.tableView reloadData];
            if (self.page >= [showdata[@"page_total"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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
    cell.block = ^(BOOL state) {
        NSDictionary *params = @{@"project_code":dic[@"project_code"],@"finish_state":state?@"1":@"0"};
        [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/updatefinishstate" params:params withModel:nil complateHandle:^(id showdata, NSString *error) {
            if (!error) {
                [self showHUDWithText:@"更改状态成功"];
            }
        }];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectDetailViewController *detailVC = [ProjectDetailViewController new];
    detailVC.projectCode = self.dataArr[indexPath.row][@"project_code"];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
