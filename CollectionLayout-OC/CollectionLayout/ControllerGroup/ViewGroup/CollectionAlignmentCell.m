//
//  CollectionAlignmentCell.m
//  PinterestDemo
//
//  Created by 苏沫离 on 2018/9/8.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "CollectionAlignmentCell.h"

@implementation CollectionAlignmentCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self){
        _backLayer = [CALayer layer];
        _backLayer.backgroundColor = [UIColor colorWithRed:15/255.0 green:136/255.0 blue:235/255.0 alpha:0.1].CGColor;
        [self.contentView.layer addSublayer:_backLayer];
        [self.contentView addSubview:self.itemLable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _itemLable.frame = self.contentView.bounds;
    _backLayer.frame = self.contentView.bounds;
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _backLayer.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_backLayer.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)].CGPath;
    _backLayer.mask = maskLayer;
}

#pragma mark - setter and getter

- (UILabel *)itemLable{
    if (_itemLable == nil){
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor colorWithRed:0/255.0 green:83/255.0 blue:150/255.0 alpha:1];
        _itemLable = lable;
    }
    return _itemLable;
}

@end
