//
//  CollectionCardCell.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

class CollectionCardCell: UICollectionViewCell {
    var nameLable: UILabel {
        get {
            let label = UILabel()
            label.backgroundColor = UIColor(patternImage: UIImage(named: "cardItemBack")!)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont.init(name: "Helvetica-Bold", size: 20)
            return label
        }
    }
    
    var imageView: UIImageView {
        get {
            let imageV = UIImageView(frame: CGRect(x: 12, y: 20, width: 42, height: 42))
            imageV.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            return imageV
        }
    }
    
    var model: DataModel! {
        didSet{
            imageView.image = model.image
            nameLable.text = "\(model.title ?? "")-\(model.index ?? 0)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(nameLable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentWidth = self.contentView.bounds.width
        imageView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentWidth)
        nameLable.frame = CGRect(x: 0, y: imageView.frame.maxY, width: contentWidth, height: 40)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes.isKind(of: YLCollectionReelLayoutAttributes.self) {
            let reelAttributes = layoutAttributes as! YLCollectionReelLayoutAttributes
            self.layer.anchorPoint = reelAttributes.anchorPoint
            let y : CGFloat = self.layer.position.y + (reelAttributes.anchorPoint.y - 0.5) * self.bounds.size.height
            self.layer.position = CGPoint(x: self.layer.position.x, y: y)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
