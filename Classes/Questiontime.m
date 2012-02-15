//
//  Questiontime.m
//  BrainBoy
//
//  Created by Me on 4/10/11.
//  Copyright 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "Questiontime.h"

@implementation Questiontime

@synthesize value = mValue;

- (void)setValue:(int)value
{
    mValue = value;
    self.text = [NSString stringWithFormat:@"%d", value];
    self.pivotX = self.width / 2.0f;
    self.pivotY = self.height / 2.0f; 
    self.rotation = PI_HALF;
    self.color = 0xffffff;
    self.fontSize = 20.0f;
    
}

@end
