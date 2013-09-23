//
//  MatchItScene.h
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "cocos2d.h"

@class MatchItScene;

enum DIFFICULTY {
    DIFFICULTY_EASY = 0,
    DIFFICULTY_NORMAL,
    DIFFICULTY_HARD,
    };

#define SHOW_TIP_TIME 3

#define CLEAR_BONUS 100
#define COMBO_BONUS 100
#define COMBO_TIME 5

#define OPACITY_FULL 255
#define OPACITY_HALF OPACITY_FULL / 2

#define MATCH_BUTTON_SIZE_SMALL 32
#define MATCH_BUTTON_SIZE_MEDIUM 48
#define MATCH_BUTTON_SIZE_BIG 64
#define MATCH_BUTTON_SIZE MATCH_BUTTON_SIZE_MEDIUM
#define MATCH_BUTTON_HEIGHT MATCH_BUTTON_SIZE
#define MATCH_BUTTON_WIDTH MATCH_BUTTON_SIZE

#define MATCH_EMPTY_EDGE 1
//#define MATCH_BUTTON_ROWS 20
//#define MATCH_BUTTON_COLS 12
#define MATCH_BUTTON_ROWS 8
#define MATCH_BUTTON_COLS 4
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
    ccTime _notClearTimeSpan;
    
    ccTime _comboTimeSpan;
    int _comboTimes;
    int _bonus;
    CCLabelAtlas *_bonusLabel;
    
    MatchItScene *_scene;
    
    CGPoint _gameAreaPosition;
}

- (id)initWithRandSeed:(unsigned)seed andDict:(NSDictionary *)infoDict andScene:(MatchItScene *)scene;

-(void)gameWin;

-(void)gameLose;

+ (id)node;

+ (id) scene;


@end
