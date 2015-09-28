//
//  MessageData.h
//  barrage
//
//  Created by LAN on 7/29/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarrageTools.h"

@interface BarrageMessageData : NSObject

//typedef NS_ENUM(NSInteger, EnumMessageType)
//{
//    EnumMessageTypeFloat = 0,       //浮动信息
//    EnumMessageTypeNailTop,         //顶部固定信息
//    EnumMessageTypeNailBottom,      //底部固定信息
//};

#define DEFAULT_FONT_SIZE 24
#define DEFAULT_FONT_NAME @"Helvetica"

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) EnumMessageType enumMessageType;

- (id)initWithDic:(NSDictionary *)dic;

- (id)initWithMessageData:(BarrageMessageData *)messageData;

- (id)initWithMessageContent:(NSString *)content
              andMessageType:(EnumMessageType)enumMessageType;

- (void)setMessageDataFontWithFontName:(NSString *)fontName
                           andFontSize:(NSInteger)size;

- (NSString *)getFont;
- (NSInteger)getSize;

@end
