//
//  CollectionSectionHeaderView.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "CollectionSectionHeaderView.h"

@interface CollectionSectionHeaderView ()
@property (nonatomic ,strong) UIImageView *imageView;
@end
@implementation CollectionSectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dub_header_back"]];
        _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 172 / 375.0 * CGRectGetWidth(UIScreen.mainScreen.bounds));
        [self addSubview:_imageView];
    }
    return self;
}

@end




