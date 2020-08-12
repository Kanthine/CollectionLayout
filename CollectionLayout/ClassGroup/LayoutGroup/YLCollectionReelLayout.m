//
//  YLCollectionReelLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/12.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionReelLayout.h"

@implementation YLCollectionReelLayoutAttributes

/// 需要实现这个方法，collectionView 实时布局时，会copy参数，确保自身的参数被copy
- (id)copyWithZone:(NSZone *)zone{
    YLCollectionReelLayoutAttributes *copy = [super copyWithZone:zone];
    if (copy) {
        copy.anchorPoint = self.anchorPoint;
    }
    return copy;
}

@end

@interface YLCollectionReelLayout()

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray<YLCollectionReelLayoutAttributes *> *attrsArray;

@end

@implementation YLCollectionReelLayout

+ (Class)layoutAttributesClass{
    return YLCollectionReelLayoutAttributes.class;
}

- (void)prepareLayout{
    [super prepareLayout];
    // 整体布局是将每个item设置在屏幕中心，然后旋转 anglePerItem * i 度
    CGFloat centerX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.bounds) / 2.0;
    // 锚点的y值，多增加了raidus的值
    CGFloat anchorPointY = ((self.itemSize.height / 2.0) + self.radius) / self.itemSize.height;
    
    /// 不要计算所有的item，只计算在屏幕中的item,theta最大倾斜
    CGFloat theta = atan2(CGRectGetWidth(self.collectionView.bounds) / 2, self.radius + (self.itemSize.height / 2.0) - CGRectGetHeight(self.collectionView.bounds) / 2.0);
    NSInteger startIndex = 0;
    NSInteger endIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    // 开始位置
    if (self.angle < -theta) {
        startIndex = floor((-theta - self.angle) / self.anglePerItem);
    }
    // 结束为止
    endIndex = MIN(endIndex, ceil((theta - self.angle) / self.anglePerItem));
    if (endIndex < startIndex) {
        endIndex = 0;
        startIndex = 0;
    }
    
    [self.attrsArray removeAllObjects];
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        YLCollectionReelLayoutAttributes *attribute = [YLCollectionReelLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        attribute.size = self.itemSize;
        // 设置居中
        attribute.center = CGPointMake(centerX, CGRectGetMidY(self.collectionView.bounds));
        // 设置偏移角度
        attribute.transform = CGAffineTransformMakeRotation(self.angle + self.anglePerItem * i);
        // 锚点，我们自定义的属性
        attribute.anchorPoint = CGPointMake(0.5, anchorPointY);
        [self.attrsArray addObject:attribute];
    }
    
}
/// 重写滚动时停下的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    // 每单位偏移量对应的偏移角度
    CGFloat factor = -self.angleAtextreme / (self.collectionViewContentSize.width - CGRectGetWidth(self.collectionView.bounds));
    CGFloat proposedAngle = proposedContentOffset.x * factor;
    
    // 大约偏移了多少个
    CGFloat ratio = proposedAngle / self.anglePerItem;
    
    CGFloat multiplier;
    
    // 往左滑动,让multiplier成为整个
    if (velocity.x > 0) {
        multiplier = ceil(ratio);
    } else if (velocity.x < 0) {  // 往右滑动
        multiplier = floor(ratio);
    } else {
        multiplier = round(ratio);
    }
    return CGPointMake(multiplier * self.anglePerItem / factor, proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

#pragma mark - setter and getter

/// 每两个item 之间的角度，任意值
- (CGFloat)anglePerItem{
    return atan(self.itemSize.width / self.radius);// atan反正切
}

/// 当collectionView滑到极端时，第 0个item的角度 （第0个开始是 0 度，  当滑到极端时， 最后一个是 0 度）
- (CGFloat)angleAtextreme{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    return itemCount > 0 ? -(itemCount - 1) * self.anglePerItem : 0;
}

/// 滑动时，第0个item的角度
- (CGFloat)angle{
    return self.angleAtextreme * self.collectionView.contentOffset.x / (self.collectionViewContentSize.width - CGRectGetWidth(self.collectionView.bounds));
}

- (CGSize)collectionViewContentSize{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(itemCount * self.itemSize.width, CGRectGetHeight(self.collectionView.bounds));
}

- (void)setRadius:(CGFloat)radius{
    if (_radius != radius) {
        _radius = radius;
        [self invalidateLayout];
    }
}

- (NSMutableArray<YLCollectionReelLayoutAttributes *> *)attrsArray{
    if (!_attrsArray){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}


@end
