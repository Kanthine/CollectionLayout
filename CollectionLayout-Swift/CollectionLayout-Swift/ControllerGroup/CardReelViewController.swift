//
//  CardReelViewController.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 转轮效果

import UIKit

class CardReelViewController: UIViewController,UICollectionViewDelegate,
                              UICollectionViewDataSource{
   ///懒加载
   lazy var collectionView : UICollectionView! = {
        let flowLayout = YLCollectionReelLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 240)
        flowLayout.radius = 500

        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionCardCell.self, forCellWithReuseIdentifier: "CollectionCardCell")
        return collectionView
   }()

   
   // MARK: - life cycyle
   override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "CardBack")!).withAlphaComponent(0.9)
        self.view.addSubview(collectionView)
   }
   
   // MARK: - UICollectionViewDelegate
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return DataModel.shareDemoData().count
   }
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       if kind == UICollectionView.elementKindSectionHeader {
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath)
           return headerView
       }
       let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath)
       return footerView
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CollectionCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCardCell", for: indexPath) as! CollectionCardCell
        let model = DataModel.shareDemoData()[indexPath.row]
        model.index = indexPath.row
        cell.model = model
        return cell
   }
}


