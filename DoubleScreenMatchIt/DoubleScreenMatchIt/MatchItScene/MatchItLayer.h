//
//  MatchItScene.h
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "CCLayer.h"

@class CCMenuItemImage;

enum DIFFICULTY {
    DIFFICULTY_EASY = 0,
    DIFFICULTY_NORMAL,
    DIFFICULTY_HARD,
    };

#define OPACITY_FULL 255
#define OPACITY_HALF OPACITY_FULL / 2

#define MATCH_BUTTON_HEIGHT 32
#define MATCH_BUTTON_WIDTH 32
#define MATCH_EMPTY_EDGE 1
#define MATCH_BUTTON_ROWS 20
#define MATCH_BUTTON_COLS 12
#define MATCH_BUTTON_COUNT MATCH_BUTTON_ROWS * MATCH_BUTTON_COLS

typedef struct PosIndex
{
    int x, y;
} PosIndex;

@interface MatchItLayer : CCLayer
{
    enum DIFFICULTY _difficulty;
    CCMenuItemImage *_matchButtons[MATCH_BUTTON_ROWS][MATCH_BUTTON_COLS];
    CCArray *_matchButtonFileNames;
    CCMenuItemImage *_beforeClickedImage ;
}

- (id)initWithRandSeed:(unsigned)seed andDict:(NSDictionary *)infoDict;

+ (id)node;

+ (id) scene;


@end
