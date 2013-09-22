//
//  MatchItScene.h
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-22.
//
//

#import "CCScene.h"

@class MatchItLayer;

@interface MatchItScene : CCScene
{
    MatchItLayer* _upLayer;
    MatchItLayer* _downLayer;
}

+(id) node;

@end
