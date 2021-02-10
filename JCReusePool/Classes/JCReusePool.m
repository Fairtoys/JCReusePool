//
//  JCReusePool.m
//  PopUtilsDemo
//
//  Created by Cerko on 2021/1/7.
//  Copyright © 2021 Cerko. All rights reserved.
//

#import "JCReusePool.h"
#import <objc/runtime.h>

@interface NSObject (JCReusePoolItem)
///重用标识
@property (strong, nonatomic, setter = reusepool_setIdentifier:) NSString *reusepool_identifier;

@end

@implementation NSObject (JCReusePoolItem)

- (void)reusepool_setIdentifier:(NSString *)reusepool_identifier{
    objc_setAssociatedObject(self, @selector(reusepool_identifier), reusepool_identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)reusepool_identifier{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@interface JCReusePool ()

@property (strong, nonatomic) NSMutableDictionary <NSString *, Class> *classPool;
@property (strong, nonatomic) NSMutableDictionary <NSString *, id (^)(NSString *)> *classCreatorPool;
@property (strong, nonatomic) NSMutableDictionary <NSString *, NSMutableSet <id> *> *reusePool;
@property (strong, nonatomic) NSMutableDictionary <NSString *, NSNumber *> *reuseCountLimits;

@end

@implementation JCReusePool

- (NSMutableDictionary<NSString *,NSMutableSet<id> *> *)reusePool{
    if (!_reusePool) {
        _reusePool = [NSMutableDictionary dictionary];
    }
    return _reusePool;
}

- (NSMutableDictionary<NSString *,Class> *)classPool{
    if (!_classPool) {
        _classPool = [NSMutableDictionary dictionary];
    }
    return _classPool;
}

- (NSMutableDictionary<NSString *,id (^)(NSString *)> *)classCreatorPool{
    if (!_classCreatorPool) {
        _classCreatorPool = [NSMutableDictionary dictionary];
    }
    return _classCreatorPool;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)reuseCountLimits{
    if (!_reuseCountLimits) {
        _reuseCountLimits = [NSMutableDictionary dictionary];
    }
    return _reuseCountLimits;
}

- (void)enqueueReuseObj:(id)obj forKey:(NSString *)key{
    if (!obj) {
        return;
    }
    
    if (!key) {
        return;
    }
    
    NSMutableSet <id> *set = _reusePool[key];
    
    //添加个数限制
    NSNumber *limitCount = _reuseCountLimits[key];
    if (limitCount && set.count >= [limitCount integerValue]) {
        return;
    }
    
    if (!set) {
        set = [NSMutableSet set];
        self.reusePool[key] = set;
    }
    [set addObject:obj];
}

- (void)enqueueReuseObj:(id)obj{
    [self enqueueReuseObj:obj forKey:[obj reusepool_identifier]];
}

- (id)dequeueReuseObjForKey:(NSString *)key{
    //1.没有key，直接返回nil
    if (!key) {
        return nil;
    }
    
    NSMutableSet <id> *set = _reusePool[key];
    
    NSObject *obj = [set anyObject];
    if (obj) {
        [set removeObject:obj];
        return obj;
    }
    
    Class clazz = _classPool[key];
    if (clazz) {
        obj = [[clazz alloc] init];
        obj.reusepool_identifier = key;
        return obj;
    }
    
    id (^block)(NSString *) = _classCreatorPool[key];
    if (block) {
        obj = block(key);
        obj.reusepool_identifier = key;
        return obj;
    }
    
    return nil;
}

- (void)registerClass:(Class)clazz forKey:(NSString *)key{
    if (!clazz) {
        return;
    }
    if (!key) {
        return;
    }
    self.classPool[key] = clazz;
}

- (void)registerObjCreateBlock:(id (^)(NSString *))block forKey:(NSString *)key{
    if (!block) {
        return;
    }
    if (!key) {
        return;
    }
    self.classCreatorPool[key] = block;
}

- (void)setReuseCount:(NSInteger)count forKey:(NSString *)key{
    if (!key) {
        return ;
    }
    self.reuseCountLimits[key] = @(count);
}

- (NSString *)reuseIdentifierForObj:(id)obj{
    return [obj reusepool_identifier];
}

@end
