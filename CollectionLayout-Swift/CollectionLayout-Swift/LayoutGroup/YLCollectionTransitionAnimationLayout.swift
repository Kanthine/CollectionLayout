//
//  YLCollectionTransitionAnimationLayout.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 转场动画 FlowLayout

import UIKit

///转场动画类型
enum YLCollectionTransitionType : UInt {
    case none = 0 //小数阅读器：无效果
    case cube //右对齐
    case cover //覆盖
    case open //小数阅读器：覆盖
    case pan //小数阅读器：平移
    case card
    case parallax
    case crossFade
    case rotateInOut
    case zoomInOut
}



open class YLCollectionTransitionAnimationAttributes: UICollectionViewLayoutAttributes {
    ///缓存 cell.contentView
    public var contentView: UIView?
    
    ///记录 UICollectionView 滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    
    ///cell.indexPath.row - 偏移的单元格数量（左减右加，上减下加）
    public var startOffset: CGFloat = 0
    public var middleOffset: CGFloat = 0
    public var endOffset: CGFloat = 0
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! YLCollectionTransitionAnimationAttributes
        copy.contentView = contentView
        copy.scrollDirection = scrollDirection
        copy.startOffset = startOffset
        copy.middleOffset = middleOffset
        copy.endOffset = endOffset
        return copy
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let o = object as? YLCollectionTransitionAnimationAttributes else { return false }
        return super.isEqual(o)
            && o.contentView == contentView
            && o.scrollDirection == scrollDirection
            && o.startOffset == startOffset
            && o.middleOffset == middleOffset
            && o.endOffset == endOffset
    }
}



//MARK:- 动画操作者

///基础协议
public protocol YLCollectionTransitionAnimationOperator {
    ///实现动画的方法
    func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes)
}


/// None 效果
public struct YLCollectionNoneAnimation: YLCollectionTransitionAnimationOperator {
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        attributes.frame = CGRect(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y, width: attributes.frame.width, height: attributes.frame.height)
        if attributes.middleOffset < 0 {
            attributes.zIndex = Int(1000 + attributes.middleOffset)
        }else{
            attributes.zIndex = Int(2000 - attributes.middleOffset);
        }
    }
}

/// UIView 扩展
extension UIView {
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        
        guard layer.anchorPoint != point else { return }
        
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var c = layer.position
        c.x -= oldPoint.x
        c.x += newPoint.x
        
        c.y -= oldPoint.y
        c.y += newPoint.y
        
        layer.position = c
        layer.anchorPoint = point
    }
}

/// Cube 动画
public struct YLCollectionCubeAnimation: YLCollectionTransitionAnimationOperator {
    /// 单元格的视角; 取值范围 [-1/2000, -1/200]，默认为 -1/500
    public var perspective: CGFloat
    
    /// totalAngle 越大，transforming 时单元格越陡峭
    public var totalAngle: CGFloat
    
    public init(perspective: CGFloat = -1 / 500.0, totalAngle: CGFloat = .pi / 2) {
        self.perspective = perspective
        self.totalAngle = totalAngle
    }
    
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        if abs(position) >= 1 {
            attributes.contentView?.layer.transform = CATransform3DIdentity
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        } else if attributes.scrollDirection == .horizontal {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, 0, 1, 0)
            
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: position > 0 ? 0 : 1, y: 0.5))
        } else {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, -1, 0, 0)
            
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: 0.5, y: position > 0 ? 0 : 1))
        }
    }
}


/// Card 动画
public struct YLCollectionCardAnimation: YLCollectionTransitionAnimationOperator {
    /// 将要离开屏幕的 cell 的 alpha。取值范围 [0,1]，默认为 0.5
    public var minAlpha: CGFloat
    
    /// 两个 cell 之间的间距比。默认为 0.4
    public var itemSpacing: CGFloat
    
    /// cell 的缩放比例
    public var scaleRate: CGFloat
    
    public init(minAlpha: CGFloat = 0.5, itemSpacing: CGFloat = 0.4, scaleRate: CGFloat = 0.7) {
        self.minAlpha = minAlpha
        self.itemSpacing = itemSpacing
        self.scaleRate = scaleRate
    }
    
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        let scaleFactor = scaleRate - 0.1 * abs(position)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        var translationTransform: CGAffineTransform
        
        if attributes.scrollDirection == .horizontal {
            let width = collectionView.frame.width
            let translationX = -(width * itemSpacing * position)
            translationTransform = CGAffineTransform(translationX: translationX, y: 0)
        } else {
            let height = collectionView.frame.height
            let translationY = -(height * itemSpacing * position)
            translationTransform = CGAffineTransform(translationX: 0, y: translationY)
        }
        
        attributes.alpha = 1.0 - abs(position) + minAlpha
        attributes.transform = translationTransform.concatenating(scaleTransform)
    }
}


/// 覆盖 动画
public struct YLCollectionCoverAnimation: YLCollectionTransitionAnimationOperator {
    /// 将要离开屏幕的 cell 的缩放比例
    public var scaleRate: CGFloat
    
    /// 传递 0 不缩放
    public init(scaleRate: CGFloat = 0.2) {
        self.scaleRate = scaleRate
    }
    
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        let contentOffset = collectionView.contentOffset
        let itemOrigin = attributes.frame.origin
        let scaleFactor = scaleRate * min(position, 0) + 1.0
        var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        if attributes.scrollDirection == .horizontal {
            let transform_1 = CGAffineTransform(translationX: position < 0 ? contentOffset.x - itemOrigin.x : 0, y: 0)
            transform = transform.concatenating(transform_1)
        } else {
            let transform_1 = CGAffineTransform(translationX: 0, y: position < 0 ? contentOffset.y - itemOrigin.y : 0)
            transform = transform.concatenating(transform_1)
        }
        attributes.transform = transform
        attributes.zIndex = attributes.indexPath.row
    }
}


/// 小说阅读器：覆盖翻页
public struct YLCollectionOpenAnimation: YLCollectionTransitionAnimationOperator {
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        let contentOffset = collectionView.contentOffset
  
        if attributes.scrollDirection == .horizontal {
            if (position > 0) {
                attributes.frame = CGRect(x: contentOffset.x, y: attributes.frame.origin.y, width: attributes.frame.width, height: attributes.frame.height)
            }
        } else {
            if (position > 0) {
                attributes.frame = CGRect(x: attributes.frame.origin.x, y: contentOffset.y, width: attributes.frame.width, height: attributes.frame.height)
            }
        }
        attributes.zIndex = 10000 - attributes.indexPath.row
        
        guard let cell : UICollectionViewCell = collectionView.cellForItem(at: attributes.indexPath) else { return }
        cell.clipsToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor // 阴影颜色
        cell.layer.shadowOffset = CGSize.zero // 偏移距离
        cell.layer.shadowOpacity = 0.5 // 不透明度
        cell.layer.shadowRadius = 10.0 // 半径
    }
}

/// 视觉差：移动 cell 的速度慢于单元格本身来实现视差效果
public struct YLCollectionParallaxAnimation: YLCollectionTransitionAnimationOperator {
    /// 速度越快，视差越明显：取值范围 [0,1]；默认 0.5 ，0表示无视差
    public var speed: CGFloat
    
    public init(speed: CGFloat = 0.5) {
        self.speed = speed
    }
    
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        let direction = attributes.scrollDirection
        guard let contentView = attributes.contentView else { return }
        if abs(position) >= 1 {
            contentView.frame = attributes.bounds
        } else if direction == .horizontal {
            let width = collectionView.frame.width
            let transitionX = -(width * speed * position)
            let transform = CGAffineTransform(translationX: transitionX, y: 0)
            let newFrame = attributes.bounds.applying(transform)
            contentView.frame = newFrame
        } else {
            let height = collectionView.frame.height
            let transitionY = -(height * speed * position)
            let transform = CGAffineTransform(translationX: 0, y: transitionY)
            let newFrame = attributes.bounds.applying(transform)
            // 不使用 attributes.transform，因为如果在绑定方法中由于布局变化而对每个单元格调用 - layoutSubviews 会有问题
            contentView.frame = newFrame
        }
        
        print(contentView)
        
        guard let cell : UICollectionViewCell = collectionView.cellForItem(at: attributes.indexPath) else { return }
        cell.clipsToBounds = true
        cell.layer.shadowColor = UIColor.clear.cgColor // 阴影颜色
        cell.layer.shadowOffset = CGSize.zero // 偏移距离
        cell.layer.shadowOpacity = 0 // 不透明度
        cell.layer.shadowRadius = 0 // 半径
    }
}



/// CrossFade 效果
public struct YLCollectionCrossFadeAnimation: YLCollectionTransitionAnimationOperator {
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let contentOffset = collectionView.contentOffset
        attributes.frame = CGRect(origin: contentOffset, size: attributes.frame.size)
        attributes.alpha = 1.0 - abs(attributes.middleOffset)
    }
}


/// 旋转效果
public struct YLCollectionRotateInOutAnimation: YLCollectionTransitionAnimationOperator {
    /// 离开屏幕的 cell 的 alpha，取值范围 [0, 1]. ，默认值 0
    public var minAlpha: CGFloat
    
    /// 离开屏幕的 cell 的旋转角度，取值范围 [0, M_PI * 2.0] ，默认值 M_PI_4
    public var maxRotate: CGFloat
    
    public init(minAlpha: CGFloat = 0, maxRotate: CGFloat = .pi / 4) {
        self.minAlpha = minAlpha
        self.maxRotate = maxRotate
    }
    
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        if abs(position) >= 1 {
            attributes.transform = .identity
            attributes.alpha = 1.0
        } else {
            let rotateFactor = maxRotate * position
            attributes.zIndex = attributes.indexPath.row
            attributes.alpha = 1.0 - abs(position) + minAlpha
            attributes.transform = CGAffineTransform(rotationAngle: rotateFactor)
        }
    }
}


/// 放大或缩小效果
public struct YLCollectionZoomInOutAnimation: YLCollectionTransitionAnimationOperator {
    /// 缩放比率，1 表示 cell 在最小时消失。默认 0.2
    public var scaleRate: CGFloat
    
    public init(scaleRate: CGFloat = 0.2) {
        self.scaleRate = scaleRate
    }
    
    public func transitionAnimation(collectionView: UICollectionView, attributes: YLCollectionTransitionAnimationAttributes) {
        let position = attributes.middleOffset
        if position <= 0 && position > -1 {
            let scaleFactor = scaleRate * position + 1.0
            attributes.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        } else {
            attributes.transform = .identity
        }
    }
}



class YLCollectionTransitionAnimationLayout: UICollectionViewFlowLayout {

    /// 过渡动画的执行者
    var animationOperator : YLCollectionTransitionAnimationOperator!
    
    
    ///转场动画类型
    var transitionType : YLCollectionTransitionType! {
        didSet{
            
            switch transitionType {
            case .none?: animationOperator = YLCollectionNoneAnimation()
            case .cube: animationOperator = YLCollectionCubeAnimation(perspective: -1 / 500.0, totalAngle: .pi / 2.0)
            case .card: animationOperator = YLCollectionCardAnimation(minAlpha: 0.5, itemSpacing: 0.4, scaleRate: 0.7)
            case .cover: animationOperator = YLCollectionCoverAnimation(scaleRate: 0.2)
            case .open: animationOperator = YLCollectionOpenAnimation()
            case .pan: animationOperator = YLCollectionParallaxAnimation(speed: 0)
            case .parallax: animationOperator = YLCollectionParallaxAnimation(speed: 0.5)
            case .crossFade: animationOperator = YLCollectionCrossFadeAnimation()
            case .rotateInOut: animationOperator = YLCollectionRotateInOutAnimation(minAlpha: 0, maxRotate: .pi / 4.0)
            case .zoomInOut: animationOperator = YLCollectionZoomInOutAnimation(scaleRate: 0.2)
            default: animationOperator = nil
            }
            invalidateLayout()
        }
    }
    
    override init() {
        super.init()
        sectionInset = UIEdgeInsets.zero
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        
        ///默认
        transitionType = YLCollectionTransitionType.none
        animationOperator = YLCollectionNoneAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layoutAttributesClass: AnyClass{
        return YLCollectionTransitionAnimationAttributes.self
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = self.collectionView else { return attributesArray }

        for item in attributesArray {
            let attribute : YLCollectionTransitionAnimationAttributes = item as! YLCollectionTransitionAnimationAttributes
            
            let distance: CGFloat
            let itemOffset: CGFloat//偏移量
            
            if scrollDirection == .horizontal {
                distance = collectionView.frame.width
                itemOffset = attribute.center.x - collectionView.contentOffset.x
                //startOffset = cell.indexPath.row - 偏移的单元格数量（左减右加，上减下加）
                attribute.startOffset = (attribute.frame.origin.x - collectionView.contentOffset.x) / attribute.frame.width
                attribute.endOffset = (attribute.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width) / attribute.frame.width
            } else {
                distance = collectionView.frame.height
                itemOffset = attribute.center.y - collectionView.contentOffset.y
                attribute.startOffset = (attribute.frame.origin.y - collectionView.contentOffset.y) / attribute.frame.height
                attribute.endOffset = (attribute.frame.origin.y - collectionView.contentOffset.y - collectionView.frame.height) / attribute.frame.height
            }
            attribute.scrollDirection = scrollDirection
            attribute.middleOffset = itemOffset / distance - 0.5
            if attribute.contentView == nil,
                let c = collectionView.cellForItem(at: attribute.indexPath)?.contentView {
                attribute.contentView = c
            }
            animationOperator.transitionAnimation(collectionView: collectionView, attributes: attribute)
        }
        return attributesArray
    }
}
