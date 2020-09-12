//
//  CollectionSectionHeaderView.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

let kCollectionSectionHeaderIdentifer : NSString = "CollectionSectionHeaderView"

class CollectionSectionHeaderView: UICollectionReusableView {
    var imageView : UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        imageView = UIImageView(image: UIImage(named: "dub_header_back"))
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  172 / 375.0 * UIScreen.main.bounds.width)
        self.addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


let kCollectionSectionFooterIdentifer : NSString = "CollectionSectionFooterView"

class CollectionSectionFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
