//
//  YLCollectionPinterestLayout.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

@objc protocol YLCollectionPinterestLayoutDelegate{
    /** 每个item的高度
     * @param itemWidth 宽度确定，高度自适应内容
     */
    func YLLayoutHeightForItemAtIndexPath(layout : YLCollectionPinterestLayout, indexPath : NSIndexPath ,itemWidth : CGFloat) -> CGFloat
    
    ///SectionHeader/SectionFooter 的大小
    @objc optional func YLLayoutReferenceSizeInSection(layout : YLCollectionPinterestLayout,elementOfKind : String,referenceSizeInSection : NSInteger) -> CGSize
    
    /** 指定的分区有多少列
     * @param section 指定的分区
     * 默认列数为 colunmCount
     */
    @objc optional func YLLayoutColumnCountForSection(inLayout : YLCollectionPinterestLayout,section : NSInteger) -> NSInteger

    /** 指定分区的内边距
     * 默认为 sectionInset
     */
    @objc optional func YLLayoutEdgeInsetsForSection(inLayout : YLCollectionPinterestLayout,forSection : NSInteger) -> UIEdgeInsets

    /** 每列之间的间距
     *  默认为 minimumInteritemSpacing
     */
    @objc optional func YLLayoutColumnSpaceForSection(inLayout : YLCollectionPinterestLayout,forSection : NSInteger) -> CGFloat

    /** 每行之间的间距
     * 默认为 minimumLineSpacing
     */
    @objc optional func YLLayoutRowSpaceForSection(inLayout : YLCollectionPinterestLayout,forSection : NSInteger) -> CGFloat
}

/** 瀑布流布局 : 确定宽度，高度自适应
 * 设置每个分区的 内边距 UIEdgeInsets； 设置每个分区的列与列之间的间距；设置多少个列
 * 根据列数、间距，计算出固定的宽度
 * 高度自适应内容
 */
class YLCollectionPinterestLayout: UICollectionViewFlowLayout {
    
    /** 列数,默认为 2
     * 根据列数，间距，计算出固定的宽度
     */
    var colunmCount = 2
    
    /// 代理
    weak open var delegate: YLCollectionPinterestLayoutDelegate?

    /// 存放所有的布局属性
    var attributesArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()

    /// 存放所有列的当前高度
    var columnHeightArray : [CGFloat] = [CGFloat]()

    override init() {
        super.init()
        minimumLineSpacing = 12 //行间距
        minimumInteritemSpacing = 12 //列间距
        sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - helper method
    ///列数
    func colunmCountForSection(section:NSInteger) -> NSInteger {
        return delegate?.YLLayoutColumnCountForSection?(inLayout: self, section: section) ?? colunmCount
    }
    
    /// 列间距
    func minimumInteritemSpacingForSection(section:NSInteger) -> CGFloat {
        return delegate?.YLLayoutColumnSpaceForSection?(inLayout: self, forSection: section) ?? minimumInteritemSpacing
    }
    
    /// 行间距
    func minimumLineSpacingForSection(section:NSInteger) -> CGFloat {
        return delegate?.YLLayoutRowSpaceForSection?(inLayout: self, forSection: section) ?? minimumLineSpacing
    }
    
    /// item的内边距
    func edgeInsetsForSection(section:NSInteger) -> UIEdgeInsets {
        return delegate?.YLLayoutEdgeInsetsForSection?(inLayout: self, forSection: section) ?? sectionInset
    }
    
    ///cell 宽度
    func itemWidthForSection(section:NSInteger) -> CGFloat {
        let colunmCount = colunmCountForSection(section: section) //一行多少列
        let widthSuper = collectionView?.bounds.width //总宽度
        let edgeInsets = edgeInsetsForSection(section: section)//内边距
        let spaceTotal = edgeInsets.left + edgeInsets.right + minimumInteritemSpacingForSection(section: section) * CGFloat(max(0, colunmCount - 1))
        return (widthSuper! - spaceTotal) / CGFloat(colunmCount) * 1.0
    }
    
    //MARK: - super method

    /** 准备更新当前布局
     * @discussion 当 CollectionView 第一次显示其内容时，以及当布局因视图的更改而显式或隐式无效时，下述方法被用来更新当前布局；
     * 在布局更新期间，首先调用该方法，预处理布局操作；
     * @note 该方法的默认实现不执行任何操作；重写该方法，预处理稍后布局所需的任何计算！
     */
    override func prepare() {
        super.prepare()
        
        if delegate == nil {
            return
        }
                   
        // 清楚之前计算的所有高度
        columnHeightArray.removeAll()
        //清除之前所有的布局属性
        attributesArray.removeAll()
        // 设置每一列默认的高度
        for _ in 0 ..< colunmCount {
            columnHeightArray.append(sectionInset.top)
        }
        //遍历分区
        for sectionIndex in 0 ..< collectionView!.numberOfSections {
            //计算分区头部高度
            let headerAttrs = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: NSIndexPath(row: 0, section: sectionIndex) as IndexPath)!
            attributesArray.append(headerAttrs)
            //添加item属性
            let itemCount : NSInteger = (collectionView?.numberOfItems(inSection: sectionIndex))!
            for rowIndex in 0 ..< itemCount {
                // 创建位置
                let indexPath = NSIndexPath(row: rowIndex, section: sectionIndex)
                // 获取indexPath位置上cell对应的布局属性
                let attrs = layoutAttributesForItem(at: indexPath as IndexPath)!
                attributesArray.append(attrs)
            }
            //计算分区尾部高度
            let footerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: NSIndexPath(row: 0, section: sectionIndex) as IndexPath)!
            attributesArray.append(footerAttributes)
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let size = delegate?.YLLayoutReferenceSizeInSection?(layout: self, elementOfKind: elementKind, referenceSizeInSection: indexPath.section) ?? CGSize.zero
        if size == CGSize.zero {
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
        
        let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let section = indexPath.section
        var maxY = columnHeightArray.max() ?? 0
        if elementKind == UICollectionView.elementKindSectionHeader {
            attri.frame = CGRect(x: 0, y: maxY, width: size.width, height: size.height)
            maxY = attri.frame.maxY + edgeInsetsForSection(section: section).top
        }else{
            maxY += edgeInsetsForSection(section: section).bottom
            attri.frame = CGRect(x: 0, y: maxY, width: size.width, height: size.height)
            maxY = attri.frame.maxY
        }
        for i in 0 ..< columnHeightArray.count {
            columnHeightArray[i] = maxY
        }
        return attri
    }
    
    /** 根据 indexPath 获取 cell 对应的布局属性
     * @param indexPath cell 的索引
     * @discussion 必须重写该方法返回 cell 的布局信息。
     * @note 该方法仅为 cell 提供布局信息
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let cellWidth = itemWidthForSection(section: indexPath.section)
        let cellHeight = delegate?.YLLayoutHeightForItemAtIndexPath(layout: self, indexPath: indexPath as NSIndexPath, itemWidth: cellWidth) ?? 0.0
        if cellHeight < 1 {
            return super.layoutAttributesForItem(at: indexPath)
        }
        // 创建布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        // 找出最短的那一列
        var minY = columnHeightArray.min() ?? 0
        let destColumn = columnHeightArray.index(of: minY)!
        let edgeInsets = edgeInsetsForSection(section: indexPath.section)
        let cellX = edgeInsets.left + CGFloat(destColumn) * (cellWidth + minimumInteritemSpacingForSection(section: indexPath.section))
        var cellY = minY
        if cellY != edgeInsets.top {
            cellY += minimumLineSpacingForSection(section: indexPath.section)
        }
        //重写frame
        attrs.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
        // 更新最短那一列的高度
        columnHeightArray[destColumn] = attrs.frame.maxY
        return attrs
    }
    
    /** 获取指定区域中所有视图（cell，supplementaryView，decorationViews）的布局属性
     * @param rect 指定区域，一般是 collectionView.bounds
     * @discussion 重写该方法，返回所有视图的布局属性；不同类型的视图，使用不同的方法创建、管理；
     * @return 默认返回 nil
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if attributesArray.count > 0 {
            return attributesArray
        }else{
            return super.layoutAttributesForElements(in: rect)
        }
    }
    
    /** 返回collectionView内容的宽度和高度
     * @discussion 必须重写该方法；该值表示所有内容的宽度和高度，而不仅仅是当前可见的内容，collectionView 使用该值配置自己的内容大小，以便滚动。
     * @return 默认返回CGSizeZero
     */
    override var collectionViewContentSize: CGSize{
        if columnHeightArray.count > 0 {
            var adjustedSpace : CGFloat = 0.0
            if #available(iOS 11.0, *) {
                adjustedSpace = collectionView!.adjustedContentInset.top + collectionView!.adjustedContentInset.bottom
            }
            let maxValue = columnHeightArray.max()
            return CGSize(width: collectionView!.bounds.width, height: maxValue! + adjustedSpace)
        }else{
            return super.collectionViewContentSize
        }
    }
}


