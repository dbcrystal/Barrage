//
//  BarrageTableViewCell.h
//  barrage
//
//  Created by LAN on 7/28/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarrageTools.h"

@class BarrageMessageData;

@interface BarrageTrack : UIView

@property (nonatomic, assign, getter=isTopNailAvailable) BOOL topNailAvailable;
@property (nonatomic, assign, getter=isBottomNailAvailable) BOOL bottomNailAvailable;

@property (nonatomic, assign) NSInteger floatCount;
@property (nonatomic, assign) NSInteger topNailedCount;
@property (nonatomic, assign) NSInteger bottomNailedCount;

- (NSInteger)floatBarrageCountInBarrageTrack;
- (BOOL)isAvailableForNewFloatBarrage;

- (void)fillWithMessage:(BarrageMessageData *)messageData
        andTimeInterval:(NSTimeInterval)timeInterval;

- (void)fillWithView:(UIView *)barrageMessageView
        messgageType:(EnumMessageType)barrageViewMessageType
     andTimeInterval:(NSTimeInterval)timeInterval;

@end
