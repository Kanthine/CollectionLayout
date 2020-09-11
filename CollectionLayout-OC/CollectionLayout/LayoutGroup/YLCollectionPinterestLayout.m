//
//  YLCollectionPinterestLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionPinterestLayout.h"

@interface YLCollectionPinterestLayout()

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeightArray;

@end

@implementation YLCollectionPinterestLayout

@synthesize minimumLineSpacing = _minimumLineSpacing;
@synthesize minimumInteritemSpacing = _minimumInteritemSpacing;

- (instancetype)init{
    self = [super init];
    if (self) {
        _colunmCount = 2;
        _minimumLineSpacing = 12;//行间距
        _minimumInteritemSpacing = 12;//列间距
        self.sectionInset = UIEdgeInsetsMake(0, 16, 20, 16);
    }
    return self;
}

#pragma mark - helper method

///列数
- (NSUInteger)colunmCountForSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(columnCountInYLLayout:forSection:)]){
        return [self.delegate columnCountInYLLayout:self forSection:section];
    }else{
        return _colunmCount;
    }
}

/// 列间距
- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(columnSpaceInYLLayout:forSection:)]){
        return [self.delegate columnSpaceInYLLayout:self forSection:section];
    }else{
        return _minimumInteritemSpacing;
    }
}

/// 行间距
- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(rowSpaceInYLLayout:forSection:)]){
        return [self.delegate rowSpaceInYLLayout:self forSection:section];
    }else{
        return _minimumLineSpacing;
    }
}

///cell 宽度
- (CGFloat)itemWidthForSection:(NSInteger)section{
    NSInteger colunmCount = [self colunmCountForSection:section];//一行多少列
    CGFloat widthSuper = CGRectGetWidth(self.collectionView.bounds);//总宽度
    UIEdgeInsets edgeInsets = [self edgeInsetsForSection:section];//内边距
    CGFloat spaceTotal = edgeInsets.left + edgeInsets.right + [self minimumInteritemSpacingForSection:section] * MAX(0, colunmCount - 1);
    return (widthSuper - spaceTotal) / colunmCount * 1.0;
}

/** item的内边距
 */
- (UIEdgeInsets)edgeInsetsForSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInYLLayout:forSection:)]){
        return [self.delegate edgeInsetsInYLLayout:self forSection:section];
    }else{
        return self.sectionInset;
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
    
    if (self.delegate) {
        // 清楚之前计算的所有高度
        [self.columnHeightArray removeAllObjects];
        //清除之前所有的布局属性
        [self.attrsArray removeAllObjects];
        // 设置每一列默认的高度
        for (NSInteger i = 0; i < self.colunmCount ; i ++){
            [self.columnHeightArray addObject:@(self.sectionInset.top)];
        }
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
            
            //计算分区尾部高度
            UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
            [self.attrsArray addObject:footerAttributes];
        }
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"elementKind ===== %@",elementKind);
    if (self.delegate && [self.delegate respondsToSelector:@selector(YLLayout:elementOfKind:referenceSizeInSection:)]) {
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        NSInteger section = indexPath.section;
        CGSize size = [self.delegate YLLayout:self elementOfKind:elementKind referenceSizeInSection:indexPath.section];
        CGFloat maxY = ((NSNumber *)[self.columnHeightArray valueForKeyPath:@"@max.self"]).doubleValue;
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            attri.frame = CGRectMake(0, maxY, size.width, size.height);
            maxY = CGRectGetMaxY(attri.frame) + [self edgeInsetsForSection:section].top;
        }else{
            maxY += [self edgeInsetsForSection:section].bottom;
            attri.frame = CGRectMake(0, maxY, size.width, size.height);
            maxY = CGRectGetMaxY(attri.frame);
        }
        for (int i = 0; i < self.columnHeightArray.count; i ++) {
            self.columnHeightArray[i] = @(maxY);
        }
        return attri;
    }else{
        return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
}

/** 根据 indexPath 获取 cell 对应的布局属性
 * @param indexPath cell 的索引
 * @discussion 必须重写该方法返回 cell 的布局信息。
 * @note 该方法仅为 cell 提供布局信息
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(YLLayout:heightForItemAtIndexPath:itemWidth:)]) {
        CGFloat cellWidth = [self itemWidthForSection:indexPath.section];
        CGFloat cellHeight= [self.delegate YLLayout:self heightForItemAtIndexPath:indexPath itemWidth:cellWidth];
        // 创建布局属性
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

        // 找出最短的那一列
        NSNumber *minValue = [self.columnHeightArray valueForKeyPath:@"@min.self"];
        CGFloat minColumnHeight = minValue.doubleValue;
        NSInteger destColumn = [self.columnHeightArray indexOfObject:minValue];
        UIEdgeInsets edgeInsets = [self edgeInsetsForSection:indexPath.section];
        CGFloat cellX = edgeInsets.left + destColumn * (cellWidth + [self minimumInteritemSpacingForSection:indexPath.section]);
        CGFloat cellY = minColumnHeight;
        if (cellY != edgeInsets.top){
            cellY += [self minimumLineSpacingForSection:indexPath.section];
        }
        //重写frame
        attrs.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        // 更新最短那一列的高度
        self.columnHeightArray[destColumn] = @(CGRectGetMaxY(attrs.frame));
        return attrs;
    }else{
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

/** 获取指定区域中所有视图（cell，supplementaryView，decorationViews）的布局属性
 * @param rect 指定区域，一般是 collectionView.bounds
 * @discussion 重写该方法，返回所有视图的布局属性；不同类型的视图，使用不同的方法创建、管理；
 * @return 默认返回 nil
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if (self.attrsArray.count) {
        return self.attrsArray;
    }else{
        return [super layoutAttributesForElementsInRect:rect];
    }
}

/** 返回collectionView内容的宽度和高度
 * @discussion 必须重写该方法；该值表示所有内容的宽度和高度，而不仅仅是当前可见的内容，collectionView 使用该值配置自己的内容大小，以便滚动。
 * @return 默认返回CGSizeZero
 */
- (CGSize)collectionViewContentSize{
    if (self.columnHeightArray.count) {
        CGFloat adjustedSpace = 0;
        if (@available(iOS 11.0, *)) {
            adjustedSpace = self.collectionView.adjustedContentInset.top + self.collectionView.adjustedContentInset.bottom;
        }
        CGFloat maxValue = [[self.columnHeightArray valueForKeyPath:@"@max.self"] doubleValue];
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), maxValue + adjustedSpace);
    }else{
        return [super collectionViewContentSize];
    }
}

#pragma mark - setter and getter

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrsArray{
    if (!_attrsArray){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray<NSNumber *> *)columnHeightArray{
    if (!_columnHeightArray){
        _columnHeightArray = [NSMutableArray array];
    }
    return _columnHeightArray;
}

@end
