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
    LRViewBorderRadius(self.container, 10, 1, [UIColor groupTableViewBackgroundColor]);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
