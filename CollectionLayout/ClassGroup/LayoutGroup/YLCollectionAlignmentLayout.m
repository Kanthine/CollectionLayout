//
//  YLCollectionAlignmentLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionAlignmentLayout.h"

@interface YLCollectionAlignmentLayout ()

@property (nonatomic, assign) CGFloat current_Y;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@end

@implementation YLCollectionAlignmentLayout

#pragma mark - super method

/** 当布局改变时，首先调用方法为更新视图做一些准备工作
 */
- (void)prepareLayout{
    [super prepareLayout];
    NSLog(@"cellAlignmentType ------ %ld",self.cellAlignmentType);
    _current_Y = 0;
    [self.attributesArray removeAllObjects];
    
    //遍历分区
    for (int sectionIndex = 0; sectionIndex < self.collectionView.numberOfSections; sectionIndex ++){
        //计算分区头部高度
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
        [self.attributesArray addObject:headerAttributes];
        
        //添加item属性
        UICollectionViewLayoutAttributes *previousAttributes = nil;
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int rowIndex = 0; rowIndex < itemCount; rowIndex ++){
            // 创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
            // 获取indexPath位置上cell对应的布局属性
            previousAttributes = [self layoutAttributesForItemAtIndexPath:indexPath previousAttributes:previousAttributes];
            [self.attributesArray addObject:previousAttributes];
        }
        
        //计算分区尾部高度
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
        [self.attributesArray addObject:footerAttributes];
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    CGSize size;
    if (self.alignmentDelegate && [self.alignmentDelegate respondsToSelector:@selector(collectionViewElementOfKind:referenceSizeInSection:)]) {
        size = [self.alignmentDelegate collectionViewElementOfKind:elementKind referenceSizeInSection:indexPath.section];
    }else{
        size = [elementKind isEqualToString:UICollectionElementKindSectionHeader] ? self.headerReferenceSize : self.footerReferenceSize;
    }
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attributes.frame = CGRectMake(0, _current_Y, size.width, size.height);
        self.current_Y = CGRectGetMaxY(attributes.frame) + self.sectionInset.top;
    }else{
        self.current_Y += self.sectionInset.bottom;
        attributes.frame = CGRectMake(0, _current_Y, size.width, size.height);
        self.current_Y = CGRectGetMaxY(attributes.frame);
    }
    return attributes;
}

/** 获取指定 UICollectionViewCell 的布局属性
 * @param indexPath 指定位置
 * @param previousAttributes 前一个布局属性，
 * @note 如果 indexPath.row = 0,则 previousAttributes = nil
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath previousAttributes:(UICollectionViewLayoutAttributes *)previousAttributes{
    
    CGSize cellSize = [self.alignmentDelegate collectionViewSizeForItemAtIndexPath:indexPath];//拿到 cell 的 size
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];//创建一个布局属性
    CGPoint startPoint = CGPointMake(self.sectionInset.left, _current_Y);
    if (self.cellAlignmentType == YLCollectionAlignmentLeft){
        if (previousAttributes){
            if (CGRectGetMaxX(previousAttributes.frame) + cellSize.width + self.minimumInteritemSpacing < self.collectionViewContentSize.width){
                startPoint = CGPointMake(CGRectGetMaxX(previousAttributes.frame) + self.minimumInteritemSpacing, previousAttributes.frame.origin.y);
            }else{
                //重启一行
                startPoint = CGPointMake(self.sectionInset.left, CGRectGetMaxY(previousAttributes.frame) + self.minimumLineSpacing);//垂直间距
            }
        }else{
            startPoint = CGPointMake(self.sectionInset.left, _current_Y);
        }
        
    }else if (self.cellAlignmentType == YLCollectionAlignmentRight){//右对齐
        if (previousAttributes){
            if (cellSize.width + self.minimumInteritemSpacing < previousAttributes.frame.origin.x){
                startPoint = CGPointMake(previousAttributes.frame.origin.x - self.minimumInteritemSpacing - cellSize.width, previousAttributes.frame.origin.y);
            }else{
                //重启一行
                startPoint = CGPointMake(self.collectionViewContentSize.width - cellSize.width - self.sectionInset.right, CGRectGetMaxY(previousAttributes.frame) + self.minimumLineSpacing);
            }
        }else{
            startPoint = CGPointMake(self.collectionViewContentSize.width - cellSize.width - self.sectionInset.right, _current_Y);
        }
    }
    
    layoutAttributes.frame = CGRectMake(startPoint.x, startPoint.y, cellSize.width, cellSize.height);
    
    self.current_Y = MAX(CGRectGetMaxY(layoutAttributes.frame), _current_Y);
    return layoutAttributes;
}

/** 获取指定区域中所有视图（cell，supplementaryView，decorationViews）的布局属性
 * @param rect 指定区域
 * @discussion 重写该方法，返回所有视图的布局属性；不同类型的视图，使用不同的方法创建、管理；
 * @return 默认返回 nil
 * @note 针对固定布局，如瀑布流等可以使用数组缓存 LayoutAttributes ，不需要再次加载创建
 *       但是对于 cell 做的特效等场景，如卡片动画，需要实时的 LayoutAttributes，因此不能缓存，只能需要时创建！
*/
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}

- (CGSize)collectionViewContentSize{
    CGFloat adjustedSpace = 0;
    if (@available(iOS 11.0, *)) {
        adjustedSpace = self.collectionView.adjustedContentInset.top + self.collectionView.adjustedContentInset.bottom;
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), _current_Y + adjustedSpace);
}

#pragma mark - setter and getter

- (void)setCellAlignmentType:(YLCollectionAlignment)cellAlignmentType{
    if (_cellAlignmentType != cellAlignmentType) {
        _cellAlignmentType = cellAlignmentType;
        [self invalidateLayout];
        NSLog(@"cellAlignmentType ===== %ld",_cellAlignmentType);
    }
}

- (void)setCurrent_Y:(CGFloat)current_Y{
    _current_Y = current_Y;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributesArray{
    if (!_attributesArray){
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end
