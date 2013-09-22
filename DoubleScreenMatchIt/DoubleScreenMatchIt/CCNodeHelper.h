//
//  CCNodeHelper.h
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import <Foundation/Foundation.h>

@interface CCNodeHelper : NSObject

+ (CCNodeHelper *)sharedCCNodeHelper;

-(CGPoint)anchorAtCenterOfScreen;
-(CGPoint)anchorAtLeftBottomOfScreen;
-(CGPoint)anchorAtLeftTopOfScreen;
-(CGPoint)anchorAtRightBottomOfScreen;
-(CGPoint)anchorAtRightTopOfScreen;

-(CGPoint)positionAtCenterOfScreen;
-(CGPoint)positionAtCenterOfScreenBySize:(CGSize)size;
-(CGPoint)positionAtLeftBottomOfScreen;
-(CGPoint)positionAtLeftTopOfScreen;
-(CGPoint)positionAtRightTopOfScreen;
-(CGPoint)positionAtRightBottomOfScreen;

@end

#define g_CCNodeHelper [CCNodeHelper sharedCCNodeHelper]