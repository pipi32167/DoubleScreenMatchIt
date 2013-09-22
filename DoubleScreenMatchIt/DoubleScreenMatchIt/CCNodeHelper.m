//
//  CCNodeHelper.m
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "CCNodeHelper.h"
#import "cocos2d.h"

@implementation CCNodeHelper

static CCNodeHelper *_sharedCCNodeHelper;

+ (CCNodeHelper *)sharedCCNodeHelper
{
    if (!_sharedCCNodeHelper) {
        _sharedCCNodeHelper = [[CCNodeHelper alloc] init];
    }
    return _sharedCCNodeHelper;
}

+(id)alloc
{
	NSAssert(_sharedCCNodeHelper == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

-(CGPoint)anchorAtCenterOfScreen
{
    return ccp(0.5, 0.5);
}

-(CGPoint)anchorAtLeftBottomOfScreen
{
    return ccp(0, 0);
}

-(CGPoint)anchorAtLeftTopOfScreen
{
    return ccp(0, 1);
}

-(CGPoint)anchorAtRightBottomOfScreen
{
    return ccp(1, 0);
}

-(CGPoint)anchorAtRightTopOfScreen
{
    return ccp(1, 1);
}

-(CGPoint)positionAtCenterOfScreenBySize:(CGSize)size
{
    CGPoint centerOfDirector = [self positionAtCenterOfScreen];
    return [self getInitPositionByPoint:centerOfDirector andSize:size];
}


-(CGPoint)getInitPositionByPoint:(CGPoint)point andSize:(CGSize)size
{
    return ccp(point.x - size.width/2, point.y - size.height/2);
}

-(CGPoint)positionAtCenterOfScreen
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width/2, winSize.height/2);
}

-(CGPoint)positionAtLeftBottomOfScreen
{
    return ccp(0, 0);
}

-(CGPoint)positionAtLeftTopOfScreen
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(0, winSize.height);
}


-(CGPoint)positionAtRightTopOfScreen
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width, winSize.height);
}

-(CGPoint)positionAtRightBottomOfScreen
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width, 0);
}

-(CGSize)winSize
{
    return [[CCDirector sharedDirector] winSize];
}

@end
