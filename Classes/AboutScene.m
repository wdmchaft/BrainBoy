//
//  AboutScene.m
//  BrainBoy
//
//  Created by Me on 12/09/11.
//  Copyright 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "AboutScene.h"
#import "Sparrow.h"


@interface AboutScene ()

- (void)setupScene;

@end

@implementation AboutScene

- (id)init
{
    if (self = [super init])
    {
        [self setupScene];  
		
		
    }
    return self;
}

- (void)setupScene
{
    
	
	//add about image.. 
	SPImage *about = [SPImage imageWithContentsOfFile:@"about.png"];
	about.x = 300;
    about.y = 400; 
	[self addChild:about];

}

- (void)dealloc
{
    [super dealloc];
}


@end
