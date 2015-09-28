//
//  BarrageView.h
//  barrage
//
//  Created by LAN on 7/28/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarrageTools.h"

#define DEFAULT_TRACK_HEIGHT 27
#define DEFAULT_TIMEINTERVAL 7.f

@class BarrageMessageData;

@interface BarrageView : UIView

/* 
 set BarrageView with new font and timeInterval
 font:barrageFont. Nil for default(Helvetica, 24).
 timeInterval:timeInterval for a barrage to disappear.Nil for default(7.f).
 */
- (void)setBarrageViewWithBarrageFont:(UIFont *)font
                       andTimeInteval:(NSTimeInterval)timeInterval;

// add New Barrage to BarrageView with barrageMessage
- (void)addNewBarrageWithMessageData:(BarrageMessageData *)messageData;

// add New Barrage to BarrageView with UIView
- (void)addNewBarrageWithView:(UIView *)barrageMessageView
             withMessgageType:(EnumMessageType)barrageViewMessageType;

- (void)setBarrageViewWithBarrageTimeInterval:(NSTimeInterval)timeInterval;

- (void)reset;

@end
