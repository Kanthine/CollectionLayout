//
//  YLCollectionAlignmentLayout.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,YLCollectionAlignment) {
    YLCollectionAlignmentLeft = 0,//左对齐
    YLCollectionAlignmentRight//右对齐
};

@protocol  YLCollectionAlignmentLayoutDelegate<NSObject>

@required

/** 每个item的宽度
 */
- (CGSize)collectionViewSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/** SectionHeader/SectionFooter 的大小
 */
-(CGSize)collectionViewElementOfKind:(NSString *)elementOfKind referenceSizeInSection:(NSInteger)section;

@end

/** 水平对齐方式
 */
@interface YLCollectionAlignmentLayout : UICollectionViewFlowLayout

@property(nonatomic , weak) id <YLCollectionAlignmentLayoutDelegate> alignmentDelegate;
@property(nonatomic ,assign) YLCollectionAlignment cellAlignmentType;

@end



NS_ASSUME_NONNULL_END


