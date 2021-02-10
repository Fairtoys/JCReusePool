//
//  JCBaseReusableView.m
//  living
//
//  Created by Cerko on 2021/1/11.
//  Copyright © 2021 MJHF. All rights reserved.
//

#import "JCBaseReusableView.h"
#import "JCReusePool.h"

@interface JCBaseReusableView ()
@property (strong, nonatomic) NSMutableDictionary <NSNumber *, __kindof UIView *> *views;

@property (strong, nonatomic) JCReusePool *reusePool;


@end


@implementation JCBaseReusableView

- (NSMutableDictionary<NSNumber *,__kindof UIView *> *)views{
    if (!_views) {
        _views = [NSMutableDictionary dictionary];
    }
    return _views;
}

- (JCReusePool *)reusePool{
    if (!_reusePool) {
        _reusePool = [[JCReusePool alloc] init];
    }
    return _reusePool;
}

- (void)reloadData{
    NSInteger numberOfTagView = self.numberOfTagView;
    //1.如果idx比总数量大，那就直接把多余的缓存起来
    for (NSNumber *number in _views.allKeys) {
        if (number.integerValue > numberOfTagView - 1) {
            [self enqueueViewForKey:number];
        }
    }
    
    for (NSInteger i = 0; i < numberOfTagView; i++) {
        UIView *v = self.viewBlock(self, i);
        NSNumber *key = @(i);
        UIView *currentTagView = _views[key];
        //2.如果不是同一个view，则缓存起来
        if (v != currentTagView) {
            [self enqueueViewForKey:key];
        }
        self.views[key] = v;
        
        //3.如果没有v,直接就下一个
        if (!v) {
            continue;
        }
        
        //4.如果父视图不是自己，也不做操作
        UIView *containerView = self.viewAsContainer;
        if ( v.superview == containerView) {
            continue;
        }
        [self addSubViewToContainer:v];
    }
}

- (void)enqueueViewForKey:(NSNumber *)number{
    if (!number) {
        return;
    }
    
    UIView *v = _views[number];
    if (!v) {
        return ;
    }
    _views[number] = nil;
    [v removeFromSuperview];
    [self.reusePool enqueueReuseObj:v];
}

- (NSInteger)numberOfTagView{
    if (self.numberOfViewBlock) {
        return self.numberOfViewBlock(self);
    }
    return 0;
}

- (__kindof UIView *)dequeneReuseViewWithKey:(NSString *)key atIndex:(NSInteger)idx{
    UIView *view = _views[@(idx)];
    NSString *reuseIdentifier = [self.reusePool reuseIdentifierForObj:view];
    if (view && [reuseIdentifier isEqualToString:key]) {
        return view;
    }
    return [self.reusePool dequeueReuseObjForKey:key];
}

- (void)registerReuseViewNib:(UINib *)nib forKey:(NSString *)key{
    [self.reusePool registerObjCreateBlock:^id _Nonnull(NSString * _Nonnull key) {
        return [nib instantiateWithOwner:nil options:nil].firstObject;
    } forKey:key];
}

- (void)registerReuseViewClass:(Class)clazz forKey:(NSString *)key{
    [self.reusePool registerClass:clazz forKey:key];
}

- (__kindof UIView *)usingViewAtIndex:(NSInteger)idx{
    return _views[@(idx)];
}

- (UIView *)viewAsContainer{
    return self;
}

- (void)addSubViewToContainer:(UIView *)subview{
    [self addSubview:subview];
}

@end
