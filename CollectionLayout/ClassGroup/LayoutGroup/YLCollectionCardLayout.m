//
//  YLCollectionCardLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionCardLayout.h"


@implementation YLCollectionCardLayout

- (void)setItemSize:(CGSize)itemSize{
    [super setItemSize:itemSize];
    
    //CoverFlow 效果，通过设置 minimumLineSpacing 间距，调节卡片之间的紧凑度
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.minimumLineSpacing = - itemSize.height * 0.8;
    }else{
        self.minimumLineSpacing = - itemSize.width * 0.8;
    }
}

///询问布局对象 滑动 CollectionView 时 是否需要更新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


/// 因为item大小随范围变化而实时变化，在-prepareLayout方法里计算缓存已经无用；
/// 需要在下述方法里亲自计算来返回布局对象数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> *attributesArray = [super layoutAttributesForElementsInRect:rect];
    CGPoint contentOffset = self.collectionView.contentOffset;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {//垂直滚动
        CGFloat height = CGRectGetHeight(self.collectionView.bounds);
        CGFloat centerY = contentOffset.y + height * 0.5;

        // 每个点根据距离中心点距离进行缩放
        [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull attri, NSUInteger idx, BOOL * _Nonnull stop) {
            // cell的中心点，和collectionView最中心点的x值的间距
            CGFloat delta = attri.center.y - centerY;
            CGFloat scale = MAX(1 - (fabs(delta) / height), 0);
            attri.alpha = scale;
            attri.zIndex = delta <= 0 ? (100 + scale * 100) : (scale * 100);
            attri.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);;
        }];
    }else{//水平滚动
        CGFloat width = CGRectGetWidth(self.collectionView.bounds);
        CGFloat centerX = contentOffset.x + width * 0.5;
        
        // 每个点根据距离中心点距离进行缩放
        [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull attri, NSUInteger idx, BOOL * _Nonnull stop) {
            // cell的中心点，和collectionView最中心点的x值的间距
            CGFloat delta = attri.center.x - centerX;
            CGFloat scale = MAX(1 - (fabs(delta) / width), 0);
            attri.alpha = scale;
            attri.zIndex = delta <= 0 ? (100 + scale * 100) : (scale * 100);
            attri.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);;
        }];
    }
    
    
    return attributesArray;
}

/// 重写滚动时停下的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat height = CGRectGetHeight(self.collectionView.bounds);
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGRect rect = CGRectMake(0, proposedContentOffset.y, width, height);
        NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
        
        CGFloat centerY = proposedContentOffset.y + height * 0.5;
        // 计算collectionView最中心点的x值
        __block CGFloat minDelta = MAXFLOAT;
        [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (fabs(minDelta) > fabs(obj.center.y - centerY)) {
                 minDelta = obj.center.y - centerY;
             }
        }];
        
        CGFloat offsetY =  proposedContentOffset.y + minDelta;
        return CGPointMake(proposedContentOffset.x, offsetY);
    }else{
        CGRect rect = CGRectMake(proposedContentOffset.x, 0, width, height);
        NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];

        // 计算collectionView最中心点的x值
        CGFloat centerX = proposedContentOffset.x + width * 0.5;
        //需要移动的最小距离
        __block CGFloat minDelta = MAXFLOAT;
        [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (fabs(minDelta) > fabs(obj.center.x - centerX)) {
                 minDelta = obj.center.x - centerX;
             }
        }];
        CGFloat offsetX =  proposedContentOffset.x + minDelta;
        return CGPointMake(offsetX, proposedContentOffset.y);
    }
}

@end
