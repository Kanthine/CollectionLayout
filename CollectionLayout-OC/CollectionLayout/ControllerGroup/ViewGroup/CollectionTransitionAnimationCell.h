//
//  CollectionTransitionAnimationCell.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/28.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

///转场动画
@interface CollectionTransitionAnimationCell : UICollectionViewCell
@property (nonatomic ,strong) DataModel *model;
@end

NS_ASSUME_NONNULL_END
