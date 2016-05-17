//
//  PTCommonCell.m
//  MySina
//
//  Created by hpt on 16/5/12.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTCommonCell.h"
#import "PTCommonArrowItem.h"
#import "PTCommonSwitchItem.h"
#import "PTCommonCheckItem.h"
#import "PTCommonLabelItem.h"
#import "PTBadgeView.h"

static NSString *commonCellId = @"CommonCellId";

@interface PTCommonCell ()
/**
 *  右边的提醒数字
 */
@property (nonatomic, strong) PTBadgeView *rightBadgeButton;
/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *rightArrow;
/**
 *  打钩
 */
@property (nonatomic, strong) UIImageView *rightCheck;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *rightSwitch;
/**
 *  标签
 */
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, weak) UITableView *tableView;
@end


@implementation PTCommonCell

#pragma mark - 懒加载右边的view
- (PTBadgeView *)rightBadgeButton
{
    if (!_rightBadgeButton) {
        self.rightBadgeButton = [[PTBadgeView alloc] init];
    }
    return _rightBadgeButton;
}

- (UIImageView *)rightArrow
{
    if (!_rightArrow) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UIImageView *)rightCheck
{
    if (!_rightCheck) {
        self.rightCheck = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_checkmark"]];
    }
    return _rightCheck;
}

- (UISwitch *)rightSwitch
{
    if (!_rightSwitch) {
        self.rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.设置文字的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    PTCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCellId];
    if (!cell) {
        cell = [[PTCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commonCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
//    // 第0行默认y=35
//    PTLog(@"frame===%f", self.y);
}

/** 背景图片有上边圆角和下边圆角，需根据cell数量来设置背景图片 */
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    // 取出背景view
    UIImageView *backgroundView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBackgroundView = (UIImageView *)self.selectedBackgroundView;
    
    // 根据cell显示的具体位置, 来设置背景view显示的图片
    // 获取cell所在组的个数
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    if (totalRows == 1) { // 这组只有1行
        backgroundView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBackgroundView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        backgroundView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBackgroundView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        backgroundView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBackgroundView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间行
        backgroundView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBackgroundView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}

#pragma mark - setter
- (void)setItem:(PTCommonItem *)item
{
    _item = item;
    
    // 1.设置图标
    self.imageView.image = [UIImage imageWithName:item.icon];
    
    // 2.设置标题
    self.textLabel.text = item.title;
    
    // 3.设置子标题
    self.detailTextLabel.text = item.subtitle;
    
    // 4.设置右边显示的控件
    [self setupRightView];
}

- (void)setupRightView
{
    if (self.item.badgeValue) {
        // 显示提醒数字
        self.rightBadgeButton.badgeValue = self.item.badgeValue;
        self.accessoryView = self.rightBadgeButton;
    } else if ([self.item isKindOfClass:[PTCommonArrowItem class]]) {
        // 显示箭头
        self.accessoryView = self.rightArrow;
    } else if ([self.item isKindOfClass:[PTCommonSwitchItem class]]) {
        // 显示开关
        self.accessoryView = self.rightSwitch;
    } else if ([self.item isKindOfClass:[PTCommonCheckItem class]]) {
        // 显示打钩(或者无显示)
        PTCommonCheckItem *checkItem = (PTCommonCheckItem *)self.item;
        self.accessoryView = checkItem.isChecked ? self.rightCheck : nil;
    } else if ([self.item isKindOfClass:[PTCommonLabelItem class]]) {
        // 显示label
        self.accessoryView = self.rightLabel;
        
        // 设置label的文字
        PTCommonLabelItem *labelItem = (PTCommonLabelItem *)self.item;
        self.rightLabel.text = labelItem.text;
        
        // 计算尺寸
        self.rightLabel.size = [self.rightLabel.text sizeWithFont:self.rightLabel.font];
    } else {
        self.accessoryView = nil;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 8;
}

@end
