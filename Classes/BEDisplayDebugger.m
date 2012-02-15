//
//  BEDisplayDebugger.m
//
//  Created by Brian Ensor on 6/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "BEDisplayDebugger.h"


@implementation BEDisplayDebugger

- (id)initWithLevels:(int)numLevels {
    if ((self = [super init])) {
        levels = numLevels;
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

+ (BEDisplayDebugger *)debuggerWithLevels:(int)numLevels {
    return [[[BEDisplayDebugger alloc] initWithLevels:numLevels] autorelease];
}

- (SPSprite *)frameForObject:(SPDisplayObject *)object {
    SPSprite *frame = [SPSprite sprite];
    SPRectangle *objectBounds = [object boundsInSpace:self.stage];
    SPQuad *left = [SPQuad quadWithWidth:1 height:objectBounds.height];
    left.color = 0xFF0000;
    [frame addChild:left];
    SPQuad *top = [SPQuad quadWithWidth:objectBounds.width height:1];
    top.color = 0xFF0000;
    [frame addChild:top];
    SPQuad *right = [SPQuad quadWithWidth:1 height:objectBounds.height];
    right.color = 0xFF0000;
    right.x = objectBounds.width-1;
    [frame addChild:right];
    SPQuad *bottom = [SPQuad quadWithWidth:objectBounds.width height:1];
    bottom.color = 0xFF0000;
    bottom.y = objectBounds.height-1;
    [frame addChild:bottom];
    frame.name = @"frame";
    frame.x = objectBounds.x;
    frame.y = objectBounds.y;
    return frame;
}

- (int)stepsToStage:(SPDisplayObject *)object {
    int steps = 0;
    SPDisplayObject *countingObject = object;
    while (countingObject != self.stage) {
        countingObject = countingObject.parent;
        steps++;
    }
    return steps;
}

- (void)storeSpritesOfObject:(SPDisplayObject *)sprite intoArray:(NSMutableArray *)array {
    for (SPSprite *child in (SPSprite *)sprite) {
        if (child != self) {
            [array addObject:child];
            if ([self stepsToStage:child] > levels) {
                return;
            }
            else if ([child isKindOfClass:[SPSprite class]]) {
                [self storeSpritesOfObject:child intoArray:array];
            }
        }
    }
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    NSMutableArray *temp = [NSMutableArray array];
    [self storeSpritesOfObject:self.parent intoArray:temp];
    NSMutableArray *frameTemp = [NSMutableArray array];
    for (SPDisplayObject *object in self) {
        if ([object.name isEqualToString:@"frame"]) {
            [frameTemp addObject:object];
        }
    }
    for (SPDisplayObject *object in frameTemp) {
        [self removeChild:object];
    }
    for (SPDisplayObject *object in temp) {
        [self addChild:[self frameForObject:object]];
    }
    [self.parent addChild:self atIndex:[self.parent numChildren]-1];
}

- (void)dealloc {
    [self removeEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    [super dealloc];
}

@end
