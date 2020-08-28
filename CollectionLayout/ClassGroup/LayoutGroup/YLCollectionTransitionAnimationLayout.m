//
//  YLCollectionTransitionAnimationLayout.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/28.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "YLCollectionTransitionAnimationLayout.h"

@interface UIView (AnchorPoint)
- (void)keepCenterAndApplyAnchorPoint:(CGPoint)point;
@end
@implementation UIView (AnchorPoint)

- (void)keepCenterAndApplyAnchorPoint:(CGPoint)point{
    if (CGPointEqualToPoint(self.layer.anchorPoint, point)) {
        return;
    }
    
    CGPoint newPoint = CGPointMake(CGRectGetWidth(self.bounds) * point.x, CGRectGetHeight(self.bounds) * point.y);
    CGPoint oldPoint = CGPointMake(CGRectGetWidth(self.bounds) * self.layer.anchorPoint.x, CGRectGetHeight(self.bounds)  * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint c = self.layer.position;
    c.x -= oldPoint.x;
    c.x += newPoint.x;
    
    c.y -= oldPoint.y;
    c.y += newPoint.y;
    
    self.layer.position = c;
    self.layer.anchorPoint = point;
}

@end


#pragma mark - 动画操作者

///基类
@interface YLCollectionTransitionAnimationOperator : NSObject
///动画
- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes;
@end
@implementation YLCollectionTransitionAnimationOperator
- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{}
@end



/// Cube 动画
@interface YLCollectionCubeAnimation : YLCollectionTransitionAnimationOperator

/// The perspective that will be applied to the cells. Must be negative. -1/500 by default.
/// Recommended range [-1/2000, -1/200].
@property (nonatomic ,assign) CGFloat perspective;
/// The higher the angle is, the _steeper_ the cell would be when transforming.
@property (nonatomic ,assign) CGFloat totalAngle;

@end

@implementation YLCollectionCubeAnimation

- (instancetype)init{
    return [self initWithPerspective: -1.0 / 500.0 totalAngle:M_PI_2];
}

- (instancetype)initWithPerspective:(CGFloat)perspective totalAngle:(CGFloat)totalAngle{
    self = [super init];
    if (self) {
        self.perspective = perspective;
        self.totalAngle = totalAngle;
    }
    return self;
}

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    CGFloat position = attributes.middleOffset;
    if (fabs(position) >= 1) {
        attributes.contentView.layer.transform = CATransform3DIdentity;
        [attributes.contentView keepCenterAndApplyAnchorPoint:CGPointMake(0.5, 0.5)];
    } else if (attributes.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat rotateAngle = self.totalAngle * position;
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = self.perspective;
        transform = CATransform3DRotate(transform, rotateAngle, 0, 1, 0);
        attributes.contentView.layer.transform = transform;
        [attributes.contentView keepCenterAndApplyAnchorPoint:CGPointMake(position > 0 ? 0 : 1, 0.5)];
    } else {
        CGFloat rotateAngle = self.totalAngle * position;
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = self.perspective;
        transform = CATransform3DRotate(transform, rotateAngle, -1, 0, 0);
        attributes.contentView.layer.transform = transform;
        [attributes.contentView keepCenterAndApplyAnchorPoint:CGPointMake(0.5, position > 0 ? 0 : 1)];
    }
}
@end


/// An animator that turns the cells into card mode.
/// - warning: You need to set `clipsToBounds` to `false` on the cell to make
/// this effective.
@interface YLCollectionCardAnimation : YLCollectionTransitionAnimationOperator

/// The alpha to apply on the cells that are away from the center. Should be
/// in range [0, 1]. 0.5 by default.
@property (nonatomic ,assign) CGFloat minAlpha;

/// The spacing ratio between two cells. 0.4 by default.
@property (nonatomic ,assign) CGFloat itemSpacing;

/// The scale rate that will applied to the cells to make it into a card.
@property (nonatomic ,assign) CGFloat scaleRate;

@end

@implementation YLCollectionCardAnimation

- (instancetype)init{
    return [self initWithMinAlpha:0.5 itemSpacing:0.4 scaleRate:0.7];
}

- (instancetype)initWithMinAlpha:(CGFloat)minAlpha itemSpacing:(CGFloat)itemSpacing scaleRate:(CGFloat)scaleRate{
    self = [super init];
    if (self) {
        self.minAlpha = minAlpha;
        self.itemSpacing = itemSpacing;
        self.scaleRate = scaleRate;
    }
    return self;
}

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    CGFloat position = attributes.middleOffset;
    CGFloat scaleFactor = self.scaleRate - 0.1 * fabs(position);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGAffineTransform translationTransform;
    if (attributes.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat width = collectionView.frame.size.width;
        CGFloat translationX = -(width * self.itemSpacing * position);
        translationTransform = CGAffineTransformMakeTranslation(translationX, 0);
    }else {
        CGFloat height = collectionView.frame.size.height;
        CGFloat translationY = -(height * self.itemSpacing * position);
        translationTransform = CGAffineTransformMakeTranslation(0, translationY);
    }
    attributes.alpha = 1.0 - fabs(position) + self.minAlpha;
    attributes.transform = CGAffineTransformConcat(translationTransform, scaleTransform);
}

@end



/// 覆盖 动画
@interface YLCollectionCoverAnimation : YLCollectionTransitionAnimationOperator
/// The max scale that would be applied to the current cell. 0 means no scale. 0.2 by default.
@property (nonatomic ,assign) CGFloat scaleRate;
@end

@implementation YLCollectionCoverAnimation

- (instancetype)init{
    return [self initWithScaleRate:0.2];
}

- (instancetype)initWithScaleRate:(CGFloat)scaleRate{
    self = [super init];
    if (self) {
        self.scaleRate = scaleRate;
    }
    return self;
}

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    CGFloat position = attributes.middleOffset;
    CGPoint contentOffset = collectionView.contentOffset;
    CGPoint itemOrigin = attributes.frame.origin;
    CGFloat scaleFactor = self.scaleRate * MIN(position, 0.0) + 1.0;
    CGAffineTransform transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    if (attributes.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGAffineTransform transform_1 = CGAffineTransformMakeTranslation(position < 0 ? contentOffset.x - itemOrigin.x : 0, 0);
        transform = CGAffineTransformConcat(transform, transform_1);
    } else {
        CGAffineTransform transform_1 = CGAffineTransformMakeTranslation(0, position < 0 ? contentOffset.y - itemOrigin.y : 0);
        transform = CGAffineTransformConcat(transform, transform_1);
    }
    attributes.transform = transform;
    attributes.zIndex = attributes.indexPath.row;
}

@end




/// An animator that implemented the parallax effect by moving the content of the cell
/// slower than the cell itself.
/// 覆盖 动画
@interface YLCollectionParallaxAnimation : YLCollectionTransitionAnimationOperator
/// The higher the speed is, the more obvious the parallax.
/// It's recommended to be in range [0, 1] where 0 means no parallax. 0.5 by default.
@property (nonatomic ,assign) CGFloat speed;
@end

@implementation YLCollectionParallaxAnimation

- (instancetype)init{
    return [self initWithSpeed:0.2];
}

- (instancetype)initWithSpeed:(CGFloat)speed{
    self = [super init];
    if (self) {
        self.speed = speed;
    }
    return self;
}

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    CGFloat position = attributes.middleOffset;
    if (fabs(position) >= 1) {
        // Reset views that are invisible.
        attributes.contentView.frame = attributes.bounds;
    } else if (attributes.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat width = CGRectGetWidth(collectionView.frame);
        CGFloat transitionX = -(width * self.speed * position);
        CGAffineTransform transform = CGAffineTransformMakeTranslation(transitionX, 0);
        CGRect newFrame = CGRectApplyAffineTransform(attributes.bounds, transform);
        attributes.contentView.frame = newFrame;
    } else {
        CGFloat height = CGRectGetHeight(collectionView.frame);
        CGFloat transitionY = -(height * self.speed * position);
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, transitionY);
        // By default, the content view takes all space in the cell
        CGRect newFrame = CGRectApplyAffineTransform(attributes.bounds, transform);
        // We don't use transform here since there's an issue if layoutSubviews is called
        // for every cell due to layout changes in binding method.
        attributes.contentView.frame = newFrame;
    }
}

@end



@interface YLCollectionCrossFadeAnimation : YLCollectionTransitionAnimationOperator
@end
@implementation YLCollectionCrossFadeAnimation

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    attributes.frame = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y, CGRectGetWidth(attributes.frame), CGRectGetHeight(attributes.frame));
    attributes.alpha = 1.0 - fabs(attributes.middleOffset);
}

@end


/// An animator that rotating the cell in/out when you scroll.
@interface YLCollectionRotateInOutAnimation : YLCollectionTransitionAnimationOperator

/// The alpha to apply on the cells that are away from the center. Should be
/// in range [0, 1]. 0 by default.
@property (nonatomic ,assign) CGFloat minAlpha;

/// The max rotating angle that would be applied to the cell. Should be in
/// range [0, 2pi]. PI/4 by default.
@property (nonatomic ,assign) CGFloat maxRotate;

@end

@implementation YLCollectionRotateInOutAnimation

- (instancetype)init{
    return [self initWithMinAlpha: 0.0 maxRotate:M_PI_4];
}
//perspective: -0.002, totalAngle: 1.5707963267948966))
- (instancetype)initWithMinAlpha:(CGFloat)minAlpha maxRotate:(CGFloat)maxRotate{
    self = [super init];
    if (self) {
        self.minAlpha = minAlpha;
        self.maxRotate = maxRotate;
    }
    return self;
}

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    CGFloat position = attributes.middleOffset;
    if (fabs(position) >= 1) {
        attributes.transform = CGAffineTransformIdentity;
        attributes.alpha = 1.0;
    }else {
        CGFloat rotateFactor = self.maxRotate * position;
        attributes.zIndex = attributes.indexPath.row;
        attributes.alpha = 1.0 - fabs(position) + self.minAlpha;
        attributes.transform = CGAffineTransformMakeRotation(rotateFactor);
    }
}
@end





/// An animator that zoom in/out cells when you scroll.
@interface YLCollectionZoomInOutAnimation : YLCollectionTransitionAnimationOperator

/// The scaleRate decides the maximum scale rate where 0 means no scale and
/// 1 means the cell will disappear at min. 0.2 by default.
@property (nonatomic ,assign) CGFloat scaleRate;

@end

@implementation YLCollectionZoomInOutAnimation

- (instancetype)init{
    return [self initWithScaleRate:0.2];
}

- (instancetype)initWithScaleRate:(CGFloat)scaleRate{
    self = [super init];
    if (self) {
        self.scaleRate = scaleRate;
    }
    return self;
}

- (void)transitionAnimationWithCollectionView:(UICollectionView *)collectionView attributes:(YLCollectionTransitionAnimationAttributes *)attributes{
    CGFloat position = attributes.middleOffset;
    if (position >= -1 && position <= 0) {
        CGFloat scaleFactor = self.scaleRate * position + 1.0;
        attributes.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    }else {
        attributes.transform = CGAffineTransformIdentity;
    }
}
@end






@implementation YLCollectionTransitionAnimationAttributes

/// 需要实现这个方法，collectionView 实时布局时，会copy参数，确保自身的参数被copy
- (id)copyWithZone:(NSZone *)zone{
    YLCollectionTransitionAnimationAttributes *copy = [super copyWithZone:zone];
    if (copy) {
        copy.contentView = self.contentView;
        copy.scrollDirection = self.scrollDirection;
        copy.startOffset = self.startOffset;
        copy.middleOffset = self.middleOffset;
        copy.endOffset = self.endOffset;
    }
    return copy;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:YLCollectionTransitionAnimationAttributes.class]) {
        return NO;
    }
    YLCollectionTransitionAnimationAttributes *attributes = (YLCollectionTransitionAnimationAttributes *)object;
    return [super isEqual:object] &&
            self.contentView == attributes.contentView &&
            self.scrollDirection == attributes.scrollDirection &&
            self.startOffset == attributes.startOffset &&
            self.middleOffset == attributes.middleOffset &&
            self.endOffset == attributes.endOffset;
}

@end


@interface YLCollectionTransitionAnimationLayout ()

/// 过渡动画的执行者
@property (nonatomic ,strong) YLCollectionTransitionAnimationOperator *animationOperator;

@end



@implementation YLCollectionTransitionAnimationLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumLineSpacing = 0.0;
        self.minimumInteritemSpacing = 0.0;
        self.transitionType = YLCollectionTransitionCard;
    }
    return self;
}

- (void)setTransitionType:(YLCollectionTransitionType)transitionType{
    if (_transitionType != transitionType) {
        _transitionType = transitionType;
        
        switch (transitionType) {
            case YLCollectionTransitionCube:{
                _animationOperator = [[YLCollectionCubeAnimation alloc] init];
            }break;
            case YLCollectionTransitionCard:{
                _animationOperator = [[YLCollectionCardAnimation alloc] init];
            }break;
            case YLCollectionTransitionCover:{
                _animationOperator = [[YLCollectionCoverAnimation alloc] init];
            }break;
            case YLCollectionTransitionParallax:{
                _animationOperator = [[YLCollectionParallaxAnimation alloc] init];
            }break;
            case YLCollectionTransitionCrossFade:{
                _animationOperator = [[YLCollectionCrossFadeAnimation alloc] init];
            }break;
            case YLCollectionTransitionRotateInOut:{
                _animationOperator = [[YLCollectionRotateInOutAnimation alloc] init];
            }break;
            case YLCollectionTransitionZoomInOut:{
                _animationOperator = [[YLCollectionZoomInOutAnimation alloc] init];
            }break;
            default:
                _animationOperator = nil;
                break;
        }
        
        [self invalidateLayout];
    }
}

+ (Class)layoutAttributesClass{
    return YLCollectionTransitionAnimationAttributes.class;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<YLCollectionTransitionAnimationAttributes *> *attributesArray = [super layoutAttributesForElementsInRect:rect];
    [attributesArray enumerateObjectsUsingBlock:^(YLCollectionTransitionAnimationAttributes * _Nonnull attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /**
         The position for each cell is defined as the ratio of the distance between
         the center of the cell and the center of the collectionView and the collectionView width/height
         depending on the scroll direction. It can be negative if the cell is, for instance,
         on the left of the screen if you're scrolling horizontally.
         */
        
        CGFloat distance = 0.0;
        CGFloat itemOffset = 0.0;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            distance = CGRectGetHeight(self.collectionView.frame);
            itemOffset = attribute.center.y - self.collectionView.contentOffset.y;
            attribute.startOffset = (attribute.frame.origin.y - self.collectionView.contentOffset.y) / CGRectGetHeight(attribute.frame);
            attribute.endOffset = (attribute.frame.origin.y - self.collectionView.contentOffset.y - CGRectGetHeight(self.collectionView.frame)) / CGRectGetHeight(attribute.frame);
        }else{
            distance = CGRectGetWidth(self.collectionView.frame);
            itemOffset = attribute.center.x - self.collectionView.contentOffset.x;
            attribute.startOffset = (attribute.frame.origin.x - self.collectionView.contentOffset.x) / CGRectGetWidth(attribute.frame);
            attribute.endOffset = (attribute.frame.origin.x - self.collectionView.contentOffset.x - CGRectGetWidth(self.collectionView.frame)) /CGRectGetWidth(attribute.frame);
        }
        
        attribute.scrollDirection = self.scrollDirection;
        attribute.middleOffset = itemOffset / distance - 0.5;
        
        if (attribute.contentView == nil){
            attribute.contentView = [self.collectionView cellForItemAtIndexPath:attribute.indexPath].contentView;
        }
        
        [self.animationOperator transitionAnimationWithCollectionView:self.collectionView attributes:attribute];
    }];
    return attributesArray;
}
//The ratio of the distance between the start of the cell and the start of the collectionView and the height/width of the cell depending on the scrollDirection.
//It's 0 when the start of the cell aligns the start of the collectionView.
//It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
/// 单元格的开始和collectionView的开始之间的距离与单元格的高度/宽度的比率取决于滚动方向。
/// 当单元格的开始与collectionView的开始对齐时，它是0。当单元格向滚动方向移动(右/下)时，它为正，而当相反方向移动时，它为负。

@end
