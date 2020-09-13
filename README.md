# CollectionLayout
UICollectionView的特效(使用Objective-C 语言 与 Swift 语言分别编写)

### 应用

左\右对齐|瀑布流|小说阅读器覆盖翻页|卡片轮转效果
:-: |:-: |:-: |:-:
![左\右对齐.gif](https://upload-images.jianshu.io/upload_images/7112462-602eb8480af4b6b8.gif?imageMogr2/auto-orient/strip)|![瀑布流.png](https://upload-images.jianshu.io/upload_images/7112462-3e3ce6bbcb76a21e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|![小说阅读器：覆盖翻页.gif](https://upload-images.jianshu.io/upload_images/7112462-413b88fda0fc5974.gif?imageMogr2/auto-orient/strip)|![卡片轮转效果.gif](https://upload-images.jianshu.io/upload_images/7112462-976ecfc01b30983a.gif?imageMogr2/auto-orient/strip)








`UICollectionView`包含三种类型的视觉元素：
* 单元格 `Cells` ：用于展示内容的主要元素，每个单元格表示集合中的单个数据项；
   具有交互性，以便用户可以执行选择、拖动和重新排序单元格等操作；
* 补充视图 `Supplementary views` ：可以理解为每个`Section`的`Header`或者`Footer`；用来实现指定部分或整个集合视图的页眉和页脚视图；
  补充视图是可选的，它们的使用和位置由布局对象定义；
* 装饰视图 `DecorationViews`：视觉装饰，每个`Section`的背景，不被 DataSounce 控制；
   是可选的，它们的使用和位置由布局对象定义。

`UICollectionView` 根据布局信息，将这些视图显示在屏幕上， 每次将项插入到`UICollectionView`或删除项时，都会对添加或删除的项进行额外的布局传递。

### 1、视图中每个项的布局属性

`UICollectionViewLayoutAttributes` 是封装的一个布局对象，用于管理 `UICollectionView` 中每个项的布局属性！

```
@interface UICollectionViewLayoutAttributes : NSObject <NSCopying, UIDynamicItem>

/** 指定项的坐标
 * 该值的设定，将影响到属性 center 与 size
 */
@property (nonatomic) CGRect frame;

/** 指定项的中点坐标
 *  该值的设定，将更新属性 frame.origin
 */
@property (nonatomic) CGPoint center;

/** 指定项的 size
 *  该值的设定，将更新属性 frame.size 和 bounds.size
 */
@property (nonatomic) CGSize size;

/** 指定项的三维变换
*/
@property (nonatomic) CATransform3D transform3D;

/** 指定项的边界
 *  设置 bounds.size 也将更新属性 size
 */
@property (nonatomic) CGRect bounds API_AVAILABLE(ios(7.0));

/** 指定项的仿射变换
 * @discussion CGAffineTransform 是一个用于绘制2D图形的仿射变换矩阵，用于做旋转、缩放、平移等
 */
@property (nonatomic) CGAffineTransform transform API_AVAILABLE(ios(7.0));

/** 指定项的透明度，默认值是 1.0
 * 取值范围：[0.0,1.0] ，0.0 表示完全透明，1.0 表示不透明
 */
@property (nonatomic) CGFloat alpha;

/** 指定项在 z 坐标轴的坐标，默认值为 0
 * 该值用于确定布局期间项目的 front-to-back 层级。索引值较高的项出现在值较低的项之上。
 * 具有相同值的项具有未确定的顺序
 */
@property (nonatomic) NSInteger zIndex; // default is 0

/** 指定的项是否显示，默认显示值为 NO
 * 作为一种优化，如果将此属性设置为YES，则 UICollectionView 可能不会创建相应的视图
 */
@property (nonatomic, getter=isHidden) BOOL hidden; 

/** 指定项在 UICollectionView 上的索引路径
 * indexPath.section 与 indexPath.item 两个值唯一确定指定项的位置
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/** 指定项的类型
 * 可以使用此属性中的值来区分布局属性是用于单元格、补充视图还是装饰视图。
 *  <ul> UICollectionElementCategory 的枚举值：
 *     <li> UICollectionElementCategoryCell 指定项是一个 cell
 *     <li> UICollectionElementCategorySupplementaryView 指定项是一个 supplementary view
 *     <li> UICollectionElementCategoryDecorationView 指定项是一个 DecorationView
 *  </ul>
 */
@property (nonatomic, readonly) UICollectionElementCategory representedElementCategory;

/** targetView 特定于布局的标识符
 *  使用该值来标识被关联的补充视图或装饰视图的特定用途。
 *  @note 如果属性 representedElementCategory = UICollectionElementCategoryCell值，则该值为 nil
 */
@property (nonatomic, readonly, nullable) NSString *representedElementKind;

/**  创建一个指定路径的 cell 的布局属性
 * @parma indexPath 单元格 cell 的索引路径
 */
+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath;

/**  创建一个指定路径的 SupplementaryView 的布局属性
 * @parma elementKind 标识补充视图类型的字符串
 *        <li> UICollectionElementKindSectionHeader 头部
 *        <li> UICollectionElementKindSectionFooter 尾部
 * @parma indexPath 补充视图 SupplementaryView 的索引路径
 * @discussion 补充视图通常是为特殊目的而设计的，例如，页眉和页脚视图的布局与单元格不同，可以为单个部分或作为一个整体提供给 CollectionView
 */
+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath;

/**  创建一个指定路径的 DecorationView 的布局属性
 * @parma decorationViewKind 标识装饰视图类型的标识符
 * @parma indexPath 装饰视图 DecorationView 的索引路径
 * @discussion 装饰视图不被 CollectionView 的 dataSource 管理，它们主要为一个部分或整个集合视图提供视觉装饰。
 *             使用参数 indexPath 来标识给定的装饰视图
 */
+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath;
@end
```

### 2、`UICollectionView` 的布局管理

[`UICollectionViewLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout?language=objc) 是为 `UICollectionView` 生成布局信息的抽象基类：该对象确定单元格、补充视图和装饰视图在 `UICollectionView` 内的位置；`UICollectionView`  将提供的布局信息应用于相应的视图，以便它们可以显示在屏幕上。

在子类化之前，考虑是否可以调整 `UICollectionViewCompositionalLayout` 来满足布局需求。

#### 2.1、 预处理：提供布局属性

下述方法提供了 `UICollectionView` 在屏幕上展示视图所需的基本布局信息。每个布局对象应该实现以下方法的几种：

```
@interface UICollectionViewLayout : NSObject <NSCoding>

/** 创建布局属性对象时要使用的类
 * 如果自定义 UICollectionViewLayoutAttributes 的子类 来管理额外的布局属性，必须重写该方法并返回自定义子类。
 * 创建布局属性的方法在创建新的布局属性对象时使用这个类。
 */
@property(class, nonatomic, readonly) Class layoutAttributesClass;

/** 返回collectionView内容的宽度和高度
 * @discussion 必须重写该方法；该值表示所有内容的宽度和高度，而不仅仅是当前可见的内容，collectionView 使用该值配置自己的内容大小，以便滚动。
 * @return 默认返回CGSizeZero
 */
@property(nonatomic, readonly) CGSize collectionViewContentSize;

/** 准备更新当前布局 ：在布局更新期间，首先调用该方法，预处理布局操作；
 * @discussion 当 CollectionView 第一次显示其内容时，需要调用 -prepareLayout 一次；
 *  当布局因视图的更改而显式或隐式无效时，需要再次调用 -prepareLayout ；
 * @note 该方法的默认实现不执行任何操作；重写该方法，预处理稍后布局所需的任何计算！
 */
- (void)prepareLayout;

///  UICollectionView 调用这四个方法来确定布局信息

/** 获取指定区域中所有视图（cell，supplementaryView，decorationViews）的布局属性
 * @param rect 指定区域
 * @discussion 重写该方法，返回所有视图的布局属性；不同类型的视图，使用不同的方法创建、管理；
 * @return 默认返回 nil
 * @note 针对固定布局，如瀑布流等可以使用数组缓存 LayoutAttributes ，不需要再次加载创建
 *       但是对于 cell 做的特效等场景，如卡片动画，需要实时的 LayoutAttributes，因此不能缓存，只能需要时创建！
*/
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

/** 根据 indexPath 获取 cell 对应的布局属性
 * @param indexPath cell 的索引
 * @discussion 必须重写该方法返回 cell 的布局信息。
 * @note 该方法仅为 cell 提供布局信息
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 返回 SupplementaryView 的布局属性
 * @discussion 如果 CollectionView 使用了SupplementaryView，则必须重写此方法并返回这些视图的布局信息；
 * @param elementKind 视图 SupplementaryView 类型
 *                    UICollectionElementKindSectionFooter
 *                    UICollectionElementKindSectionHeader
 * @param indexPath 索引
 * @note 如果布局不支持补充视图，则不必调用该方法；
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

/** 返回装饰视图 DecorationView 的布局属性
 * @discussion 如果 CollectionView 使用了DecorationView，则必须重写此方法并返回这些视图的布局信息；
 * @param elementKind 标识装饰视图 DecorationView 类型
 * @param indexPath 索引
 * @note 如果布局不支持装饰视图，则不必调用该方法；
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;

/** 当用户拖动项时，检索项的布局属性。
 * @param indexPath 被拖动之前，项的索引路径
 * @param position 被拖动项在 UICollectionView 坐标系中的当前位置
 * @note 如果重写此方法，先调用super以检索项的现有属性，然后对返回的结构进行更改
 * @return 返回一个项目现有属性的副本，有两个变化:
 *         中心点 center 被设置为 position，
 *         zIndex值被设置为NSIntegerMax，项目浮动在UICollectionView的其他项目之上
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position API_AVAILABLE(ios(9.0));

/** 检索在动画布局更新或更改后使用的内容偏移量
 * @param proposedContentOffset 在 UICollectionView 的内容视图的坐标空间中：可见内容左上角的建议点；
 *                              表示 UICollectionView 计算出的在动画结束时最有可能使用的值
 * @return 要使用的内容偏移量。该方法的默认实现返回proposedContentOffset参数中的值。
 * @discussion UICollectionView 在调用 -prepareLayout 和 -collectionViewContentSize 方法之后调用这个方法；
 *        有机会更改在动画结束时使用的proposedContentOffset； 如果动画或转换可能导致项目的定位方式不是最佳的，可以重写此方法；
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset API_AVAILABLE(ios(7.0));

/** 检索停止滚动的点
 * @param proposedContentOffset 在 UICollectionView 的内容视图中建议停止滚动的点;
 *                              在该值下，如果不进行任何调整，滚动将自然停止；
 * @param velocity 沿水平轴和垂直轴的当前滚动速度。该值以 每秒/点 为单位进行测量
 * @return 要使用的内容偏移量。这个值反映了调整后的可见区域的左上角。该方法的默认实现返回proposedContentOffset参数中的值。
 *
 * 如果您希望滚动行为抓取到特定的边界，您可以覆盖此方法并使用它来更改停止点。
 * 例如，您可以使用此方法始终在项目之间的边界上停止滚动，而不是在项目中间停止滚动。
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;//return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
@end
```



#### 2.2、 响应 `UICollectionView` 更新

 当 `UICollectionView` 中的数据发生更改并且要插入或删除项时，布局对象需要更新布局信息； 特别地，任何被拖动、添加或删除的项必须更新其布局信息以反映其新位置；
* 对于已拖动的项，`UICollectionView` 使用标准方法检索项的更新布局属性；
* 对于被插入或删除的项，`UICollectionView` 调用一些不同的方法，开发者应该覆盖这些方法来提供适当的布局信息:

```
/** 当UICollectionView经历动画转换时(如批更新块或动画边界更改)，将调用此方法集。
 * 对于屏幕上的每个元素在失效之前，finallayoutattributesfordisoriing 系列方法将被调用，并从屏幕上的内容到这些最终属性进行动画设置。
 * 对于失效后屏幕上的每个元素，initiallayoutattributesforappearance 系列方法将被调用，并设置从这些初始属性到最终屏幕上的内容的动画。
 */

/** 检索插入到 UICollectionView 中的项（Cell / SupplementaryView / DecorationView）的开始布局信息
 * @param indexPath 要插入的项的索引路径。
 * @return 布局属性对象，用于描述放置相应项的位置，默认返回nil ；
 * @discussion 在调用 -prepareForCollectionViewUpdates: 和 -finalizeCollectionViewUpdates 之间调用这个方法 , 返回描述项的初始位置和状态的布局信息；
 *    UICollectionView 使用这些信息作为任何动画的起点。(动画的终点是项目在集合视图中的新位置。)
 *    如果返回nil，布局对象使用项目的最终属性作为动画的开始点和结束点。
 */
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath;
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath;

/** 检索即将从 UICollectionView 中移除的项的最终布局信息
 * @param indexPath 被删除项的索引路径
 * @return 布局属性对象，描述要用作移除动画的结束点的项的位置，默认返回nil ；
 * @discussion 在调用 -prepareForCollectionViewUpdates: 和 -finalizeCollectionViewUpdates 之间调用这个方法 , 返回描述项目的最终位置和状态的布局信息；
 *     UICollectionView 使用此信息作为任何动画的终点。(动画的起始点是项目的当前位置。)
 *     如果返回nil，布局对象对动画的开始点和结束点使用相同的属性。
 */
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath;
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath;
```

除了上述方法之外，还可以重写以下方法做一些处理工作：

```
/** 当对 UICollectionView 进行删除/插入的更新时：
 *   1、首先调用此方法，让布局对象知道将要发生什么变化
 *   2、之后，会进行额外的调用，以收集将进行动画化的插入、删除和移动项的布局信息。
 * @param updateItems 移动到新索引路径的元素
 *
 * @note 它将在调用下面的 initial/final 布局属性方法之前调用，以使布局有机会对插入和删除布局属性进行批处理计算。
 */
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems;

/** 更新后在动画块Block内调用，执行任何额外的动画清理工作;
 * 用于执行所有插入、删除和移动动画的动画块中调用，以便根据需要使用此方法创建额外的动画。
 * 也可以使用它来执行与管理布局对象的状态信息相关的最后时刻的任务；
 */
- (void)finalizeCollectionViewUpdates;

/** 检索要添加到布局中的补充\装饰视图的索引路径数组
 * @param elementKind 视图的类型
 * @return 新的补充\装饰视图的位置；如果不想添加任何视图，可以返回一个空数组。
 * @discussion 向UICollectionView添加单元格或 sections 时，将调用该方法，促使布局对象有机会添加新的补充\装饰视图来补充添加的内容。
 *    在调用 -prepareForCollectionViewUpdates: 和 -finalizeCollectionViewUpdates 之间调用这个方法
 */
- (NSArray<NSIndexPath *> *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));
- (NSArray<NSIndexPath *> *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));

/** 检索表示要删除的补充视图的索引路径数组。
 * 一个NSIndexPath对象数组，表示你想要删除的补充视图，或者如果你不想删除任何给定类型的视图，一个空数组。
 * 每当您在集合视图中删除单元格或部分时，集合视图将调用此方法。实现此方法使布局对象有机会删除不再需要的任何补充视图。
 * 集合视图在调用prepareForCollectionViewUpdates:和finalizeCollectionViewUpdates之间调用这个方法。
 */
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));

/** 检索表示要删除的装饰视图的索引路径数组。
 * @return 一个NSIndexPath对象数组，表示要删除的装饰视图;如果不想删除任何给定类型的视图，则使用空数组。
 * @discussion 每当您在集合视图中删除单元格或部分时，集合视图将调用此方法。实现此方法使布局对象有机会删除不再需要的任何装饰视图。

 集合视图在调用prepareForCollectionViewUpdates:和finalizeCollectionViewUpdates之间调用这个方法。
 */
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind API_AVAILABLE(ios(7.0));

/** 当项目位于 UICollectionView 边界中的指定位置时，检索该项的索引路径
 * @param previousIndexPath 项的前一个索引路径
 * @param position 在 UICollectionView 中指定位置
 * @return 与 UICollectionView 中指定位置对应的索引路径
 * @discussion 在项目拖动期间，将 UICollectionView 中的点映射到对应于这些点位置的索引路径。
 *      默认实现搜索指定位置的现有单元格，并返回该单元格的索引路径。
 *      如果在同一位置有多个单元格，该方法将返回最上面的单元格：即 zIndex 值最大的单元格
 * 重写此方法，可以更改索引路径的确定方式。例如，返回具有 zIndex 最低值的单元格索引路径。
 * @note 如果覆盖此方法，则不需要调用super。
 */
- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position API_AVAILABLE(ios(9.0));
```

#### 2.3、使布局无效：优化布局性能

在自定义布局时，可以通过只取消布局中实际更改的部分来提高性能:
*   当更改项时，调用 `-invalidateLayout` 方法强制将 `UICollectionView` 重新计算它的所有布局信息并重新应用它;
*   一个更好的解决方案是只重新计算已更改的布局信息，这正是无效上下文允许您做的事情。

无效上下文允许您指定布局的哪些部分发生了更改, 然后，布局对象可以使用该信息来最小化它重新计算的数据量。

要自定义无效上下文，需要子类化 `UICollectionViewLayoutInvalidationContex`：在子类中，定义表示布局数据中可以独立重新计算的部分的自定义属性。
 当你需要在运行时使你的布局失效时，创建一个无效上下文子类的实例，根据改变的布局信息配置自定义属性，并将该对象传递到你的布局的 `-invalidateLayoutWithContext:`方法，该方法的自定义实现可以使用` invalidation` 上下文中的信息来仅重新计算已更改的布局部分。
 还应该重写`invalidationContextClass`方法并返回自定义类。

```
/** 使当前布局失效并触发布局更新
 * @discussion 可以在任何时候调用此方法来更新布局信息；
 *      异步使布局无效，并立即返回；因此，可以从相同的代码块多次调用此方法，而不会触发多次布局更新；
 *      实际的布局更新发生在下一个视图布局更新周期中；
 * @note 子类在重写时必须始终调用super。
 */
- (void)invalidateLayout;

/** 根据提供的上下文信息使当前部分布局无效
 * @param context 上下文对象，指示要刷新布局的哪些部分
 * @discussion 该方法默认使用 UICollectionViewLayoutInvalidationContext 类的基本属性优化布局过程。
 *          如果自定义上下文对象，需要重写此方法并将上下文对象的任何自定义属性应用于布局计算
 * @note 子类在重写时必须始终调用super。
 */
- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context API_AVAILABLE(ios(7.0));

/** 如果自定义一个 UICollectionViewLayoutInvalidationContext 的子类提高布局更新的性能，
 * 需要在 UICollectionViewLayout 的子类中调用该方法返回 Context 的子类
 */
@property(class, nonatomic, readonly) Class invalidationContextClass API_AVAILABLE(ios(7.0));

/** 询问布局对象 滑动 CollectionView 时 是否需要更新布局
 * @newBounds 滑动 UICollectionView 停止时的新边界
 * @return 如果需要更新布局，则返回YES；默认返回NO，不需要更改布局；
 * @discussion 如果滑动 UICollectionView 并且返回YES，那么通过调用 -invalidateLayoutWithContext: 使布局无效；
*/
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

/** 检索 UICollectionView.bounds 更改时对应部分的上下文对象
 * @newBounds UICollectionView 的新边界
 * @return 描述需要更改部分的上下文对象；不需更改返回nil；
 * @discussion 重写此方法创建和配置自定义 UICollectionViewLayoutInvalidationContext 以响应边界更改；
 *    如果重写此方法，首先调用super以获得要返回的无效上下文对象；然后设置任何自定义属性并返回它；
 */
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds API_AVAILABLE(ios(7.0));

/** 询问布局对象：单元格自动调整大小，是否需要布局更新
 * @param preferredAttributes 单元格的 -preferredLayoutAttributesFittingAttributes: 方法返回的布局属性
 * @param originalAttributes 布局对象最初为单元格建议的属性；
 * @return 如果布局应该无效，则返回 YES ；默认返回 NO，如果不应该无效；
 * @discussion 当 UICollectionView 包含自调整大小的单元格时，单元格可以在应用这些属性之前修改它们自己的布局属性；
 *       当单元格提供一组不同的属性时，调用该方法确定单元格的更改是否需要布局更新；
 */
- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0));

/** 检索上下文对象，该对象标识为响应动态单元格更改而应更改的布局部分
 * @param preferredAttributes 单元格的 -preferredLayoutAttributesFittingAttributes: 方法返回的布局属性
 * @param originalAttributes 布局对象最初为单元格建议的属性；
 * @return 无效上下文，其中包含关于需要对布局进行哪些更改的信息。
 * @discussion 重写该方法在返回上下文之前，调用super以便父类可以执行对象的基本配置，还可以执行附加配置。
 */
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0));

/** 检索上下文对象，该对象标识在布局中交互移动的项
 * @param targetIndexPaths 正在移动的项的当前位置
 * @param targetPosition 项的目的点
 * @param previousIndexPaths 要移动的项以前位置
 * @param previousPosition 项的原始点
 * @return 包含关于需要对布局进行哪些更改的信息。
 * @discussion 布局对象使用此方法在进行一个或多个项的交互式移动时检索上下文。
 */
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition API_AVAILABLE(ios(9.0));

/** 检索上下文对象，该对象标识已移动的项
 * @param indexPaths 项的最终位置。对于已取消的交互，这些索引路径对应于项的原始索引路径。
 * @param previousIndexPaths 项的原始位置。包含在移动序列期间集合视图报告的最后一组索引路径。
 * @param movementCancelled 指示移动是否成功结束或取消的布尔值。
 * @return 包含关于需要对布局进行哪些更改的信息
 * @discussion 当一个或多个项的交互式移动结束时，布局对象使用此方法检索无效上下文，原因可能是移动成功，也可能是用户取消了该移动。
 */
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled API_AVAILABLE(ios(9.0));
```


#### 2.4、协调动画变化

```
/** 在显示单元格的新边界之前，UICollectionView 在动画块内的边界发生改变时调用
 * 为视图边界的动画更改或 Item 的插入或删除准备布局对象
 * @param oldBounds UICollectionView 的当前边界
 * @discussion 对 UICollectionView.bounds 执行任何动画更改之前或在动画插入或删除项之前调用此方法。
 *             此方法使布局对象有机会执行为这些动画更改准备所需的任何计算。
 *             具体来说，使用此方法计算插入或删除项的初始位置或最终位置，以便在请求时返回这些值。
 * 还可以使用此方法执行其他动画 : 创建的任何动画都被添加到用于处理插入、删除和边界更改的动画块中。
 */
- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds;

/** 在对 UICollectionView.bounds 进行任何动画更改或在插入或删除项之后清理
 * @discussion 以动画更改 UICollectionView.bounds 后或在动画插入或删除项后调用此方法。在动画块内调用；
 *            此方法使布局对象有机会执行与这些操作相关的任何清理。
 */
- (void)finalizeAnimatedBoundsChange;
```

#### 2.5、布局之间的过渡

`UICollectionView` 在传入和传出布局的布局过渡动画之前调用这些方法

```
/** 告知布局对象，它将作为 UICollectionView 的布局被删除
 * 过渡动画前将要删除旧的Layout
 * @param newLayout 过渡动画结束时要使用的新布局对象。使用此对象根据最终的布局对象提供不同的起始属性。
 * @discussion 在执行布局转换之前，UICollectionView 调用此方法，以便布局对象可以执行生成布局属性所需的任何初始计算
 */
- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout API_AVAILABLE(ios(7.0));

/** 告知布局对象准备安装为UICollectionView的布局
 * @param oldLayout 在转换开始时安装在集合视图中的布局对象。您可以使用此对象根据开始布局对象提供不同的结束属性。
 * @discussion 在执行布局转换之前，集合视图调用此方法，以便您的布局对象可以执行生成布局属性所需的任何初始计算。
*/
- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout API_AVAILABLE(ios(7.0));

/** 告诉布局对象在发生过渡动画之前执行最后的步骤
 * @discussion 集合视图在收集了执行从一个布局到另一个布局转换所需的所有布局属性之后调用此方法。
 * 可以使用这个方法来清理任何由 -prepareForTransitionFromLayout: 或 -prepareForTransitionToLayout: 方法的实现创建的数据结构或缓存。
 */
- (void)finalizeLayoutTransition API_AVAILABLE(ios(7.0));
```


#### 2.6、注册装饰视图

```
/** 为布局对象注册一个装饰视图
 * @param viewClass 要用于补充视图的类；如果想取消装饰视图的注册，可以将 viewClass 指定 nil
 * @param decorationViewKind 装饰视图的元素类型；使用此字符串来区分布局中具有不同的装饰视图；不能为nil，也不能为空字符串；
 * @discussion 装饰视图为部分或整个UICollectionView提供视觉装饰，但不与UICollectionView的数据源提供的数据绑定。
 *   不需要显式地创建装饰视图。注册一个装饰视图后，由布局对象决定何时需要装饰视图，并从其 -layoutAttributesForElementsInRect: 方法中返回相应的布局属性。
 *   对于指定装饰视图的布局属性，UICollectionView 创建(或重用)视图并根据注册信息自动显示它。
 */
- (void)registerClass:(nullable Class)viewClass forDecorationViewOfKind:(NSString *)elementKind;
- (void)registerNib:(nullable UINib *)nib forDecorationViewOfKind:(NSString *)elementKind;
```

#### 2.7、支持从右到左的布局

`UICollectionView` 的默认排列顺序是从左到右，但是有时候需求可能从右到左排列。这时重写下述方法：

```
/** 布局排列方向，默认为 从左到右
 * 重写该方法，可以实现从右到左排列
 *  <ul> UIUserInterfaceLayoutDirection 的枚举值：指定用户界面的方向流。
 *     <li> UIUserInterfaceLayoutDirectionLeftToRight 布局方向从左到右
 *     <li> UIUserInterfaceLayoutDirectionRightToLeft 布局方向从右到左
 *          当使用本地化(如阿拉伯语或希伯来语)运行时，这个值是合适的，因为用户界面布局的原点应该位于坐标系统的右边缘
 *  </ul>
 */
@property (nonatomic, readonly) UIUserInterfaceLayoutDirection developmentLayoutDirection;

/** 是否在适当的时候自动翻转水平坐标系统，默认为NO
 * 如果子类的返回 YES，UICollectionView 显示这个布局将确保它的边界。原点总是在前沿，如果需要，水平翻转它的坐标系统。
 * 当使用从左到右的布局时，布局信息会自动匹配集合视图的自然坐标系统。
 * 但是，当用户的语言具有从右到左的方向时，提供的布局信息仍然基于集合视图的自然坐标系统。
 * 这种差异会导致使用相反方向的语言出现布局问题。
 * 将该值设置为YES时，集合视图会自动翻转其水平坐标系统的方向，以匹配当前语言。
 * 翻转水平坐标系统可以有效地翻转现有的布局信息，从而得到更美观的布局。
 */
@property(nonatomic, readonly) BOOL flipsHorizontallyInOppositeLayoutDirection;
```

