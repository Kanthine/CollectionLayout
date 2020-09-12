//
//  DataModel.m
//  PinterestDemo
//
//  Created by 苏沫离 on 2020/8/10.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (NSArray<NSString *> *)introsArray{
    return @[@"两千年中国政治伦理与社会伦理的基石",
             @"不把这本书读懂、读通、读透，就不能深刻理解和把握中国几千年的传统文化。",
             @"构建中华文明阶梯的重要典籍",
             @"影响人类文化的100本书之一",
             @"最能代表中国文化的哲学书",
             @"一部划时代的巨作",
             @"长途绿皮火车悠悠的驶入了终点站——中港市，林昆穿着一身地摊货，背着个破帆布包，晃晃荡荡的从车站里出来，刚一出来就被一群人给围住。兄弟，住店不！来我们店吧，经济实惠，还有特殊服务！兄弟，跟姐走吧，姐包你满意！林昆回头一看，顿时一哆嗦，那位口口声声包他满意的姐至少五十多岁，长的又黑又老又丑，就是动物园里的大猩猩，也比她婀娜的多啊林昆赶紧从人群里挤出来，来到了旁边专门停出租车的空地上，钻进了一辆出租车里。小伙子，去哪啊！”司机师傅热情的笑道，同时眼眶里闪过一抹狡黠之色。\n这司机是常年混火车站这一片的，一眼就看出了林昆是个外来的吊丝，心里头正琢磨着待会儿故意绕几个圈子，好宰这个小子一顿，林昆把一张纸条递了过来。去这里。司机师傅接过纸条一看，脸顿时绿了，嘴角的笑容也是微微一颤，只见纸条上写着：天楚国际大厦，走西南路，转高架桥，全程1",
             @"当今社会的 救世箴言",
             @"欧洲历代君主的案头书，政治家的最高指南",
             @"以史为鉴，知千秋盛衰兴替；前事不忘，明万代是非得失",
             @"一部治国安邦、立身处世的最佳教科书",
             @"兵家韬略之首",@"一部包含着丰富的智慧和谋略的杰作",
             @"司机师傅热情的笑道，同时眼眶里闪过一抹狡黠之色",@"角的笑容也是微微一颤，只见纸条上写着：天楚国际大厦，走西南路，转高",];
}


+ (NSMutableArray<DataModel *> *)shareDemoData{
    static NSMutableArray *shareArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DataModel creatDemoData:^(NSMutableArray<DataModel *> * _Nonnull array) {
            shareArray = array;
        }];
    });
    return shareArray;
}

+ (void)creatDemoData:(void(^)(NSMutableArray<DataModel *> *array))dataBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [NSMutableArray array];
        NSArray<NSString *> *itemArray = @[@"学生",@"媒体",@"公关",@"摄影",
                                           @"动漫",@"设计",@"影视",@"音乐",
                                           @"模特",@"体育运动",@"互联网",@"IT",
                                           @"通讯",@"金融保险",@"商业服务"];
        NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];
        for (int i = 1; i < 16; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [imageArray addObject:image];
        }
        [itemArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DataModel *model = [[DataModel alloc] init];
            model.title = itemArray[idx];
            model.detaile = DataModel.introsArray[idx];
            model.image = imageArray[idx];
            [array addObject:model];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dataBlock(array);
        });
    });
}

@end


#import <objc/message.h>

@implementation DataModel (Alignment)

- (void)setAlignmentTitleSize:(CGSize)alignmentTitleSize{
    objc_setAssociatedObject(self, @selector(alignmentTitleSize), [NSValue valueWithCGSize:alignmentTitleSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (CGSize)alignmentTitleSize{
    CGSize size = [objc_getAssociatedObject(self, _cmd) CGSizeValue];
    if (size.width < 10) {
        CGSize textSize = [self.title boundingRectWithSize:CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]} context:nil].size;
        size = CGSizeMake(18 + textSize.width + 18,9 + textSize.height + 9);
        objc_setAssociatedObject(self, @selector(alignmentTitleSize), [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return size;
}

@end



@implementation DataModel (Pinterest)

- (void)setDetaileHeight:(CGFloat)detaileHeight{
    objc_setAssociatedObject(self, @selector(detaileHeight), @(detaileHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)detaileHeight{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setImageSize:(CGSize)imageSize{
    objc_setAssociatedObject(self, @selector(imageSize), [NSValue valueWithCGSize:imageSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)imageSize{
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

- (void)setCellHeight:(CGFloat)cellHeight{
    objc_setAssociatedObject(self, @selector(cellHeight), @(cellHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)cellHeight{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (CGFloat)cellHeightByWidth:(CGFloat)width{
    if (width < 30) {
        return 0;
    }
    
    if (self.cellHeight < 8) {
        self.imageSize = CGSizeMake(width, self.image.size.height / self.image.size.width * width);
        self.detaileHeight = [self.detaile boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height + 2;
        self.cellHeight = self.imageSize.height + 8 + self.detaileHeight;
    }
    return self.cellHeight;
}

@end
