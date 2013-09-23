//
//  DebugLayer.m
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-23.
//
//

#import "DebugLayer.h"
#import "cocos2d.h"
#import "CCNodeHelper.h"
//#import "IntroLayer.h"
#import "MatchItScene.h"

@implementation DebugLayer


+(id) node
{
    return [[[DebugLayer alloc] init] autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        CCMenuItemImage *buttonRestart = [CCMenuItemImage itemWithNormalImage:@"button_restart.png" selectedImage:@"button_restart_clicked.png" target:self selector:@selector(restart)];
        buttonRestart.position = [g_CCNodeHelper positionAtCenterOfScreen];
        
        CCMenu *menu = [CCMenu menuWithItems:buttonRestart, nil];
        menu.position = [g_CCNodeHelper positionAtLeftBottomOfScreen];
        [self addChild:menu];
    }
    return self;
}


-(void)restart
{
    [[CCDirector sharedDirector] replaceScene:[MatchItScene node]];
}

@end
