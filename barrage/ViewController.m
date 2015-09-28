//
//  ViewController.m
//  barrage
//
//  Created by LAN on 7/28/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import "ViewController.h"
#import "BarrageView.h"
#import "EditBarrageViewController.h"

#import "BarrageMessageData.h"

@interface ViewController ()

@property (nonatomic, strong) BarrageView *barrageView;

@property (nonatomic, strong) NSTimer *floatTimer;
@property (nonatomic, strong) NSTimer *nailedTopTimer;
@property (nonatomic, strong) NSTimer *nailedBottomTime;

@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
}

- (void)createUI
{
    self.count = 0;
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.floatTimer) {
        [self.floatTimer invalidate];
        self.floatTimer = nil;
    }
    
    self.floatTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                       target:self
                                                     selector:@selector(createNewMessageData)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.floatTimer forMode:NSRunLoopCommonModes];
    
    if (self.nailedTopTimer) {
        [self.nailedTopTimer invalidate];
        self.nailedTopTimer = nil;
    }
    
    self.nailedTopTimer = [NSTimer scheduledTimerWithTimeInterval:1.3f
                                                       target:self
                                                     selector:@selector(createNewTopNailedMessageData)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.nailedTopTimer forMode:NSRunLoopCommonModes];

    if (self.nailedBottomTime) {
        [self.nailedBottomTime invalidate];
        self.nailedBottomTime = nil;
    }
    
    self.nailedBottomTime = [NSTimer scheduledTimerWithTimeInterval:1.3f
                                                       target:self
                                                     selector:@selector(createNewBottomNailedMessageData)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.nailedBottomTime forMode:NSRunLoopCommonModes];

    self.barrageView = [[BarrageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [self.barrageView setBarrageViewWithBarrageFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]
                                     andTimeInteval:11.f];
    [self.view addSubview:self.barrageView];
}

- (void)createNewMessageData
{
    BarrageMessageData *data = [[BarrageMessageData alloc] initWithMessageContent:@"我从未见过如此厚颜无耻之人"
                                                     andMessageType:EnumMessageTypeFloat];
    
    [self.barrageView addNewBarrageWithMessageData:data];
    
    self.count++;
    if (self.count%10 == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
        view.backgroundColor = [UIColor yellowColor];
        [self.barrageView addNewBarrageWithView:view withMessgageType:EnumMessageTypeFloat];
    }
}

- (void)createNewTopNailedMessageData
{
    BarrageMessageData *data = [[BarrageMessageData alloc] initWithMessageContent:@"我从未见过如此厚颜无耻之人"                                                     andMessageType:EnumMessageTypeNailTop];
    
    [self.barrageView addNewBarrageWithMessageData:data];
    
    self.count++;
    if (self.count%10 == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
        view.backgroundColor = [UIColor yellowColor];
        [self.barrageView addNewBarrageWithView:view withMessgageType:EnumMessageTypeNailTop];
    }
}

- (void)createNewBottomNailedMessageData
{
    BarrageMessageData *data = [[BarrageMessageData alloc] initWithMessageContent:@"我从未见过如此厚颜无耻之人"
                                                     andMessageType:EnumMessageTypeNailBottom];
    
    [self.barrageView addNewBarrageWithMessageData:data];
}

-(void)btnInitBarrageWrittenPage
{
    EditBarrageViewController *editBarrageViewController = [[EditBarrageViewController alloc] init];
    [self.navigationController pushViewController:editBarrageViewController
                                         animated:YES];
}

@end
