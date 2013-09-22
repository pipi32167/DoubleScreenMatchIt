//
//  MatchItButton.h
//  DoubleScreenMatchIt
//
//  Created by yangqibin on 13-9-21.
//
//

#import "CCMenuItem.h"

@interface MatchItButton : CCMenuItemImage

+ (id)itemWithNormalImage:(NSString *)value
            selectedImage:(NSString *)value2
                   target:(id)r
                 selector:(SEL)s;

@end
