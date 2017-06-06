# ZGPopUpMenuView

一行代码实现的弹出式菜单，带有小箭头效果

**注意：**iOS 8以下不支持高斯模糊背景的显示

## 效果图

 ![](http://onj3jyfip.bkt.clouddn.com/blog/popupmenuview/img/popupmenu.gif)

## 使用示例：


```objective-c
    [ZGPopUpMenuView popMenuWithBuilder:^(ZGPopUpMenuViewBuilder *builder) {
        builder.items = @[@"item0", @"item1", @"item2", @"item3", @"item4"];
        builder.position = CGPointMake(150,100);
        builder.arrowHeight = 5;
        builder.localScale = 0.5;
        builder.selectIdx = 0;
        builder.gaussBlurred = YES;
    } select:^(NSInteger index, NSString *item) {
        NSLog(@"%zd",index);
    }];
```

