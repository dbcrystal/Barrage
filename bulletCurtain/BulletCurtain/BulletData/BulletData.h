//
//  BulletData.h
//  v6cn-iPhone
//
//  Created by LeeVic on 3/4/16.
//  Copyright © 2016 Darcy Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AbstractBulletCurtainView.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EnumBulletDisplayType)
{
    EnumBulletDisplayTypeFloat = 0,			//浮动信息
    EnumBulletDisplayTypeFixOnTop,			//顶部固定信息
    EnumBulletDisplayTypeFixOnBottom		//底部固定信息
};

@interface BulletData : NSObject

@property (nonatomic, strong) UIView *bulletView;
@property (nonatomic, assign) EnumBulletDisplayType enumBulletDisplayType;

- (instancetype)initWithBulletView:(UIView *)bulletView
              andBulletDisplayType:(EnumBulletDisplayType)enumType;

@end
