//
//  Score.h
//  BrainBoy
//
//  Created by Me on 3/10/11.
//  Copyright 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "SPTextField.h"

@interface Score : SPTextField
{
    int mValue;
}

@property (nonatomic, assign) int value;

@end