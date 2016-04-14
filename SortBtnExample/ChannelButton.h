//
//  ChannelButton.h
//  SortBtnExample
//
//  Created by shengxin on 16/4/14.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelButton : UIView


/**
 *  文字
 */
@property (nonatomic,copy) NSString  *text;
/**
 *  按钮选中
 */
@property (nonatomic,assign) BOOL btnSelect;
/**
 *  按钮是否拖拽
 */
@property (nonatomic,assign) BOOL btnDrag;




@end
