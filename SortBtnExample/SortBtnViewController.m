//
//  SortBtnViewController.m
//  SortBtnExample
//
//  Created by shengxin on 16/4/13.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import "SortBtnViewController.h"
#import "SortBtnScrollView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SortBtnViewController ()
{
    BOOL isAutoPressRightButton;
}
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) SortBtnScrollView *iSortBtnScrollView;

@end

@implementation SortBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isAutoPressRightButton = YES;
    [self initNav];
    [self initRightBtn];
    [self initSortScrollView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isAutoPressRightButton==YES) {
        //下拉动画
        [self rightButtonClick:self.rightButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property
- (void)setBgContentImage:(UIImage *)bgContentImage{
    _bgContentImage = bgContentImage;
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:_bgContentImage];
    backgroundImageView.frame =CGRectMake(0.0,0, kScreenWidth,kScreenHeight);
    [self.view insertSubview:backgroundImageView belowSubview:self.iSortBtnScrollView];
}

#pragma mark - init
- (void)initNav{
    //点击返回按钮一切的操作都恢复原状，只有点击右侧按钮进行编辑才有效
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initRightBtn{
    UIButton *btn = [[UIButton alloc] init];
    //4.4.1
    [btn setImage:[UIImage imageNamed:@"top_navigation_cross"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.rightButton = btn;
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:btn];

}

- (void)initSortScrollView{
    self.iSortBtnScrollView = [[SortBtnScrollView alloc] initWithFrame:CGRectMake(0,-kScreenHeight,kScreenWidth,kScreenHeight-64)];
    [self.view addSubview:self.iSortBtnScrollView];
}

#pragma mark - UITouch
-(void)rightButtonClick:(UIButton *)btn
{
    isAutoPressRightButton = NO;
    btn.selected = !btn.selected;
    //下拉
    if (btn.selected) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.iSortBtnScrollView.frame = CGRectMake(0.0,64.0, kScreenWidth, kScreenHeight-64);
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:0.15 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, -M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            
        }];
        //上拉
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.iSortBtnScrollView.frame = CGRectMake(0.0, -kScreenHeight, kScreenWidth, kScreenHeight-64);
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
        //编辑按钮点击之后旋转效果
        [UIView animateWithDuration:0.1 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)popController{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoverDataNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
