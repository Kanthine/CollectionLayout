//
//  YLCollectionCardLayout.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YLCollectionCardType){
    YLCollectionCardTypeCoverFlow = 0,
};


///卡片翻转
@interface YLCollectionCardLayout : UICollectionViewFlowLayout
@property (nonatomic ,assign) YLCollectionCardType cardType;
@property (nonatomic, assign) CGFloat itemOffset;
@end

NS_ASSUME_NONNULL_END
