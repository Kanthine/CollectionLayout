//
//  PinterestViewController.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 瀑布流：高度自适应

import UIKit

class PinterestViewController: UIViewController,UICollectionViewDelegate,
                               UICollectionViewDataSource, YLCollectionPinterestLayoutDelegate{
    ///懒加载
    lazy var collectionView : UICollectionView! = {
        let flowLayout = YLCollectionPinterestLayout()
        let width = (UIScreen.main.bounds.width - 16 * 2.0 - 12) / 2.0
        flowLayout.itemSize = CGSize(width: width, height: 123 / 165.0 * width + 24)
        flowLayout.delegate = self
        
         let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
         collectionView.backgroundColor = UIColor.white
         collectionView.showsVerticalScrollIndicator = false
         collectionView.showsHorizontalScrollIndicator = false
         collectionView.delegate = self
         collectionView.dataSource = self
         collectionView.register(PinterestCollectionCell.self, forCellWithReuseIdentifier: "PinterestCollectionCell")
        collectionView.register(CollectionSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(CollectionSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        return collectionView
    }()

    
    // MARK: - life cycyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = self.view.bounds
    }
    
    // MARK: - YLCollectionViewLayoutDelegate
    
    func YLLayoutReferenceSizeInSection(layout: YLCollectionPinterestLayout, elementOfKind: String, referenceSizeInSection: NSInteger) -> CGSize {
        if elementOfKind == UICollectionView.elementKindSectionHeader {
            return CGSize(width: UIScreen.main.bounds.width, height: 172 / 375.0 * UIScreen.main.bounds.width)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 0.1)
    }
    
    func YLLayoutHeightForItemAtIndexPath(layout: YLCollectionPinterestLayout, indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        return DataModel.shareDemoData()[indexPath.row].cellHeightByWidth(width: itemWidth)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
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
         let cell : PinterestCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinterestCollectionCell", for: indexPath) as! PinterestCollectionCell
         cell.model = DataModel.shareDemoData()[indexPath.row]
         return cell
    }
 }
