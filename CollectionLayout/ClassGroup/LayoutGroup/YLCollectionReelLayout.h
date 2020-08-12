//
//  YLCollectionReelLayout.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/12.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLCollectionReelLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic ,assign) CGPoint anchorPoint;//添加锚点
@end

///转轮效果
@interface YLCollectionReelLayout : UICollectionViewFlowLayout

@property (nonatomic ,assign) CGFloat radius;//半径


@end

NS_ASSUME_NONNULL_END
