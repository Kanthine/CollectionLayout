//
//  CardViewController.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
// 卡片翻转

import UIKit

class CardViewController: UIViewController,UICollectionViewDelegate,
                          UICollectionViewDataSource{
    
    var indexArray : [NSNumber] = [NSNumber]()

    ///懒加载
    lazy var collectionView : UICollectionView! = {
        let flowLayout = YLCollectionCardLayout()
        flowLayout.scrollDirection = .vertical
        var frame : CGRect
        if flowLayout.scrollDirection == .vertical {
            frame = view.bounds
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width)
        }else{
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 160.0, height: UIScreen.main.bounds.width - 120)
            frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.width)
        }
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
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
        reloadData()
    }
    
    func reloadData(){
        let count = DataModel.shareDemoData().count
        indexArray.removeAll()
        for _ in 0 ..< 100 {
            for j in 0 ..< count {
                indexArray.append(NSNumber(value: j))
            }
        }
        // 定位到 第50组(中间那组)
        collectionView.scrollToItem(at: NSIndexPath(row: 100 / 2 * count, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pointInView = view.convert(collectionView.center, to: collectionView)
        let indexPathNow = collectionView.indexPathForItem(at: pointInView)
        let index = indexPathNow!.row % DataModel.shareDemoData().count
        
        // 动画停止, 重新定位到 第50组(中间那组) 模型
        collectionView.scrollToItem(at: NSIndexPath(row: 100 / 2 * DataModel.shareDemoData().count + index, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CollectionCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCardCell", for: indexPath) as! CollectionCardCell
        let index = indexArray[indexPath.row].intValue
        let model = DataModel.shareDemoData()[index]
        model.index = index
        cell.model = model
        return cell
    }
}
