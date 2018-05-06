//
//  ItemSearchController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ItemSearchController.h"
#import "ItemCell.h"
#import "ProjectDetailViewController.h"
@interface ItemSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ItemSearchController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.searchBar becomeFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SIZEWIDTH - 100, 35)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入项目名或编号";
    searchBar.barTintColor = COLOR(245, 245, 245, 1);
    searchBar.tintColor = [UIColor blackColor];
    LRViewBorderRadius(searchBar, 17.5, 0, COLOR(245, 245, 245, 1));
    self.searchBar = searchBar;
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, SIZEWIDTH - 100, 35);
    self.tableView.rowHeight = 120;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemCell"];
    [KRBaseTool tableViewAddRefreshFooter:self.tableView withTarget:self refreshingAction:@selector(getMore)];
    [self search];
    // Do any additional setup after loading the view from its nib.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self search];
}

- (void)getMore{
    self.page ++;
    [self searchAction];
}


- (void)search {
//    if ([self cheakIsNull:self.searchBar.text]) {
//        return;
//    }
    self.page = 1;
    [self searchAction];
}




- (void)searchAction {
    [self.view endEditing:YES];
    NSMutableDictionary *params = [@{@"page":@(self.page),@"rows":@20,@"project_type":@"0"} mutableCopy];
    if (self.searchBar.text.length > 0) {
        params[@"project_name"] = self.searchBar.text;
    }
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
    [self.tableView tableViewDisplayWitMsg:@"暂无项目" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
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
        cell.daysText.text = @"项目编号：";
        cell.days.text = [NSString stringWithFormat:@"%@",dic[@"project_code"]];
//        cell.completeSwitch.on = [dic[@"finish_state"] isEqualToString:@"1"] ? YES : NO;
        cell.statuLabel.text = [KRBaseTool intToStau:[dic[@"finish_state"] integerValue]];
        cell.typeView.hidden = YES;
    }
    else{
        cell.days.hidden = YES;
        cell.completeSwitch.hidden = YES;
        cell.daysText.hidden = YES;
        cell.typeView.hidden = NO;
        cell.itemTime.text = [NSString stringWithFormat:@"%@ => %@",dic[@"start_time"],dic[@"finish_time"]];
        cell.proCodeLabel.text = [NSString stringWithFormat:@"项目编号：%@",dic[@"project_code"]];
        cell.proTypeLabel.text = [NSString stringWithFormat:@"项目类型：%@",dic[@"project_type"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
