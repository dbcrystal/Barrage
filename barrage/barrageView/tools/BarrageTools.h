//
//  BarrageTools.h
//  barrage
//
//  Created by LAN on 7/29/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BarrageToolsShared [BarrageTools sharedTools]

typedef NS_ENUM(NSInteger, EnumMessageType)
{
    EnumMessageTypeFloat = 0,       //浮动信息
    EnumMessageTypeNailTop,         //顶部固定信息
    EnumMessageTypeNailBottom,      //底部固定信息
};

@interface BarrageTools : UIView

+ (BarrageTools *)sharedTools;

#pragma mark - calc frame needed
+ (CGSize)sizeForString:(NSString *)string andFont:(UIFont *)font;

#pragma mark - UIScreen
//+ (CGFloat)screenWidth;
//+ (CGFloat)screenHeight;

@end
