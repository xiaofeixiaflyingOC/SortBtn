//
//  SortBtnScrollView.m
//  SortBtnExample
//
//  Created by shengxin on 16/4/13.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import "SortBtnScrollView.h"
#import "ChannelButton.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SortBtnScrollView()
{
    //下面可能根据不同分辨率屏幕进行不同参数的设置
    //按钮的宽度
    NSInteger _buttonW;
    //按钮的高度
    NSInteger _buttonH;
    //按钮距离屏幕边框的距离
    NSInteger _buttonMarginForDevice;
    //按钮列数
    NSInteger _totalCol;
    //选中的view的起始位置
    CGPoint originPoint;
    //选中View最后需要移动到的位置
    CGPoint endPoint;
}
@property (nonatomic, strong) UIView *iTopView;
@property (nonatomic, strong) UIButton *iSelectBtn;

//一开始的频道数组（主要用于判断是否进行了频道编辑）
@property (nonatomic,strong) NSMutableArray  *originalChannelDataArray;
//进行编辑频道的btn数组
@property (nonatomic,strong) NSMutableArray  *selectButtonArray;
//已选频道的数据数组，根据沙盒文件查找
@property (nonatomic,strong) NSMutableArray  *selectChannelDataArray;
//是否编辑按钮
@property (nonatomic,assign) BOOL isEdit;
@end

@implementation SortBtnScrollView

#pragma mark - public
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSet];
        [self initTopView];
        [self setChannelButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverData:) name:@"recoverDataNotification" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initData{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"channelDatas"];
    self.selectChannelDataArray = [[NSMutableArray alloc] initWithArray:array];
    self.originalChannelDataArray = [[NSMutableArray alloc] initWithArray:array];
}

- (void)initSet{
    self.isEdit = NO;
    self.userInteractionEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:0.99];
}

- (void)initTopView{
    self.iTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,44)];
    self.iTopView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.iTopView];
    
    self.iSelectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.iSelectBtn setFrame:CGRectMake(self.frame.size.width-80,(44-17)/2.0, 80, 17)];
    [self.iSelectBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.iSelectBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.iSelectBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.iTopView addSubview:self.iSelectBtn];
    [self.iSelectBtn addTarget:self action:@selector(editButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置频道button
-(void)setChannelButton
{
    //1.添加已选频道按钮
    for (NSInteger i = 0; i < self.selectChannelDataArray.count; i++) {
        NSString *title = self.selectChannelDataArray[i];
        ChannelButton  *btn = [[ChannelButton alloc] init];
        btn.text = title;
        //添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        [btn addGestureRecognizer:pan];
        [pan addTarget:self action:@selector(panView:)];

        [self.selectButtonArray addObject:btn];
        [self addSubview:btn];
    }
    //更新位置
    [self updateAllFrameWithAnimationsDuration:0];
}

#pragma mark - 更新所有控件的位置,是否有动画
/**
 *  更新所有控件的位置
 */
-(void)updateAllFrameWithAnimationsDuration:(NSTimeInterval) timeInterval
{
    [UIView animateWithDuration:timeInterval animations:^{
        //1.设置topView的Frame
        self.iTopView.frame = CGRectMake(0, 0, self.frame.size.width,44);//宽高需要稍后改变
        //2.设置selectButton的Frame buttonMargin
        CGFloat marginX = (kScreenWidth - self.buttonMarginForDevice * 2 - self.totalCol * self.buttonW) / (self.totalCol - 1);
        CGFloat marginY = 15;
        CGFloat selectButtonStartY = CGRectGetMaxY(self.iTopView.frame) + 20;//选择频道的Y值得开始位置
        for (NSInteger i = 0; i < self.selectButtonArray.count; i++) {
            NSInteger row = i / self.totalCol;
            NSInteger col = i % self.totalCol;
            CGFloat x = self.buttonMarginForDevice + (self.buttonW + marginX) * col;
            CGFloat y = selectButtonStartY + (self.buttonH + marginY) * row;
            ChannelButton *channeButton = self.selectButtonArray[i];
            channeButton.frame = CGRectMake(x, y, self.buttonW, self.buttonH);
        }
    }];
}

#pragma mark - 根据不同分辨率屏幕进行不同参数的设置

-(NSInteger)buttonW{
    _buttonW = 72;
    return _buttonW;
}

-(NSInteger)buttonH{
    _buttonH = 30;
    return _buttonH;
}

-(NSInteger)buttonMarginForDevice{
    _buttonMarginForDevice = 10;
    return _buttonMarginForDevice;
}

-(NSInteger)totalCol{
    _totalCol = 4;
    return _totalCol;
}

#pragma mark - 懒加载 自动生成的频道按钮
-(NSMutableArray *)selectButtonArray{
    if (_selectButtonArray == nil) {
        _selectButtonArray = [NSMutableArray array];
    }
    return _selectButtonArray;
}

#pragma mark - UITouch

- (void)editButton{
    self.iSelectBtn.selected = !self.iSelectBtn.selected;
    self.isEdit = !self.isEdit;

    ChannelButton *channelButton = (ChannelButton *)self.selectButtonArray[0];
    channelButton.userInteractionEnabled = !channelButton.isUserInteractionEnabled;
}

#pragma mark - 拖拽事件响应方法
/**
 *  频道拖拽事件
 */
-(void)panView:(UIPanGestureRecognizer *) pan
{
    ChannelButton *SelectBtn =(ChannelButton *) pan.view;
    if (![self.selectButtonArray containsObject:SelectBtn] || !self.isEdit) return;
    if (pan.state == UIGestureRecognizerStateBegan ) {
        originPoint  = SelectBtn.center;
        endPoint = originPoint;
        SelectBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        SelectBtn.exclusiveTouch = YES;
        [self bringSubviewToFront:SelectBtn];
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint ChangePoint = [pan translationInView:pan.view];
        CGPoint temp = SelectBtn.center;
        temp.x += ChangePoint.x;
        temp.y += ChangePoint.y;
        SelectBtn.center = temp;
        [pan setTranslation:CGPointZero inView:pan.view];
        NSInteger index = [self indexOfPoint:SelectBtn.center withButton:SelectBtn];
        //第一个不可动
        if (index <=0) {
            return;
        }else{
            ChannelButton *button = self.selectButtonArray[index];
            endPoint = button.center;
            [self.selectButtonArray removeObject:SelectBtn];//先移除btn
            [self.selectButtonArray insertObject:SelectBtn atIndex:index];
            [self updateFrameSelect:index];
        }
        
    }else if(pan.state == UIGestureRecognizerStateEnded){
        SelectBtn.center = endPoint;
        SelectBtn.transform = CGAffineTransformIdentity;
    }else if(pan.state == UIGestureRecognizerStateCancelled){
        SelectBtn.center = endPoint;
        SelectBtn.transform = CGAffineTransformIdentity;
    }
}

//判断拖拽到与第几个btn可以交换
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(ChannelButton *)btn
{
    for (NSInteger i = 0;i<self.selectButtonArray.count;i++)
    {
        ChannelButton *button = self.selectButtonArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

-(void)updateFrameSelect:(NSInteger)index
{
    CGFloat marginX = (kScreenWidth - self.buttonMarginForDevice * 2 - self.totalCol * self.buttonW) / (self.totalCol - 1);
    CGFloat marginY = 15;
    CGFloat selectButtonStartY = CGRectGetMaxY(self.iTopView.frame) + 20;//选择频道的Y值得开始位置
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger i = 0; i < self.selectButtonArray.count; i++) {
            if (i == index) {
                continue;
            }
            NSInteger row = i / self.totalCol;
            NSInteger col = i % self.totalCol;
            CGFloat x = self.buttonMarginForDevice + (self.buttonW + marginX) * col;
            CGFloat y = selectButtonStartY + (self.buttonH + marginY) * row;
            ChannelButton *channeButton = self.selectButtonArray[i];
            channeButton.frame = CGRectMake(x, y, self.buttonW, self.buttonH);
        }
    }];
   [self saveChannelData];
}

- (void)saveChannelData{
    
    NSMutableArray *selectChannelArray = [[NSMutableArray alloc] init];
    for (ChannelButton *btn in self.selectButtonArray) {
        [selectChannelArray addObject:btn.text];
    }
    [[NSUserDefaults standardUserDefaults] setObject:selectChannelArray forKey:@"channelDatas"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - NSNotificaiton

- (void)recoverData:(id)notification{
    [[NSUserDefaults standardUserDefaults] setObject:self.originalChannelDataArray forKey:@"channelDatas"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
