//
//  BarrageTableViewCell.m
//  barrage
//
//  Created by LAN on 7/28/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import "BarrageTrack.h"

#import "BarrageTools.h"
#import "BarrageMessageData.h"

@interface BarrageTrack ()

@property (nonatomic, strong) NSMutableArray *arrFloatBarrageLabel;

@end

@implementation BarrageTrack

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
    
    self.topNailAvailable = YES;
    self.bottomNailAvailable = YES;
    
    self.floatCount = 0;
    self.topNailedCount = 0;
    self.bottomNailedCount = 0;
    
    if (!self.arrFloatBarrageLabel) {
        self.arrFloatBarrageLabel = [[NSMutableArray alloc] init];
    }
    [self.arrFloatBarrageLabel removeAllObjects];
}

- (void)reset
{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *view in viewsToRemove) {
        [view removeFromSuperview];
    }
    
    self.topNailAvailable = YES;
    self.bottomNailAvailable = YES;
    
    self.floatCount = 0;
    self.topNailedCount = 0;
    self.bottomNailedCount = 0;
}

#pragma mark - init barrage
- (void)fillWithMessage:(BarrageMessageData *)messageData
        andTimeInterval:(NSTimeInterval)timeInterval
{
    CGSize size = [BarrageTools sizeForString:messageData.content andFont:[UIFont fontWithName:[messageData getFont]
                                                                                          size:[messageData getSize]]];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = messageData.content;
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.alpha = 0.8;
    lbl.font = [UIFont fontWithName:[messageData getFont]
                               size:[messageData getSize]];
    lbl.layer.shadowColor = [[UIColor blackColor] CGColor];
    lbl.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    lbl.layer.shadowOpacity = 1.f;
    lbl.layer.shadowRadius = 1.f;
    
    if (messageData.enumMessageType == EnumMessageTypeFloat) {
        lbl.frame = CGRectMake(self.bounds.size.width, 0, size.width, size.height);
        [self addSubview:lbl];
        [self.arrFloatBarrageLabel addObject:lbl];
        
        [self showFloatBarrageWithView:lbl andTimeInterval:timeInterval];
    } else {
        lbl.frame = CGRectMake(0, 0, size.width, size.height);
        lbl.center = CGPointMake(self.bounds.size.width / 2, lbl.center.y);
        [self addSubview:lbl];
        
        [self addNailedCount:messageData.enumMessageType];
        [self showNailBarrageWithView:lbl messageType:messageData.enumMessageType andTimeInterval:timeInterval];
    }
}

- (void)fillWithView:(UIView *)barrageMessageView
        messgageType:(EnumMessageType)barrageViewMessageType
     andTimeInterval:(NSTimeInterval)timeInterval
{
    if (barrageViewMessageType == EnumMessageTypeFloat) {
        barrageMessageView.frame = CGRectMake(self.bounds.size.width, 0, CGRectGetWidth(barrageMessageView.frame), CGRectGetHeight(barrageMessageView.frame));
        [self addSubview:barrageMessageView];
        
        [self showFloatBarrageWithView:barrageMessageView
                       andTimeInterval:timeInterval];
    } else {
        barrageMessageView.center = CGPointMake(self.center.x, CGRectGetHeight(barrageMessageView.frame)/2);
        [self addSubview:barrageMessageView];
        
        [self showNailBarrageWithView:barrageMessageView
                          messageType:EnumMessageTypeNailTop
                      andTimeInterval:timeInterval];
    }
}

#pragma mark - modify Float Barrage Status
- (NSInteger)floatBarrageCountInBarrageTrack
{
    NSInteger floatBarrageCount = 0;
    for (UILabel *label in self.arrFloatBarrageLabel) {
        if (label.bounds.size.width+[[label.layer presentationLayer] frame].origin.x >= self.bounds.size.width) {
            floatBarrageCount++;
        }
    }
    return floatBarrageCount;
}

- (BOOL)isAvailableForNewFloatBarrage
{
    for (UILabel *label in self.arrFloatBarrageLabel) {
        if (label.bounds.size.width+[[label.layer presentationLayer] frame].origin.x >= self.bounds.size.width) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - modify Nailed Barrage Count
- (void)addNailedCount:(EnumMessageType)messageType
{
    if (messageType == EnumMessageTypeNailTop) {
        self.topNailedCount++;
        self.topNailAvailable = NO;
    } else if (messageType == EnumMessageTypeNailBottom) {
        self.bottomNailedCount++;
        self.bottomNailAvailable = NO;
    }
}

- (void)removeNailedCount:(EnumMessageType)messageType
{
    if (messageType == EnumMessageTypeNailTop) {
        self.topNailedCount--;
        if (self.topNailedCount == 0) {
            self.topNailAvailable = YES;
        }
    } else if (messageType == EnumMessageTypeNailBottom) {
        self.bottomNailedCount--;
        if (self.bottomNailedCount == 0) {
            self.bottomNailAvailable = YES;
        }
    }
}

#pragma mark - show float barrage
- (void)showFloatBarrageWithView:(UIView *)label andTimeInterval:(NSTimeInterval)timeInterval
{
    self.floatCount++;
    
    [UIView animateWithDuration:timeInterval
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         label.frame = CGRectMake(-label.bounds.size.width, 0, label.bounds.size.width, label.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         //从界面中去掉已经显示完成的弹幕，并将该弹幕的Label从数组中去掉
                         [label removeFromSuperview];
                         [self.arrFloatBarrageLabel removeObject:label];
                     }];
}

#pragma mark - show nailed barrage
- (void)showNailBarrageWithView:(UIView *)label messageType:(EnumMessageType)messageType andTimeInterval:(NSTimeInterval)timeInterval
{    
    NSArray *arrayOfShitINeedToPassAlong = @[label, [NSNumber numberWithInteger:messageType]];
    
    [self performSelector:@selector(removeNailBarrage:) withObject:arrayOfShitINeedToPassAlong afterDelay:timeInterval];
}

//- (void)removeNailBarrage:(UILabel *)label andMessageType:(EnumMessageType)messageType
- (void)removeNailBarrage:(NSArray *)arr
{
    [self removeNailedCount:[[arr objectAtIndex:1] integerValue]];
    
    [[arr objectAtIndex:0] removeFromSuperview];
}

@end
