//
//  MatchItScene.h
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "CCLayer.h"

@class CCMenuItemImage;

#define MATCH_BUTTON_HEIGHT 32
#define MATCH_BUTTON_WIDTH 32
#define MATCH_BUTTON_ROWS 10
#define MATCH_BUTTON_COLS 10
#define MATCH_BUTTON_COUNT MATCH_BUTTON_ROWS * MATCH_BUTTON_COLS

typedef struct PosIndex
{
    int x, y;
} PosIndex;

@interface MatchItLayer : CCLayer
{
    CCMenuItemImage *_matchButtons[MATCH_BUTTON_ROWS][MATCH_BUTTON_COLS];
    CCArray *_matchButtonFileNames;
    CCArray *_matchButtonSprites;
    CCMenuItemImage *_beforeClickedImage ;
}

- (id)initWithRandSeed:(unsigned)seed andDict:(NSDictionary *)infoDict;

+ (id)node;

+ (id) scene;


@end
