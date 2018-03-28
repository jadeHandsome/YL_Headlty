//
//  CommitDeviceController.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/15.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "CommitDeviceController.h"
#import "DeviceInfoView.h"
#import "CommitSuccessController.h"
@interface CommitDeviceController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *temp;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *viewsArr;
@end

@implementation CommitDeviceController

- (NSMutableArray *)viewsArr{
    if (!_viewsArr) {
        _viewsArr = [NSMutableArray array];
    }
    return _viewsArr;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn setTitle:@"添加设备" forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"添加1"] forState:UIControlStateNormal];
        [addBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
        LRViewBorderRadius(addBtn, 22.5, 1, ThemeColor);
        _addBtn = addBtn;
        [self.container addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.temp.mas_bottom).offset(10);
            make.left.equalTo(self.container).offset(15);
            make.right.equalTo(self.container).offset(-15);
            make.bottom.equalTo(self.container).offset(-40);
            make.height.mas_offset(45);
        }];
    }
    return _addBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popOut];
    self.navigationItem.title = @"设备信息";
    LRViewBorderRadius(self.sureBtn, 22.5, 0, ThemeColor);
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    UIView *container = [[UIView alloc] init];
    self.container = container;
    [self.scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    UIView *tempView = [[UIView alloc] init];
    [container addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(container);
        make.height.mas_equalTo(0);
    }];
    self.temp = tempView;
    [container addSubview:self.addBtn];
}

- (void)addDevice{
    __block DeviceType type;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备类型" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"外出设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = OutDevice;
        [self addDeviceWith:type];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"化学试剂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = ChemicalDevice;
        [self addDeviceWith:type];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"实验设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = ExperimentDevice;
        [self addDeviceWith:type];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)addDeviceWith:(DeviceType)type{
    DeviceInfoView *infoView = [[DeviceInfoView alloc] initWith:type];
    infoView.vc = self;
    [self.container addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.temp.mas_bottom);
    }];
    [self.viewsArr addObject:infoView];
    self.temp = infoView;
    [self.addBtn removeFromSuperview];
    self.addBtn = nil;
    [self.container addSubview:self.addBtn];
}



- (IBAction)sureAction:(UIButton *)sender {
    NSMutableArray *list = [NSMutableArray array];
    if (self.viewsArr.count == 0) {
        [self showHUDWithText:@"请添加设备"];
        return;
    }
    else{
        for (DeviceInfoView *view in self.viewsArr) {
            if (![view cheakIsReady]) {
                [self showHUDWithText:@"请把信息填写完整"];
                return;
            }
            else{
                [list addObject:view.dic];
            }
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.preParams];
    params[@"device_list"] = list;
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/saveinfo" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (showdata) {
            CommitSuccessController *successVC = [CommitSuccessController new];
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }];
    
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
