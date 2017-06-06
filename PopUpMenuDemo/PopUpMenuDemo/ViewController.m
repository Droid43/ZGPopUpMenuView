//
//  ViewController.m
//  PopUpMenuDemo
//
//  Created by Zeng Gen on 2017/3/15.
//  Copyright © 2017年 ZengGen. All rights reserved.
//

#import "ViewController.h"
#import "ZGPopUpMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popMenu:(UIButton *) btn{
    static NSUInteger idx = 0;
    [ZGPopUpMenuView popMenuWithBuilder:^(ZGPopUpMenuViewBuilder *builder) {
        ZGPopUpMenuArrowLocation local[] = {ZGPopUpMenuArrowTop, ZGPopUpMenuArrowLeft, ZGPopUpMenuArrowRight, ZGPopUpMenuArrowBottom};
        builder.items = @[@"item0", @"item1", @"item2", @"item3", @"item4"];
        builder.position = btn.center;
        builder.arrowHeight = 5;
        builder.localScale = 0.5;
        builder.arrowLocation = local[0];
        
        builder.selectIdx = idx;
        builder.localScale = (arc4random() % 100) / (CGFloat)100;
        builder.arrowLocation = local[arc4random() % 4];
        
//       builder.selectIdx = arc4random() % builder.items.count;
//       builder.animated = NO;
//       builder.shadowed = NO;
//       builder.gaussBlurred = YES;
        
    } select:^(NSInteger index, NSString *item) {
        idx = index;
        NSLog(@"%zd",index);
    }];
}

@end
