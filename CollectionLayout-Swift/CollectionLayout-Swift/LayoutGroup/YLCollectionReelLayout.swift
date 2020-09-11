//
//  YLCollectionReelLayout.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

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

}
