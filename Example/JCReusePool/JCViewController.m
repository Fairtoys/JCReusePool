//
//  JCViewController.m
//  JCReusePool
//
//  Created by 313574889@qq.com on 02/10/2021.
//  Copyright (c) 2021 313574889@qq.com. All rights reserved.
//

#import "JCViewController.h"
#import "JCStackDemoView.h"
#import <Masonry/Masonry.h>

@interface JCViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) JCStackDemoView *reuseView;

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self seutpViews];
}

- (void)seutpViews{
    [self.containerView addSubview:self.reuseView];
    
    [self.reuseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self.containerView);
        make.height.mas_equalTo(44);
    }];
}

- (JCStackDemoView *)reuseView{
    if (!_reuseView) {
        _reuseView = [[UINib nibWithNibName:NSStringFromClass(JCStackDemoView.class) bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        [_reuseView registerReuseViewClass:UILabel.class forKey:NSStringFromClass(UILabel.class)];
        [_reuseView setViewBlock:^__kindof UIView * _Nullable(__kindof JCBaseReusableView * _Nonnull v, NSInteger idx) {
            UILabel *view = [v dequeneReuseViewWithKey:NSStringFromClass(UILabel.class) atIndex:idx];
            view.text = [NSString stringWithFormat:@"%@", @(idx)];
            return view;
        }];
        [_reuseView setNumberOfViewBlock:^NSInteger(__kindof UIView * _Nonnull v) {
            return arc4random_uniform(10) + 1;
        }];
    }
    return _reuseView;
}

- (IBAction)onClickReloadBtn:(id)sender {
    [self.reuseView reloadData];
}

@end
