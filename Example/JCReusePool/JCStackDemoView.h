//
//  JCStackDemoView.h
//  living
//
//  Created by Cerko on 2020/12/29.
//  Copyright © 2020 MJHF. All rights reserved.
//

#import <JCReusePool/JCBaseReusableView.h>

NS_ASSUME_NONNULL_BEGIN

///任务奖励
@interface JCStackDemoView : JCBaseReusableView
///用来放置任务奖励的stack容器
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

NS_ASSUME_NONNULL_END
