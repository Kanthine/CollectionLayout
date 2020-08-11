//
//  YLCollectionPinterestLayout.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YLCollectionPinterestLayout;

@protocol YLCollectionPinterestLayoutDelegate <NSObject>

@required

/** 每个item的高度
 * @param itemWidth 宽度确定，高度自适应内容
 */
- (CGFloat)YLLayout:(YLCollectionPinterestLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional

/** SectionHeader/SectionFooter 的大小
 */
-(CGSize)YLLayout:(YLCollectionPinterestLayout *)layout elementOfKind:(NSString *)elementOfKind referenceSizeInSection:(NSInteger)section;


/** 指定的分区有多少列
 * @param section 指定的分区
 * 默认列数为 colunmCount
 */
- (NSUInteger)columnCountInYLLayout:(YLCollectionPinterestLayout *)layout forSection:(NSInteger)section;

/** 指定分区的内边距
 * 默认为 sectionInset
 */
- (UIEdgeInsets)edgeInsetsInYLLayout:(YLCollectionPinterestLayout *)layout forSection:(NSInteger)section;

/** 每列之间的间距
 *  默认为 minimumInteritemSpacing
 */
- (CGFloat)columnSpaceInYLLayout:(YLCollectionPinterestLayout *)layout forSection:(NSInteger)section;

/** 每行之间的间距
 * 默认为 minimumLineSpacing
 */
- (CGFloat)rowSpaceInYLLayout:(YLCollectionPinterestLayout *)layout forSection:(NSInteger)section;

@end

/** 瀑布流布局 : 确定宽度，高度自适应
 * 设置每个分区的 内边距 UIEdgeInsets； 设置每个分区的列与列之间的间距；设置多少个列
 * 根据列数、间距，计算出固定的宽度
 * 高度自适应内容
 */
@interface YLCollectionPinterestLayout : UICollectionViewFlowLayout

/** 列数,默认为 2
 * 根据列数，间距，计算出固定的宽度
 */
@property (nonatomic, assign) NSUInteger colunmCount;

/** 代理 */
@property (nonatomic, weak) id<YLCollectionPinterestLayoutDelegate> delegate;

@end


NS_ASSUME_NONNULL_END
