//
//  JCBaseReusableView.h
//  living
//
//  Created by Cerko on 2021/1/11.
//  Copyright © 2021 MJHF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef  __kindof UIView * __nullable (^JCBaseReusableViewItemViewBlock)(__kindof UIView *v, NSInteger idx);
typedef NSInteger (^JCBaseReusableViewNumberBlock)(__kindof UIView *v);

@interface JCBaseReusableView : UIView

#pragma mark - publics
///刷新View，会回调 numberOfTagViewBlock 和 ViewBlock
- (void)reloadData;
///获取View的个数
@property (assign, nonatomic, readonly) NSInteger numberOfTagView;
///获取idx位置的view，如果没有调用过reloadData，则这个返回值肯定是nil
- (nullable __kindof UIView *)usingViewAtIndex:(NSInteger)idx;

#pragma mark - blocks
///返回View的回调
@property (copy, nonatomic) JCBaseReusableViewItemViewBlock viewBlock;
///返回View数量的回调
@property (copy, nonatomic) JCBaseReusableViewNumberBlock numberOfViewBlock;

#pragma mark - reuse
///注册View的nib
- (void)registerReuseViewNib:(UINib *)nib forKey:(NSString *)key;
///注册View的class
- (void)registerReuseViewClass:(Class)clazz forKey:(NSString *)key;
///从复用池获取View， 如果没注册class，则返回nil
- (nullable __kindof UIView *)dequeneReuseViewWithKey:(NSString *)key atIndex:(NSInteger)idx;

#pragma mark - 放view的容器
///子类可重写，default self
- (UIView *)viewAsContainer;
///子类可重写，默认是将subview添加到self
- (void)addSubViewToContainer:(UIView *)subview;

@end

NS_ASSUME_NONNULL_END
