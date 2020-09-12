//
//  YLCollectionCardLayout.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 卡片翻转

import UIKit

class YLCollectionCardLayout: UICollectionViewFlowLayout {
    var itemOffset : CGFloat!

    override var itemSize: CGSize{
        didSet{
            //CoverFlow 效果，通过设置 minimumLineSpacing 间距，调节卡片之间的紧凑度
            if (scrollDirection == .vertical) {
                minimumLineSpacing = -itemSize.height * 0.8;
            }else{
                minimumLineSpacing = -itemSize.width * 0.8;
            }
        }
    }
    
    ///询问布局对象 滑动 CollectionView 时 是否需要更新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 因为item大小随范围变化而实时变化，在-prepareLayout方法里计算缓存已经无用；
    /// 需要在下述方法里亲自计算来返回布局对象数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArray : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        let contentOffset = collectionView!.contentOffset
        if scrollDirection == .vertical {//垂直滚动
            let height = collectionView!.bounds.height
            let centerY = contentOffset.y + height * 0.5
            // 每个点根据距离中心点距离进行缩放
            for attri in attributesArray {
                // cell的中心点，和collectionView最中心点的x值的间距
                let delta = attri.center.y - centerY
                let scale = max(1 - (abs(delta) / height), 0)
                attri.alpha = scale
                attri.zIndex = Int(delta <= 0 ? (100 + scale * 100) : (scale * 100))
                attri.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            }
        }else{//水平滚动
            let width = collectionView!.bounds.width
            let centerX = contentOffset.x + width * 0.5
            
            // 每个点根据距离中心点距离进行缩放
            for attri in attributesArray {
                // cell的中心点，和collectionView最中心点的x值的间距
                let delta = attri.center.x - centerX
                let scale = max(1 - (abs(delta) / width), 0)
                attri.alpha = scale
                attri.zIndex = Int(delta <= 0 ? (100 + scale * 100) : (scale * 100))
                attri.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            }
        }
        return attributesArray
    }
    
    /// 重写滚动时停下的位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let height = collectionView!.bounds.height
        let width = collectionView!.bounds.width
        if scrollDirection == .vertical {//垂直滚动
            let rect = CGRect(x: 0, y: proposedContentOffset.y, width: width, height: height)
            let attributes : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
            let centerY = proposedContentOffset.y + height * 0.5
            var minDelta = CGFloat.greatestFiniteMagnitude
            for attri in attributes {
                if abs(minDelta) > abs(attri.center.y - centerY) {
                    minDelta = attri.center.y - centerY
                 }
            }
            let offsetY = proposedContentOffset.y + minDelta
            return CGPoint(x: proposedContentOffset.x,y: offsetY)
        }else{
            let rect = CGRect(x: proposedContentOffset.x, y: 0, width: width, height: height)
            let attributes : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
            // 计算collectionView最中心点的x值
            let centerX = proposedContentOffset.x + width * 0.5
            //需要移动的最小距离
            var minDelta = CGFloat.greatestFiniteMagnitude
            for attri in attributes {
                if (abs(minDelta) > abs(attri.center.x - centerX)) {
                     minDelta = attri.center.x - centerX
                 }
            }
            let offsetX =  proposedContentOffset.x + minDelta
            return CGPoint(x: offsetX,y: proposedContentOffset.y)
        }
    }
}

