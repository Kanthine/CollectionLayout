

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <QuartzCore/QuartzCore.h>
#if defined USING_CHAMELEON || defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
#else
#define ICAROUSEL_MACOS
#endif


#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef NS_ENUM(NSInteger, iCarouselType)
{
    iCarouselTypeCoverFlow = 0,
};


typedef NS_ENUM(NSInteger, iCarouselOption)
{
    iCarouselOptionWrap = 0,
    iCarouselOptionShowBackfaces,
    iCarouselOptionOffsetMultiplier,
    iCarouselOptionVisibleItems,
    iCarouselOptionCount,
    iCarouselOptionArc,
    iCarouselOptionAngle,
    iCarouselOptionRadius,
    iCarouselOptionTilt,
    iCarouselOptionSpacing,
    iCarouselOptionFadeMin,
    iCarouselOptionFadeMax,
    iCarouselOptionFadeRange,
    iCarouselOptionFadeMinAlpha
};


NS_ASSUME_NONNULL_BEGIN

@protocol iCarouselDataSource, iCarouselDelegate;

@interface iCarousel : UIView

@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDelegate> delegate;
@property (nonatomic, assign) iCarouselType type;
//@property (nonatomic, assign) CGFloat perspective;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, assign) CGFloat bounceDistance;
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign, getter = isVertical) BOOL vertical;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) CGFloat itemOffset;
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGSize contentOffset;
//@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
@property (nonatomic, assign) NSInteger currentItemIndex;
@property (nonatomic, strong, readonly) UIView * __nullable currentItemView;
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, readonly) CGFloat toggle;
@property (nonatomic, assign) CGFloat autoscroll;
@property (nonatomic, assign) BOOL stopAtItemBoundary;
@property (nonatomic, assign) BOOL scrollToItemBoundary;
@property (nonatomic, assign) BOOL ignorePerpendicularSwipes;
@property (nonatomic, assign) BOOL centerItemWhenSelected;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (nullable UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;
- (nullable UIView *)itemViewAtPoint:(CGPoint)point;

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end


@protocol iCarouselDataSource <NSObject>

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@optional

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@end


@protocol iCarouselDelegate <NSObject>
@optional



- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
