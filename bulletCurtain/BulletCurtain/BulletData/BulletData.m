//
//  BulletData.m
//  v6cn-iPhone
//
//  Created by LeeVic on 3/4/16.
//  Copyright © 2016 Darcy Niu. All rights reserved.
//

#import "BulletData.h"

@implementation BulletData

- (instancetype)initWithBulletView:(UIView *)bulletView
              andBulletDisplayType:(EnumBulletDisplayType)enumType
{
    self = [super init];
    if (self) {
        self.bulletView = bulletView;
        self.enumBulletDisplayType = enumType;
    }
    return self;
}

@end
