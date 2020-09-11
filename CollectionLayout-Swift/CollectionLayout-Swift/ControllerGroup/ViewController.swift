//
//  ViewController.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView : UICollectionView!
    var dataArray : NSMutableArray!
    let itemArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Flow Layout"
        
         itemArray.add(["左对齐/右对齐":"AlignmentViewController"])
         itemArray.add(["瀑布流":"PinterestViewController"])
         itemArray.add(["卡片覆盖效果":"CardViewController"])
         itemArray.add(["卡片轮转效果":"CardReelViewController"])
         itemArray.add(["卡片轮转效果":"TransitionAnimationViewController"])
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: self.view.bounds.width - 24, height: 44)
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionAlignmentCell.self, forCellWithReuseIdentifier: "CollectionAlignmentCell")
        self.view.addSubview(collectionView)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CollectionAlignmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionAlignmentCell", for: indexPath) as! CollectionAlignmentCell
        let dict : NSDictionary = itemArray.object(at: indexPath.row) as! NSDictionary
        cell.itemLable.text = dict.allKeys.first as! String
        return cell
    }
    
}

