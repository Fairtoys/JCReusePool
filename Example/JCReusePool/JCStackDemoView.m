//
//  JCStackDemoView.m
//  living
//
//  Created by Cerko on 2020/12/29.
//  Copyright © 2020 MJHF. All rights reserved.
//

#import "JCStackDemoView.h"

@implementation JCStackDemoView

- (UIView *)viewAsContainer{
    return self.stackView;
}

- (void)addSubViewToContainer:(UIView *)subview{
    [self.stackView addArrangedSubview:subview];
}

@end
