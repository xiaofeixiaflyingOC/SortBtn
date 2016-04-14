//
//  ChannelButton.m
//  SortBtnExample
//
//  Created by shengxin on 16/4/14.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import "ChannelButton.h"


@interface ChannelButton()

@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation ChannelButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textColor = [UIColor colorWithRed:102.0f/255 green:102.0/255 blue:102.0/255 alpha:1.0];
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.layer.cornerRadius = 15.0;
        textLabel.layer.borderWidth = 1.0;
        textLabel.layer.borderColor = [UIColor colorWithRed:205.0/255.f green:205.0/255.f blue:205.0/255.f alpha:100.0/100.f].CGColor;
        self.textLabel = textLabel;
        [self addSubview:textLabel];
    }
    return self;
}

//布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    //1.textLabel位置
    self.textLabel.frame = self.bounds;
}

//设置文字
-(void)setText:(NSString *)text{
    _text = [text copy];
    self.textLabel.text = _text;
}

//拖拽
-(void)setBtnDrag:(BOOL)btnDrag{
    _btnDrag = btnDrag;
    if (_btnDrag) {
        self.textLabel.layer.borderColor = [UIColor colorWithRed:39.0/255.f green:128.0/255.f blue:248.0/255.f alpha:100.0/100.f].CGColor;
    }else{
        self.textLabel.layer.borderColor = [UIColor colorWithRed:205.0/255.f green:205.0/255.f blue:205.0/255.f alpha:100.0/100.f].CGColor;
    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (!userInteractionEnabled) {
        self.textLabel.textColor = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1.0];
    }else{
        if (self.btnSelect) {
            [self setBtnSelect:YES];
        }else{
            self.textLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
        }
    }
}

@end
