//
//  PinterestCollectionCell.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

class PinterestCollectionCell: UICollectionViewCell {
    lazy var nameLable : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(patternImage: UIImage(named: "cardItemBack")!)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var imageView : UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 12, y: 20, width: 42, height: 42))
        imageV.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1.0)
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    var model : DataModel! {
        didSet{
            imageView.image = model.image
            nameLable.text = model.detaile as String?
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(nameLable)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: model.imageSize.width, height: model.imageSize.height)
        nameLable.frame = CGRect(x: 0, y: imageView.frame.maxX + 10, width: self.contentView.bounds.width, height: model.detaileHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
