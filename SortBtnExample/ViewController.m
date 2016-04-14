//
//  ViewController.m
//  SortBtnExample
//
//  Created by shengxin on 16/4/13.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import "ViewController.h"
#import "SortBtnViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *iTextLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    [self initDatas];
    [self initNav];
    [self initTextLabel];
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeText];
}

#pragma mark - init 
- (void)initNav{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    
    UIImage *image1 = [UIImage imageNamed:@"top_navigation_square"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(self.view.frame.size.width-image1.size.width, 20+(44-image1.size.width)/2, image1.size.width, image1.size.height)];
    [button setImage:image1 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initTextLabel{
    self.iTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,(self.view.frame.size.width-20), 100)];
    self.iTextLabel.numberOfLines = 0;
    self.iTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:self.iTextLabel];
}

- (void)initContentView{
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-image.size.width/2.0)/2, 100, image.size.width/2.0, image.size.height/2.0)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView  setImage:image];
    [self.view addSubview:imageView];
}

- (void)initDatas{
    NSArray *array = @[@"头条",@"体育",@"美女",@"NBA",@"CBA",@"娱乐",@"财经",@"科技",@"中国足球队",@"北京"];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"channelDatas"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - changeText
- (void)changeText{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelDatas"];
    for(id obj in array){
        [str appendString:obj];
        [str appendString:@" "];
    }
    self.iTextLabel.text = str;
}

#pragma mark - getImage
- (UIImage*)getImage{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.frame.size, YES, 0.0);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - UITouch
- (void)pushController{
    //截取一张图片
    UIImage *image = [self getImage];
    SortBtnViewController *s = [[SortBtnViewController alloc] init];
    s.bgContentImage = image;
    [self.navigationController pushViewController:s animated:NO];
}
@end
