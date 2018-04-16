//
//  ItemCell.m
//  YL_Healthy
//
//  Created by 周春仕 on 2018/3/28.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    LRViewBorderRadius(self.container, 10, 1, [UIColor lightGrayColor]);
    // Initialization code
}
- (IBAction)changeState:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"完成状态" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"已采样" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.block(@"1");
        [sender setTitle:@"已采样" forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"已完成实验" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.block(@"2");
        [sender setTitle:@"已完成实验" forState:UIControlStateNormal];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"已完成报告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.block(@"3");
        [sender setTitle:@"已完成报告" forState:UIControlStateNormal];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"已存档" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.block(@"4");
        [sender setTitle:@"已存档" forState:UIControlStateNormal];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self.vc presentViewController:alert animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
