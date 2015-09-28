//
//  BarrageTools.m
//  barrage
//
//  Created by LAN on 7/29/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import "BarrageTools.h"

@implementation BarrageTools

+ (BarrageTools *)sharedTools
{
    static BarrageTools *tools = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[BarrageTools alloc] init];
    });
    
    return tools;
}

#pragma mark - calc frame needed
+ (CGSize)sizeForString:(NSString *)string andFont:(UIFont *)font
{
    CGSize maximumLabelSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary *attr = @{NSFontAttributeName:font};
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        CGRect labelBounds = [string boundingRectWithSize:maximumLabelSize
                                                  options:options
                                               attributes:attr
                                                  context:nil];
        return labelBounds.size;
    } else {
        CGSize labelSize = [string sizeWithFont:font
                              constrainedToSize:maximumLabelSize
                                  lineBreakMode:NSLineBreakByWordWrapping];
        return labelSize;
    }
}

+ (CGFloat)screenWidth
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

+ (CGFloat)screenHeight
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

@end
