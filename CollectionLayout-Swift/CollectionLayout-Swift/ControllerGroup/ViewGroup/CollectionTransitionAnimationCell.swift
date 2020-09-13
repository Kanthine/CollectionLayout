//
//  CollectionTransitionAnimationCell.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

///转场动画
class CollectionTransitionAnimationCell: UICollectionViewCell {
    lazy var nameLable : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(patternImage: UIImage(named: "cardItemBack")!)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        return label
    }()
    
    lazy var imageView : UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        imageV.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1.0)
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    
    var model : DataModel! {
        didSet{
            imageView.image = model.image
            nameLable.text = "\(model.title)-\(model.index)"
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
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: contentView.bounds.height - 40)
        nameLable.frame = CGRect(x: 0, y: imageView.frame.maxY, width: contentView.bounds.width, height: 40)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
