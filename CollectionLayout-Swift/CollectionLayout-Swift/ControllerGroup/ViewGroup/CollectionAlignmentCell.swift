//
//  CollectionAlignmentCell.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

class CollectionAlignmentCell: UICollectionViewCell {
    let itemLable = UILabel()
    let backLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backLayer.backgroundColor = UIColor(red: 15/255.0, green: 136/255.0, blue: 235/255.0, alpha: 0.1).cgColor
        self.contentView.layer.addSublayer(backLayer)
        
        itemLable.font = UIFont.systemFont(ofSize: 14)
        itemLable.textAlignment = .center
        itemLable.textColor = UIColor(red: 0/255.0, green: 83/255.0, blue: 150/255.0, alpha: 1)
        self.contentView.addSubview(itemLable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemLable.frame = self.bounds
        backLayer.frame = self.bounds
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = backLayer.bounds
        maskLayer.path = UIBezierPath.init(roundedRect: backLayer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6)).cgPath
        backLayer.mask = maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
