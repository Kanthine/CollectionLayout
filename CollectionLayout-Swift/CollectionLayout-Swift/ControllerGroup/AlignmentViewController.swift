//
//  AlignmentViewController.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 左对齐、右对齐

import UIKit

class AlignmentViewController: UIViewController,UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               YLCollectionAlignmentLayoutDelegate {
    ///懒加载
    lazy var rightButton : UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("左对齐", for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonItemClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView : UICollectionView! = {
        let flowLayout = YLCollectionAlignmentLayout()
        flowLayout.alignmentDelegate = self
        flowLayout.cellAlignmentType = YLCollectionAlignment.left
        flowLayout.minimumLineSpacing = 16 //行间距
        flowLayout.minimumInteritemSpacing = 16 //列间距
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 20, right: 12)

        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionAlignmentCell.self, forCellWithReuseIdentifier: "CollectionAlignmentCell")
        collectionView.register(CollectionSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(CollectionSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        return collectionView
    }()

    
    // MARK: - life cycyle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(collectionView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = self.view.bounds
    }
    
    
    // MARK: - response click
    @objc func rightBarButtonItemClick(sender : UIButton) {
        let flowLayout : YLCollectionAlignmentLayout = collectionView.collectionViewLayout as! YLCollectionAlignmentLayout
        
        if sender.titleLabel?.text == "右对齐" {
            sender.setTitle("左对齐", for: .normal)
            flowLayout.cellAlignmentType = YLCollectionAlignment.left
        }else if sender.titleLabel?.text == "左对齐" {
            sender.setTitle("右对齐", for: .normal)
            flowLayout.cellAlignmentType = YLCollectionAlignment.Right
        }
    }
    
    // MARK: - YLAlignmentFlowLayoutDelegate
    
    func collectionViewElementOfKind(elementOfKind: String, referenceSizeInSection: NSInteger) -> CGSize {
        if elementOfKind == UICollectionView.elementKindSectionHeader {
            return CGSize(width: UIScreen.main.bounds.width, height: 172 / 375.0 * UIScreen.main.bounds.width)
        }else{
            return CGSize.zero
        }
    }
    
    func collectionViewSizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        return DataModel.shareDemoData()[indexPath.row].alignmentTitleSize;
    }

    // MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
        let cell : CollectionAlignmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionAlignmentCell", for: indexPath) as! CollectionAlignmentCell
        cell.itemLable.text = DataModel.shareDemoData()[indexPath.row].title as String?
        return cell
    }
    
}


