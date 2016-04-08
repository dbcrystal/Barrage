//
//  BarrageTrackPanel.h
//  barrage
//
//  Created by LeeVic on 9/28/15.
//  Copyright © 2015 LAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulletData.h"
//#import <AbstractBulletCurtainView.h>

@interface RoomBulletCurtainView : UIView//AbstractBulletCurtainView

- (void)addNewBulletWithView:(UIView *)bulletView
        andBulletDisplayType:(enum EnumBulletDisplayType)displayType;

- (void)reset;

@end
