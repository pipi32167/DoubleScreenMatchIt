//
//  MatchItScene.m
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "MatchItLayer.h"
#import "cocos2d.h"
#import "Cocos2dHelper.h"

@implementation MatchItLayer

+(id) node
{
    return [[[MatchItLayer alloc] init] autorelease];
}

+(id) scene
{
    id scene = [CCScene node];
    id layer = [MatchItLayer node];
    [scene addChild:layer];
    return  scene;
}

- (id)initWithRandSeed:(unsigned)seed andDict:(NSDictionary *)infoDict
{
    self = [super init];
    if (self) {
        
        srand(seed);
        
        //5 is temp number
        NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:MATCH_BUTTON_COUNT + 5];
        
        CGSize totalSize = CGSizeMake(MATCH_BUTTON_WIDTH * MATCH_BUTTON_ROWS, MATCH_BUTTON_HEIGHT * MATCH_BUTTON_COLS);
//        CGPoint initPosition = [g_CCNodeHelper positionAtCenterOfScreenBySize:totalSize];
        NSDictionary *posDict = [infoDict objectForKey:@"MainAreaPosition"];
        CGPoint gameAreaPosition = ccp([[posDict objectForKey:@"X"] floatValue],
                            [[posDict objectForKey:@"Y"] floatValue]);
        CGPoint initPosition = [g_CCNodeHelper getInitPositionByPoint:gameAreaPosition andSize:totalSize];
        
        [self setupMatchButtonFileNames];
        
        int randomShuffleArray[MATCH_BUTTON_ROWS - 2][MATCH_BUTTON_COLS - 2] = {0};
        [self setupRandomShuffleArray:*randomShuffleArray withLength:((MATCH_BUTTON_ROWS - 2) * (MATCH_BUTTON_COLS - 2))];
        
        for (int i = 0; i < MATCH_BUTTON_ROWS; i++) {
            for (int j = 0; j < MATCH_BUTTON_COLS; j++) {
                
                int imageIndex ;
                CCSprite *sprite;
                BOOL visible ;
                
                if (i == 0 || i == MATCH_BUTTON_ROWS - 1
                    || j == 0 || j == MATCH_BUTTON_COLS - 1) {
                    
                    imageIndex = [_matchButtonFileNames count];
                    sprite = [CCSprite spriteWithSpriteFrameName:@"emptyButton.png"];
                    visible = NO;
                    
                } else {
                    
                    imageIndex = randomShuffleArray[i-1][j-1];
                    sprite = [CCSprite spriteWithSpriteFrameName:[_matchButtonFileNames objectAtIndex:imageIndex]];
                    visible = YES;
                }
                
                CCMenuItemImage *item = [CCMenuItemImage itemWithNormalSprite:sprite selectedSprite:nil block:^(id sender) {
                    
                    [self clickWithButton:sender];
                }];
                
                item.visible = visible;
                item.tag = imageIndex;
                item.position = ccp(initPosition.x + i * MATCH_BUTTON_WIDTH,
                                    initPosition.y + j * MATCH_BUTTON_HEIGHT);
                item.anchorPoint = ccp(0, 0);
                
                [buttonArray addObject:item];
                
                _matchButtons[i][j] = item;
            }
        }
//
//        CCMenuItemImage *buttonTips = [CCMenuItemImage itemWithNormalImage:@"button_tips.png" selectedImage:@"button_tips.png" target:self selector:@selector(tip)];
//        CGSize winSize = [g_CCNodeHelper winSize];
//        buttonTips.position = ccp(winSize.width * 3 / 4, winSize.height * 1 / 6);
//        [buttonArray addObject:buttonTips];
//        
//        CCMenuItemImage *buttonReset = [CCMenuItemImage itemWithNormalImage:@"button_reset.png" selectedImage:@"button_reset.png" target:self selector:@selector(reset)];
//        buttonReset.position = ccp(winSize.width * 3 / 4, winSize.height * 2 / 6);
//        [buttonArray addObject:buttonReset];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png" ];
        bg.position = [g_CCNodeHelper positionAtLeftBottomOfScreen];
        bg.anchorPoint = [g_CCNodeHelper anchorAtLeftBottomOfScreen];
        [self addChild:bg];
        
        CCSprite *bg2 = [CCSprite spriteWithFile:@"background2.png"];
        bg2.position = gameAreaPosition;
        [bg addChild:bg2];
        
        CCMenu *menu = [CCMenu menuWithArray:buttonArray];
        menu.position = [g_CCNodeHelper positionAtLeftBottomOfScreen];
        //        menu.anchorPoint = [g_CCNodeHelper anchorAtCenterOfScreen];
        [self addChild:menu];
        
    }
    return self;
}

-(void)tip
{
    
}

-(void)reset
{
    
}

- (void)setupMatchButtonFileNames
{
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *matchButtonInfoDict = [configDict objectForKey:@"MatchButtonInfo"];
    
    NSString *imageFile = [matchButtonInfoDict objectForKey:@"FileName"];
    int beginId = [[matchButtonInfoDict objectForKey:@"BeginId"] intValue];
    int endId = [[matchButtonInfoDict objectForKey:@"EndId"] intValue];
    
    _matchButtonFileNames = [[CCArray alloc] initWithCapacity:(endId - beginId + 1)];
    for (int i  = beginId; i <= endId; i++) {
        
        NSString *fileName = [NSString stringWithFormat:imageFile, i];
        [_matchButtonFileNames addObject:fileName];
    }
}

- (void)setupRandomShuffleArray:(int *)array withLength:(int)length
{
    int count = [_matchButtonFileNames count];
    for (int i = 0; i < length; i+=2) {
        
        array[i] = array[i + 1] = rand() % count ;
    }
    
    for (int shuffleCount = 0; shuffleCount < 3; shuffleCount ++) {
        for (int i = 0; i < length; i++) {
            
            int randIndex = rand() % length;
            int temp = array[i];
            array[i] = array[randIndex];
            array[randIndex] = temp;
        }
    }
}

- (void)dealloc
{
    [_matchButtonFileNames release];
    [super dealloc];
}


- (PosIndex)getButtonIndex:(CCMenuItemImage *)button
{
    int i, j;
    for (i = 0; i < MATCH_BUTTON_ROWS; i++) {
        for (j = 0; j < MATCH_BUTTON_COLS; j++) {
            
            if (button == _matchButtons[i][j]) {
                
                return {i, j};
            }
        }
    }
    
    NSAssert(i < MATCH_BUTTON_ROWS && j < MATCH_BUTTON_COLS, @"index should not over limit");
    
    return {-1, -1};
}

- (void)clickWithButton:(CCMenuItemImage *)button
{
    PosIndex posIndex = [self getButtonIndex:button];
    
    NSLog(@"click %d, %d", posIndex.x, posIndex.y);
    
    BOOL clear = NO;
    if (_beforeClickedImage != nil
        && [self button:(CCMenuItemImage *)_beforeClickedImage canMatch:(CCMenuItemImage *)button]) {
        
        _beforeClickedImage.visible = NO;
        button.visible = NO;
        clear = YES;
    }
    
    if (clear) {
        [g_Audio playEffect:@"clear0.wav"];
    } else {
        if (button.visible == YES) {
            [g_Audio playEffect:@"click0.wav"];
        }
    }
    
    if (button.visible == YES) {
        _beforeClickedImage.opacity = OPACITY_FULL;
        button.opacity = OPACITY_HALF;
        _beforeClickedImage = button;
    }
}

- (BOOL)isNoBlockBetween:(PosIndex)posIndex1 andPosIndex:(PosIndex)posIndex2
{
    
    if (posIndex1.x == posIndex2.x) {
        
        int max = MAX(posIndex1.y, posIndex2.y);
        int min = MIN(posIndex1.y, posIndex2.y);
        int y ;
        for (y = min + 1; y < max; y ++) {
            
            if (_matchButtons[posIndex1.x][y].visible == YES) {
                break;
            }
        }
        
        if (y == max) {
            return YES;
        }
    }
    
    if (posIndex1.y == posIndex2.y) {
        
        int max = MAX(posIndex1.x, posIndex2.x);
        int min = MIN(posIndex1.x, posIndex2.x);
        int x ;
        for (x = min + 1; x < max; x ++) {
            
            if (_matchButtons[x][posIndex1.y].visible == YES) {
                break;
            }
        }
        
        if (x == max) {
            return YES;
        }
    }
    
    return NO;
    
}

//check buttons can match by various corners
- (BOOL)button:(CCMenuItemImage *)button1 canMatch:(CCMenuItemImage *)button2
{
    if (button1.tag == button2.tag) {
        
        if (button2.visible == YES && button1.visible == YES
            && button2 != button1) {
            
            //no corner check
            PosIndex posIndex1 = [self getButtonIndex:button1];
            PosIndex posIndex2 = [self getButtonIndex:button2];
            
            if ((posIndex1.x == posIndex2.x
                 || posIndex1.y == posIndex2.y)
                && [self isNoBlockBetween:posIndex1 andPosIndex:posIndex2]) {
                
                return YES;
            }
            
            //single corner check
            PosIndex posIndex3 = {posIndex1.x, posIndex2.y};
            PosIndex posIndex4 = {posIndex2.x, posIndex1.y};
            
            if (    (_matchButtons[posIndex3.x][posIndex3.y].visible == NO
                     && [self isNoBlockBetween:posIndex1 andPosIndex:posIndex3]
                     && [self isNoBlockBetween:posIndex2 andPosIndex:posIndex3])
                ||  (_matchButtons[posIndex4.x][posIndex4.y].visible == NO
                     && [self isNoBlockBetween:posIndex1 andPosIndex:posIndex4]
                     && [self isNoBlockBetween:posIndex2 andPosIndex:posIndex4])) {
                    
                    return YES;
                }
            
            
            //double corner check
            
            //x axis scan
            for(int x = 0; x < MATCH_BUTTON_ROWS; x++) {
                
                PosIndex posIndex5 = {x, posIndex1.y};
                PosIndex posIndex6 = {x, posIndex2.y};
                
                if (   _matchButtons[posIndex5.x][posIndex5.y].visible == NO
                    && _matchButtons[posIndex6.x][posIndex6.y].visible == NO
                    && [self isNoBlockBetween:posIndex1 andPosIndex:posIndex5]
                    && [self isNoBlockBetween:posIndex6 andPosIndex:posIndex5]
                    && [self isNoBlockBetween:posIndex2 andPosIndex:posIndex6]) {
                    
                    return YES;
                }
            }
            //y axis scan
            for(int y = 0; y < MATCH_BUTTON_COLS; y++) {
                
                PosIndex posIndex5 = {posIndex1.x, y};
                PosIndex posIndex6 = {posIndex2.x, y};
                
                if (   _matchButtons[posIndex5.x][posIndex5.y].visible == NO
                    && _matchButtons[posIndex6.x][posIndex6.y].visible == NO
                    && [self isNoBlockBetween:posIndex1 andPosIndex:posIndex5]
                    && [self isNoBlockBetween:posIndex6 andPosIndex:posIndex5]
                    && [self isNoBlockBetween:posIndex2 andPosIndex:posIndex6]) {
                    
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

@end
