//
//  YLCollectionTransitionAnimationLayout.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/28.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface YLCollectionTransitionAnimationAttributes : UICollectionViewLayoutAttributes

///缓存 cell.contentView
@property (nonatomic ,strong) UIView *contentView;

///记录 UICollectionView 滚动方向
@property (nonatomic ,assign) UICollectionViewScrollDirection scrollDirection;

/// The ratio of the distance between the start of the cell and the start of the collectionView and the height/width of the cell depending on the scrollDirection. It's 0 when the start of the cell aligns the start of the collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
/**
 *
 */
@property (nonatomic ,assign) CGFloat startOffset;

/// The ratio of the distance between the center of the cell and the center of the collectionView and the height/width of the cell depending on the scrollDirection. It's 0 when the center of the cell aligns the center of the collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
@property (nonatomic ,assign) CGFloat middleOffset;

/// The ratio of the distance between the **start** of the cell and the end of the collectionView and the height/width of the cell depending on the scrollDirection. It's 0 when the **start** of the cell aligns the end of the collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
@property (nonatomic ,assign) CGFloat endOffset;

@end




///转场动画类型
typedef NS_ENUM(NSUInteger,YLCollectionTransitionType) {
    YLCollectionTransitionNone = 0,
    YLCollectionTransitionCube,
    YLCollectionTransitionCover,//覆盖
    YLCollectionTransitionCard,
    YLCollectionTransitionParallax,
    YLCollectionTransitionCrossFade,
    YLCollectionTransitionRotateInOut,
    YLCollectionTransitionZoomInOut,
};


///转场动画 FlowLayout
@interface YLCollectionTransitionAnimationLayout : UICollectionViewFlowLayout

///转场动画类型
@property (nonatomic ,assign) YLCollectionTransitionType transitionType;

@end

NS_ASSUME_NONNULL_END
