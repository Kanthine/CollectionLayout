//
//  YLCollectionReelLayout.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 转轮效果

import UIKit


class YLCollectionReelLayoutAttributes: UICollectionViewLayoutAttributes {
    var anchorPoint : CGPoint! //添加锚点
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy : YLCollectionReelLayoutAttributes = super.copy(with: zone) as! YLCollectionReelLayoutAttributes
        copy.anchorPoint = anchorPoint
        return copy
    }
}

class YLCollectionReelLayout: UICollectionViewFlowLayout {
    var radius : CGFloat!{ //半径
        didSet{
            invalidateLayout()
        }
    }
   
    
    /// 存放所有的布局属性
    var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()

    /// 每两个item 之间的角度，任意值
    var anglePerItem : CGFloat {
        // atan反正切
        return atan(itemSize.width / radius)
    }
        
    /// 当collectionView滑到极端时，第 0个item的角度 （第0个开始是 0 度，  当滑到极端时， 最后一个是 0 度）
    var angleAtextreme : CGFloat {
        let itemCount = collectionView?.numberOfItems(inSection: 0)
        return itemCount! > 0 ? -CGFloat(itemCount! - 1) * anglePerItem : 0.0
    }
        
    /// 滑动时，第0个item的角度
    var angle : CGFloat {
        return angleAtextreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    override class var layoutAttributesClass: AnyClass{
        get{
            return YLCollectionReelLayoutAttributes.self
        }
    }
    
    override func prepare() {
        super.prepare()
        
        // 整体布局是将每个item设置在屏幕中心，然后旋转 anglePerItem * i 度
        let centerX = (collectionView?.contentOffset.x)! + (collectionView?.bounds.width)! / 2.0
        
        // 锚点的y值，多增加了raidus的值
        let anchorPointY = (itemSize.height / 2.0 + radius) / itemSize.height

        /// 不要计算所有的item，只计算在屏幕中的item,theta最大倾斜
        let theta = atan2((collectionView?.bounds.width)! / 2.0, radius! + itemSize.height / 2.0 - (collectionView?.bounds.height)! / 2.0)
        var startIndex = 0
        var endIndex = (collectionView?.numberOfItems(inSection: 0))! - 1
        // 开始位置
        if angle < -theta {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        // 结束为止
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        if endIndex < startIndex {
            endIndex = 0
            startIndex = 0
        }
        attrsArray.removeAll()
        for i in startIndex ..< endIndex + 1 {
            let attribute = YLCollectionReelLayoutAttributes.init(forCellWith: NSIndexPath(row: i, section: 0) as IndexPath)
            attribute.size = itemSize
            // 设置居中
            attribute.center = CGPoint(x: centerX, y: (collectionView?.bounds.midY)!)
            // 设置偏移角度
            attribute.transform = CGAffineTransform(rotationAngle: angle + anglePerItem * CGFloat(i))
            // 锚点，我们自定义的属性
            attribute.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            attrsArray.append(attribute)
        }
    }
    
    /// 重写滚动时停下的位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // 每单位偏移量对应的偏移角度
        let factor = -angleAtextreme / (collectionViewContentSize.width - (collectionView?.bounds.width)!)
        let proposedAngle = proposedContentOffset.x * factor
        // 大约偏移了多少个
        let ratio = proposedAngle / anglePerItem
        var multiplier : CGFloat
        // 往左滑动,让multiplier成为整个
        if velocity.x > 0 {
            multiplier = ceil(ratio)
        } else if velocity.x < 0 {  // 往右滑动
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        return CGPoint(x:  multiplier * self.anglePerItem / factor,y: proposedContentOffset.y)
    }
    
    ///询问布局对象 滑动 CollectionView 时 是否需要更新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize{
        let itemCount = collectionView?.numberOfItems(inSection: 0)
        return CGSize(width: CGFloat(itemCount!) * itemSize.width, height: (collectionView?.bounds.height)!)
    }
}
