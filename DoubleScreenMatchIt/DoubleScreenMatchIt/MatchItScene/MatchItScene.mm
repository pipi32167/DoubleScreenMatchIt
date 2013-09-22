//
//  MatchItScene.m
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-22.
//
//

#import "MatchItScene.h"
#import "cocos2d.h"
#import "MatchItLayer.h"
//#import "CCNodeHelper.h"
#import "Cocos2dHelper.h"

@implementation MatchItScene

+(id) node
{
    return [[[MatchItScene alloc] init] autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [g_Audio preloadBackgroundMusic:@"bg0.wav"];
        [g_Audio preloadEffect:@"click0.wav"];
        [g_Audio preloadEffect:@"clear0.wav"];
        [g_Audio playBackgroundMusic:@"bg0.wav"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UI.plist"];
        
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSDictionary *area1Info = [configDict objectForKey:@"GameAreaInfo1"];
        NSDictionary *area2Info = [configDict objectForKey:@"GameAreaInfo2"];
        
        unsigned seed = time(NULL);
        CGSize winSize = [g_CCNodeHelper winSize];
        
        _upLayer = [[MatchItLayer alloc] initWithRandSeed:seed andDict:area2Info];
//        _upLayer.position = ccp(0, winSize.height/4);
        [self addChild:_upLayer];
        _upLayer.rotation = 180;
        [_upLayer release];
        
        
        _downLayer = [[MatchItLayer alloc] initWithRandSeed:seed andDict:area2Info];
//        _downLayer.position = ccp(0, -winSize.height/4);
        [self addChild:_downLayer];
        [_downLayer release];
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

@end
