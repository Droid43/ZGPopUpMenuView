//
//  ZGPopUpMenuView.h
//  PopUpMenuDemo
//
//  Created by Zeng Gen on 2017/3/15.
//  Copyright © 2017年 ZengGen. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 箭头所指方向.

 - ZGPopUpMenuArrowTop: 箭头向上.
 - ZGPopUpMenuArrowLeft: 箭头向左.
 - ZGPopUpMenuArrowBottom: 箭头向下.
 - ZGPopUpMenuArrowRight: 箭头向右.
 - ZGPopUpMenuArrowDefault: 默认方向，向上.
 */
typedef NS_ENUM(NSUInteger, ZGPopUpMenuArrowLocation){
    ZGPopUpMenuArrowTop,
    ZGPopUpMenuArrowLeft,
    ZGPopUpMenuArrowBottom,
    ZGPopUpMenuArrowRight,
    ZGPopUpMenuArrowDefault = ZGPopUpMenuArrowTop,
};

@interface ZGPopUpMenuViewBuilder : NSObject
/**
 菜单条目高度
 */
@property (nonatomic) CGFloat itemWidth;

/**
 菜单条目宽度
 */
@property (nonatomic) CGFloat itemHeight;

/**
 箭头头部在整个屏幕的位置
 */
@property (nonatomic) CGPoint position;

/**
 箭头朝向
 */
@property (nonatomic) ZGPopUpMenuArrowLocation arrowLocation;

/**
 箭头头部在对应边的等分比，方向从上到下或从左到右，范围（0，1）
 */
@property (nonatomic) CGFloat localScale;
/**
 箭头高度
 */
@property (nonatomic) CGFloat arrowHeight;
/**
 菜单条目正常状态背景颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 菜单条目选中状态背景颜色
 */
@property (nonatomic, strong) UIColor *selectColor;

/**
 菜单条目分割线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
菜单条目正常状态文字颜色
 */
@property (nonatomic, strong) UIColor *normalTextColor;

/**
 菜单条目选中状态文字颜色
 */
@property (nonatomic, strong) UIColor *selectTextColor;

/**
 菜单栏所在view的背景色
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 菜单栏内文字的字体
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 菜单栏所有的文字标题
 */
@property (nonatomic, strong) NSArray<NSString *> *items;

/**
 初始化选中的条目序号，默认为0
 */
@property (nonatomic) NSInteger selectIdx;

/**
 菜单栏弹出消失时是否有动画效果，默认开启
 */
@property (nonatomic) BOOL animated;

/**
 菜单栏是否有阴影，默认开启
 */
@property (nonatomic) BOOL shadowed;

/**
 菜单栏所在背景是否进行高斯模糊,iOS8以上支持，默认关闭高斯背景
 */
@property (nonatomic) BOOL gaussBlurred;

@end


/**
 一行代码实现弹出式菜单菜单
 */
@interface ZGPopUpMenuView : UIView

/**
 弹出菜单
 
 @param block 弹出菜单适配器回调
 */
+(void)popMenuWithBuilder:(void(^)(ZGPopUpMenuViewBuilder *builder)) block;

/**
 弹出菜单
 
 @param block 弹出菜单适配器回调
 @param action 选中菜单后的回调
 */
+(void)popMenuWithBuilder:(void(^)(ZGPopUpMenuViewBuilder *builder)) block
                   select:(void(^)(NSInteger index, NSString *item)) action;

/**
 弹出菜单
 
 @param block 弹出菜单适配器回调
 @param selectAction 选中菜单后的回调
 @param cancleAction 取消操作的回调
 */
+(void)popMenuWithBuilder:(void(^)(ZGPopUpMenuViewBuilder *builder)) block
                   select:(void(^)(NSInteger index, NSString *item)) selectAction
                   cancle:(void(^)()) cancleAction;

@end
