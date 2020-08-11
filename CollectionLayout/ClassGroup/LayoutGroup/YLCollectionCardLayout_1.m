//
//  YLCollectionCardLayout_1.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionCardLayout_1.h"

@implementation YLCollectionCardLayout_1

#pragma mark - super method

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat height = CGRectGetHeight(self.collectionView.bounds);
        CGFloat centerY = self.collectionView.contentOffset.y + height * 0.5;

        [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // cell的中心点，和collectionView最中心点的x值的间距
            CGFloat delta = fabs(obj.center.y - centerY);
            CGFloat scale = 1 - (delta /height);
            // 设置缩放比例
            obj.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }else{
        CGFloat width = CGRectGetWidth(self.collectionView.bounds);
        CGFloat centerX = self.collectionView.contentOffset.x + width * 0.5;
        
        [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // cell的中心点，和collectionView最中心点的x值的间距
            CGFloat delta = fabs(obj.center.x - centerX);
            CGFloat scale = 1 - (delta /width);
            // 设置缩放比例
            obj.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }
    
    
    return attributes;
}

///停止滚动的点
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

        CGFloat centerX = proposedContentOffset.x + width * 0.5;
        // 计算collectionView最中心点的x值
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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
