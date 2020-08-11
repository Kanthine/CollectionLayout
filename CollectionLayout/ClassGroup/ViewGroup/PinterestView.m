//
//  PinterestView.m
//  PinterestDemo
//
//  Created by 苏沫离 on 2020/8/10.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "PinterestView.h"

@interface PinterestCollectionCell ()
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *nameLable;
@end
@implementation PinterestCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.nameLable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    self.imageView.frame = CGRectMake(0, 0, _model.imageSize.width, _model.imageSize.height);
    self.nameLable.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10, contentWidth, _model.detaileHeight);
}

#pragma mark - public method

- (void)setModel:(DataModel *)model{
    _model = model;
    self.imageView.image = model.image;    
    self.nameLable.text = model.detaile;
}

#pragma mark - getter and setter

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 42, 42)];
        _imageView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)nameLable{
    if (_nameLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _nameLable = label;
    }
    return _nameLable;
}

@end
