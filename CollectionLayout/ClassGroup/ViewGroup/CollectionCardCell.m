//
//  CollectionCardCell.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "CollectionCardCell.h"

@interface CollectionCardCell ()
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *nameLable;
@end
@implementation CollectionCardCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.clipsToBounds = YES;
        self.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.nameLable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    self.imageView.frame = CGRectMake(0, 0, contentWidth, contentWidth);
    self.nameLable.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), contentWidth, 40.0);
}

#pragma mark - public method

- (void)setModel:(DataModel *)model{
    _model = model;
    self.imageView.image = model.image;
    self.nameLable.text = [NSString stringWithFormat:@"%@-%ld",model.title,model.index];
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
        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardItemBack"]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _nameLable = label;
    }
    return _nameLable;
}

@end
