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
#import "DebugLayer.h"
#import "ResourceConfig.h"

@implementation MatchItScene

+(id) node
{
    return [[[MatchItScene alloc] init] autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [g_Audio preloadBackgroundMusic:SFX_MATCH_BACKGROUND];
        [g_Audio preloadEffect:SFX_MATCH_CLICK];
        [g_Audio preloadEffect:SFX_MATCH_COMBO];
        [g_Audio playBackgroundMusic:SFX_MATCH_BACKGROUND];
        
        [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UI.plist"];
        
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//        NSDictionary *area1Info = [configDict objectForKey:@"GameAreaInfo1"];
        NSDictionary *area2Info = [configDict objectForKey:@"GameAreaInfo2"];
        
        unsigned seed = time(NULL);
//        CGSize winSize = [g_CCNodeHelper winSize];
        
        _upLayer = [[MatchItLayer alloc] initWithRandSeed:seed andDict:area2Info andScene:self];
//        _upLayer.position = ccp(0, winSize.height/4);
        [self addChild:_upLayer z:0];
        _upLayer.rotation = 180;
        [_upLayer release];
        
        _downLayer = [[MatchItLayer alloc] initWithRandSeed:seed andDict:area2Info andScene:self];
//        _downLayer.position = ccp(0, -winSize.height/4);
        [self addChild:_downLayer z:0];
        [_downLayer release];
        
        [self addChild:[DebugLayer node] z:1];
        
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

-(void)winnerIs:(MatchItLayer *)layer
{
    if (layer == _downLayer) {
        
        [_downLayer gameWin];
        [_upLayer gameLose];
    } else {
        [_downLayer gameLose];
        [_upLayer gameWin];
    }
}

@end
