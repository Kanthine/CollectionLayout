//
//  YLCollectionAlignmentLayout.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 水平对齐方式

import UIKit

enum YLCollectionAlignment : UInt {
    case left = 0 //左对齐
    case Right //右对齐
}

@objc protocol YLCollectionAlignmentLayoutDelegate{
    /// 每个item的宽度
    func collectionViewSizeForItemAtIndexPath(indexPath : NSIndexPath) -> CGSize
            
    @objc optional //可选协议方法
    ///SectionHeader/SectionFooter 的大小
    func collectionViewElementOfKind(elementOfKind : String,referenceSizeInSection : NSInteger) -> CGSize
}

class YLCollectionAlignmentLayout: UICollectionViewFlowLayout {

    weak open var alignmentDelegate: YLCollectionAlignmentLayoutDelegate?

    var cellAlignmentType : YLCollectionAlignment! {
        didSet{
            invalidateLayout()
        }
    }
    
    var current_Y : CGFloat!
    var attributesArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    
    // MARK: - super method
    
    ///当布局改变时，首先调用方法为更新视图做一些准备工作
    override func prepare() {
        super.prepare()
        current_Y = 0
        attributesArray.removeAll()
        
        //遍历分区
        for sectionIndex in 0 ..< collectionView!.numberOfSections {
            //计算分区头部高度
            let headerAttributes : UICollectionViewLayoutAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: NSIndexPath(row: 0, section: sectionIndex) as IndexPath)!
            attributesArray.append(headerAttributes)

            //添加item属性
            var previousAttributes : UICollectionViewLayoutAttributes!

            for rowIndex in 0 ..< (collectionView?.numberOfItems(inSection: sectionIndex))! {
                // 创建位置
                let indexPath = NSIndexPath(row: rowIndex, section: sectionIndex)
                // 获取indexPath位置上cell对应的布局属性
                previousAttributes = layoutAttributesForItem(at: indexPath as IndexPath, previousAttributes: previousAttributes)!
                attributesArray.append(previousAttributes)
            }

            //计算分区尾部高度
            let footerAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: NSIndexPath(row: 0, section: sectionIndex) as IndexPath) ?? nil
            if footerAttributes != nil {
                attributesArray.append(footerAttributes!)
            }
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let size = alignmentDelegate?.collectionViewElementOfKind?(elementOfKind: elementKind, referenceSizeInSection: indexPath.section) ?? (elementKind == UICollectionView.elementKindSectionHeader ? headerReferenceSize : footerReferenceSize)
        if elementKind == UICollectionView.elementKindSectionHeader {
            attributes.frame = CGRect(x: 0, y: current_Y, width: size.width, height: size.height)
            current_Y = attributes.frame.maxY + sectionInset.top
        }else{
            current_Y += sectionInset.bottom
            attributes.frame = CGRect(x: 0, y: current_Y, width: size.width, height: size.height)
            current_Y = attributes.frame.maxY
        }
        return attributes
    }
    
    /** 获取指定 UICollectionViewCell 的布局属性
     * @param indexPath 指定位置
     * @param previousAttributes 前一个布局属性，
     * @note 如果 indexPath.row = 0,则 previousAttributes = nil
     */
    func layoutAttributesForItem(at indexPath: IndexPath ,previousAttributes : UICollectionViewLayoutAttributes! = nil) -> UICollectionViewLayoutAttributes? {
        
        //拿到 cell 的 size
        let cellSize : CGSize = (alignmentDelegate?.collectionViewSizeForItemAtIndexPath(indexPath: indexPath as NSIndexPath))!
        let layoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)//创建一个布局属性
        var startPoint = CGPoint(x: sectionInset.left, y: current_Y)
        if cellAlignmentType == YLCollectionAlignment.left {
            if previousAttributes != nil {
                if previousAttributes.frame.maxX + cellSize.width + minimumInteritemSpacing < collectionViewContentSize.width {
                    startPoint = CGPoint(x: previousAttributes.frame.maxX + minimumInteritemSpacing, y: previousAttributes.frame.origin.y)
                }else{
                    //重启一行
                    startPoint = CGPoint(x: sectionInset.left, y: previousAttributes.frame.maxY + minimumLineSpacing)//垂直间距
                }
            }else{
                startPoint = CGPoint(x: sectionInset.left, y: current_Y)
            }
        }else if cellAlignmentType == YLCollectionAlignment.Right {//右对齐
            if previousAttributes != nil {
                if cellSize.width + minimumInteritemSpacing < previousAttributes.frame.origin.x {
                    
                    startPoint = CGPoint(x: previousAttributes.frame.origin.x - minimumInteritemSpacing - cellSize.width, y: previousAttributes.frame.origin.y)
                }else{
                    //重启一行
                    startPoint = CGPoint(x: collectionViewContentSize.width - cellSize.width - sectionInset.right, y: previousAttributes.frame.maxY + minimumLineSpacing)
                }
            }else{
                startPoint = CGPoint(x: collectionViewContentSize.width - cellSize.width - sectionInset.right, y: current_Y)
            }
        }

        layoutAttributes.frame = CGRect(x: startPoint.x, y: startPoint.y, width: cellSize.width, height: cellSize.height)
        current_Y = max(layoutAttributes.frame.maxY, current_Y)
        return layoutAttributes
    }
    
    /** 获取指定区域中所有视图（cell，supplementaryView，decorationViews）的布局属性
     * @param rect 指定区域
     * @discussion 重写该方法，返回所有视图的布局属性；不同类型的视图，使用不同的方法创建、管理；
     * @return 默认返回 nil
     * @note 针对固定布局，如瀑布流等可以使用数组缓存 LayoutAttributes ，不需要再次加载创建
     *       但是对于 cell 做的特效等场景，如卡片动画，需要实时的 LayoutAttributes，因此不能缓存，只能需要时创建！
    */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return (attributesArray as! [UICollectionViewLayoutAttributes])
    }
    
    override var collectionViewContentSize: CGSize{
        get{
            var adjustedSpace : CGFloat = 0
            if #available(iOS 11.0, *) {
                adjustedSpace = (collectionView?.adjustedContentInset.top)! + (collectionView?.adjustedContentInset.bottom)!
            }
            return CGSize(width: (collectionView?.frame.width)!, height: current_Y + adjustedSpace)
        }
    }
}
