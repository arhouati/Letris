//
//  LETGameLevels.m
//  Lettris Arabic
//
//  Created by Abdelkader on 22/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import "LETGameLevels.h"
#import "LETGame.h"
#import "LETGameStart.h"
#import "blocked.h"

// Sprite Node View

#import <AVFoundation/AVFoundation.h>

static SKSpriteNode *bgSceneLevels;
static SKSpriteNode *bgPopinLevels;
static SKSpriteNode *buttonClosePopinLevels;
static SKSpriteNode *labelStep;

static SKSpriteNode *heart;
static SKSpriteNode *backButton;
static SKLabelNode *backButtonLabel;

static AVAudioPlayer *_audioPlayer;
static AVAudioPlayer *_audioBackgroundPlayer;

// Arrays
static NSMutableArray *levelsOfCurrentStep;

// Path and Document Directory
static NSArray *paths;
static NSString *documentsDirectory;

// BOOL
BOOL optionVolume;

@implementation LETGameLevels


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        [self displayBannerInterstitial];
        
        self.name  = @"gameLevels";
        
        // Get All steps and levels
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        
        NSString *pListPathSteps= [documentsDirectory stringByAppendingPathComponent:@"steps.plist"];
        
        // Update steps that are underConstructer
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ( pListPathSteps )
        {
            if ([manager isWritableFileAtPath:pListPathSteps])
            {
                NSMutableArray  *infoDict = [NSMutableArray arrayWithContentsOfFile:pListPathSteps];
                [infoDict writeToFile:pListPathSteps atomically:YES];
                
                // step = 2
                NSMutableDictionary *step = [infoDict objectAtIndex:1];
                [step setObject:@"NO" forKey:@"underConstruction"];
                [infoDict writeToFile:pListPathSteps atomically:YES];
            }
        }
        
        self.steps = [NSMutableArray arrayWithContentsOfFile:pListPathSteps];

        NSString *pListPathLevels= [documentsDirectory stringByAppendingPathComponent:@"levels.plist"];
        
        // patch levels information for the old version of game app
        manager = [NSFileManager defaultManager];
        
        if ( pListPathLevels )
        {
            if ([manager isWritableFileAtPath:pListPathLevels])
            {
                NSMutableArray  *infoDict = [NSMutableArray arrayWithContentsOfFile:pListPathLevels];
                [infoDict writeToFile:pListPathLevels atomically:YES];
                
                // deblock automaticaly level 6
                NSMutableDictionary *levelLastStep = [infoDict objectAtIndex:5];
                NSMutableDictionary *levelNextStep = [infoDict objectAtIndex:6];
                if( [[levelLastStep objectForKey:@"blocked"] isEqual:@NO] ){
                    [levelNextStep setObject:@NO forKey:@"blocked"];
                }
                [infoDict writeToFile:pListPathLevels atomically:YES];
                
                // level from 6 to 11
                for(int i = 6; i <=11; i++){
                    NSMutableDictionary *level = [infoDict objectAtIndex:i];
                    [level setObject:@"LETGame2" forKey:@"class"];
                    
                    // update level 11
                    if( i ==11 )
                    {
                        [level setObject:@"words-ara-vegetables" forKey:@"file"];
                        [level setObject:@"إكتشف 5 أسماء فواكه وخضر" forKey:@"instruction"];

                    }
                    [infoDict writeToFile:pListPathLevels atomically:YES];
                }
                
            }
        }
        
        self.levels = [NSMutableArray arrayWithContentsOfFile:pListPathLevels];
        
        levelsOfCurrentStep = [[NSMutableArray alloc] init];
        
        self.stepsNodes = [[NSMutableArray alloc] init];
        
        // initialise number of Life and decrement the number
        self.numberHeart = [self getNumberLifes];
        
        // Get Option volume
        optionVolume = [self getOptionVolume];
        
        if(optionVolume){
            [self initAudioBackgroundPlayer:@"appearSteps"];
            _audioBackgroundPlayer.volume = 0.05;
            [_audioBackgroundPlayer play];
        }
        
        // Set Background Scene
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg-scene-game.jpg"];
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.name = @"BACKGROUND";
        [background setUserInteractionEnabled:YES];
        
        [self addChild:background];
        
        [self displayStepsView];
        [self displayLifesView];
        
    }
    return self;
}

-(id)initWithSizeAndDeblockNextLevel:(CGSize)size  nextLevel:(int)indexNextLevel
{
    self = [self initWithSize:size];
    
    [self runAction:[SKAction waitForDuration:2] completion:^{
        
        [self deblockNextLevel:indexNextLevel];
        
        NSString *pListPathLevels= [documentsDirectory stringByAppendingPathComponent:@"levels.plist"];
        
        self.levels = [NSMutableArray arrayWithContentsOfFile:pListPathLevels];
        
    }];
    
    return self;
}


#pragma mark -
#pragma mark fonctions add graphics components to scene levels

-(void)displayLifesView
{
    
    SKAction *displayTopBarHearView  = [SKAction moveToY:self.size.height -30 duration:0.5];
    SKAction *displayTopBarNumberHearView  = [SKAction moveToY:self.size.height -42 duration:0.5];
    
    // display back button
    SKAction *displayBackButton  = [SKAction sequence:@[[SKAction fadeInWithDuration:0.7],
                                                        [SKAction moveToX:40 duration:0.5]]];
    
    SKAction *displayBackButtonLabel  = [SKAction sequence:@[[SKAction fadeInWithDuration:0.7],
                                                        [SKAction moveToX:100 duration:0.5]]];
    
    backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    backButton.name = @"back";
    backButton.position = CGPointMake(100, self.size.height -35);
    backButton.alpha = -2;
    [backButton setZPosition:1];
    [self addChild:backButton];
    [backButton runAction:displayBackButton completion:^{
        [heart runAction:displayTopBarHearView];
        [self.numberHeartLabel runAction:displayTopBarNumberHearView];
    }];
    
    backButtonLabel = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Bold"];
    backButtonLabel.name = @"backLabel";
    backButtonLabel.text = @"رجوع";
    backButtonLabel.fontSize = 35;
    backButtonLabel.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    backButtonLabel.alpha = -2;
    [backButton setZPosition:1];
    backButtonLabel.position = CGPointMake(150, self.size.height -50);
    [backButtonLabel setZPosition:1];
    [self addChild:backButtonLabel];
    [backButtonLabel runAction:displayBackButtonLabel];
    
}


-(void)displayStepsView
{
    // Road Trace
    SKSpriteNode *road = [SKSpriteNode spriteNodeWithImageNamed:@"road"];
    
    road.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    road.name = @"road";
    road.alpha = -2;
    [road setUserInteractionEnabled:YES];
    
    [self addChild:road];
    
    [road runAction:[SKAction fadeInWithDuration:0.5]];
    
    // Start Door & boy
    SKSpriteNode *startDoor = [SKSpriteNode spriteNodeWithImageNamed:@"door"];
    
    if( self.size.width == 414 || self.size.width == 375) //Iphone 6 & 6s & 7 plus Iphone 6 & 6s & 7
        startDoor.position = CGPointMake(startDoor.size.width/2 + 30, - startDoor.size.height/2);
    else //Iphone 5 & 5S & SE
        startDoor.position = CGPointMake(startDoor.size.width/2 + 5, - startDoor.size.height/2);
    
    
    startDoor.name = @"startDoor";
    [startDoor setZPosition:1];
    [startDoor setUserInteractionEnabled:YES];
    [self addChild:startDoor];
    
    SKSpriteNode *boy = [SKSpriteNode spriteNodeWithImageNamed:@"boy"];
    
    if( self.size.width == 414 || self.size.width == 375 ) //Iphone 6 & 6s & 7 plus Iphone 6 & 6s & 7
        boy.position = CGPointMake(startDoor.size.width/2 + 50, startDoor.size.height/2 -5);
    else //Iphone 5 & 5S & SE
        boy.position = CGPointMake(startDoor.size.width/2 + 25, startDoor.size.height/2 -5);
    
    boy.name = @"startDoor";
    boy.alpha = -2;
    [boy setUserInteractionEnabled:YES];
    [self addChild:boy];
    
    [startDoor runAction:[SKAction moveToY:startDoor.size.height/2-5 duration:0.5] completion:^{
        
        if( self.size.width == 414 || self.size.width == 375 ) //Iphone 6 & 6s & 7 plus Iphone 6 & 6s & 7
            [boy runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:0.5],
                                                [SKAction moveToX:startDoor.size.width/2 + 60
                                                         duration:0.6]]] completion:^{
                [boy setZPosition:2];
            }];
        else //Iphone 5 & 5S & SE
            [boy runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:0.5],
                                            [SKAction moveToX:startDoor.size.width/2 + 35
                                                     duration:0.6]]] completion:^{
                    [boy setZPosition:2];
                        }];
    }];
    
    
    // Add Cup Of winners
    SKSpriteNode *cup = [SKSpriteNode spriteNodeWithImageNamed:@"cup"];
    
    if( self.size.width == 414 || self.size.width == 375) //Iphone 6 & 6s & 7 plus Iphone 6 & 6s & 7
        cup.position = CGPointMake( self.size.width -120 , self.size.height -60 );
    else //Iphone 5 & 5S & SE
        cup.position = CGPointMake( self.size.width -80 , self.size.height -40 );
    
    cup.name = @"startDoor";
    cup.alpha = -2;
    [cup setUserInteractionEnabled:YES];
    [self addChild:cup];
    
    
    // BEsfehanBold  BElham BJadidBold  BKoodakOutline  A_Nefel_Botan
    // Add Cup Of winners
    SKSpriteNode *roadOfKnowladge = [SKSpriteNode spriteNodeWithImageNamed:@"steps-scene-label"];
    
    roadOfKnowladge.position = CGPointMake( self.size.width - roadOfKnowladge.size.width/2 -10 , -40 );
    roadOfKnowladge.name = @"roadOfKnowladge";
    [roadOfKnowladge setUserInteractionEnabled:YES];
    [self addChild:roadOfKnowladge];
    
    [cup runAction:[SKAction fadeInWithDuration:1] completion:^{
        // add steps
        [self addSteps];
        [roadOfKnowladge runAction:[SKAction moveToY:40 duration:1]];
    }];

    
}


-(void)displayPopinLevels:(int)indexStep
{
    [self displayPopinLevels:indexStep indexLevelToDeblock:-1];
}


-(void)displayPopinLevels:(int)indexStep indexLevelToDeblock:(int)indexLevelToDeblock
{
    
    bgSceneLevels = [SKSpriteNode spriteNodeWithImageNamed:@"bgPause"];
    bgSceneLevels.position = CGPointMake(bgSceneLevels.size.width/2, bgSceneLevels.size.height/2);
    bgSceneLevels.name = @"bgSceneLevels";
    [bgSceneLevels setUserInteractionEnabled:YES];
    [bgSceneLevels setZPosition:1];
    [self addChild:bgSceneLevels];
    
    bgPopinLevels = [SKSpriteNode spriteNodeWithImageNamed:@"popin"];
    bgPopinLevels.position = CGPointMake(self.size.width/2 , self.size.height/2 );
    bgPopinLevels.name = @"bgSceneLevels";
    bgPopinLevels.alpha = -2;
    [bgPopinLevels setUserInteractionEnabled:YES];
    [bgPopinLevels setZPosition:1];
    [self addChild:bgPopinLevels];
    
    buttonClosePopinLevels = [SKSpriteNode spriteNodeWithImageNamed:@"close-popin"];
    buttonClosePopinLevels.position = CGPointMake(self.size.width/2 + bgPopinLevels.size.width/2 - buttonClosePopinLevels.size.width/2 - 3 , self.size.height/2 + bgPopinLevels.size.height/2 - buttonClosePopinLevels.size.height/2 + 2);
    buttonClosePopinLevels.name = @"closePopin";
    [buttonClosePopinLevels setZPosition:1];
    buttonClosePopinLevels.alpha = -2;
    [self addChild:buttonClosePopinLevels];
    
    NSString *imageLabel = [[NSString alloc] initWithFormat:@"step-label-%d",indexStep+1];
    labelStep = [SKSpriteNode spriteNodeWithImageNamed:imageLabel];
    labelStep.position = CGPointMake(self.size.width/2 , bgPopinLevels.position.y );
    labelStep.name = @"labelStep";
    labelStep.alpha = -2;
    [labelStep setUserInteractionEnabled:YES];
    [labelStep setZPosition:1];
    [self addChild:labelStep];
    
    [bgPopinLevels runAction:[SKAction fadeInWithDuration:0.3] completion:^{
        
        [labelStep runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:0.2],
                                                  [SKAction moveToY:self.size.height/2 + bgPopinLevels.size.height/2 duration:0.5]
                                                  ]
                              ]
         completion:^{
             
             // Add Levels of the current step
             [self addLevels:indexStep indexLevelToDeblock:indexLevelToDeblock];
             
             [buttonClosePopinLevels runAction:[SKAction fadeInWithDuration:1]];
             
         }];
        
       
        
    }];
    
}


-(void)hidePopinLevels
{
    SKAction *sequence = [SKAction sequence:@[[SKAction moveBy:CGVectorMake(0, self.size.height +300) duration:0.6],
                                             [SKAction removeFromParent]
                                              ]];
    
    [bgPopinLevels runAction:sequence];
    [labelStep runAction:sequence];
    for (SKSpriteNode *level in levelsOfCurrentStep) {
        [level runAction:sequence];
    }
    [buttonClosePopinLevels runAction:sequence completion:^{
        
        [bgSceneLevels runAction:[SKAction fadeOutWithDuration:0.2] completion:^{
            [bgSceneLevels removeFromParent];
        }];
        
    }];
    
}


-(void)addSteps
{
    
    float duration = 0;
    
    for (NSMutableDictionary *step in self.steps) {
        
        NSString *image = [[NSString alloc] initWithFormat:@"step_%@",[step objectForKey:@"index"]];
        SKSpriteNode *stepNode = [SKSpriteNode spriteNodeWithImageNamed:image];
                
        if( self.size.width == 414) //Iphone 6 & 6s & 7 plus
            stepNode.position = CGPointMake([[step objectForKey:@"x-3"] intValue], [[step objectForKey:@"y-3"] intValue]);
        else if( self.size.width == 375) //Iphone 6 & 6s & 7
            stepNode.position = CGPointMake([[step objectForKey:@"x-2"] intValue], [[step objectForKey:@"y-2"] intValue]);
        else  //Iphone 5 & 5s & SE
            stepNode.position = CGPointMake([[step objectForKey:@"x"] intValue], [[step objectForKey:@"y"] intValue]);
        
        stepNode.alpha = -2;
        
        stepNode.name = @"step";
        [self addChild:stepNode];
        
        duration += 0.3;
        
        [stepNode runAction:[SKAction fadeInWithDuration:duration]];
        
        NSNumber *underConstruction = [step objectForKey:@"underConstruction"];
        if( [underConstruction boolValue] )
        {
            [stepNode setUserInteractionEnabled:YES];
            
            SKSpriteNode *underConstruction = [SKSpriteNode spriteNodeWithImageNamed:@"under-construction"];
            underConstruction.position = CGPointMake(stepNode.position.x + 10, stepNode.position.y +10);
            underConstruction.alpha = -2;
            [underConstruction setUserInteractionEnabled:YES];
            [self addChild:underConstruction];
            
            [underConstruction runAction:[SKAction fadeInWithDuration:duration]];
        }
        else
        {
        
           /* NSNumber *blocked = [step objectForKey:@"blocked"];
            if( [blocked boolValue] )
            {
                SKSpriteNode *blockedStep = [SKSpriteNode spriteNodeWithImageNamed:@"blocked-step"];
                blockedStep.position = CGPointMake([[step objectForKey:@"x"] intValue] + stepNode.size.width/2 -10, [[step objectForKey:@"y"] intValue] + stepNode.size.height/2 -10);
                blockedStep.alpha = -2;
                [blockedStep setUserInteractionEnabled:YES];
                [self addChild:blockedStep];
            
                [blockedStep runAction:[SKAction fadeInWithDuration:duration]];
            }*/
        }
        
        [self.stepsNodes addObject:stepNode];
    }
}


-(void)addLevels:(int)indexStep indexLevelToDeblock:(int)indexLevelToDeblock
{
    
    NSMutableArray *levelOfCurrentStep = (NSMutableArray *)[self.levels subarrayWithRange:NSMakeRange(indexStep*6, 6)];
    
    int index = 0;
    int ligne = 0;
    int xLevel = 0;
    int yLevel = 0;
    BOOL toDeblock = FALSE;
    for (NSMutableDictionary *level in levelOfCurrentStep) {
        
        if( index == (fmod(indexLevelToDeblock, 6)  -1) )
            toDeblock = TRUE;
        else
            toDeblock = FALSE;
        
        if( self.size.width == 320) //Iphone 4 & 5
            xLevel = (self.size.width /4) - 10 + (index % 3) * 90;
        else if( self.size.width == 414) //Iphone 6 & 6s & 7 plus
            xLevel = (self.size.width /4) + 10 + (index % 3) * 90;
        else
            xLevel = (self.size.width /4) + 5 + (index % 3) * 90;

        yLevel = bgPopinLevels.position.y + 40 - ligne;
        [self addLevel:level position:CGPointMake(xLevel, yLevel) toDeblock:toDeblock];
        
        index++;
        
        if (index % 3 == 0) {
            ligne = ligne + 100;
        }
    }
}


-(void)addLevel:(NSMutableDictionary *)level position:(CGPoint)position toDeblock:(BOOL)toDeblock
{
    SKSpriteNode *levelNode;
    NSString *image;
    NSNumber *blocked = [level objectForKey:@"blocked"];
    int index = (int)[[level objectForKey:@"index"] integerValue];
    
    image = [blocked boolValue] ?  @"blocked" : [[NSString alloc] initWithFormat:@"%d", index%6 ? index%6 : 6 ] ;

    if (toDeblock) {
      
        if(optionVolume){
            [self initAudioPlayer:@"newLevel"];
            [_audioPlayer play];
        }
        
        levelNode = [SKSpriteNode spriteNodeWithImageNamed:@"blocked"];

    }else{
        
        levelNode = [SKSpriteNode spriteNodeWithImageNamed:image];
        
    }
    
    levelNode.name = [[NSString alloc] initWithFormat:@"%d",index];
    levelNode.position = bgPopinLevels.position;
    [levelNode setZPosition:1];
    
    if( [blocked boolValue] )
    {
        [levelNode setUserInteractionEnabled:YES];
    }
    
    [self addChild:levelNode];
    
    
    if (toDeblock) {
        NSMutableArray *animeTexture = [[NSMutableArray alloc] initWithArray:BLOCKED_ANIM_BLOCKED];
        
        [animeTexture addObject: [SKTexture textureWithImageNamed:image]];
        
        SKAction *sequence = [SKAction sequence:@[[SKAction moveTo:position duration:0.5],
                                                 [SKAction animateWithTextures:animeTexture timePerFrame:0.2] ]];
        [levelNode runAction:sequence];

    }else{
        [levelNode runAction:[SKAction moveTo:position duration:0.5]];
    }
    
    [levelsOfCurrentStep addObject:levelNode];
    
}

-(void)displayRateApp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayRateApp"
                                                        object:self
                                                      userInfo:nil];
}

-(void)initAudioPlayer:(NSString*) file{
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], file];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

-(void)initAudioBackgroundPlayer:(NSString*) file{
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], file];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    _audioBackgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

-(int)getOptionVolume
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pListPath= [documentsDirectory stringByAppendingPathComponent:@"lives.plist"];
    
    NSMutableDictionary *lives = [NSMutableDictionary dictionaryWithContentsOfFile:pListPath];
    
    return [[lives objectForKey:@"volume"] intValue];
    
}

-(void)displayBannerInterstitial
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayBannerInterstitial"
                                                        object:self
                                                      userInfo:nil];
}

#pragma mark -
#pragma mark functions about level and lifes

-(int)getNumberLifes
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pListPath= [documentsDirectory stringByAppendingPathComponent:@"lives.plist"];
    
    NSMutableDictionary *lives = [NSMutableDictionary dictionaryWithContentsOfFile:pListPath];
    
    return [[lives objectForKey:@"numberHeart"] intValue];
    
}


-(void)deblockNextLevel:(int)indexNextLevel
{
    int step = indexNextLevel%6 == 0 ? (int) indexNextLevel/6 -1 : (int) labs( indexNextLevel/6 ) ;
    
    if( step > 1 ){
       
        // it's the end of demo
        [self displayRateApp];
       
    }else{
        
        // TODO : deblock step if the level is the first level to deblock
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"levels.plist"];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ( writableDBPath )
        {
            if ([manager isWritableFileAtPath:writableDBPath])
            {
                NSMutableArray  *infoDict = [NSMutableArray arrayWithContentsOfFile:writableDBPath];
                [infoDict writeToFile:writableDBPath atomically:YES];
                NSMutableDictionary *nextLevel = [infoDict objectAtIndex:(indexNextLevel -1)];
                [nextLevel setObject:@"NO" forKey:@"blocked"];
                [infoDict writeToFile:writableDBPath atomically:YES];
            }
        }
    
        [self displayPopinLevels:step indexLevelToDeblock:indexNextLevel];
        
    }
}

#pragma mark -
#pragma mark functions to handle touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectLetter:positionInScene];
}


-(void)selectLetter:(CGPoint)touchLocation {
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if( [touchedNode.name isEqualToString:@"step"] )
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
            [self initAudioPlayer:@"popinLevels"];
            [_audioPlayer play];
        }
        
        int indexStep = (int) [self.stepsNodes indexOfObject:touchedNode];
        [self displayPopinLevels:indexStep];
    }
    else if( [touchedNode.name isEqualToString:@"closePopin"] )
    {
        if(optionVolume){
            [self initAudioPlayer:@"exitGame"];
            [_audioPlayer play];
        }
        
        [self hidePopinLevels];
    }
    else if( [touchedNode.name isEqualToString:@"back"]  || [touchedNode.name isEqualToString:@"backLabel"])
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
        }
        
        SKScene * gameStart = [[LETGameStart alloc] initWithSize:self.size];
        [self.view presentScene:gameStart transition:[SKTransition fadeWithColor:[UIColor greenColor] duration:0]];
    }
    else
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
        }
        
        NSMutableDictionary *level = [self.levels objectAtIndex:([touchedNode.name intValue] -1)];
        
        SKScene * game = [[NSClassFromString([level objectForKey:@"class"]) alloc] initWithSize:self.size
                                                                                    currentLevel:level];
        [self.view presentScene:game transition:[SKTransition doorsOpenHorizontalWithDuration:0.5]];
    }
    
}

@end
