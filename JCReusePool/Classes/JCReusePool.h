//
//  JCReusePool.h
//  PopUtilsDemo
//
//  Created by Cerko on 2021/1/7.
//  Copyright © 2021 Cerko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCReusePool : NSObject

///从复用池里取出对应的对象
- (nullable id)dequeueReuseObjForKey:(NSString *)key;

///将对象放回复用池
- (void)enqueueReuseObj:(id)obj forKey:(NSString *)key;
- (void)enqueueReuseObj:(id)obj;

///注册创建对象的方法
- (void)registerClass:(Class)clazz forKey:(NSString *)key;
- (void)registerObjCreateBlock:(id (^)(NSString *key))block forKey:(NSString *)key;

///设置对应key复用池的count限制，超过最大大小，则就不会再加到复用池了
- (void)setReuseCount:(NSInteger)count forKey:(NSString *)key;

///获取obj对应的重用标志
- (nullable NSString *)reuseIdentifierForObj:(id)obj;
@end

NS_ASSUME_NONNULL_END
