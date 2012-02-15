//
//  Level1Play.mm
//  BrainBoy
//
//  Created by Me on 12/09/11.
//  Copyright 2011 Gymnasium Kirchenfeld. All rights reserved.
//

#import "Level1Play.h"
#import "Game.h"


@interface Level1Play ()

@end

@implementation Level1Play
@synthesize theQuestion;
@synthesize theScore;
@synthesize theLives;
@synthesize answerOne;
@synthesize answerTwo;
@synthesize answerThree;
@synthesize answerFour;
@synthesize theQuiz;
@synthesize timer;
@synthesize blink;

- (id)init {
    if ((self = [super init])) {

        
        // add spaceship and thrust particle effects
        // create particle system
        mParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"rocketthrust.pex"];    
        mParticleSystem.emitterX = 164;
        mParticleSystem.emitterY = 65;
        mParticleSystem.pivotX = mParticleSystem.width / 2.0f;
        mParticleSystem.pivotY = mParticleSystem.height / 2.0f;
        
        // add it to the stage and the juggler
        [self addChild:mParticleSystem];
        [[SPStage mainStage].juggler addObject:mParticleSystem];
        
        [mParticleSystem start];
        [mParticleSystem release];
        
        
        //put spaceship over the top of it
        spaceship = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"spaceship"]];
        
        spaceship.x = 140;
        spaceship.y = 40;
        spaceship.scaleX = 0.5f;
        spaceship.scaleY = 0.5f;
        
        [self addChild:spaceship];
        [spaceship release];

        //progress
        
        progressback = [[SPImage alloc] initWithContentsOfFile:@"progressback.png"];
        progressback.x = -5;
        progressback.scaleX = 0.9f;
        progressback.scaleY = 0.8f;
        progressback.y = -2;
        [self addChild:progressback];

        progresscontent = [[SPSprite alloc] init];
		progresscontent.rotation = SP_D2R(90);
		progresscontent.x = 320;
        progresscontent.y = 0;
		[self addChild:progresscontent];
        
        
       progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress.png"];

        progress = [SXGauge gaugeWithTexture:progresstexture];
        [progresscontent addChild:progress];
        progress.x = 0; 
        progress.y = 280;
        progress.scaleX = 0.8f;
        progress.ratio = 0.05f;
        
        //hearts
        heartTexture = [Media atlasTexture:@"heart"];
		heart = [SPImage imageWithTexture:heartTexture];	
        heart.y = 375;
        heart.x = 280;
        
        [self addChild:heart];

        heart1 = [SPImage imageWithTexture:heartTexture];	
        heart1.y = 405;
        heart1.x = 280;
        
        [self addChild:heart1];

         heart2 = [SPImage imageWithTexture:heartTexture];	
        heart2.y = 435;
        heart2.x = 280;
        
        [self addChild:heart2];

        
        //pause button
        pauseButtonTexture = [Media atlasTexture:@"pauseiphone"];
        
        pause = [[SPButton alloc] initWithUpState:pauseButtonTexture text:@""];
        pause.alpha = 1.0f;
        pause.x = 280;
        pause.y = 10;
        [pause addEventListener:@selector(onPauseButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:pause]; 
        [pause release];

     
        // start init questions
        questionLive = NO;
        restartGame = NO;
        
        theQuestion = [[SPTextField alloc] initWithWidth:300 height:80 text:@"" fontName:@"Funky" fontSize:20.0f color:0xffffff];
        theQuestion.x = 290;
        theQuestion.rotation = SP_D2R(90);
        theQuestion.y = 60;
        [self addChild:theQuestion];
        [theQuestion release];

        
        theQuestion.text = @"";
        // This means that we are at the startup-state
		// We need to make the other buttons visible, and start the game.
   
        SPTexture *answerButtonTexture = [Media atlasTexture:@"answertexture"];
        answerOne = [[SPButton alloc] initWithUpState:answerButtonTexture];       
        answerOne.text = @"Get";
        answerOne.fontName = @"Funky";
        answerOne.fontSize = 15.0f;
        answerOne.fontColor = 0xffffff;
        answerOne.x = 240;
        answerOne.rotation = SP_D2R(90);
        answerOne.y = 320;
        [self addChild:answerOne];
        [answerOne release];

        SPTween *answer1tween = [SPTween tweenWithTarget:answerOne time:4.0f];
        [answer1tween animateProperty:@"scaleX" targetValue:1.2f];
        [answer1tween animateProperty:@"scaleY" targetValue:1.2f];
        answer1tween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:answer1tween];
        
        answerTwo = [[SPButton alloc] initWithUpState:answerButtonTexture];
        answerTwo.text = @"Ready";
        answerTwo.fontName = @"Funky";
        answerTwo.fontSize = 15.0f;
        answerTwo.fontColor = 0xffffff;
        answerTwo.x = 180;
        answerTwo.rotation = SP_D2R(90);
        answerTwo.y = 320;
        [self addChild:answerTwo];
        [answerTwo release];

        SPTween *answer2tween = [SPTween tweenWithTarget:answerTwo time:3.0f];
        [answer2tween animateProperty:@"scaleX" targetValue:1.2f];
        [answer2tween animateProperty:@"scaleY" targetValue:1.2f];
        answer2tween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:answer2tween];
        
        
        answerThree = [[SPButton alloc] initWithUpState:answerButtonTexture];
        answerThree.text = @"To";
        answerThree.fontName = @"Funky";
        answerThree.fontSize = 15.0f;
        answerThree.fontColor = 0xffffff;
        answerThree.x = 120;
        answerThree.rotation = SP_D2R(90);
        answerThree.y = 320;
        [self addChild:answerThree];
        [answerThree release];

        
        SPTween *answer3tween = [SPTween tweenWithTarget:answerThree time:5.0f];
        [answer3tween animateProperty:@"scaleX" targetValue:1.2f];
        [answer3tween animateProperty:@"scaleY" targetValue:1.2f];
        answer3tween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:answer3tween];
        
        answerFour = [[SPButton alloc] initWithUpState:answerButtonTexture];
        answerFour.text = @"Fly!";
        answerFour.fontName = @"Funky";
        answerFour.fontSize = 15.0f;
        answerFour.fontColor = 0xffffff;
        answerFour.x = 60;
        answerFour.rotation = SP_D2R(90);
        answerFour.y = 320;
        [self addChild:answerFour];
        [answerFour release];

        SPTween *answer4tween = [SPTween tweenWithTarget:answerFour time:2.0f];
        [answer4tween animateProperty:@"scaleX" targetValue:1.2f];
        [answer4tween animateProperty:@"scaleY" targetValue:1.2f];
        answer4tween.loop = SPLoopTypeReverse;
        [[SPStage mainStage].stage.juggler addObject:answer4tween];
        
        answerOne.alpha = 1.0f;
		answerTwo.alpha = 1.0f;
		answerThree.alpha = 1.0f;
		answerFour.alpha = 1.0f;
        
        theScore = [[SPTextField alloc] initWithWidth:150 height:80 text:@"" fontName:@"Funky" fontSize:15.0f color:0xffffff];
        theScore.x = 300;
        theScore.rotation = SP_D2R(90);
        theScore.y = 340;
        theScore.text = @"Score:0";
        [self addChild:theScore];
        [theScore release];

        
        theLives = [[SPTextField alloc] initWithWidth:280 height:80 text:@"" fontName:@"Funky" fontSize:18.0f color:0xffffff];
        theLives.x = 335;
        theLives.rotation = SP_D2R(90);
        theLives.y = 40;
                theLives.text = @"Lives:0";
        [self addChild:theLives];
        [theLives release];

        
        questionNumber = 0;
        myScore = 0;
        myLives = 0;
        
        livesLeft = 3;
        
        currentLevel = 0;
        
        // load frames 
        SPTexture *countdown3 = [SPTexture textureWithContentsOfFile:@"3.png"];
        SPTexture *countdown2 = [SPTexture textureWithContentsOfFile:@"2.png"];
        SPTexture *countdown1 = [SPTexture textureWithContentsOfFile:@"1.png"];
        SPTexture *countdowngo = [SPTexture textureWithContentsOfFile:@"go.png"];

        // create movie clip
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        countdown = [SPMovieClip movieWithFrame:countdown3 fps:1];
        [countdown addFrame:countdown3];
        [countdown addFrame:countdown2];
        [countdown addFrame:countdown1];
        [countdown addFrame:countdowngo];
        }
        else {
            countdown = [SPMovieClip movieWithFrame:countdown3 fps:1];
            [countdown addFrame:countdown3];
            [countdown addFrame:countdown2];
            [countdown addFrame:countdown1];
            [countdown addFrame:countdowngo];
        }
      
        // control playback:
        [countdown play];       
        
        // looping:
        countdown.loop = NO;
        
        //add end selector
        [countdown addEventListener:@selector(onCountdownFin:) atObject:self forType:SP_EVENT_TYPE_MOVIE_COMPLETED];
        
        //add it
        [self addChild:countdown];
        
        // important: add clip to juggler
        [[SPStage mainStage].juggler addObject:countdown];
        

    
    }
    
    return self;
}
//starts selectors

//selectors for answers


-(void)askQuestion
{
	// Unhide all the answer buttons.
    answerOne.alpha = 1.0f;
    answerTwo.alpha = 1.0f;
    answerThree.alpha = 1.0f;
    answerFour.alpha = 1.0f;
    
    
	// Set the game to a "live" question (for timer purposes)
	questionLive = YES;
	
	// Set the time for the timer
	time = 8.0;
	
	// Go to the next question
	questionNumber = questionNumber + 1;
	
	NSInteger row = 0;
	if(questionNumber == 0)
	{
        time = 13.0;
	
    }
    if(questionNumber == 1)
	{
		row = (questionNumber - 1);
               
    }
	if(questionNumber == 2)
	{
		row = (questionNumber - 1) * 6;
	}
    if(questionNumber == 3)
	{
		row = (questionNumber - 1) * 6;
	}
    if(questionNumber == 4)
	{
		row = (questionNumber - 1) * 6;
	}
    if(questionNumber == 5)
	{
		row = (questionNumber - 1) * 6;
	}
    if(questionNumber == 6)
	{
		row = (questionNumber - 1) * 6;
	}
	
	// Set the question string, and set the buttons the the answers
	NSString *selected = [theQuiz objectAtIndex:row];
	NSString *activeQuestion = [[NSString alloc] initWithFormat:@"Question: %@", selected];
    
	answerOne.text = [theQuiz objectAtIndex:row+1];
        [answerOne addEventListener:@selector(buttonOne:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    answerTwo.text = [theQuiz objectAtIndex:row+2];
            [answerTwo addEventListener:@selector(buttonTwo:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    answerThree.text = [theQuiz objectAtIndex:row+3];
            [answerThree addEventListener:@selector(buttonThree:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    answerFour.text = [theQuiz objectAtIndex:row+4];
            [answerFour addEventListener:@selector(buttonFour:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
	rightAnswer = [[theQuiz objectAtIndex:row+5] intValue];
	
	// Set theQuestion label to the active question
	theQuestion.text = activeQuestion;
	
	// Start the timer for the countdown
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
	
	[activeQuestion release];
    
}


-(void)updateScore
{
	// If the score is being updated, the question is not live
	questionLive = NO;
	
	[timer invalidate];
    
    questionLive = NO;

	// Hide the answers from the previous question
    answerOne.alpha = 0.0f;
    answerTwo.alpha = 0.0f;
    answerThree.alpha = 0.0f;
    answerFour.alpha = 0.0f;
    
    [answerOne removeEventListener:@selector(buttonOne:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [answerTwo removeEventListener:@selector(buttonTwo:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [answerThree removeEventListener:@selector(buttonThree:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [answerFour removeEventListener:@selector(buttonFour:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
	NSString *scoreUpdate = [[NSString alloc] initWithFormat:@"Score: %d", myScore];
	theScore.text = scoreUpdate;
	[scoreUpdate release];
	
    currentLevel = currentLevel + 1;

	// END THE GAME.
	if(questionNumber == 7)
	{
	
            //here I load the next level
        if(currentLevel == 7){
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame2" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
       
            [(Game *)self.stage LevelTwo];

            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            
            troposphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Through the Troposphere!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            troposphere.x = 300;
            troposphere.y = 20;
            troposphere.rotation = SP_D2R(90);
            [self addChild:troposphere];
            [troposphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:troposphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:troposphere byTime:6.0] removeFromParent];

            airplane = [SPImage imageWithContentsOfFile:@"airplane.png"];	
            airplane.y = 700;
            airplane.x = (arc4random() % (260)) + 40;
            airplane.scaleX = 0.5f;
            airplane.scaleY = 0.5f;
            [self addChild:airplane];
            
            SPTween *airplanetween = [SPTween tweenWithTarget:airplane time:10.0f];
            [airplanetween animateProperty:@"y" targetValue:-300];
            [[SPStage mainStage].stage.juggler addObject:airplanetween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:airplane byTime:10.0] removeFromParent];
            
            airplane2 = [SPImage imageWithContentsOfFile:@"airplane.png"];	
            airplane2.y = 700;
            airplane2.x = (arc4random() % (260)) + 40;
            airplane2.scaleX = 0.5f;
            airplane2.scaleY = 0.5f;
            [self addChild:airplane2];
            
            SPTween *airplanetween2 = [SPTween tweenWithTarget:airplane2 time:10.0f];
            [airplanetween2 animateProperty:@"y" targetValue:-300];
            [[SPStage mainStage].stage.juggler addObject:airplanetween2];
            airplanetween2.delay = 10.0f;
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:airplane2 byTime:10.0] removeFromParent];
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress2.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
            
        }
        if(currentLevel == 14)
		{
            [[OFAchievement achievement: @"1342332"] updateProgressionComplete: 50.0f andShowNotification: YES];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame3" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
            
            [(Game *)self.stage LevelThree];
            
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            // create particle system
            cometParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"comet.pex"];    
            cometParticleSystem.emitterX = 320;
            cometParticleSystem.emitterY = (arc4random() % (260)) + 80;
            
            cometParticleSystem.pivotX = cometParticleSystem.width / 2.0f;
            cometParticleSystem.pivotY = cometParticleSystem.height / 2.0f;
            
            // add it to the stage and the juggler
            [self addChild:cometParticleSystem];
            [[SPStage mainStage].juggler addObject:cometParticleSystem];
            
            [cometParticleSystem start];
            [cometParticleSystem release];
            
            SPTween *comettween = [SPTween tweenWithTarget:cometParticleSystem time:8.0f];
            [comettween animateProperty:@"emitterX" targetValue:-100];
            [comettween animateProperty:@"emitterY" targetValue:0];
            [[SPStage mainStage].stage.juggler addObject:comettween];
        
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            stratosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Through the Stratosphere!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            stratosphere.x = 300;
            stratosphere.y = 20;
            stratosphere.rotation = SP_D2R(90);
            [self addChild:stratosphere];
            [stratosphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:stratosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:stratosphere byTime:6.0] removeFromParent];
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress3.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
        }
        if(currentLevel == 21)
		{
            [[OFAchievement achievement: @"1342332"] updateProgressionComplete: 100.0f andShowNotification: YES];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame4" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
            
            [(Game *)self.stage LevelFour];
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            mesosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Through the Mesosphere!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            mesosphere.x = 300;
            mesosphere.y = 20;
            mesosphere.rotation = SP_D2R(90);
            [self addChild:mesosphere];
            [mesosphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:mesosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:mesosphere byTime:6.0] removeFromParent];
            
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress4.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
        }
        if(currentLevel == 28)
		{
            [[OFAchievement achievement: @"1342342"] updateProgressionComplete: 50.0f andShowNotification: YES];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame5" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            // create particle system
            cometParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"galaxy1.pex"];    
            cometParticleSystem.emitterX = 220;
            cometParticleSystem.emitterY = 400;
            
            cometParticleSystem.pivotX = cometParticleSystem.width / 2.0f;
            cometParticleSystem.pivotY = cometParticleSystem.height / 2.0f;
            
            // add it to the stage and the juggler
            [self addChild:cometParticleSystem];
            [[SPStage mainStage].juggler addObject:cometParticleSystem];
            
            [cometParticleSystem start];
            [cometParticleSystem release];
            
            SPTween *comettween = [SPTween tweenWithTarget:cometParticleSystem time:10.0f];
            [comettween animateProperty:@"emitterY" targetValue:-200];
            comettween.delay = 20;
            [[SPStage mainStage].stage.juggler addObject:comettween];
            
            
            thermosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Through the Exosphere!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            thermosphere.x = 300;
            thermosphere.y = 20;
            thermosphere.rotation = SP_D2R(90);
            [self addChild:thermosphere];
            [thermosphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:thermosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:thermosphere byTime:6.0] removeFromParent];
            
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress5.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
        }
        if(currentLevel == 35)
		{
            [[OFAchievement achievement: @"1342342"] updateProgressionComplete: 100.0f andShowNotification: YES];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame6" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
            
            
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            // create particle system
            cometParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"galaxy2.pex"];    
            cometParticleSystem.emitterX = 220;
            cometParticleSystem.emitterY = 500;
            
            cometParticleSystem.pivotX = cometParticleSystem.width / 2.0f;
            cometParticleSystem.pivotY = cometParticleSystem.height / 2.0f;
            
            // add it to the stage and the juggler
            [self addChild:cometParticleSystem];
            [[SPStage mainStage].juggler addObject:cometParticleSystem];
            
            [cometParticleSystem start];
            [cometParticleSystem release];
            
            SPTween *comettween = [SPTween tweenWithTarget:cometParticleSystem time:10.0f];
            [comettween animateProperty:@"emitterY" targetValue:-200];
            comettween.delay = 20;
            [[SPStage mainStage].stage.juggler addObject:comettween];
            
            
            thermosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Spacetime!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            thermosphere.x = 300;
            thermosphere.y = 20;
            thermosphere.rotation = SP_D2R(90);
            [self addChild:thermosphere];
            [thermosphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:thermosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:thermosphere byTime:6.0] removeFromParent];
            
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress5.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
        }
        if(currentLevel == 42)
		{
            [[OFAchievement achievement: @"1342352"] updateProgressionComplete: 50.0f andShowNotification: YES];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame7" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
            
            
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            // create particle system
            cometParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"galaxy2.pex"];    
            cometParticleSystem.emitterX = 500;
            cometParticleSystem.emitterY = (arc4random() % (260)) + 80;
            
            cometParticleSystem.pivotX = cometParticleSystem.width / 2.0f;
            cometParticleSystem.pivotY = cometParticleSystem.height / 2.0f;
            
            // add it to the stage and the juggler
            [self addChild:cometParticleSystem];
            [[SPStage mainStage].juggler addObject:cometParticleSystem];
            
            [cometParticleSystem start];
            [cometParticleSystem release];
            
            SPTween *comettween = [SPTween tweenWithTarget:cometParticleSystem time:8.0f];
            [comettween animateProperty:@"emitterX" targetValue:-100];
            comettween.delay = 20;
            [[SPStage mainStage].stage.juggler addObject:comettween];
            
            
            thermosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Through the milky way!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            thermosphere.x = 300;
            thermosphere.y = 20;
            thermosphere.rotation = SP_D2R(90);
            [self addChild:thermosphere];
            [thermosphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:thermosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:thermosphere byTime:6.0] removeFromParent];
            
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress5.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
        }
        if(currentLevel == 49)
		{
            [[OFAchievement achievement: @"1342352"] updateProgressionComplete: 100.0f andShowNotification: YES];
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame8" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
                        
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            
            // create particle system
            cometParticleSystem = [[SXParticleSystem alloc] initWithContentsOfFile:@"clocks.pex"];    
            cometParticleSystem.emitterX = 500;
            cometParticleSystem.emitterY = (arc4random() % (260)) + 80;
            
            cometParticleSystem.pivotX = cometParticleSystem.width / 2.0f;
            cometParticleSystem.pivotY = cometParticleSystem.height / 2.0f;
            
            // add it to the stage and the juggler
            [self addChild:cometParticleSystem];
            [[SPStage mainStage].juggler addObject:cometParticleSystem];
            
            [cometParticleSystem start];
            [cometParticleSystem release];
            
            SPTween *comettween = [SPTween tweenWithTarget:cometParticleSystem time:8.0f];
            [comettween animateProperty:@"emitterX" targetValue:-100];
            comettween.delay = 20;
            [[SPStage mainStage].stage.juggler addObject:comettween];
            
            
            thermosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"Time Travel!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            thermosphere.x = 300;
            thermosphere.y = 20;
            thermosphere.rotation = SP_D2R(90);
            [self addChild:thermosphere];
            [thermosphere release];
            
            SPTween *tropotween = [SPTween tweenWithTarget:thermosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:thermosphere byTime:6.0] removeFromParent];
            
            
            SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween animateProperty:@"x" targetValue:270];
            [shiptween animateProperty:@"rotation" targetValue:SP_D2R(-25)];
            [[SPStage mainStage].stage.juggler addObject:shiptween];
            
            SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween animateProperty:@"emitterX" targetValue:289];
            [[SPStage mainStage].stage.juggler addObject:shipparticletween];
            
            //send ship down
            SPTween *shiptween2 = [SPTween tweenWithTarget:spaceship time:1.5f];
            [shiptween2 animateProperty:@"x" targetValue:225];
            [shiptween2 animateProperty:@"rotation" targetValue:SP_D2R(0)];
            shiptween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shiptween2];
            
            SPTween *shipparticletween2 = [SPTween tweenWithTarget:mParticleSystem time:1.5f];
            [shipparticletween2 animateProperty:@"emitterX" targetValue:244];
            shipparticletween2.delay = 3.0f;
            [[SPStage mainStage].stage.juggler addObject:shipparticletween2];
            
            
            progresstexture = [[SPTexture alloc] initWithContentsOfFile:@"progress5.png"];
            progress = [SXGauge gaugeWithTexture:progresstexture];
            [progresscontent addChild:progress];
            progress.x = 0; 
            progress.y = 280;
            progress.scaleX = 0.8f;
            progress.ratio = 0.05f;
        }
        if(currentLevel == 55)
		{
            [[OFAchievement achievement: @"1342362"] updateProgressionComplete: 100.0f andShowNotification: YES];
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);

            NSBundle *bundle = [NSBundle mainBundle];
            NSString *textFilePath = [bundle pathForResource:@"quizgame8" ofType:@"txt"];
            NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
            NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            self.theQuiz = quizArray;
            [quizArray release];
            
            questionNumber = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
            cloudcovering = [SPImage imageWithContentsOfFile:@"cloudslevelbreak.png"];	
            cloudcovering.y = 0;
            cloudcovering.x = 0;
            [self addChild:cloudcovering];
            SPTween *cloudstween = [SPTween tweenWithTarget:cloudcovering time:5.0f];
            [cloudstween animateProperty:@"x" targetValue:500];
            [[SPStage mainStage].stage.juggler addObject:cloudstween];
            thermosphere = [[SPTextField alloc] initWithWidth:400 height:300 text:@"See you soon!" fontName:@"Funky" fontSize:45.0f color:0xffffff];
            thermosphere.x = 300;
            thermosphere.y = 20;
            thermosphere.rotation = SP_D2R(90);
            [self addChild:thermosphere];
            [thermosphere release];
    
            SPTween *tropotween = [SPTween tweenWithTarget:thermosphere time:6.0f transition:SP_TRANSITION_EASE_IN];
            [tropotween animateProperty:@"scaleX" targetValue:1.8f];
            [tropotween animateProperty:@"scaleY" targetValue:1.8f];
            [tropotween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:tropotween];
            [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:thermosphere byTime:6.0] removeFromParent];
            
        }

        
	}
    
	else
	{
        
        // Give a short rest between questions
        time = 3.0;
        
        // Initialize the timer
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        
	}
}


// RESET METHOD
-(void)reset {
        [answerOne removeEventListener:@selector(reset:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
	
	
}

-(void)countDown
{
    if(currentLevel == 55) {
        //initialise end function
        [(Game *)self.stage pausesound];
        questionLive = NO;
        [timer invalidate];
        
        answerOne.alpha = 0.0f;
        answerTwo.alpha = 0.0f;
        answerThree.alpha = 0.0f;
        answerFour.alpha = 0.0f;
        
        completemenu = [[SPImage alloc] initWithContentsOfFile:@"complete.png"];
        [self addChild:completemenu];
        [completemenu release];
        
        informedTexture = [[SPTexture alloc] initWithContentsOfFile:@"informed.png"];
        informed = [[SPButton alloc] initWithUpState:informedTexture text:@""];
        informed.alpha = 1.0f;
        informed.x = 145;
        informed.y = 160;
        [informed addEventListener:@selector(onInformedButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:informed]; 
        [informed release];
        
        backtomenuTexture = [Media atlasTexture:@"backtomenuiphone"];
        backtomenu = [[SPButton alloc] initWithUpState:backtomenuTexture text:@""];
        backtomenu.alpha = 1.0f;
        backtomenu.x = 85;
        backtomenu.y = 175;
        [backtomenu addEventListener:@selector(onBackMenuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:backtomenu];
        [backtomenu release];
    }
    else {
    
	// Question live counter
	if(questionLive==YES)
	{
		time = time - 1;
		theLives.text = [NSString stringWithFormat:@"Time remaining: %i!", time];
        

		if(time == 0)
		{
			// Loser!
            
            
			questionLive = NO;

			theQuestion.text = @"Sorry, you ran out of time!";
			myScore = myScore - 50;
            livesLeft = livesLeft - 1;
            
            crossTexture = [Media atlasTexture:@"cross"];
            cross = [SPImage imageWithTexture:crossTexture];	
            cross.y = 260;
            cross.x = 220;
            [self addChild:cross];

            
            SPTween *crosstween = [SPTween tweenWithTarget:cross time:2.0f transition:SP_TRANSITION_EASE_IN];
            [crosstween animateProperty:@"scaleX" targetValue:1.8f];
            [crosstween animateProperty:@"scaleY" targetValue:1.8f];
            [crosstween animateProperty:@"alpha" targetValue:0.0f];
            [[SPStage mainStage].stage.juggler addObject:crosstween];
            
			[timer invalidate];
            
            if (livesLeft == 2){
                heart.alpha = 0.0f; 
                [self updateScore];

            }
            if (livesLeft == 1)
            {
                heart1.alpha = 0.0f; 
                [self updateScore];

            }
            if (livesLeft == 0)
            {
                heart2.alpha = 0.0f; 
                [self onEndGame];
                
            }
            
		}
	}
	// In-between Question counter
	else
	{
        
		time = time - 1;
		theLives.text = [NSString stringWithFormat:@"Next question in...%i!", time];
        
		if(time == 0)
		{
			[timer invalidate];
			theLives.text = @"";
			[self askQuestion];
		}
	}
	if(time < 0)
	{
		[timer invalidate];
	}
}
}

- (void)buttonOne:(SPEvent *)event
{
	if(questionNumber == 0){
		// This means that we are at the startup-state
		// We need to make the other buttons visible, and start the game.
        
		[self askQuestion];
	}
	else
	{	
        NSInteger theAnswerValue = 1;

        [self shootOne:(SPEvent *)event];
        
   //     NSNumber *answernumber = [NSNumber numberWithInt:theAnswerValue];
        
	//	[self performSelector:@selector(checkAnswer:) withObject:answernumber afterDelay:2.0];
      
        [self checkAnswer:(int)theAnswerValue];

	}
}

- (void)buttonTwo:(SPEvent *)event
{
	NSInteger theAnswerValue = 2;
    
    [self shootTwo:(SPEvent *)event];
    
 //   NSNumber *answernumber = [NSNumber numberWithInt:theAnswerValue];
    
  //  [self performSelector:@selector(checkAnswer:) withObject:answernumber afterDelay:2.0];
    
	[self checkAnswer:(int)theAnswerValue];
}

- (void)buttonThree:(SPEvent *)event
{
	NSInteger theAnswerValue = 3;
    
    [self shootThree:(SPEvent *)event];
    
 //   NSNumber *answernumber = [NSNumber numberWithInt:theAnswerValue];
    
  //  [self performSelector:@selector(checkAnswer:) withObject:answernumber afterDelay:2.0];
    
	[self checkAnswer:(int)theAnswerValue];
}

- (void)buttonFour:(SPEvent *)event
{
	NSInteger theAnswerValue = 4;
    
    [self shootFour:(SPEvent *)event];
    
 //   NSNumber *answernumber = [NSNumber numberWithInt:theAnswerValue];
    
   // [self performSelector:@selector(checkAnswer:) withObject:answernumber afterDelay:2.0];
    
	[self checkAnswer:(int)theAnswerValue];
}


// Check for the answer
-(void)checkAnswer:(int)theAnswerValue
{
	if(rightAnswer == theAnswerValue)
	{
		theQuestion.text = @"Well done";
		myScore = myScore + 50;
        
        
        if(questionNumber == 1)
        {
            progress.ratio = 0.1f;
            
        }
        if(questionNumber == 2)
        {
            progress.ratio = 0.3f;

        }
        if(questionNumber == 3)
        {
            progress.ratio = 0.5f;
            
        }
        if(questionNumber == 4)
        {
            progress.ratio = 0.7f;
            
        }
        if(questionNumber == 5)
        {
            progress.ratio = 0.9f;
            
        }
        if(questionNumber == 6)
        {
            progress.ratio = 1.0f;
            
        }
        if(questionNumber == 7)
        {
            progress.ratio = 1.0f;
            [[OFAchievement achievement: @"1309662"] updateProgressionComplete: 100.0f andShowNotification: YES];
            
        }
        if(questionNumber == 8)
        {
            progress.ratio = 1.0f;
            
        }
        
        tickTexture = [Media atlasTexture:@"tick"];
        tick = [SPImage imageWithTexture:tickTexture];	
        tick.y = 260;
        tick.x = 220;
        [self addChild:tick];
        
        SPTween *ticktween = [SPTween tweenWithTarget:tick time:2.0f transition:SP_TRANSITION_EASE_IN];
        [ticktween animateProperty:@"scaleX" targetValue:1.8f];
        [ticktween animateProperty:@"scaleY" targetValue:1.8f];
        [ticktween animateProperty:@"alpha" targetValue:0.0f];
        [[SPStage mainStage].stage.juggler addObject:ticktween];
        
        [self updateScore];
        
        
	}
    
	else
	{
		theQuestion.text = @"Nope, thats not it.";
		myScore = myScore - 50;
        
        crossTexture = [Media atlasTexture:@"cross"];
        cross = [SPImage imageWithTexture:crossTexture];	
        cross.y = 260;
        cross.x = 220;
        [self addChild:cross];
        SPTween *crosstween = [SPTween tweenWithTarget:cross time:2.0f transition:SP_TRANSITION_EASE_IN];
        [crosstween animateProperty:@"scaleX" targetValue:1.8f];
        [crosstween animateProperty:@"scaleY" targetValue:1.8f];
        [crosstween animateProperty:@"alpha" targetValue:0.0f];
        [[SPStage mainStage].stage.juggler addObject:crosstween];

        
        livesLeft = livesLeft - 1;
        if (livesLeft == 2){
            heart.alpha = 0.0f; 
            [self updateScore];
        }
        if (livesLeft == 1)
        {
            heart1.alpha = 0.0f; 
            [self updateScore];
        }
        if (livesLeft == 0)
        {
            heart2.alpha = 0.0f; 
            [self onEndGame];
        }
        
        
        
	}

	//[self updateScore];
}


-(void)loadQuiz
{
	if ((arc4random() % 2) == 0){
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *textFilePath = [bundle pathForResource:@"quizgame" ofType:@"txt"];
        NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
        NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
        self.theQuiz = quizArray;
         [quizArray release];
    }
    else {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *textFilePath = [bundle pathForResource:@"quizgame" ofType:@"txt"];
        NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
        NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
        self.theQuiz = quizArray;
         [quizArray release];
    }
    
    myScore = 0;

}

- (void)shootOne:(SPEvent *)event
{
    SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:0.5f];
    [shiptween animateProperty:@"x" targetValue:225];
    
    [[SPStage mainStage].stage.juggler addObject:shiptween];
    
    SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:0.5f];
    [shipparticletween animateProperty:@"emitterX" targetValue:244];
    
    [[SPStage mainStage].stage.juggler addObject:shipparticletween];
    
    //bullet
    bullet = [[SPTextField alloc] initWithWidth:10 height:10 text:@"." fontName:@"Funky" fontSize:20.0f color:0xffffff];
    bullet.x = 235;
    bullet.y = 100;
    [self addChild:bullet];
    [bullet release];

    SPTween *moveBullet = [SPTween tweenWithTarget:bullet time:1.0f];
    [moveBullet animateProperty:@"y" targetValue:600];
    [[SPStage mainStage].juggler addObject:moveBullet];

    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:bullet byTime:1.0] removeFromParent];

    
}
- (void)shootTwo:(SPEvent *)event
{
    SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:0.5f];
    [shiptween animateProperty:@"x" targetValue:180];
    
    [[SPStage mainStage].stage.juggler addObject:shiptween];
    
    SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:0.5f];
    [shipparticletween animateProperty:@"emitterX" targetValue:199];
    
    [[SPStage mainStage].stage.juggler addObject:shipparticletween];

    //bullet
    bullet = [[SPTextField alloc] initWithWidth:10 height:10 text:@"." fontName:@"Funky" fontSize:20.0f color:0xffffff];
    bullet.x = 190;
    bullet.y = 100;
    [self addChild:bullet];
    [bullet release];

    SPTween *moveBullet = [SPTween tweenWithTarget:bullet time:1.0f];
    [moveBullet animateProperty:@"y" targetValue:600];
    [[SPStage mainStage].juggler addObject:moveBullet];
    
    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:bullet byTime:1.0] removeFromParent];

    
    
}
- (void)shootThree:(SPEvent *)event
{
    SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:0.5f];
    [shiptween animateProperty:@"x" targetValue:120];
    
    [[SPStage mainStage].stage.juggler addObject:shiptween];
    
    SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:0.5f];
    [shipparticletween animateProperty:@"emitterX" targetValue:139];
    
    [[SPStage mainStage].stage.juggler addObject:shipparticletween];

    //bullet
    bullet = [[SPTextField alloc] initWithWidth:10 height:10 text:@"." fontName:@"Funky" fontSize:20.0f color:0xffffff];
    bullet.x = 130;
    bullet.y = 100;
    [self addChild:bullet];
    [bullet release];

    SPTween *moveBullet = [SPTween tweenWithTarget:bullet time:1.0f];
    [moveBullet animateProperty:@"y" targetValue:600];
    [[SPStage mainStage].juggler addObject:moveBullet];
    
    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:bullet byTime:1.0] removeFromParent];
    
}
- (void)shootFour:(SPEvent *)event
{
    SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:0.5f];
    [shiptween animateProperty:@"x" targetValue:60];
    
    [[SPStage mainStage].stage.juggler addObject:shiptween];
    
    SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:0.5f];
    [shipparticletween animateProperty:@"emitterX" targetValue:79];
    
    [[SPStage mainStage].stage.juggler addObject:shipparticletween];

    //bullet
    bullet = [[SPTextField alloc] initWithWidth:10 height:10 text:@"." fontName:@"Funky" fontSize:20.0f color:0xffffff];
    bullet.x = 65;
    bullet.y = 70;
    [self addChild:bullet];
    [bullet release];

    SPTween *moveBullet = [SPTween tweenWithTarget:bullet time:1.0f];
    [moveBullet animateProperty:@"y" targetValue:600];
    [[SPStage mainStage].juggler addObject:moveBullet];
    
    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:bullet byTime:1.0] removeFromParent];
    
}

- (void)onCountdownFin:(SPEvent *)event
{
    [self removeChild:countdown];
    [[SPStage mainStage].juggler removeObject:countdown];
    
    [self loadQuiz];
    [self askQuestion];

}


//menu for pause
- (void)onPauseButtonTriggered:(SPEvent *)event
{
 
    [(Game *)self.stage pausesound];
    questionLive = NO;
    [timer invalidate];
    answerOne.alpha = 0.0f;
    answerTwo.alpha = 0.0f;
    answerThree.alpha = 0.0f;
    answerFour.alpha = 0.0f;
    
    pausemenu = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"pausemenuiphone"]];
    [self addChild:pausemenu];
    [pausemenu release];

        
    backtogameTexture = [Media atlasTexture:@"backtogameiphone"];
    backtogame = [[SPButton alloc] initWithUpState:backtogameTexture text:@""];
    backtogame.alpha = 1.0f;
    backtogame.x = 160;
    backtogame.y = 180;
    [backtogame addEventListener:@selector(onBackGameButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:backtogame]; 
    [backtogame release];

    backtomenuTexture = [Media atlasTexture:@"backtomenuiphone"];
    backtomenu = [[SPButton alloc] initWithUpState:backtomenuTexture text:@""];
    backtomenu.alpha = 1.0f;
    backtomenu.x = 100;
    backtomenu.y = 180;
    [backtomenu addEventListener:@selector(onBackMenuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:backtomenu];
    [backtomenu release];

    [[SPStage mainStage].juggler pause]; 
    
    
}

//back to game button 
- (void)onBackGameButtonTriggered:(SPEvent *)event
{

    [[SPStage mainStage].juggler play]; 
    
    [(Game *)self.stage unpausesound];

    answerOne.alpha = 1.0f;
    answerTwo.alpha = 1.0f;
    answerThree.alpha = 1.0f;
    answerFour.alpha = 1.0f;
    
    questionLive = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];

    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:backtogame byTime:0.0] removeFromParent];
    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:pausemenu byTime:0.0] removeFromParent];    
    [[[SPStage mainStage].stage.juggler delayInvocationAtTarget:backtomenu byTime:0.0] removeFromParent];   

    [self removeChild:backtogame];
    [self removeChild:pausemenu];
    [self removeChild:backtomenu];

}

//back to menu
- (void)onBackMenuButtonTriggered:(SPEvent *)event
{
    [[SPStage mainStage].juggler play]; 
    [(Game *)self.stage PlayScreenCompleted:(SPEvent *)event];
}


- (void)onInformedButtonTriggered:(SPEvent *)event
{
    
    //run mailer
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dev.31ll.com/projects/mailbrainboylist/mailv2.php"]];

}

//try again
- (void)onTryAgainButtonTriggered:(SPEvent *)event
{
    [(Game *)self.stage LevelTwo];

    // add spaceship and thrust particle effects
    // create particle system
    
    mParticleSystem.emitterX = 164;
    mParticleSystem.emitterY = 65;
    mParticleSystem.alpha = 1.0f;
    
    spaceship.alpha = 1.0f;
    spaceship.x = 140;
    spaceship.y = 40;
    
    [self removeChild:endgamemenu];
    [self removeChild:scorefield];
    [self removeChild:tryagain]; 
    [self removeChild:backtomenu];
  
    heart.alpha = 1.0f; 
    heart1.alpha = 1.0f; 
    heart2.alpha = 1.0f; 
    
    progress.ratio = 0.1f;
    questionLive = NO;
    questionNumber = 0;
    myLives = 0;
    livesLeft = 3;
    
    [self loadQuiz];
    [self askQuestion];
    
}

//when the games done and dusted
- (void)onEndGame
{
    
    questionLive = NO;    
    [timer invalidate];

    
    //mmm vibrate
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    
    //temp again
    myScore = myScore + 50;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:myScore forKey:@"score"];
    
    
    [OFHighScoreService setHighScore:myScore forLeaderboard:@"954536"
                 onSuccessInvocation:[OFInvocation invocationForTarget:nil selector:nil] 
                 onFailureInvocation:[OFInvocation invocationForTarget:nil selector:nil]];
    
    
    SPTween *shiptween = [SPTween tweenWithTarget:spaceship time:0.5f];
    [shiptween animateProperty:@"x" targetValue:0];
    [shiptween animateProperty:@"alpha" targetValue:0.0f];
    [[SPStage mainStage].stage.juggler addObject:shiptween];
    
    
    SPTween *shipparticletween = [SPTween tweenWithTarget:mParticleSystem time:0.2f];
    [shipparticletween animateProperty:@"alpha" targetValue:0.0f];
    [[SPStage mainStage].stage.juggler addObject:shipparticletween];
    
    endgamemenu = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"endgame"]];
    [self addChild:endgamemenu];
    [endgamemenu release];

    scorefield = [SPTextField textFieldWithText:[NSString stringWithFormat:@"Score: %d",myScore]];
    scorefield.fontName = @"Funky";
    scorefield.rotation = SP_D2R(90);
    scorefield.y = 180;
    scorefield.x = 242;
    scorefield.color = 0xffffff;
    scorefield.fontSize = 15.0f;
    [self addChild:scorefield];
    
    
    tryagainTexture = [Media atlasTexture:@"tryagain"];
    tryagain = [[SPButton alloc] initWithUpState:tryagainTexture text:@""];
    tryagain.alpha = 1.0f;
    tryagain.x = 125;
    tryagain.y = 186;
    [tryagain addEventListener:@selector(onTryAgainButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:tryagain]; 
    [tryagain release];

    
    backtomenuTexture = [Media atlasTexture:@"backtomenuiphone"];
    backtomenu = [[SPButton alloc] initWithUpState:backtomenuTexture text:@""];
    backtomenu.alpha = 1.0f;
    backtomenu.x = 80;
    backtomenu.y = 180;
    [backtomenu addEventListener:@selector(onBackMenuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:backtomenu];
    [backtomenu release];

    
}

- (void) dealloc
{  
    
    //super
    [super dealloc];
    
}
@end
