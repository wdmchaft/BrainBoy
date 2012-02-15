//
//  Level1Play.h
//  BrainBoy
//
//  Created by Me on 12/09/11.
//  Copyright 2011 Gymnasium Kirchenfeld. All rights reserved.
//
//import libraries
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SHAnimatableColor.h"
#import "SXParticleSystem.h"
#import "SXMotionTween.h"
#import "SXGauge.h"
#import "SampleOFDelegate.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFHighScoreService.h"
#import "OpenFeint/OFSocialNotificationApi.h"
#import "Openfeint/OFAchievementService.h"
#import "Openfeint/OFAchievement.h"

//import my stuff
#import "Menu.h"

@interface Level1Play : SPSprite {
    
    //background elements
    SPMovieClip *countdown;

    //heart and lives
    SPTexture *heartTexture;
    SPImage *heart;
    SPImage *heart1;
    SPImage *heart2;
    SPTexture *crossTexture;
    SPImage *cross;
    SPImage *cross2;
    SPTexture *tickTexture;
    SPImage *tick;
    SPTexture *savedTexture;
    SPImage *saved;
    
    //HUD 
    SPTexture *pauseButtonTexture;
    SPButton *pause;
    
    SPTexture *progresstexture;
    SPImage *progressback;
    SXGauge *progress;
    SPSprite *progresscontent;
    SPMovieClip *timercountdown;
    SPTextField *scorefield;

    //loaded on pause
    SPImage *pausemenu;
    SPTexture *backtogameTexture;
    SPTexture *backtomenuTexture;
    SPButton *backtogame;
    SPButton *backtomenu;
 
    //loaded on endgame
    SPImage *endgamemenu;
    SPTexture *tryagainTexture;
    SPButton *tryagain;

    //atmos
    SPTextField *troposphere;
    SPTextField *stratosphere;
    SPTextField *mesosphere;
    SPTextField *thermosphere;
    SPTextField *exosphere;
    SPImage *cloudcovering;
    SPImage *airplane;
    SPImage *airplane2;

    //questions
    
        SPTextField *theQuestion;
        SPTextField *theScore;
        SPTextField *theLives;
        SPTextField *bullet;
        SPButton *answerOne;
        SPButton *answerTwo;
        SPButton *answerThree;
        SPButton *answerFour;
    
        SPTween *answer1tween2;
        SPTween *answer2tween2;
        SPTween *answer3tween2;
        SPTween *answer4tween2;

        NSInteger livesLeft;
        NSInteger myScore;
        NSInteger myLives;
        NSInteger questionNumber;
        NSInteger rightAnswer;
        NSInteger time;
        NSArray *theQuiz;
        NSTimer *timer;
        BOOL questionLive;
        BOOL restartGame;
        NSInteger currentLevel;
    
    //end calls
    SPImage *completemenu;
    SPTexture *informedTexture;
    SPButton *informed;
    
    //spaceship
    SPImage *spaceship;
    SXParticleSystem *mParticleSystem;       
    SXParticleSystem *cometParticleSystem;       

}
//questions and answers props
@property (retain, nonatomic) SPTextField	*theQuestion;
@property (retain, nonatomic) SPTextField	*theScore;
@property (retain, nonatomic) SPTextField	*theLives;
@property (retain, nonatomic) SPButton	*answerOne;
@property (retain, nonatomic) SPButton	*answerTwo;
@property (retain, nonatomic) SPButton	*answerThree;
@property (retain, nonatomic) SPButton	*answerFour;
@property (retain, nonatomic) NSArray *theQuiz;
@property (retain, nonatomic) NSTimer *timer;


@property (nonatomic, retain) NSTimer * blink;

-(void)buttonOne:(SPEvent *)event;
-(void)buttonTwo:(SPEvent *)event;
-(void)buttonThree:(SPEvent *)event;
-(void)buttonFour:(SPEvent *)event;

//question events
-(void)shootOne:(SPEvent *)event;
-(void)shootTwo:(SPEvent *)event;
-(void)shootThree:(SPEvent *)event;
-(void)shootFour:(SPEvent *)event;

-(void)checkAnswer:(int)theAnswerValue;

-(void)askQuestion;

-(void)updateScore;

-(void)loadQuiz;

-(void)countDown;

-(void)reset;

//button events

- (void)onInformedButtonTriggered:(SPEvent *)event;
- (void)onPauseButtonTriggered:(SPEvent *)event;
- (void)onBackMenuButtonTriggered:(SPEvent *)event;
- (void)onBackGameButtonTriggered:(SPEvent *)event;
- (void)onTryAgainButtonTriggered:(SPEvent *)event;

//all over red rover
- (void)onEndGame;
// on tick


@end
