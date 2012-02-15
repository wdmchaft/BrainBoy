//
//  BEDisplayDebugger.h
//
//  Created by Brian Ensor on 6/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BEDisplayDebugger : SPSprite {
    int levels;
}

- (id)initWithLevels:(int)numLevels;
+ (BEDisplayDebugger *)debuggerWithLevels:(int)numLevels;

@end
