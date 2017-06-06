//
//  ZGPopUpMenuView.m
//  PopUpMenuDemo
//
//  Created by Zeng Gen on 2017/3/15.
//  Copyright © 2017年 ZengGen. All rights reserved.
//

#import "ZGPopUpMenuView.h"


#pragma mark- 适配器
@implementation ZGPopUpMenuViewBuilder
+(instancetype)defaultBuilder{
    ZGPopUpMenuViewBuilder *builder = [[self alloc] init];
    builder.arrowLocation = ZGPopUpMenuArrowDefault;
    builder.normalColor = [UIColor whiteColor];
    builder.selectColor = [UIColor blueColor];
    builder.lineColor = [UIColor blueColor];
    builder.normalTextColor = [UIColor blueColor];
    builder.selectTextColor = [UIColor whiteColor];
    builder.backgroundColor = [UIColor clearColor];
    builder.textFont = [UIFont systemFontOfSize:16];
    builder.itemHeight = 30;
    builder.itemWidth = 100;
    builder.arrowHeight = 10;
    builder.selectIdx = 0;
    builder.animated = YES;
    builder.gaussBlurred = NO;
    builder.shadowed = YES;
    return builder;
}
@end

#pragma mark- 菜单条目 UITableViewCell
@interface ZGPopUpMenuCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@end

@implementation ZGPopUpMenuCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.label = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5)];
        [self.contentView addSubview:self.line];
    }
    return self;
}
-(void)updateBackground{
    self.backgroundColor = self.selected ? self.selectColor : self.normalColor;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self updateBackground];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [self updateBackground];
}
@end



#pragma mark- 弹出式菜单
@interface ZGPopUpMenuView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ZGPopUpMenuViewBuilder *builder;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, copy) void (^selectAction)(NSInteger , NSString *);
@property (nonatomic, copy) void (^cancleAction)(NSInteger , NSString *);
@end

@implementation ZGPopUpMenuView
int const kVisualEffectViewTag = 100;
CGFloat const kFadeAnimationDution = 0.2;

#pragma mark- init
-(instancetype)init{
    if(self = [super init]){
        self.builder = [ZGPopUpMenuViewBuilder defaultBuilder];
        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[ZGPopUpMenuCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.sectionIndexColor = self.builder.selectColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.view = [UIView new];
        self.view.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        tap.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tap];
        [self addSubview:self.tableView];
        [self.view addSubview:self];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    }
    return self;
}

#pragma mark- Datasource Delegate Action
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.builder.items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZGPopUpMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    CGRect frame = cell.contentView.frame;
    CGFloat x,y,w,h,arrow;
    x = frame.origin.x;
    y = frame.origin.y;
    w = self.builder.itemWidth;
    h = self.builder.itemHeight;
    arrow = self.builder.arrowHeight;
    //  顶部和底部label留出 arrow的高度
    if(indexPath.row == 0){
        frame = CGRectMake(x + arrow, y + arrow, w , h);
    }else if(indexPath.row == self.builder.items.count - 1){
        frame = CGRectMake(x + arrow, y, w , h);
    }else{
        frame = CGRectMake(x + arrow, y, w , h);
    }
    //    颜色初始化
    cell.label.frame = frame;
    cell.label.textColor = self.builder.normalTextColor;
    cell.label.highlightedTextColor = self.builder.selectTextColor;
    cell.label.font = self.builder.textFont;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = self.builder.normalColor;
    cell.normalColor = self.builder.normalColor;
    cell.selectColor = self.builder.selectColor;
    cell.label.text = self.builder.items[index];
    cell.line.frame = CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5);
    cell.line.backgroundColor = self.builder.lineColor;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == self.builder.items.count - 1)
        return self.builder.itemHeight + self.builder.arrowHeight;
    return self.builder.itemHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectAction){
        NSInteger index = indexPath.row;
        self.selectAction(index, self.builder.items[index]);
    }
    [self dismissMenu];
}

//view点击事件，过滤选中菜单条目的情况
-(void)tapView:(UITapGestureRecognizer *)tap{
    if(CGRectContainsPoint(self.frame, [tap locationInView:self.view]))return;
    [self dismissMenu];
}


#pragma mark- Pop Dismiss Menu
-(void)showMenu{
    if(!self.builder.animated)return;
    CGFloat scale = self.builder.localScale;
    CGRect oldFrame = self.frame;
    switch (self.builder.arrowLocation) {
        case ZGPopUpMenuArrowTop:{
            self.layer.anchorPoint = CGPointMake(scale, 0);
        }break;
        case ZGPopUpMenuArrowLeft:{
            self.layer.anchorPoint = CGPointMake(0, scale);
        }break;
        case ZGPopUpMenuArrowBottom:{
            self.layer.anchorPoint = CGPointMake(scale, 1);
        }break;
        case ZGPopUpMenuArrowRight:{
            self.layer.anchorPoint = CGPointMake(1, scale);
        }break;
        default:
            break;
    }
    self.frame = oldFrame;
    self.layer.transform = CATransform3DMakeScale(0, 0, 0);
    UIVisualEffectView *effectView = [self.view viewWithTag:kVisualEffectViewTag];
    effectView.alpha = 0;
    [UIView animateWithDuration:kFadeAnimationDution animations: ^ {
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
        effectView.alpha = 1;
    } completion:nil];
}

-(void)dismissMenu{
    if(!self.builder.animated){
        [self.view removeFromSuperview];
        return;
    }
    UIVisualEffectView *effectView = [self.view viewWithTag:kVisualEffectViewTag];
    //    effectView.alpha = 1;
    [UIView animateWithDuration:kFadeAnimationDution animations: ^ {
        self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
        effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}


#pragma mark- mask path，绘制遮罩路径
- (UIBezierPath *)getMaskPath {
    UIBezierPath * maskPath;
    maskPath = [UIBezierPath bezierPath];
    CGFloat  w, h, arrowH, xMin, xMax, yMin, yMax;
    w = self.builder.itemWidth;
    h = self.builder.itemHeight * self.builder.items.count;
    arrowH = self.builder.arrowHeight;
    
    xMin = arrowH;
    xMax = xMin + w;
    yMin = arrowH;
    yMax = yMin + h;
    CGPoint p, p0, p1, p2;
    p = CGPointZero;
    switch (self.builder.arrowLocation) {
        case ZGPopUpMenuArrowTop:{
            p.x += xMin + self.builder.localScale * w;
            p.y += yMin;
            p0 = p1 = p2 = p;
            p0.x -= arrowH;
            p1.y -= arrowH;
            p2.x += arrowH;
            
            [maskPath moveToPoint:p0];
            [maskPath addLineToPoint:p1];
            [maskPath addLineToPoint:p2];
            [maskPath addLineToPoint:CGPointMake(xMax, yMin)];
            [maskPath addLineToPoint:CGPointMake(xMax, yMax)];
            [maskPath addLineToPoint:CGPointMake(xMin, yMax)];
            [maskPath addLineToPoint:CGPointMake(xMin, yMin)];
        }break;
        case ZGPopUpMenuArrowLeft:{
            p.y += yMin + self.builder.localScale * h;
            p.x += xMin;
            p0 = p1 = p2 = p;
            p0.y += arrowH;
            p1.x -= arrowH;
            p2.y -= arrowH;
            [maskPath moveToPoint:p0];
            [maskPath addLineToPoint:p1];
            [maskPath addLineToPoint:p2];
            [maskPath addLineToPoint:CGPointMake(xMin, yMin)];
            [maskPath addLineToPoint:CGPointMake(xMax, yMin)];
            [maskPath addLineToPoint:CGPointMake(xMax, yMax)];
            [maskPath addLineToPoint:CGPointMake(xMin, yMax)];
        }break;
        case ZGPopUpMenuArrowBottom:{
            p.x += xMin + self.builder.localScale * w;
            p.y += yMin + h;
            p0 = p1 = p2 = p;
            p0.x += arrowH;
            p1.y += arrowH;
            p2.x -= arrowH;
            [maskPath moveToPoint:p0];
            [maskPath addLineToPoint:p1];
            [maskPath addLineToPoint:p2];
            [maskPath addLineToPoint:CGPointMake(xMin, yMax)];
            [maskPath addLineToPoint:CGPointMake(xMin, yMin)];
            [maskPath addLineToPoint:CGPointMake(xMax, yMin)];
            [maskPath addLineToPoint:CGPointMake(xMax, yMax)];
            
        }break;
        case ZGPopUpMenuArrowRight:{
            p.x += xMin + w;
            p.y += yMin + self.builder.localScale * h;
            p0 = p1 = p2 = p;
            p0.y -= arrowH;
            p1.x += arrowH;
            p2.y += arrowH;
            [maskPath moveToPoint:p0];
            [maskPath addLineToPoint:p1];
            [maskPath addLineToPoint:p2];
            [maskPath addLineToPoint:CGPointMake(xMax, yMax)];
            [maskPath addLineToPoint:CGPointMake(xMin, yMax)];
            [maskPath addLineToPoint:CGPointMake(xMin, yMin)];
            [maskPath addLineToPoint:CGPointMake(xMax, yMin)];
        }break;
        default:
            break;
    }
    [maskPath closePath];
    return maskPath;
}

- (CAShapeLayer *)getMaskShapeLayer {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = self.getMaskPath.CGPath;
    return layer;
}


#pragma mark- 计算菜单位置
-(CGRect)getMenuFrame{
    CGRect frame = CGRectZero;
    CGFloat  w, h, arrowH, scale;
    w = self.builder.itemWidth;
    h = self.builder.itemHeight * self.builder.items.count;
    arrowH = self.builder.arrowHeight;
    scale = self.builder.localScale;
    CGPoint p = self.builder.position;
    
    frame.size.width = w;
    frame.size.height = h;
    switch (self.builder.arrowLocation) {
        case ZGPopUpMenuArrowTop:{
            frame.origin.x = p.x - scale * w;
            frame.origin.y = p.y + arrowH;
        }break;
        case ZGPopUpMenuArrowLeft:{
            frame.origin.x = p.x + arrowH;
            frame.origin.y = p.y - scale * h;
        }break;
        case ZGPopUpMenuArrowBottom:{
            frame.origin.x = p.x - scale * w;
            frame.origin.y = p.y - h - arrowH;
        }break;
        case ZGPopUpMenuArrowRight:{
            frame.origin.x = p.x - w - arrowH;
            frame.origin.y = p.y - scale * h;
        }break;
            
        default:
            break;
    }
    return frame;
}
-(void)checkLocalScale{
    CGFloat  w, h, arrowH, scale;
    w = self.builder.itemWidth;
    h = self.builder.itemHeight * self.builder.items.count;
    arrowH = self.builder.arrowHeight;
    scale = self.builder.localScale;
    switch (self.builder.arrowLocation) {
        case ZGPopUpMenuArrowTop:
        case ZGPopUpMenuArrowBottom:{
            if(scale < arrowH/w)
                self.builder.localScale = arrowH/w;
            else if(scale > 1 - arrowH/w)
                self.builder.localScale = 1 - arrowH/w;
        }break;
        case ZGPopUpMenuArrowLeft:
        case ZGPopUpMenuArrowRight:{
            if(scale < arrowH/h)
                self.builder.localScale = arrowH/h;
            else if(scale > 1 - arrowH/h)
                self.builder.localScale = 1 - arrowH/h;
        }break;
        default:
            break;
    }
}
-(void)addShadow{
    if(!self.builder.shadowed)return;
    self.layer.shadowColor=[UIColor blackColor].CGColor;
    self.layer.shadowOffset=CGSizeMake(0, 0);
    self.layer.shadowOpacity=0.5;
    self.layer.shadowRadius=5;
}

-(void)resetView{
    if(self.builder.gaussBlurred){
        if([self.view viewWithTag:kVisualEffectViewTag] == nil){
#ifdef __IPHONE_8_0
            
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            effectView.frame = self.view.frame;
            effectView.alpha = 1;
            effectView.tag = kVisualEffectViewTag;
            [self.view addSubview:effectView];
            [self.view sendSubviewToBack:effectView];
#endif
        }
    }
    CGRect frame = [self getMenuFrame];
    self.frame = frame;
    frame.origin = CGPointMake(-self.builder.arrowHeight, -self.builder.arrowHeight);
    frame.size.width += self.builder.arrowHeight *2;
    frame.size.height += self.builder.arrowHeight *2;
    self.tableView.separatorColor= self.builder.lineColor;
    self.tableView.frame = frame;
    [self.tableView.layer setMask:[self getMaskShapeLayer]];
    [self.tableView reloadData];
    if(self.builder.selectIdx < 0)
        self.builder.selectIdx = 0;
    else if(self.builder.selectIdx >= self.builder.items.count)
        self.builder.selectIdx = self.builder.items.count - 1;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.builder.selectIdx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self addShadow];
    self.view.backgroundColor= self.builder.backgroundColor;
}
#pragma mark- Public Medoth

+(void)popMenuWithBuilder:(void (^)(ZGPopUpMenuViewBuilder *))block{
    [self popMenuWithBuilder:block select:nil];
}
+(void)popMenuWithBuilder:(void (^)(ZGPopUpMenuViewBuilder *))block select:(void (^)(NSInteger, NSString *))action{
    [self popMenuWithBuilder:block select:action cancle:nil];
}

+(void)popMenuWithBuilder:(void (^)(ZGPopUpMenuViewBuilder *))block select:(void (^)(NSInteger, NSString *))selectAction cancle:(void (^)())cancleAction{
    ZGPopUpMenuView *menuView = [[self alloc] init];
    menuView.selectAction = selectAction;
    menuView.cancleAction = cancleAction;
    if(block){
        block(menuView.builder);
        [menuView checkLocalScale];
        [menuView resetView];
        [menuView showMenu];
    }
}


@end
