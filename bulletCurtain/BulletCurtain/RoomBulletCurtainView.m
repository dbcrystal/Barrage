//
//  BarrageTrackPanel.m
//  barrage
//
//  Created by LeeVic on 9/28/15.
//  Copyright © 2015 LAN. All rights reserved.
//

#import "RoomBulletCurtainView.h"



#define BULLET_VIEW_DISPLAY_TIMEINTERVAL 7.f

@interface RoomBulletCurtainView ()

@property (nonatomic, assign) NSInteger lastFloatBulletIndex;
@property (nonatomic, assign) NSInteger lastFixOnTopBulletIndex;
@property (nonatomic, assign) NSInteger lastFixOnBottomBulletIndex;

@property (nonatomic, strong) NSMutableArray *arrBulletCache;
@property (nonatomic, assign) BOOL lock;

@property (nonatomic, strong) NSTimer *timerAddBullets;

@property (nonatomic, strong) NSMutableArray *arrBulletFloat;
@property (nonatomic, strong) NSMutableArray *arrBulletFixOnTop;
@property (nonatomic, strong) NSMutableArray *arrBulletFixOnBottom;

@end

@implementation RoomBulletCurtainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled= NO;
    
    [self reset];
}

#pragma mark - (父类方法)添加新的弹幕 至 指定缓冲池
/**
 *  添加 弹幕 至缓冲池
 *
 *  @param bulletView  需要添加显示的弹幕View
 *  @param displayType 弹幕类型（浮动、置顶、置底）
 */
- (void)addNewBulletWithView:(UIView *)bulletView
        andBulletDisplayType:(enum EnumBulletDisplayType)displayType
{
    BulletData *data = [[BulletData alloc] initWithBulletView:bulletView
                                         andBulletDisplayType:displayType];
    [self.arrBulletCache addObject:data];
    
    if (![self.timerAddBullets isValid]) {
        self.timerAddBullets = [NSTimer scheduledTimerWithTimeInterval:.2f
                                                                target:self
                                                              selector:@selector(showBulletViewsInCache)
                                                              userInfo:nil
                                                               repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timerAddBullets
                                     forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - (子类方法)定时器触发，处理并显示缓冲池中存储的新的弹幕
- (void)showBulletViewsInCache
{
    if (self.lock) {
        return;
    }
    while ([self.arrBulletCache count] != 0) {
        self.lock = YES;
        BulletData *data = [self.arrBulletCache firstObject];
        [self.arrBulletCache removeObjectAtIndex:0];
        [self showBulletWithView:data.bulletView
            andBulletDisplayType:data.enumBulletDisplayType];
    }
    self.lock = NO;
}

/**
 *  将缓冲池中的弹幕 添加显示
 *
 *  @param bulletView  需要添加显示的弹幕View
 *  @param displayType 弹幕类型（浮动、置顶、置底）
 */
- (void)showBulletWithView:(UIView *)bulletView
      andBulletDisplayType:(enum EnumBulletDisplayType)displayType
{
    switch (displayType) {
        case EnumBulletDisplayTypeFloat:                                        /* 浮动弹幕 */
        {
            // Case 1:若浮动弹幕队列为空，则添加新的弹幕动画，并将弹幕添加到队列中
            if (!self.arrBulletFloat || [self.arrBulletFloat count] <= 0) {
                [self.arrBulletFloat addObject:bulletView];
                
                bulletView.frame = CGRectMake(CGRectGetWidth(self.frame),
                                              0.f,
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self addSubview:bulletView];
                
                [self showFloatBulletWithView:bulletView
                              andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFloatBulletIndex = 0;
                
                return;
            }
            
            // Case 2:若浮动弹幕队列非空，则遍历队列，判断是否有弹幕右边缘已经在屏幕内侧，若有，则将新的弹幕添加到其后并显示滚动效果
            for (NSInteger index = 0; index < [self.arrBulletFloat count]; index++) {
                UIView *view = [self.arrBulletFloat objectAtIndex:index];

                if (CGRectGetMaxX([[view.layer presentationLayer] frame]) <= CGRectGetWidth(self.frame) &&
                    [view.layer presentationLayer]) {
                    [self.arrBulletFloat replaceObjectAtIndex:index
                                                   withObject:bulletView];
                    
                    bulletView.frame = CGRectMake(CGRectGetWidth(self.frame),
                                                  index == 0 ? 0.f :
                                                  CGRectGetMaxY([[self.arrBulletFloat objectAtIndex:index-1] frame]),
                                                  CGRectGetWidth(bulletView.frame),
                                                  CGRectGetHeight(bulletView.frame));
                    [self addSubview:bulletView];
                    
                    [self showFloatBulletWithView:bulletView
                                  andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                    
                    self.lastFloatBulletIndex = index;
                    
                    return;
                }
            }
            
            /**
             *  Case 3:
             *
             *  若在上述逻辑之后，没有找到可以显示的位置：
             *
             *  第一种情况：新的弹幕可以放在队列中最新一条弹幕后，不超出屏幕范围
             *            可将新的弹幕添加进队列尾端，并为其添加滚动效果
             *
             */
            if (CGRectGetHeight(bulletView.frame) <=
                CGRectGetMaxY(self.frame) - CGRectGetMaxY([[self.arrBulletFloat lastObject] frame])) {
                
                bulletView.frame = CGRectMake(CGRectGetWidth(self.frame),
                                              CGRectGetMaxY([[self.arrBulletFloat lastObject] frame]),
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self.arrBulletFloat addObject:bulletView];
                [self addSubview:bulletView];
                
                [self showFloatBulletWithView:bulletView
                              andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFloatBulletIndex = [self.arrBulletFloat count] - 1;
                
                return;
            }
            
            /**
             *  第二种情况：所有弹道都已占满
             *            将新的弹幕view放在队列最近一条插入记录后一个元素进行替换，并将新的弹幕view放在这条插入记录frame的下面
             */
            
            // 先判断最近一次弹幕 是不是队列尾端，若是，则改插入位为弹幕队列第一个
            if ([self.arrBulletFloat count] - 1 == self.lastFloatBulletIndex) {
                [self.arrBulletFloat replaceObjectAtIndex:0
                                               withObject:bulletView];
                
                bulletView.frame = CGRectMake(CGRectGetWidth(self.frame),
                                              0.f,
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self addSubview:bulletView];
                
                [self showFloatBulletWithView:bulletView
                              andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFloatBulletIndex = 0;
                
                return;
            }
            
            // 若最近一次弹幕 没有出现在队列尾端，则选择插入位为最近一次弹幕的顺序下一位，并作相应替换
            [self.arrBulletFloat replaceObjectAtIndex:self.lastFloatBulletIndex+1
                                           withObject:bulletView];
            
            bulletView.frame = CGRectMake(CGRectGetWidth(self.frame),
                                          CGRectGetMaxY([[self.arrBulletFloat objectAtIndex:self.lastFloatBulletIndex] frame]),
                                          CGRectGetWidth(bulletView.frame),
                                          CGRectGetHeight(bulletView.frame));
            [self addSubview:bulletView];
            
            
            [self showFloatBulletWithView:bulletView
                          andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
            
            self.lastFloatBulletIndex++;
            
        }
            break;
        case EnumBulletDisplayTypeFixOnTop:                                     /* 置顶弹幕 */
        {
            // Case 1:若置顶弹幕队列为空，则将新的置顶弹幕添加到队列中
            if (!self.arrBulletFixOnTop || [self.arrBulletFixOnTop count] <= 0) {
                [self.arrBulletFixOnTop addObject:bulletView];
                
                bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                              0.f,
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                
                [self addSubview:bulletView];
                
                [self showNailedBulletWithView:bulletView
                               andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFixOnTopBulletIndex = 0;
                
                return;
            }
            
            // Case 2:若置顶弹幕队列非空，则遍历队列，判断是否有弹幕宽度为0.f，若有，则将新的弹幕作替换并显示
            for (NSInteger index = 0; index < [self.arrBulletFixOnTop count]; index++) {
                UIView *view = [self.arrBulletFixOnTop objectAtIndex:index];
                
                if (CGRectGetWidth(view.frame) <= 0.f) {
                    [self.arrBulletFixOnTop replaceObjectAtIndex:index
                                                      withObject:bulletView];
                    
                    bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                                  index == 0 ? 0.f :
                                                  CGRectGetMaxY([[self.arrBulletFixOnTop objectAtIndex:index-1] frame]),
                                                  CGRectGetWidth(bulletView.frame),
                                                  CGRectGetHeight(bulletView.frame));
                    [self addSubview:bulletView];
                    
                    [self showNailedBulletWithView:bulletView
                                   andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                    
                    self.lastFixOnTopBulletIndex = index;
                    
                    return;
                }
            }
            
            /**
             *  Case 3:
             *
             *  若在上述逻辑之后，没有找到可以显示的位置：
             *
             *  第一种情况：新的弹幕可以放在队列中最新一条弹幕后，不超出屏幕范围
             *            可将新的弹幕添加进队列尾端，并显示
             *
             */
            if (CGRectGetHeight(bulletView.frame) <=
                CGRectGetMaxY(self.frame) - CGRectGetMaxY([[self.arrBulletFixOnTop lastObject] frame])) {
                
                bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                              CGRectGetMaxY([[self.arrBulletFixOnTop lastObject] frame]),
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self.arrBulletFixOnTop addObject:bulletView];
                [self addSubview:bulletView];
                
                [self showNailedBulletWithView:bulletView
                               andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFixOnTopBulletIndex = [self.arrBulletFixOnTop count] - 1;
                
                return;
            }
            
            /**
             *  第二种情况：所有弹道都已沾满
             *            将新的弹幕view放在队列最近一条插入记录后一个元素进行替换，并将新的弹幕view放在这条插入记录frame的下面
             */
            
            // 先判断最近一次弹幕 是不是队列尾端，若是，则改插入位为弹幕队列第一个
            if ([self.arrBulletFixOnTop count] - 1 == self.lastFixOnTopBulletIndex) {
                [self.arrBulletFixOnTop replaceObjectAtIndex:0
                                                  withObject:bulletView];
                
                bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                              0.f,
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self addSubview:bulletView];
                
                [self showNailedBulletWithView:bulletView
                               andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFixOnTopBulletIndex = 0;
                
                return;
            }
            
            // 若最近一次弹幕 没有出现在队列尾端，则选择插入位为最近一次弹幕的顺序下一位，并作相应替换
            [self.arrBulletFixOnTop replaceObjectAtIndex:self.lastFixOnTopBulletIndex+1
                                              withObject:bulletView];
            
            bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                          CGRectGetMaxY([[self.arrBulletFixOnTop objectAtIndex:self.lastFixOnTopBulletIndex] frame]),
                                          CGRectGetWidth(bulletView.frame),
                                          CGRectGetHeight(bulletView.frame));
            [self addSubview:bulletView];
            
            
            [self showNailedBulletWithView:bulletView
                           andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
            
            self.lastFixOnTopBulletIndex++;
        }
            break;
        case EnumBulletDisplayTypeFixOnBottom:                                      /* 置底弹幕 */
        {
            // Case 1:若置底弹幕队列为空，则将新的置底弹幕添加到队列中
            if (!self.arrBulletFixOnBottom || [self.arrBulletFixOnBottom count] <= 0) {
                [self.arrBulletFixOnBottom addObject:bulletView];
                
                bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                              CGRectGetHeight(self.frame)-CGRectGetHeight(bulletView.frame),
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                
                [self addSubview:bulletView];
                
                [self showNailedBulletWithView:bulletView
                               andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFixOnBottomBulletIndex = 0;
                
                return;
            }
            
            // Case 2:若置底弹幕队列非空，则遍历队列，判断是否有弹幕宽度为0.f，若有，则将新的弹幕作替换并显示
            for (NSInteger index = 0; index < [self.arrBulletFixOnBottom count]; index++) {
                UIView *view = [self.arrBulletFixOnBottom objectAtIndex:index];
                
                if (CGRectGetWidth(view.frame) <= 0.f) {
                    [self.arrBulletFixOnBottom replaceObjectAtIndex:index
                                                         withObject:bulletView];
                    
                    bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                                  index == 0 ? CGRectGetHeight(self.frame)-CGRectGetHeight(bulletView.frame) :
                                                  CGRectGetMinY([[self.arrBulletFixOnBottom objectAtIndex:index-1] frame])-CGRectGetHeight(bulletView.frame),
                                                  CGRectGetWidth(bulletView.frame),
                                                  CGRectGetHeight(bulletView.frame));
                    [self addSubview:bulletView];
                    
                    [self showNailedBulletWithView:bulletView
                                   andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                    
                    self.lastFixOnBottomBulletIndex = index;
                    
                    return;
                }
            }
            
            /**
             *  Case 3:
             *
             *  若在上述逻辑之后，没有找到可以显示的位置：
             *
             *  第一种情况：新的弹幕可以放在队列中最新一条弹幕后，不超出屏幕范围
             *            可将新的弹幕添加进队列尾端，并显示
             *
             */
            if (CGRectGetHeight(bulletView.frame) <= CGRectGetMinY([[self.arrBulletFixOnBottom lastObject] frame])) {
                
                bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                              CGRectGetMinY([[self.arrBulletFixOnBottom lastObject] frame])-CGRectGetHeight(bulletView.frame),
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self.arrBulletFixOnBottom addObject:bulletView];
                [self addSubview:bulletView];
                
                [self showNailedBulletWithView:bulletView
                               andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFixOnBottomBulletIndex = [self.arrBulletFixOnBottom count] - 1;
                
                return;
            }
            
            /**
             *  第二种情况：所有弹道都已沾满
             *            将新的弹幕view放在队列最近一条插入记录后一个元素进行替换，并将新的弹幕view放在这条插入记录frame的下面
             */
            
            // 先判断最近一次弹幕 是不是队列尾端，若是，则改插入位为弹幕队列第一个
            //            if ([self.arrBulletFixOnBottom count] - 1 == self.lastFixOnBottomBulletIndex) {
            if (CGRectGetHeight(bulletView.frame) >
                CGRectGetMinY([[self.arrBulletFixOnBottom objectAtIndex:self.lastFixOnBottomBulletIndex] frame])) {
                [self.arrBulletFixOnBottom replaceObjectAtIndex:0
                                                     withObject:bulletView];
                
                bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                              CGRectGetHeight(self.frame)-CGRectGetHeight(bulletView.frame),
                                              CGRectGetWidth(bulletView.frame),
                                              CGRectGetHeight(bulletView.frame));
                [self addSubview:bulletView];
                
                [self showNailedBulletWithView:bulletView
                               andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
                
                self.lastFixOnBottomBulletIndex = 0;
                
                return;
            }
            
            // 若最近一次弹幕 没有出现在队列尾端，则选择插入位为最近一次弹幕的顺序下一位，并作相应替换
            [self.arrBulletFixOnBottom replaceObjectAtIndex:self.lastFixOnBottomBulletIndex+1
                                                 withObject:bulletView];
            
            bulletView.frame = CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(bulletView.frame))/2,
                                          CGRectGetMinY([[self.arrBulletFixOnBottom objectAtIndex:self.lastFixOnBottomBulletIndex] frame])-CGRectGetHeight(bulletView.frame),
                                          CGRectGetWidth(bulletView.frame),
                                          CGRectGetHeight(bulletView.frame));
            [self addSubview:bulletView];
            
            
            [self showNailedBulletWithView:bulletView
                           andTimeInterval:BULLET_VIEW_DISPLAY_TIMEINTERVAL];
            
            self.lastFixOnBottomBulletIndex++;
        }
            break;
        default:
            break;
    }
}

#pragma mark - show float barrage
- (void)showFloatBulletWithView:(UIView *)view
                andTimeInterval:(NSTimeInterval)timeInterval
{
    [UIView animateWithDuration:timeInterval
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         view.frame = CGRectMake(-CGRectGetWidth(view.frame),
                                                 CGRectGetMinY(view.frame),
                                                 CGRectGetWidth(view.frame),
                                                 CGRectGetHeight(view.frame));
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

#pragma mark - show nailed barrage
- (void)showNailedBulletWithView:(UIView *)view
                 andTimeInterval:(NSTimeInterval)timeInterval
{
    [self performSelector:@selector(removeBulletView:)
               withObject:view
               afterDelay:timeInterval];
}

- (void)removeBulletView:(UIView *)view
{
    [view removeFromSuperview];
    view.frame = CGRectMake(CGRectGetMinX(view.frame),
                            CGRectGetMinY(view.frame),
                            0.f,
                            CGRectGetHeight(view.frame));
}

- (void)reset
{
    // 重置 弹幕存储队列 及 标记位
    self.lastFloatBulletIndex = 0;
    self.lastFixOnTopBulletIndex = 0;
    self.lastFixOnBottomBulletIndex = 0;
    
    if (!self.arrBulletFloat) {
        self.arrBulletFloat = [[NSMutableArray alloc] init];
    }
    [self.arrBulletFloat removeAllObjects];
    
    if (!self.arrBulletFixOnTop) {
        self.arrBulletFixOnTop = [[NSMutableArray alloc] init];
    }
    [self.arrBulletFixOnTop removeAllObjects];
    
    if (!self.arrBulletFixOnBottom) {
        self.arrBulletFixOnBottom = [[NSMutableArray alloc] init];
    }
    [self.arrBulletFixOnBottom removeAllObjects];
    
    // 移除 弹幕 及 动画
    NSArray *viewsToRemove = [self subviews];
    for (UIView *view in viewsToRemove) {
        [view.layer removeAllAnimations];
        [view removeFromSuperview];
    }
    
    // 清空 弹幕缓冲池
    if (!self.arrBulletCache) {
        self.arrBulletCache = [[NSMutableArray alloc] init];
    }
    [self.arrBulletCache removeAllObjects];
    
    if (self.timerAddBullets) {
        [self.timerAddBullets invalidate];
        self.timerAddBullets = nil;
    }
    self.lock = NO;
}

@end
