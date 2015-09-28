//
//  MessageData.m
//  barrage
//
//  Created by LAN on 7/29/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import "BarrageMessageData.h"

@interface BarrageMessageData ()

@property (nonatomic, strong) NSString *font;
//@property (nonatomic, strong, readonly) NSString *color;
@property (nonatomic, assign) NSInteger size;

@end

@implementation BarrageMessageData

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.content = [dic objectForKey:@"content"];
        self.font = DEFAULT_FONT_NAME;
        self.size = DEFAULT_FONT_SIZE;
        
        self.enumMessageType = [[dic objectForKey:@"messageType"] integerValue] > EnumMessageTypeNailBottom ? EnumMessageTypeFloat : [[dic objectForKey:@"messageType"] integerValue];
    }
    return self;
}

- (id)initWithMessageData:(BarrageMessageData *)messageData
{
    self = [super init];
    if (self) {
        self.content = messageData.content;
        self.font = DEFAULT_FONT_NAME;
        self.size = DEFAULT_FONT_SIZE;
        
        self.enumMessageType = messageData.enumMessageType;
    }
    return self;
}

- (id)initWithMessageContent:(NSString *)content
              andMessageType:(EnumMessageType)enumMessageType
{
    self = [super init];
    if (self) {
        self.content = content;
//        self.font = [font isEqualToString:@""] ? @"Helvetica" : font;
//        self.size = size == 0 ? DEFAULT_FONT_SIZE :size;
        self.font = DEFAULT_FONT_NAME;
        self.size = DEFAULT_FONT_SIZE;
        
        self.enumMessageType = enumMessageType;
    }
    return self;
}

- (void)setMessageDataFontWithFontName:(NSString *)fontName
                           andFontSize:(NSInteger)size
{
    self.font = [fontName isEqualToString:@""] ? DEFAULT_FONT_NAME : fontName;
    self.size = size <= 0 ? DEFAULT_FONT_SIZE :size;
}

- (NSString *)getFont
{
    return self.font;
}

- (NSInteger)getSize
{
    return self.size;
}

@end
