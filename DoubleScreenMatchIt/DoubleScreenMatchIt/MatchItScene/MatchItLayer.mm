//
//  MatchItScene.m
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "MatchItLayer.h"
#import "Cocos2dHelper.h"
#import "ResourceConfig.h"

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

- (id)initWithRandSeed:(unsigned)seed andDict:(NSDictionary *)infoDict andScene:(MatchItScene *)scene
{
    self = [super init];
    if (self) {
        
        _scene = scene;
        
        srand(seed);
        
        //5 is temp number
        NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:MATCH_BUTTON_COUNT + 5];
        
        CGSize totalSize = CGSizeMake(MATCH_BUTTON_WIDTH * MATCH_BUTTON_ROWS, MATCH_BUTTON_HEIGHT * MATCH_BUTTON_COLS);
//        CGPoint initPosition = [g_CCNodeHelper positionAtCenterOfScreenBySize:totalSize];
        NSDictionary *posDict = [infoDict objectForKey:@"MainAreaPosition"];
        _gameAreaPosition = ccp([[posDict objectForKey:@"X"] floatValue],
                            [[posDict objectForKey:@"Y"] floatValue]);
        CGPoint initPosition = [g_CCNodeHelper getInitPositionByPoint:_gameAreaPosition andSize:totalSize];
        
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
                    NSLog(@"%d, count:%d", imageIndex, [_matchButtonFileNames count]);
                    NSAssert(imageIndex < [_matchButtonFileNames count], @"image index should not over limit");
                    NSString *fileName = [_matchButtonFileNames objectAtIndex:imageIndex];
                    sprite = [CCSprite spriteWithSpriteFrameName:fileName];
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
        
        CGSize winSize = [g_CCNodeHelper winSize];

        CCMenuItemImage *buttonTips = [CCMenuItemImage itemWithNormalImage:@"button_tip.png" selectedImage:@"button_tip_clicked.png" target:self selector:@selector(tip)];
        buttonTips.position = ccp(winSize.width - 32, 100);
        [buttonArray addObject:buttonTips];
        
        CCMenuItemImage *buttonReset = [CCMenuItemImage itemWithNormalImage:@"button_reset.png" selectedImage:@"button_reset_clicked.png" target:self selector:@selector(reset)];
        buttonReset.position = ccp(winSize.width - 32, 50);
        [buttonArray addObject:buttonReset];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png" ];
        bg.position = [g_CCNodeHelper positionAtLeftBottomOfScreen];
        bg.anchorPoint = [g_CCNodeHelper anchorAtLeftBottomOfScreen];
        [self addChild:bg];
        
        CCSprite *bg2 = [CCSprite spriteWithFile:@"background2.png"];
        bg2.position = _gameAreaPosition;
        [bg addChild:bg2];
        
        CCMenu *menu = [CCMenu menuWithArray:buttonArray];
        menu.position = [g_CCNodeHelper positionAtLeftBottomOfScreen];
        //        menu.anchorPoint = [g_CCNodeHelper anchorAtCenterOfScreen];
        [self addChild:menu];
        
        _notClearTimeSpan = 0;
        _comboTimeSpan = COMBO_TIME;
        _bonus = 0;
        
        _bonusLabel = [CCLabelAtlas labelWithString:@"000" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
        _bonusLabel.position = ccp(winSize.width / 2, winSize.height / 2 - 50);
        [self addChild:_bonusLabel];
        
        [self schedule:@selector(tick:)];
    }
    return self;
}

-(void)tick:(ccTime)dt
{
    _notClearTimeSpan += dt;
    if (_notClearTimeSpan >= SHOW_TIP_TIME) {
        
        _notClearTimeSpan = 0;
        [self tip];
    }
    
    if (_comboTimeSpan < COMBO_TIME) {
        
        _comboTimeSpan += dt;
    }
}

-(void)tip
{
    CCMenuItemImage *button1, *button2;
    for (int i = 0; i < MATCH_BUTTON_ROWS; i++) {
        for (int j = 0; j < MATCH_BUTTON_COLS; j++) {
            for (int k = i; k < MATCH_BUTTON_ROWS; k++) {
                for (int l = j; l < MATCH_BUTTON_COLS; l++) {
                    
                    button1 = _matchButtons[i][j];
                    button2 = _matchButtons[k][l];
                    
                    if ([self button:button1 canMatch:button2]) {
                        
                        [self buttonBlink:button1];
                        [self buttonBlink:button2];
                        
                        return ;
                    }
                }
            }
        }
    }
}

-(void)buttonBlink:(CCMenuItemImage *)button
{
//    CCBlink *blink = [CCBlink actionWithDuration:1 blinks:3];
//    [button runAction:blink];
    
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.2];
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.2];
    CCSequence *seq = [CCSequence actions:fadeOut, fadeIn, nil];
    CCRepeat *repeat = [CCRepeat actionWithAction:seq times:3];
    [button runAction:repeat];
}

-(void)reset
{
    
    CCArray *visibleButtons = [CCArray arrayWithCapacity:MATCH_BUTTON_COUNT];
    for (int i = 0; i < MATCH_BUTTON_ROWS; i++) {
        for (int j = 0; j < MATCH_BUTTON_COLS; j++) {
            
            if (_matchButtons[i][j].visible) {
                
                [visibleButtons addObject:_matchButtons[i][j]];
            }
        }
    }
    
    for (int i = 0; i < 3; i++) {
        [self randomShuffleArray:visibleButtons block:^(CCMenuItemImage *button1, CCMenuItemImage *button2) {
            CGPoint temp = button1.position;
            button1.position = button2.position;
            button2.position = temp;
            
            PosIndex tempIndex1 = [self getButtonIndex:button1];
            PosIndex tempIndex2 = [self getButtonIndex:button2];
            _matchButtons[tempIndex1.x][tempIndex1.y] = button2;
            _matchButtons[tempIndex2.x][tempIndex2.y] = button1;
        }];
    }
    
}

-(void)randomShuffleArray:(CCArray *)array
                    block:(void(^)(CCMenuItemImage *button1, CCMenuItemImage *button2))block
{
    int count = [array count];
    int randIndex;
    for (int i = 0; i < count; i++) {
        randIndex = rand() % count;
        CCMenuItemImage *button1 = [array objectAtIndex:i];
        CCMenuItemImage *button2 = [array objectAtIndex:randIndex];
        block(button1, button2);
    }
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
//        array[i] = array[i + 1] = i / 2;
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

-(void)addBonus
{
    int normalBonus = CLEAR_BONUS;
    int comboBonus = 0;
    if (_comboTimeSpan < COMBO_TIME) {
        
        _comboTimes ++;
        comboBonus = _comboTimes * COMBO_BONUS;

    } else {
        
        _comboTimes = 0;
    }
    
    _bonus += normalBonus + comboBonus;
    _comboTimeSpan = 0;
    [_bonusLabel setString:[NSString stringWithFormat:@"%d", _bonus]];
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
        _notClearTimeSpan = 0;
        
        [self addBonus];
        
        clear = YES;
    }
    
    if (clear) {
        [g_Audio playEffect:SFX_MATCH_COMBO];
    } else {
        if (button.visible == YES) {
            [g_Audio playEffect:SFX_MATCH_CLICK];
        }
    }
    
    if (button.visible == YES) {
        _beforeClickedImage.opacity = OPACITY_FULL;
        button.opacity = OPACITY_HALF;
        _beforeClickedImage = button;
    }
    
    if ([self haveButtonsToClear] == NO) {
        
        [self reset];
    }
    
    if ([self isWin]) {
        
        [_scene winnerIs:self];
    }
}

-(void)gameWin
{
    [self gameEndWithPic:@"win.png"];
}

-(void)gameLose
{
    [self gameEndWithPic:@"lose.png"];
}

-(void)gameEndWithPic:(NSString *)fileName
{
    [self removeAllChildrenWithCleanup:YES];
    [self unschedule:@selector(tick:)];
    
    CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:fileName selectedImage:fileName];
    item.position = _gameAreaPosition;
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    menu.position = [g_CCNodeHelper positionAtLeftBottomOfScreen];
    [self addChild:menu];
}

-(BOOL) isWin
{
    for (int i = 0; i < MATCH_BUTTON_ROWS; i++) {
        for (int j = 0; j < MATCH_BUTTON_COLS; j++) {
            
            if (_matchButtons[i][j].visible == YES) {
                return NO;
            }
        }
    }
    
    return YES;
}

-(BOOL) haveButtonsToClear
{
    
    CCMenuItemImage *button1, *button2;
    for (int i = 0; i < MATCH_BUTTON_ROWS; i++) {
        for (int j = 0; j < MATCH_BUTTON_COLS; j++) {
            for (int k = i; k < MATCH_BUTTON_ROWS; k++) {
                for (int l = j; l < MATCH_BUTTON_COLS; l++) {
                    
                    button1 = _matchButtons[i][j];
                    button2 = _matchButtons[k][l];
                    
                    if ([self button:button1 canMatch:button2]) {
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
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
