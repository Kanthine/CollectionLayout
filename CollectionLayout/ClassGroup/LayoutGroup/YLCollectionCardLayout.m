//
//  YLCollectionCardLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionCardLayout.h"

@interface YLCollectionCardLayout()
<UIScrollViewDelegate>
/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrsArray;
@property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;

@end


@implementation YLCollectionCardLayout

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollView ==== %@",scrollView);
}

#pragma mark - helper method

- (BOOL)isVertical{
    return self.scrollDirection == UICollectionViewScrollDirectionVertical;
}

- (CGFloat)offsetForItemAtIndex:(NSInteger)index{
    //calculate relative position

    CGFloat myCurrentPath = self.isVertical ?
    MAX(floor(self.collectionContenOffset.y / (int)self.collectionContenSize.height ), 0):
    MAX(floor(self.collectionContenOffset.x / (int)self.collectionContenSize.width ), 0);

    CGFloat offset = index - myCurrentPath;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (_wrapEnabled){
        if (offset > numberOfItems/2.0){
            offset -= numberOfItems;
        }else if (offset < - numberOfItems / 2.0){
            offset += numberOfItems;
        }
    }
    return offset;
}

- (CGFloat)alphaForItemWithOffset:(CGFloat)offset{
    CGFloat fadeMin = -INFINITY;
    CGFloat fadeMax = INFINITY;
    CGFloat fadeRange = 1.0;
    CGFloat fadeMinAlpha = 0.0;
    CGFloat factor = 0.0;
    if (offset > fadeMax){
        factor = offset - fadeMax;
    }else if (offset < fadeMin){
        factor = fadeMin - offset;
    }
    return 1.0 - MIN(factor, fadeRange) / fadeRange * (1.0 - fadeMinAlpha);
}

- (CATransform3D)transformForItemViewWithOffset:(CGFloat)offset{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    transform = CATransform3DTranslate(transform, 0, 0, 0.0);
    switch (_cardType){
        case YLCollectionCardTypeCoverFlow:{
            CGFloat tilt = 0;
            CGFloat spacing = 0.352455;
            CGFloat clampedOffset = MAX(-1.0, MIN(1.0, offset));
            CGFloat x = (clampedOffset * 0.5 * tilt + offset * spacing) * self.itemSize.width;
            //CGFloat z = fabs(clampedOffset) * - _itemWidth * 0.5;
            CGFloat z = offset * self.itemSize.width * spacing;
            if (z > 0){
                z = - z;
            }
            if (self.isVertical){
                transform = CATransform3DTranslate(transform, 0.0, x, z);
                return CATransform3DRotate(transform, -clampedOffset * M_PI_2 * tilt, -1.0, 0.0, 0.0);
            }else{
                transform = CATransform3DTranslate(transform, x, 0.0, z);
                return CATransform3DRotate(transform, -clampedOffset * M_PI_2 * tilt, 0.0, 1.0, 0.0);
            }
        }
    }
}


#pragma mark - super method

/** 准备更新当前布局
 * @discussion 当 CollectionView 第一次显示其内容时，以及当布局因视图的更改而显式或隐式无效时，下述方法被用来更新当前布局；
 * 在布局更新期间，首先调用该方法，预处理布局操作；
 * @note 该方法的默认实现不执行任何操作；重写该方法，预处理稍后布局所需的任何计算！
 */
- (void)prepareLayout{
    [super prepareLayout];

    //清除之前所有的布局属性
    [self.attrsArray removeAllObjects];

    //遍历分区
    for (int sectionIndex = 0; sectionIndex < self.collectionView.numberOfSections; sectionIndex ++){
        //计算分区头部高度
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
        [self.attrsArray addObject:headerAttrs];

        //添加item属性
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int rowIndex = 0; rowIndex < itemCount; rowIndex ++){
            // 创建位置
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
            // 获取indexPath位置上cell对应的布局属性
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = self.itemSize;
    CGFloat offset = [self offsetForItemAtIndex:indexPath.row];

    attrs.alpha = [self alphaForItemWithOffset:offset];
    attrs.zIndex = offset * self.itemSize.width * 0.25 * 1.1;;

    CGFloat myCurrentPath = self.isVertical ?
    MAX(floor(self.collectionContenOffset.y / (int)self.collectionContenSize.height ), 0):
    MAX(floor(self.collectionContenOffset.x / (int)self.collectionContenSize.width ), 0);

    attrs.zIndex = MAX(indexPath.row - myCurrentPath + 1, 0);


    attrs.center = CGPointMake(self.collectionView.bounds.size.width/2.0 + self.collectionView.contentOffset.x,
                                        self.collectionView.bounds.size.height/2.0 + self.collectionView.contentOffset.y);

    attrs.transform3D = [self transformForItemViewWithOffset:offset];;

    return attrs;
}

///停止滚动的点
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{

    CGRect rect = CGRectMake(0, proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);


//    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];

    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5;
    CGFloat centerY = proposedContentOffset.y + CGRectGetHeight(self.collectionView.bounds) * 0.5;
    __block CGFloat minDelta = MAXFLOAT;

    [self.attrsArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (abs(minDelta) > abs(obj.center.y - centerY)) {
             minDelta = obj.center.y- centerY;
         }
    }];

    CGFloat offsetY =  proposedContentOffset.y + minDelta;
    return CGPointMake(proposedContentOffset.x, offsetY);
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionContenSize{
     return CGSizeMake((int)self.collectionView.bounds.size.width, (int)self.collectionView.bounds.size.height);
}

- (CGPoint)collectionContenOffset{
    return CGPointMake((int)self.collectionView.contentOffset.x, (int)self.collectionView.contentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if (self.attrsArray.count) {
        return self.attrsArray;
    }else{
        return [super layoutAttributesForElementsInRect:rect];
    }
}

#pragma mark - setter and getter

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrsArray{
    if (!_attrsArray){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

@end
