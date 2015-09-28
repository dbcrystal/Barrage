//
//  BarrageView.m
//  barrage
//
//  Created by LAN on 7/28/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import "BarrageView.h"
#import "BarrageTrack.h"

#import "BarrageTools.h"
#import "BarrageMessageData.h"

@interface BarrageView ()

@property (nonatomic, strong) NSMutableArray *arrTopBarrageTrack;
@property (nonatomic, strong) NSMutableArray *arrBottomBarrageTrack;

@property (nonatomic, strong) BarrageTrack *presentBarrageTrack;

@property (nonatomic, assign) NSInteger trackCount;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) UIFont *barrageFont;

@end

@implementation BarrageView

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
    
    [self setBarrageViewWithBarrageFont:[UIFont fontWithName:DEFAULT_FONT_NAME
                                                        size:DEFAULT_FONT_SIZE]
                         andTimeInteval:DEFAULT_TIMEINTERVAL];
    
    [self setUserInteractionEnabled:NO];
    [self reset];
}

#pragma mark - change BarrageView Default settings
- (void)setBarrageViewWithBarrageFont:(UIFont *)font
                       andTimeInteval:(NSTimeInterval)timeInterval
{
    CGFloat trackHeight;
    if (font) {
        trackHeight = [BarrageTools sizeForString:@"Test" andFont:font].height;
        self.barrageFont = font;
        self.trackCount = self.bounds.size.height/trackHeight;
        NSLog(@"%f", trackHeight);
    } else {
        trackHeight = DEFAULT_TRACK_HEIGHT;
        self.trackCount = self.bounds.size.height/DEFAULT_TRACK_HEIGHT;
    }
    
    if (timeInterval <= 0.f) {
        self.timeInterval = DEFAULT_TIMEINTERVAL;
    } else {
        self.timeInterval = timeInterval;
    }
    
    if (!self.arrTopBarrageTrack) {
        self.arrTopBarrageTrack = [[NSMutableArray alloc] init];
    }
    [self.arrTopBarrageTrack removeAllObjects];
    
    if(!self.arrBottomBarrageTrack) {
        self.arrBottomBarrageTrack = [[NSMutableArray alloc] init];
    }
    [self.arrBottomBarrageTrack removeAllObjects];
    
    for (int count = 0; count < self.trackCount; count++) {
        BarrageTrack * barrageTrack = [[BarrageTrack alloc] initWithFrame:CGRectMake(0, count*trackHeight, self.bounds.size.width, trackHeight)];
        [self.arrTopBarrageTrack addObject:barrageTrack];
        [self addSubview:barrageTrack];
    }
    
    for (int count = 0; count < self.trackCount; count++) {
        BarrageTrack * barrageTrack = [[BarrageTrack alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-(count+1)*trackHeight, self.bounds.size.width, trackHeight)];
        [self.arrBottomBarrageTrack addObject:barrageTrack];
        [self addSubview:barrageTrack];
    }
    
    self.presentBarrageTrack = [[BarrageTrack alloc] initWithFrame:self.frame];
    [self addSubview:self.presentBarrageTrack];
}

#pragma mark - add new barrage
- (void)addNewBarrageWithMessageData:(BarrageMessageData *)messageData
{
    [messageData setMessageDataFontWithFontName:self.barrageFont.fontName
                                    andFontSize:self.barrageFont.pointSize];
    switch (messageData.enumMessageType) {
        case EnumMessageTypeFloat:                                              //浮动弹幕
            [self addFloatBarrageWithMessageData:messageData
                                    andCellArray:self.arrTopBarrageTrack];
            break;
        case EnumMessageTypeNailTop:                                            //顶部固定弹幕
            [self addTopNailedBarrageWithMessageData:messageData
                                        andCellArray:self.arrTopBarrageTrack];
            break;
        case EnumMessageTypeNailBottom:                                         //底部固定弹幕
            [self addBottomNailedBarrageWithMessageData:messageData
                                           andCellArray:self.arrBottomBarrageTrack];
            break;
        default:
            break;
    }
}

- (void)addFloatBarrageWithMessageData:(BarrageMessageData *)messageData andCellArray:(NSArray *)arr
{
    NSInteger minFloatCount = [[arr objectAtIndex:0] floatBarrageCountInBarrageTrack];
    NSInteger minCountCellAtIndex = 0;
    NSInteger index = 0;
    
    for (BarrageTrack *cell in arr) {
        if ([cell floatBarrageCountInBarrageTrack] == 0) {
            minCountCellAtIndex = index;
            break;
        }
        if ([cell floatBarrageCountInBarrageTrack] < minFloatCount) {
            minFloatCount = [cell floatBarrageCountInBarrageTrack];
            minCountCellAtIndex = index;
        }
        index++;
    }
    [[arr objectAtIndex:minCountCellAtIndex] fillWithMessage:messageData
                                             andTimeInterval:self.timeInterval];
}

- (void)addTopNailedBarrageWithMessageData:(BarrageMessageData *)messageData andCellArray:(NSArray *)arr
{
    NSInteger minTopNailedCount = [[arr objectAtIndex:0] topNailedCount];
    NSInteger minCountCellAtIndex = 0;
    NSInteger index = 0;
    
    for (BarrageTrack *cell in arr) {
        if (cell.isTopNailAvailable) {
            minCountCellAtIndex = index;
            break;
        }
        if (cell.topNailedCount < minTopNailedCount) {
            minTopNailedCount = cell.topNailedCount;
            minCountCellAtIndex = index;
        }
        index++;
    }
    [[arr objectAtIndex:minCountCellAtIndex] fillWithMessage:messageData
                                             andTimeInterval:self.timeInterval];
}

- (void)addBottomNailedBarrageWithMessageData:(BarrageMessageData *)messageData andCellArray:(NSArray *)arr
{
    NSInteger minBottomNailedCount = [[arr objectAtIndex:0] bottomNailedCount];
    NSInteger minCountCellAtIndex = 0;
    NSInteger index = 0;
    
    for (BarrageTrack *cell in arr) {
        if (cell.isBottomNailAvailable) {
            minCountCellAtIndex = index;
            break;
        }
        if (cell.bottomNailedCount < minBottomNailedCount) {
            minBottomNailedCount = cell.bottomNailedCount;
            minCountCellAtIndex = index;
        }
        index++;
    }
    [[arr objectAtIndex:minCountCellAtIndex] fillWithMessage:messageData
                                             andTimeInterval:self.timeInterval];
}

- (void)setBarrageViewWithBarrageTimeInterval:(NSTimeInterval)timeInterval
{
    self.timeInterval = timeInterval;
}

- (void)addNewBarrageWithView:(UIView *)barrageMessageView
             withMessgageType:(EnumMessageType)barrageViewMessageType
{
    [self.presentBarrageTrack fillWithView:barrageMessageView
                              messgageType:barrageViewMessageType
                           andTimeInterval:self.timeInterval];
}

#pragma mark - reset
- (void)reset
{
    self.timeInterval = DEFAULT_TIMEINTERVAL;
}

@end
