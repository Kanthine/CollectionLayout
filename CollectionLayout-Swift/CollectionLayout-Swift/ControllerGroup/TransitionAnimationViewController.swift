//
//  TransitionAnimationViewController.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//


import UIKit

class YLSheetView: UIView {
    
    let itemArray : [String] = ["None","Cube","Cover","Open","Pan","Card","Parallax","CrossFade","RotateInOut","ZoomInOut",]
    private var didSelectedBlock:((_ transitionType : YLCollectionTransitionType,_ item : String) -> Void)?
    
    ///懒加载
    lazy var coverButton : UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.frame = UIScreen.main.bounds        
        button.addTarget(self, action: #selector(dismissButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var contentView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 124))
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.textAlignment = .center
        label.text = "Transition Type"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(label)
        
        for idx in 0 ..< itemArray.count {
            let item = itemArray[idx]
            let button = UIButton(type: .custom)
            button.tag = idx
            button.addTarget(self, action: #selector(handleButtonClick(sender:)), for: .touchUpInside)
            button.frame = CGRect(x: 12, y: 30 + 40 * idx, width: Int(view.bounds.width - 12.0 * 2.0), height: 40)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(UIColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1), for: .normal)
            button.setTitle("YLCollectionTransition\(item)", for: .normal)
            view.addSubview(button)
        }

        let height = 30 + 40 * itemArray.count + 34
        view.frame = CGRect(x: 0, y: Int(UIScreen.main.bounds.height) - height, width: Int(UIScreen.main.bounds.width), height: height)
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: (UIRectCorner.topLeft), cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        return view
    }()
    
    convenience init(handle : @escaping (_ transitionType : YLCollectionTransitionType,_ item : String) -> Void ) {
        self.init(frame: UIScreen.main.bounds)
        didSelectedBlock = handle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverButton)
        addSubview(contentView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        (UIApplication.shared.delegate?.window)!!.addSubview(self)
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        coverButton.alpha = 0
        UIView.animate(withDuration: 0.2) { [self] in
            coverButton.alpha = 1.0
            contentView.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - response click
    @objc func dismissButtonClick() {
        UIView.animate(withDuration: 0.2) { [self] in
            coverButton.alpha = 0
            contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        } completion: { (finished : Bool) in
            self.removeFromSuperview()
        }
    }
    
    @objc func handleButtonClick(sender : UIButton) {
        didSelectedBlock!(YLCollectionTransitionType(rawValue: UInt(sender.tag))!,itemArray[sender.tag])
        dismissButtonClick()
    }
}



class TransitionAnimationViewController: UIViewController,UICollectionViewDelegate,
    UICollectionViewDataSource {
    ///懒加载
    lazy var rightButton : UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("Cube", for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonItemClick(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var collectionView : UICollectionView! = {
        let flowLayout = YLCollectionTransitionAnimationLayout()
        flowLayout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height - 120)
        flowLayout.scrollDirection = .horizontal
        flowLayout.transitionType = .cube

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 10, width: flowLayout.itemSize.width, height: flowLayout.itemSize.height), collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CollectionTransitionAnimationCell.self, forCellWithReuseIdentifier: "CollectionTransitionAnimationCell")
        return collectionView
    }()


    // MARK: - life cycyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "CardBack")!).withAlphaComponent(0.9)
        self.view.addSubview(collectionView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = self.view.bounds
    }


    // MARK: - response click
    @objc func rightBarButtonItemClick(sender : UIButton) {
    let flowLayout : YLCollectionTransitionAnimationLayout = collectionView.collectionViewLayout as! YLCollectionTransitionAnimationLayout
        let sheetView = YLSheetView { (transitionType : YLCollectionTransitionType,item : String) in
            sender.setTitle(item, for: .normal)
            flowLayout.transitionType = transitionType
        }
        collectionView.reloadData()
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataModel.shareDemoData().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CollectionTransitionAnimationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionTransitionAnimationCell", for: indexPath) as! CollectionTransitionAnimationCell

        let model = DataModel.shareDemoData()[indexPath.row]
        model.index = indexPath.row
        cell.model = model
        return cell
    }
}




