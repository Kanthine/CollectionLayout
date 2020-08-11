//
//  YLCollectionAlignmentLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionAlignmentLayout.h"

@interface YLCollectionAlignmentLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@end

@implementation YLCollectionAlignmentLayout

#pragma mark - super method

///使当前布局失效并触发布局更新
//- (void)invalidateLayout{
//    [super invalidateLayout];
//
//    [self prepareLayout];
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    return YES;
//}
//
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes{
//    return YES;
//}

/** 当布局改变时，首先调用方法为更新视图做一些准备工作
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    NSLog(@"cellAlignmentType ------ %ld",self.cellAlignmentType);
    
    if (self.cellAlignmentType == YLCollectionAlignmentDefault) {
        return;
    }
    
    [self.attributesArray removeAllObjects];
    
    //遍历分区
    for (int sectionIndex = 0; sectionIndex < self.collectionView.numberOfSections; sectionIndex ++){
        //添加item属性
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int rowIndex = 0; rowIndex < itemCount; rowIndex ++){
            // 创建位置
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
            // 获取indexPath位置上cell对应的布局属性
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesArray addObject:attrs];
        }
    }
}

/** 获取指定视图的布局属性
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if (self.cellAlignmentType == YLCollectionAlignmentDefault) {
        return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
    UICollectionViewLayoutAttributes *headerAttrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    headerAttrs.frame = CGRectZero;
    return headerAttrs;
}

/** 获取指定 UICollectionViewCell 的布局属性
 * @param indexPath 指定位置
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellAlignmentType == YLCollectionAlignmentDefault) {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];//创建一个布局属性
    CGSize cellSize = [self.alignmentDelegate collectionViewSizeForItemAtIndexPath:indexPath];//拿到 cell 的 size
    CGPoint startPoint = CGPointZero;
    if (self.cellAlignmentType == YLCollectionAlignmentLeft){
        if (indexPath.row > 0){
            
            UICollectionViewLayoutAttributes *prevLayoutAttributes;//前一个布局
            if (self.attributesArray.count > indexPath.row - 1) {
                prevLayoutAttributes = self.attributesArray[indexPath.row -1];
            }else{
                prevLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
            }
            
            if (CGRectGetMaxX(prevLayoutAttributes.frame) + cellSize.width + self.minimumInteritemSpacing < self.collectionViewContentSize.width){
                startPoint = CGPointMake(CGRectGetMaxX(prevLayoutAttributes.frame) + self.minimumInteritemSpacing, prevLayoutAttributes.frame.origin.y);
            }else{
                //重启一行
                startPoint = CGPointMake(0, CGRectGetMaxY(prevLayoutAttributes.frame) + self.minimumLineSpacing);//垂直间距
            }
        }else{
            startPoint = CGPointMake(0, 0);
        }
        
    }else if (self.cellAlignmentType == YLCollectionAlignmentRight){//右对齐
        if (indexPath.row > 0){
            
            UICollectionViewLayoutAttributes *prevLayoutAttributes;//前一个布局
            if (self.attributesArray.count > indexPath.row - 1) {
                prevLayoutAttributes = self.attributesArray[indexPath.row -1];
            }else{
                prevLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
            }
            
            if (cellSize.width + self.minimumInteritemSpacing < prevLayoutAttributes.frame.origin.x){
                startPoint = CGPointMake(prevLayoutAttributes.frame.origin.x - self.minimumInteritemSpacing - cellSize.width, prevLayoutAttributes.frame.origin.y);
            }else{
                //重启一行
                startPoint = CGPointMake(self.collectionViewContentSize.width - cellSize.width, CGRectGetMaxY(prevLayoutAttributes.frame) + self.minimumLineSpacing);
            }
        }else{
            startPoint = CGPointMake(self.collectionViewContentSize.width - cellSize.width, 0);
        }
    }
    layoutAttributes.frame = CGRectMake(startPoint.x, startPoint.y, cellSize.width, cellSize.height);
    return layoutAttributes;
}

/** 返回指定区域中所有单元格和视图的布局属性。
 * @param rect 指定区域
 * @return 默认返回 nil
 * @note 必须重写此方法，返回视图指定区域的所有布局信息。
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if (self.cellAlignmentType == YLCollectionAlignmentDefault) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    return self.attributesArray;
}

#pragma mark - setter and getter

- (void)setCellAlignmentType:(YLCollectionAlignment)cellAlignmentType{
    if (_cellAlignmentType != cellAlignmentType) {
        _cellAlignmentType = cellAlignmentType;
        [self invalidateLayout];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            NSLog(@"cellAlignmentType ==4=== %ld",self->_cellAlignmentType);
        });
        NSLog(@"cellAlignmentType ==2=== %ld",_cellAlignmentType);
    }
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributesArray{
    if (!_attributesArray){
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end
