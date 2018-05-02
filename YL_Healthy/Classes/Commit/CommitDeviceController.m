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
#import "DeviceChooseController.h"
@interface CommitDeviceController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *temp;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *viewsArr;

@end

@implementation CommitDeviceController
{
    NSArray *outArray;
    NSArray *shiyanArray;
    NSArray *shijiArray;
    NSArray *hasArray;
}
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
    hasArray = [NSArray array];
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
        NSMutableArray *mut = [hasArray mutableCopy];
        if ([mut containsObject:@"1"]) {
            return ;
        }
        [mut addObject:@"1"];
        hasArray = [mut copy];
        [self setNedDisplay];
//        [self addDeviceWith:type];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"实验设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = ChemicalDevice;
        NSMutableArray *mut = [hasArray mutableCopy];
        if ([mut containsObject:@"2"]) {
            return ;
        }
        [mut addObject:@"2"];
        hasArray = [mut copy];
        [self setNedDisplay];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"化学试剂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        type = ExperimentDevice;
        NSMutableArray *mut = [hasArray mutableCopy];
        if ([mut containsObject:@"3"]) {
            return ;
        }
        [mut addObject:@"3"];
        hasArray = [mut copy];
        [self setNedDisplay];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (void)setNedDisplay {
    for (UIView *sub in self.container.subviews) {
        if (sub == self.container) {
            continue;
        }
        [sub removeFromSuperview];
    }
    UIView *temp = self.container;
    if ([hasArray containsObject:@"1"]) {
        UIView *sub = [self setDeViceWith:outArray type:OutDevice];
        [self.container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == self.container) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(self.container);
           
        }];
        temp = sub;
    }
    if ([hasArray containsObject:@"2"]) {
        UIView *sub = [self setDeViceWith:shiyanArray type:ExperimentDevice];
        [self.container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == self.container) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(self.container);
            
        }];
        temp = sub;
    }
    if ([hasArray containsObject:@"3"]) {
        UIView *sub = [self setDeViceWith:shijiArray type:ChemicalDevice];
        [self.container addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == self.container) {
                make.top.equalTo(temp.mas_top);
            } else {
                make.top.equalTo(temp.mas_bottom);
            }
            make.left.right.equalTo(self.container);
            
        }];
        temp = sub;
    }
    self.temp = temp;
    [self.addBtn removeFromSuperview];
    self.addBtn = nil;
    [self.container addSubview:self.addBtn];
    
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
    
//    UIView *deviceView = [[UIView alloc]init];
//    UILabel *titleLabel = [[UILabel alloc]init];
//    [deviceView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.equalTo(deviceView);
//        make.left.equalTo(deviceView.mas_left).with.offset(15);
//        make.height.equalTo(@45);
//    }];
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    titleLabel.textColor = [UIColor redColor];
//    if (type == OutDevice) {
//        titleLabel.text = @"外出设备";
//    } else if (type == ChemicalDevice) {
//        titleLabel.text = @"实验设备";
//    } else {
//        titleLabel.text = @"化学试剂";
//    }
//    UIView *bottomV = [[UIView alloc]init];
//    [deviceView addSubview:bottomV];
//    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleLabel.mas_bottom);
//        make.height.equalTo(@(45 * array.count));
//        make.left.right.equalTo(deviceView);
//    }]
    
}
- (UIView *)setDeViceWith:(NSArray *)array type:(DeviceType)type{
    UIView *deviceView = [[UIView alloc]init];
    UILabel *titleLabel = [[UILabel alloc]init];
    [deviceView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(deviceView);
        make.left.equalTo(deviceView.mas_left).with.offset(15);
        make.height.equalTo(@45);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor redColor];
    if (type == OutDevice) {
        titleLabel.text = @"外出设备";
    } else if (type == ChemicalDevice) {
        titleLabel.text = @"化学试剂";
    } else {
        titleLabel.text = @"实验设备";
    }
    UIView *bottomV = [[UIView alloc]init];
    [deviceView addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.equalTo(@(45 * (array.count + 1)));
        make.left.right.equalTo(deviceView);
        make.bottom.equalTo(deviceView.mas_bottom);
    }];
    bottomV.backgroundColor = [UIColor whiteColor];
    UIView *temp = titleLabel;
    for (int i= 0; i < array.count; i ++) {
        UIView *sub = [self addCellStylewithtitleText:array[i][@"device_name"] detailText:array[i][@"device_code"]];
        [bottomV addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom);
            make.left.right.equalTo(bottomV);
            make.height.equalTo(@45);
        }];
        UILongPressGestureRecognizer *lo = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deletDevice:)];
        if (type == OutDevice) {
            sub.tag = i + 100;
        } else if (type == ChemicalDevice) {
            sub.tag = i + 1000;
        } else {
            sub.tag = i + 10000;
        }
        
        
        [sub addGestureRecognizer:lo];
        temp = sub;
    }
    UIView *add = [[UIView alloc]init];
    [bottomV addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(temp.mas_bottom);
        make.left.right.equalTo(bottomV);
        make.height.equalTo(@45);
    }];
    UIButton *addBtn = [[UIButton alloc]init];
    [add addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(add);
    }];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.tag = type;
    [addBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addDevice:) forControlEvents:UIControlEventTouchUpInside];
    return deviceView;
}
- (void)addDevice:(UIButton *)sender {
    DeviceChooseController *chooseVC = [DeviceChooseController new];
    
    chooseVC.deviceType =  sender.tag == OutDevice ? @"0" : sender.tag == ChemicalDevice ? @"2" : @"1";
    if ([chooseVC.deviceType isEqualToString:@"0"]) {
        chooseVC.oldArray = outArray;
    } else if ([chooseVC.deviceType isEqualToString:@"1"]) {
         chooseVC.oldArray = shiyanArray;
    } else {
         chooseVC.oldArray = shijiArray;
    }
    __weak typeof(self) weakSelf = self;
    chooseVC.block = ^(NSArray *dic) {
        if (sender.tag == OutDevice) {
            outArray = [dic copy];
        } else if (sender.tag == ChemicalDevice) {
            shijiArray = [dic copy];
        } else {
            shiyanArray = [dic copy];
        }
        [weakSelf setNedDisplay];
        //        self.deviceLabel.text = dic[@"device_name"];
        //        self.deviceCodeLabel.text = dic[@"device_code"];
        //        self.dic[@"device_name"] = dic[@"device_name"];
        //        self.dic[@"device_code"] = dic[@"device_code"];
    };
    [self.navigationController pushViewController:chooseVC animated:YES];
}
- (UIView *)addCellStylewithtitleText:(NSString *)title detailText:(NSString *)detailText {
    UIView *titleView = [[UIView alloc]init];
    UIView *line = [[UIView alloc]init];
    [titleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(titleView);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(222, 222, 222);
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(15);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    UILabel *detailLabel = [[UILabel alloc]init];
    [titleView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView.mas_right).with.offset(-15);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.text = detailText;
    return titleView;
}

- (IBAction)sureAction:(UIButton *)sender {
//    NSMutableArray *list = [NSMutableArray array];
//    if (self.viewsArr.count == 0) {
//        [self showHUDWithText:@"请添加设备"];
//        return;
//    }
//    else{
//        for (DeviceInfoView *view in self.viewsArr) {
//            if (![view cheakIsReady]) {
//                [self showHUDWithText:@"请把信息填写完整"];
//                return;
//            }
//            else{
//                [list addObject:view.dic];
//            }
//        }
//    }
    NSInteger count = outArray.count + shijiArray.count + shiyanArray.count;
    if (count == 0) {
        [self showHUDWithText:@"请添加设备"];
        return;
    }
    NSMutableArray *mut = [NSMutableArray array];
    [mut addObjectsFromArray:outArray];
    [mut addObjectsFromArray:shijiArray];
    [mut addObjectsFromArray:shiyanArray];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.preParams];
    params[@"device_list"] = [mut copy];
    params[@"project_type"] = @"0";
    
    [[KRMainNetTool sharedKRMainNetTool] sendRequstWith:@"project/saveinfo" params:params withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            CommitSuccessController *successVC = [CommitSuccessController new];
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }];
    
}
- (void)deletDevice:(UILongPressGestureRecognizer *)longSender {
    [KRBaseTool showAlert:@"确定删除设备?" with_Controller:self with_titleArr:@[@"确定"] withShowType:UIAlertControllerStyleAlert with_Block:^(int index) {
        NSMutableArray *mut = [NSMutableArray array];
        if (longSender.view.tag >= 100 && longSender.view.tag < 1000) {
            //外出
            for (NSDictionary *dic in outArray) {
                if ([outArray indexOfObject:dic] == (longSender.view.tag - 100)) {
                    continue;
                }
                [mut addObject:dic];
            }
            outArray = [mut copy];
        } else if (longSender.view.tag >= 1000 && longSender.view.tag < 10000) {
            //化学
            for (NSDictionary *dic in shijiArray) {
                if ([shijiArray indexOfObject:dic] == (longSender.view.tag - 1000)) {
                    continue;
                }
                [mut addObject:dic];
            }
            shijiArray = [mut copy];
        } else if (longSender.view.tag >= 10000) {
            //实验
            for (NSDictionary *dic in shiyanArray) {
                if ([shiyanArray indexOfObject:dic] == (longSender.view.tag - 10000)) {
                    continue;
                }
                [mut addObject:dic];
            }
            shiyanArray = [mut copy];
        }
        [self setNedDisplay];
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
