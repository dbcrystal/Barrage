//
//  ViewController.m
//  bulletCurtain
//
//  Created by LeeVic on 3/3/16.
//  Copyright © 2016 LeeVic. All rights reserved.
//

#import "ViewController.h"

#import "RoomBulletCurtainView.h"

@interface ViewController ()

@property (nonatomic, strong) RoomBulletCurtainView *bcView;

@property (nonatomic, strong) NSTimer *floatTimer;
@property (nonatomic, strong) NSTimer *nailedTopTimer;

@property (nonatomic, assign) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bcView = [[RoomBulletCurtainView alloc] initWithFrame:CGRectMake(0.f,
                                                                          0.f,
                                                                          self.view.frame.size.width,
                                                                          self.view.frame.size.height)];
    [self.view addSubview:self.bcView];
    self.index = 0;
    
    // 添加 滚动弹幕
    {
        if (self.floatTimer) {
            [self.floatTimer invalidate];
            self.floatTimer = nil;
        }
        
//        self.floatTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
//                                                           target:self
//                                                         selector:@selector(createNewFloatMessageData)
//                                                         userInfo:nil
//                                                          repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.floatTimer forMode:NSRunLoopCommonModes];
        
        [self createNewFloatMessageData];
    }
    
    
}

#pragma mark - 添加滚动弹幕
- (void)createNewFloatMessageData
{
    for (NSInteger index = 0; index < 15; index++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 420, 40+index%5*10)];
        view.alpha = 0.5f;
        view.backgroundColor = [self randomColor];
        [self.bcView addNewBulletWithView:view
                     andBulletDisplayType:EnumBulletDisplayTypeFixOnBottom];
     }
//    self.index++;
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                            0,
//                                                            520,
//                                                            40+self.index%5*10)];
//    view1.alpha = 0.5f;
//    view1.backgroundColor = [self randomColor];
//    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                             0,
//                                                             720,
//                                                             40+self.index%5*10)];
//    view2.alpha = 0.5f;
//    view2.backgroundColor = [self randomColor];
//    
//    [self.bcView addNewBulletWithView:view1
//                 andBulletDisplayType:EnumBulletDisplayTypeFloat];
//    [self.bcView addNewBulletWithView:view2
//                 andBulletDisplayType:EnumBulletDisplayTypeFloat];
}

- (UIColor *)randomColor
{
    float red = arc4random() % 255 / 255.0;
    float green = arc4random() % 255 / 255.0;
    float blue = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
