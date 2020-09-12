//
//  DataModel.swift
//  CollectionLayout-Swift
//
//  Created by 苏沫离 on 2020/9/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    var title : NSString!
    var detaile : NSString!
    var image : UIImage!
    var index : NSInteger!
    

    /// 延迟加载并返回FilesContentBuilder的单例实例
    struct Singleton{
        static var onceToken : Int = 0
        static var shareArray:[DataModel] = [DataModel]()
    }
    private static var __once: () = {
        creatDemoData { (array : [DataModel]) in
            Singleton.shareArray = array
        }
    }()
    //单例
    class func shareDemoData()->[DataModel]{
        _ = DataModel.__once
        return Singleton.shareArray
    }
    
}

///分类里面不能存储属性，只能通过关联属性来达到目的
extension DataModel{
    
    
    private struct AssociatedKey {
        static var alignmentTitleSizeKey = "alignmentTitleSizeKey"
        ///瀑布流
        static var detaileHeight: CGFloat = 0.0
        static var cellHeight: CGFloat = 0.0
        static var imageSize: CGSize = CGSize.zero
    }
    ///左对齐/右对齐
    public var alignmentTitleSize: CGSize {
        get {
            var size = objc_getAssociatedObject(self, &AssociatedKey.alignmentTitleSizeKey) as! CGSize
            if size.width < 10 {
                let textSize = self.title.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: 200), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil).size
                size = CGSize(width: 18 + textSize.width + 18, height: 9 + textSize.height + 9)
                objc_setAssociatedObject(self, &AssociatedKey.alignmentTitleSizeKey, size, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            return size;
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.alignmentTitleSizeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var imageSize: CGSize {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.imageSize) as! CGSize
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.imageSize, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    public var detaileHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.detaileHeight) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.detaileHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    public var cellHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.cellHeight) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.cellHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func cellHeightByWidth(width:CGFloat) -> CGFloat {
        if width < 30 {
            return 0
        }
        
        if self.cellHeight < 8 {
            self.imageSize = CGSize(width: width, height: self.image.size.height / self.image.size.width * width)
            self.detaileHeight = self.detaile.boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], context: nil).size.height + 2
            self.cellHeight = self.imageSize.height + 8 + self.detaileHeight;
        }
        return self.cellHeight
    }
}




func introsArray() -> [String] {
    return ["两千年中国政治伦理与社会伦理的基石",
    "不把这本书读懂、读通、读透，就不能深刻理解和把握中国几千年的传统文化。",
    "构建中华文明阶梯的重要典籍",
    "影响人类文化的100本书之一",
    "最能代表中国文化的哲学书",
    "一部划时代的巨作",
    "长途绿皮火车悠悠的驶入了终点站——中港市，林昆穿着一身地摊货，背着个破帆布包，晃晃荡荡的从车站里出来，刚一出来就被一群人给围住。兄弟，住店不！来我们店吧，经济实惠，还有特殊服务！兄弟，跟姐走吧，姐包你满意！林昆回头一看，顿时一哆嗦，那位口口声声包他满意的姐至少五十多岁，长的又黑又老又丑，就是动物园里的大猩猩，也比她婀娜的多啊林昆赶紧从人群里挤出来，来到了旁边专门停出租车的空地上，钻进了一辆出租车里。小伙子，去哪啊！”司机师傅热情的笑道，同时眼眶里闪过一抹狡黠之色。\n这司机是常年混火车站这一片的，一眼就看出了林昆是个外来的吊丝，心里头正琢磨着待会儿故意绕几个圈子，好宰这个小子一顿，林昆把一张纸条递了过来。去这里。司机师傅接过纸条一看，脸顿时绿了，嘴角的笑容也是微微一颤，只见纸条上写着：天楚国际大厦，走西南路，转高架桥，全程1",
    "当今社会的 救世箴言",
    "欧洲历代君主的案头书，政治家的最高指南",
    "以史为鉴，知千秋盛衰兴替；前事不忘，明万代是非得失",
    "一部治国安邦、立身处世的最佳教科书",
    "兵家韬略之首","一部包含着丰富的智慧和谋略的杰作",
    "司机师傅热情的笑道，同时眼眶里闪过一抹狡黠之色","角的笑容也是微微一颤，只见纸条上写着：天楚国际大厦，走西南路，转高",]
}

/// @escaping 逃逸闭包
func creatDemoData(dataBlock: @escaping (_ array: [DataModel]) -> Void ) {
    DispatchQueue.global().async {
        let resultArray = NSMutableArray()
        let itemArray = ["学生","媒体","公关","摄影","动漫","设计","影视","音乐",
                         "模特","体育运动","互联网","IT","通讯","金融保险","商业服务"];
        for i in 1 ..< 16 {
            let model = DataModel()
            model.title = itemArray[i - 1] as NSString
            model.detaile = introsArray()[i - 1] as NSString
            model.image = UIImage(named: "\(i)")
            model.alignmentTitleSize = CGSize.zero
            resultArray.add(model)
        }
        DispatchQueue.main.async {
            dataBlock(resultArray as! [DataModel])
        }
    }
}
