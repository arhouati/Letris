//
//  LETGame.m
//  Lettris Arabic
//
//  Created by Abdelkader on 12/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import "LETGame.h"
#import "LETColumn.h"
#import "LETGameLevels.h"

@implementation LETGame



-(id)initWithSize:(CGSize)size currentLevel:(NSMutableDictionary *)level {
    
    if (self = [super initWithSize:size]) {
        
        // init variables :
        nbrColumn = 6;
        maxLetterByColumn = 8;
        
        stopAddLetter = NO;
        replayAcived = YES;
        
        // save level
        self.level = level;
        
        // initialise number of Life and decrement the number
        self.numberHeart = [self getNumberLifes];
        
        if (self.numberHeart == 0) {
            [self waitHavingLive];
            return self;
        }
        
        if( self.size.width == 414) //Iphone 6 & 6s & 7 plus
        {
            maxLetterByColumn = 11;
        }
        else if( self.size.width == 375) //Iphone 6 & 6s & 7
        {
            maxLetterByColumn = 10;
        }
        
        // Initialize positions columns
        self.arrayColumns = [[NSMutableArray alloc] initWithObjects:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:1 nbrElement:0 maxLetter:maxLetterByColumn],
                                                                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:2 nbrElement:0 maxLetter:maxLetterByColumn],
                                                                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:3 nbrElement:0 maxLetter:maxLetterByColumn],
                                                                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:4 nbrElement:0 maxLetter:maxLetterByColumn],
                                                                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:5 nbrElement:0 maxLetter:maxLetterByColumn],
                                                                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:6 nbrElement:0 maxLetter:maxLetterByColumn],
                        nil];
        
        if( self.size.width == 414) //Iphone 6 & 6s & 7 plus
        {
            nbrColumn = 8;
            [self.arrayColumns addObject:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:7 nbrElement:0 maxLetter:maxLetterByColumn] ];
            [self.arrayColumns addObject:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:8 nbrElement:0 maxLetter:maxLetterByColumn] ];
        }
        else if( self.size.width == 375) //Iphone 6 & 6s & 7
        {
            nbrColumn = 7;
            [self.arrayColumns addObject:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:7 nbrElement:0 maxLetter:maxLetterByColumn] ];
        }
        else  //Iphone 5 & 5s & SE
        {
        }
        
        // get List Words
        [self getListWords];
        
        // Initialize Array letters selected
        self.theWordNodes = [[NSMutableArray alloc] init];
        self.arrayWordsTemp = [[NSMutableArray alloc] init];
        
        // Set Background Scene
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg-scene-game.jpg"];
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.name = @"BACKGROUND";
        [background setUserInteractionEnabled:YES];
        
        [self addChild:background];
        
        /* Initialise Action */
        notSelected =  [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15];
        selected = [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.5 duration:0.15];
        valideWordBg = [SKAction colorizeWithColor:[SKColor greenColor] colorBlendFactor:1 duration:0.3];
        
        // determine lever Game Properties
        self.speedLetter = (int) [[self.level objectForKey:@"speed"] integerValue];
        self.instrucionMessage = [self.level objectForKey:@"instruction"];
        
        // add a first letter
        [self displayWordView];
        [self displayTopBarView];
        [self displayInstructionAndStartGame];
        
        // Get Option volume
        optionVolume = [self getOptionVolume];
        
        if(optionVolume){
            [self initAudioBackgroundPlayer:@"backgroundMusic"];
            _audioBackgroundPlayer.numberOfLoops = -1;
            _audioBackgroundPlayer.volume = 0.05;
            [_audioBackgroundPlayer play];
        }
    }
    return self;
}

-(void)initFromScrach
{
    // delete Letter
    for (LETColumn *column in self.arrayColumns) {
        for (SKSpriteNode *letter in column.letters) {
            SKAction *fadeAway =   [SKAction fadeOutWithDuration:0.25];
            [letter runAction:fadeAway completion:^{
                [letter removeFromParent];
            }];
        }
    }
    
    // Initialize positions columns
    if( self.size.width == 414) //Iphone 6 & 6s & 7 plus
    {
        maxLetterByColumn = 11;
    }
    else if( self.size.width == 375) //Iphone 6 & 6s & 7
    {
        maxLetterByColumn = 10;
    }
    
    self.arrayColumns = [[NSMutableArray alloc] initWithObjects:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:1 nbrElement:0 maxLetter:maxLetterByColumn],
                                                            [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:2 nbrElement:0 maxLetter:maxLetterByColumn],
                                                            [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:3 nbrElement:0 maxLetter:maxLetterByColumn],
                                                            [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:4 nbrElement:0 maxLetter:maxLetterByColumn],
                                                            [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:5 nbrElement:0 maxLetter:maxLetterByColumn],
                                                            [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:6 nbrElement:0 maxLetter:maxLetterByColumn],
                         nil];
    
    
    if( self.size.width == 414) //Iphone 6 & 6s & 7 plus
    {
        nbrColumn = 8;
        [self.arrayColumns addObject:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:7 nbrElement:0 maxLetter:maxLetterByColumn]];
        [self.arrayColumns addObject:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:8 nbrElement:0 maxLetter:maxLetterByColumn]];

    }
    else if( self.size.width == 375) //Iphone 6 & 6s & 7
    {
        nbrColumn = 7;
        [self.arrayColumns addObject:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:7 nbrElement:0 maxLetter:maxLetterByColumn]];
    }
    else  //Iphone 5 & 5s & SE
    {
    }
    
    // get List Words
    [self getListWords];
    
    // Initialize Array letters selected
    self.theWordNodes = [[NSMutableArray alloc] init];
    self.arrayWordsTemp = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark fonctions add graphics components to scene game

-(void)displayInstructionAndStartGame
{
    replayAcived = FALSE;
    // Remove letter from Scene
    SKAction *moveCenterInstruction =     [SKAction moveTo:CGPointMake(self.size.width/2, 240) duration:1.0];
    SKAction *moveCenter =     [SKAction moveTo:CGPointMake(self.size.width/2, 250) duration:1.0];
    SKAction *wait =       [SKAction waitForDuration:1.5];
    SKAction *moveOut =     [SKAction moveTo:CGPointMake(-150, 250) duration:1.0];
    SKAction *moveOutInstruction =     [SKAction moveTo:CGPointMake(-150, 250) duration:1.0];
    SKAction *removeFromParent = [SKAction removeFromParent];
    SKAction *startGame = [SKAction runBlock:^{[self startGame];}];
    
    SKAction *sequenceInstriction = [SKAction sequence:@[moveCenterInstruction, wait, moveOutInstruction, startGame, removeFromParent]];
    SKAction *sequenceBGInstriction = [SKAction sequence:@[moveCenter, wait, moveOut, removeFromParent]];
    
    SKSpriteNode *bgInstruction = [SKSpriteNode spriteNodeWithImageNamed:@"bg-instruction.png"];
    bgInstruction.position = CGPointMake(460, 250);
    bgInstruction.name = @"bgInstruction";
    [bgInstruction setUserInteractionEnabled:YES];
    [self addChild:bgInstruction];
    
    [bgInstruction runAction:sequenceBGInstriction];
    
    self.instruction = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Bold"];
    self.instruction.text = self.instrucionMessage;
    self.instruction.name = @"instruction";
    self.instruction.fontSize = 25;
    self.instruction.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    self.instruction.position = CGPointMake(460, 240);
    [self.instruction setUserInteractionEnabled:YES];
    [self addChild:self.instruction];
    
    [self.instruction runAction:sequenceInstriction completion:^{
        replayAcived = TRUE;
        stopAddLetter = FALSE;
    }];
}


-(void)displayWordView
{
    SKAction *displayWordView  = [SKAction moveToY:22 duration:0.5];
    SKAction *displayWordViewScore  = [SKAction moveToY:10 duration:0.5];
    SKAction *displayWordViewWord  = [SKAction moveToY:15 duration:0.5];
    
    buttonPause = [SKSpriteNode spriteNodeWithImageNamed:@"pause.png"];
    buttonPause.position = CGPointMake(30, -22);
    [buttonPause setZPosition:1];
    buttonPause.name = @"pause";
    [self addChild:buttonPause];
    [buttonPause runAction:displayWordView];
    
    buttonWord = [SKSpriteNode spriteNodeWithImageNamed:@"bg-word.png"];
    buttonWord.name = @"validateBG";
    buttonWord.position = CGPointMake(self.size.width/2, -22);
    [buttonWord setZPosition:1];
    [self addChild:buttonWord];
    
    [buttonWord runAction:displayWordView];

    self.theWord = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Bold"];
    self.theWord.name = @"word";
    self.theWord.fontSize = 22;
    self.theWord.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    self.theWord.position = CGPointMake(self.size.width/2, -22);
    [self.theWord setZPosition:1];
    [self addChild:self.theWord];
    
    [self.theWord runAction:displayWordViewWord];
    
    self.theScore = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Bold"];
    self.theScore.text = @"0";
    self.theScore.fontSize = 32;
    self.theScore.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    self.theScore.position = CGPointMake(self.size.width -30, -22);
    [self.theScore setUserInteractionEnabled:YES];
    [self.theScore setZPosition:1];
    [self addChild:self.theScore];
    
    [self.theScore runAction:displayWordViewScore];
    
}

-(void)hideWordView{
    
    SKAction *hideWordView  = [SKAction moveToY:-22 duration:0.5];

    [buttonPause runAction:hideWordView];
    [buttonWord runAction:hideWordView];
    [self.theWord runAction:hideWordView];
    [self.theScore runAction:hideWordView];

}


-(void)displayTopBarView
{
    
    SKAction *displayTopBarView  = [SKAction moveToY:self.size.height -15 duration:0.5];
    SKAction *displayInstructionTopBarView  = [SKAction moveToY:self.size.height -30 duration:0.5];
    //SKAction *displayTopBarHearView  = [SKAction moveToY:self.size.height -17 duration:0.5];
    //SKAction *displayTopBarNumberHearView  = [SKAction moveToY:self.size.height -25 duration:0.5];


    bgTopBar = [SKSpriteNode spriteNodeWithImageNamed:@"bg-top-bar.png"];
    bgTopBar.position = CGPointMake(bgTopBar.size.width/2, self.size.height + 70);
    [bgTopBar setUserInteractionEnabled:YES];
    [bgTopBar setZPosition:1];
    [self addChild:bgTopBar];
    [bgTopBar runAction:displayTopBarView];
    
    /*heart = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heart.position = CGPointMake(heart.size.width/2 + 35, self.size.height + 70);
    [heart setUserInteractionEnabled:YES];
    [heart setZPosition:1];
    [self addChild:heart];
    [heart runAction:displayTopBarHearView];
    
    self.numberHeartLabel = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Bold"];
    self.numberHeartLabel.text = [[NSString alloc] initWithFormat:@"%d",self.numberHeart];
    self.numberHeartLabel.fontSize = 24;
    self.numberHeartLabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [self.numberHeartLabel setUserInteractionEnabled:YES];
    self.numberHeartLabel.position = CGPointMake(20, self.size.height + 70);
    [self.numberHeartLabel setZPosition:1];
    [self addChild:self.numberHeartLabel];
    [self.numberHeartLabel runAction:displayTopBarNumberHearView];*/
    
    topBarInscription = [[SKLabelNode alloc] initWithFontNamed:@"AmericanTypewriter-Bold"];
    topBarInscription.text = [self.level objectForKey:@"instruction"];
    topBarInscription.fontSize = 25;
    topBarInscription.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [topBarInscription setUserInteractionEnabled:YES];
    topBarInscription.position = CGPointMake(self.size.width - topBarInscription.frame.size.width/2 -10, self.size.height + 30);
    [topBarInscription setZPosition:1];
    [self addChild:topBarInscription];
    [topBarInscription runAction:displayInstructionTopBarView];
    
}


-(void)hideTopBarView
{
    
    SKAction *hideTopBarView  = [SKAction moveToY:self.size.height + 70 duration:0.5];

    [bgTopBar runAction:hideTopBarView];
    [heart runAction:hideTopBarView];
    [self.numberHeartLabel runAction:hideTopBarView];
    [topBarInscription runAction:hideTopBarView];
    
}

-(void)decrementLifesFromView
{

    /*
    SKAction *move1 = [SKAction moveBy:CGVectorMake(6, 15) duration:0.6];
    SKAction *move2 = [SKAction moveBy:CGVectorMake(120, -250) duration:0.8];
    SKAction *move3 = [SKAction rotateByAngle:200 duration:0.5];
    SKAction *move4 = [SKAction fadeOutWithDuration:0.5];
    SKAction *removeNode = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[move1, move2, move3, move4, removeNode]];
    */
    //SKAction *move1 = [SKAction scaleBy:2 duration:0.2];
    //SKAction *move2 = [SKAction scaleBy:-2 duration:0.2];
    /*SKAction *move3 = [SKAction rotateByAngle:200 duration:0.5];
    SKAction *move4 = [SKAction fadeOutWithDuration:0.5];
    SKAction *removeNode = [SKAction removeFromParent];
    */
    //SKAction *sequence = [SKAction sequence:@[move1, move2, move1, move2, move1]];
    
    /*[heart runAction:sequence completion:^{
        self.numberHeart--;
        self.numberHeartLabel.text = [[NSString alloc] initWithFormat:@"%d",self.numberHeart];
        
        // decrement Live into file plist
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pListPath= [documentsDirectory stringByAppendingPathComponent:@"lives.plist"];
        
        NSMutableDictionary *lives = [NSMutableDictionary dictionaryWithContentsOfFile:pListPath];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ( pListPath )
        {
            if ([manager isWritableFileAtPath:pListPath])
            {
                [lives setObject:[[NSString alloc] initWithFormat:@"%d",self.numberHeart] forKey:@"numberHeart"];
                [lives writeToFile:pListPath atomically:YES];
            }
        }

    }];*/
    
}


-(void)displayGameWin:(void (^)(void))completed
{

    bgScenePaused = [SKSpriteNode spriteNodeWithImageNamed:@"bgPause.png"];
    bgScenePaused.position = CGPointMake(bgScenePaused.size.width/2, bgScenePaused.size.height/2);
    bgScenePaused.name = @"bgPause";
    [bgScenePaused setUserInteractionEnabled:YES];
    [bgScenePaused setZPosition:2];
    [self addChild:bgScenePaused];
    
    bgPopinLevels = [SKSpriteNode spriteNodeWithImageNamed:@"popin.png"];
    bgPopinLevels.position = CGPointMake(self.size.width/2 , self.size.height/2 );
    bgPopinLevels.name = @"bgSceneLevels";
    bgPopinLevels.alpha = -2;
    [bgPopinLevels setUserInteractionEnabled:YES];
    [bgPopinLevels setZPosition:2];
    [self addChild:bgPopinLevels];
    
    logoLevelWon = [SKSpriteNode spriteNodeWithImageNamed:@"level-won.png"];
    logoLevelWon.position = CGPointMake(self.size.width/2 , self.size.height/2 + 120 );
    logoLevelWon.name = @"logoLevelWon";
    [logoLevelWon setUserInteractionEnabled:YES];
    [logoLevelWon setZPosition:2];
    [self addChild:logoLevelWon];
    
    buttonClosePopinLevels = [SKSpriteNode spriteNodeWithImageNamed:@"close-popin.png"];
    buttonClosePopinLevels.position = CGPointMake(self.size.width/2 + bgPopinLevels.size.width/2 - buttonClosePopinLevels.size.width/2 - 3 , self.size.height/2 + bgPopinLevels.size.height/2 - buttonClosePopinLevels.size.height/2 + 2);
    buttonClosePopinLevels.name = @"closePopin";
    [buttonClosePopinLevels setZPosition:2];
    buttonClosePopinLevels.alpha = -2;
    [self addChild:buttonClosePopinLevels];
    
    SKLabelNode *NextLevelMessage1 = [[SKLabelNode alloc] init];
    NextLevelMessage1.text = @"هنيئاً، قد ربحت التحدي !";
    NextLevelMessage1.fontSize = 27;
    NextLevelMessage1.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    NextLevelMessage1.position = CGPointMake(self.size.width/2 , -50);
    [NextLevelMessage1 setZPosition:2];
    [NextLevelMessage1 setUserInteractionEnabled:YES];
    [self addChild:NextLevelMessage1];
    
    SKLabelNode *NextLevelMessage2 = [[SKLabelNode alloc] init];
    NextLevelMessage2.text = @".تم فتح المستوى الموالي";
    NextLevelMessage2.fontSize = 27;
    NextLevelMessage2.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    NextLevelMessage2.position = CGPointMake(self.size.width/2 , -50);
    [NextLevelMessage2 setZPosition:2];
    [NextLevelMessage2 setUserInteractionEnabled:YES];
    [self addChild:NextLevelMessage2];

    NextLevel = [SKSpriteNode spriteNodeWithImageNamed:@"nextLevel.png"];
    NextLevel.position = CGPointMake(self.size.width/2, -50);
    NextLevel.name = @"nextLevel";
    [NextLevel setZPosition:2];
    [self addChild:NextLevel];
    
    SKAction *display =  [SKAction moveToY:self.size.height/2 -40 duration:0.3];
    SKAction *displayNextMessage1 =  [SKAction moveToY:self.size.height/2 +20 duration:0.3];
    SKAction *displayNextMessage2 =  [SKAction moveToY:self.size.height/2 -20 duration:0.3];
    SKAction *displayButtonNext =  [SKAction moveToY:self.size.height/2 -60 duration:0.3];

    [bgPopinLevels runAction:[SKAction fadeInWithDuration:0.3] completion:^{
        
        if(optionVolume){
            [self initAudioWinPlayer:@"winLevel"];
            [_audioBackgroundPlayer stop];
            [_audioWinPlayer play];
        }
        
        // Add Levels of the current step
        [buttonClosePopinLevels runAction:[SKAction fadeInWithDuration:1] completion:^{
            if (completed) {
                completed();
            }
        }];
    }];
    [logoLevelWon runAction:[SKAction fadeInWithDuration:0.3]];
    [bgButtonPause runAction:display];
    [NextLevelMessage1 runAction:displayNextMessage1];
    [NextLevelMessage2 runAction:displayNextMessage2];
    [NextLevel runAction:displayButtonNext];
 
}


-(void)displayPauseView:(void (^)(void))completed {
    
    bgScenePaused = [SKSpriteNode spriteNodeWithImageNamed:@"bgPause.png"];
    bgScenePaused.position = CGPointMake(bgScenePaused.size.width/2, bgScenePaused.size.height/2);
    bgScenePaused.name = @"bgPause";
    [bgScenePaused setUserInteractionEnabled:YES];
    [bgScenePaused setZPosition:2];
    [self addChild:bgScenePaused];
    
    bgButtonPause = [SKSpriteNode spriteNodeWithImageNamed:@"bg-button-pause"];
    bgButtonPause.position = CGPointMake(self.size.width/2, -50);
    bgButtonPause.name = @"bgButtonPause";
    [bgButtonPause setUserInteractionEnabled:YES];
    [bgButtonPause setZPosition:2];
    [self addChild:bgButtonPause];
    
    buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
    buttonPlay.position = CGPointMake(self.size.width/2 - 105, -50);
    buttonPlay.name = @"play";
    [buttonPlay setZPosition:2];
    [self addChild:buttonPlay];
    
    buttonRePlay = [SKSpriteNode spriteNodeWithImageNamed:@"replay"];
    buttonRePlay.position = CGPointMake(self.size.width/2 - 35, -50);
    if ( ! replayAcived )
        buttonRePlay.name = @"play";
    else
        buttonRePlay.name = @"replay";
    [buttonRePlay setZPosition:2];
    [self addChild:buttonRePlay];
    
    buttonExit = [SKSpriteNode spriteNodeWithImageNamed:@"exit.png"];
    buttonExit.position = CGPointMake(self.size.width/2 + 40, -50);
    buttonExit.name = @"exit";
    [buttonExit setZPosition:2];
    [self addChild:buttonExit];
    
    
    if ( optionVolume ) {
        volume = [SKSpriteNode spriteNodeWithImageNamed:@"volume"];
    }else{
        volume = [SKSpriteNode spriteNodeWithImageNamed:@"volume-disabled"];
    }    
    
    volume.position = CGPointMake(self.size.width/2 + 110, -50);
    volume.name = @"volume";
    [volume setZPosition:2];
    [self addChild:volume];
    
    novolume = [SKSpriteNode spriteNodeWithImageNamed:@"novolume.png"];
    novolume.position = CGPointMake(self.size.width/2 + 125, - 70);
    novolume.name = @"novolume";
    novolume.hidden = optionVolume;
    [novolume setZPosition:2];
    [self addChild:novolume];
    
    SKAction *display =  [SKAction moveToY:self.size.height/2 duration:0.3];
    SKAction *displayNoVolume =  [SKAction moveToY:self.size.height/2 -15 duration:0.3];
    SKAction *wait = [SKAction waitForDuration:0.2];
    
    SKAction *sequencePlay = [SKAction sequence:@[display, wait]];
    
    [bgButtonPause runAction:display];
    [buttonExit runAction:display];
    [buttonRePlay runAction:display];
    [volume runAction:display];
    [novolume runAction:displayNoVolume];
    
    [buttonPlay runAction:sequencePlay completion:^{
        // function after complete
        if (completed) completed();
    }];
}


-(void)hidePauseView
{
    SKAction *hide = [SKAction moveToY:self.size.height +300 duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[hide, remove]];
    
    [bgButtonPause runAction:sequence];
    [buttonExit runAction:sequence];
    [buttonRePlay runAction:sequence];
    [volume runAction:sequence];
    [novolume runAction:sequence];

    [buttonPlay runAction:sequence completion:^{
        [bgScenePaused removeFromParent];
    }];
    
}


-(void)displayGameOver:(void (^)(void))completed
{
    bgScenePaused = [SKSpriteNode spriteNodeWithImageNamed:@"bgPause.png"];
    bgScenePaused.position = CGPointMake(bgScenePaused.size.width/2, bgScenePaused.size.height/2);
    bgScenePaused.name = @"bgPause";
    [bgScenePaused setUserInteractionEnabled:YES];
    [bgScenePaused setZPosition:2];
    [self addChild:bgScenePaused];
    
    bgPopinLevels = [SKSpriteNode spriteNodeWithImageNamed:@"popin.png"];
    bgPopinLevels.position = CGPointMake(self.size.width/2 , self.size.height/2 );
    bgPopinLevels.name = @"bgSceneLevels";
    bgPopinLevels.alpha = -2;
    [bgPopinLevels setUserInteractionEnabled:YES];
    [bgPopinLevels setZPosition:2];
    [self addChild:bgPopinLevels];
    
    logoLevelWon = [SKSpriteNode spriteNodeWithImageNamed:@"level-lose.png"];
    logoLevelWon.position = CGPointMake(self.size.width/2 , self.size.height/2 +120 );
    logoLevelWon.name = @"logoLevelWon";
    [logoLevelWon setUserInteractionEnabled:YES];
    [logoLevelWon setZPosition:2];
    [self addChild:logoLevelWon];
    
    buttonClosePopinLevels = [SKSpriteNode spriteNodeWithImageNamed:@"close-popin.png"];
    buttonClosePopinLevels.position = CGPointMake(self.size.width/2 + bgPopinLevels.size.width/2 - buttonClosePopinLevels.size.width/2 - 3 , self.size.height/2 + bgPopinLevels.size.height/2 - buttonClosePopinLevels.size.height/2 + 2);
    buttonClosePopinLevels.name = @"closePopinGameOver";
    [buttonClosePopinLevels setZPosition:2];
    buttonClosePopinLevels.alpha = -2;
    [self addChild:buttonClosePopinLevels];
    
    GameOverMessage1 = [[SKLabelNode alloc] init];
    GameOverMessage1.text = @"لقد خسرت التحدي";
    GameOverMessage1.fontSize = 27;
    GameOverMessage1.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    GameOverMessage1.position = CGPointMake(self.size.width/2 , -50);
    [GameOverMessage1 setZPosition:2];
    [GameOverMessage1 setUserInteractionEnabled:YES];
    [self addChild:GameOverMessage1];
    
    GameOverMessage2 = [[SKLabelNode alloc] init];
    GameOverMessage2.text = @"حاول مجدداً";
    GameOverMessage2.fontSize = 27;
    GameOverMessage2.fontColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    GameOverMessage2.position = CGPointMake(self.size.width/2 , -50);
    [GameOverMessage2 setZPosition:2];
    [GameOverMessage2 setUserInteractionEnabled:YES];
    [self addChild:GameOverMessage2];
    
    buttonRePlay = [SKSpriteNode spriteNodeWithImageNamed:@"replay.png"];
    buttonRePlay.position = CGPointMake(self.size.width/2 - 35, -50);
    if ( ! replayAcived )
        buttonRePlay.name = @"playGameOver";
    else
        buttonRePlay.name = @"replayGameOver";
    [buttonRePlay setZPosition:2];
    [self addChild:buttonRePlay];
    
    buttonExit = [SKSpriteNode spriteNodeWithImageNamed:@"exit.png"];
    buttonExit.position = CGPointMake(self.size.width/2 + 40, -50);
    buttonExit.name = @"exitGameOver";
    [buttonExit setZPosition:2];
    [self addChild:buttonExit];
    
    SKAction *display =  [SKAction moveToY:self.size.height/2 -40 duration:0.3];
    SKAction *displayNextMessage1 =  [SKAction moveToY:self.size.height/2 +20 duration:0.3];
    SKAction *displayNextMessage2 =  [SKAction moveToY:self.size.height/2 -20 duration:0.3];
    SKAction *displayButtonNext =  [SKAction moveToY:self.size.height/2 -60 duration:0.3];
    
    [bgPopinLevels runAction:[SKAction fadeInWithDuration:0.3] completion:^{
        // Add Levels of the current step
        [buttonClosePopinLevels runAction:[SKAction fadeInWithDuration:0.1] completion:^{
            if (completed) {
                completed();
            }
        }];
    }];
    [logoLevelWon runAction:[SKAction fadeInWithDuration:0.3]];
    [bgButtonPause runAction:display];
    [GameOverMessage1 runAction:displayNextMessage1];
    [GameOverMessage2 runAction:displayNextMessage2];
    [buttonRePlay runAction:displayButtonNext];
    [buttonExit runAction:displayButtonNext];

}


-(void)hideGameOverView
{
    SKAction *hide = [SKAction moveToY:self.size.height +300 duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[hide, remove]];
    
    [bgButtonPause runAction:sequence];
    [buttonExit runAction:sequence];
    [bgPopinLevels runAction:sequence];
    [logoLevelWon runAction:sequence];
    [buttonClosePopinLevels runAction:sequence];
    [GameOverMessage1 runAction:sequence];
    [GameOverMessage2 runAction:sequence];
    
    [buttonRePlay runAction:sequence completion:^{
        [bgScenePaused removeFromParent];
    }];
}


-(void)hidePauseViewAndExitGame
{
    [self hidePauseView];
    [self displayExitGameView];
}

-(void)hideGameOverViewAndExitGame
{
    [self hideGameOverView];
    [self displayExitGameView];
}


-(void)displayExitGameView
{
    [self deleteAllLetters];
    [self hideTopBarView];
    [self hideWordView];
    
    SKAction *wait = [SKAction waitForDuration:0.5];
 
    [self runAction:wait completion:^{
        self.paused = true;
        SKTransition *reveal = [SKTransition fadeWithColor:[UIColor darkGrayColor] duration:0.5];
        
        //SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
        
        
        //SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:0.5];
        
        //SKTransition *reveal = [SKTransition doorwayWithDuration:0.5];

        reveal.pausesIncomingScene = YES;
        SKScene * gameLevels = [[LETGameLevels alloc] initWithSize:self.size];
        
        [self.view presentScene:gameLevels transition:reveal];
        
        stopAddLetter = NO;
    }];
    
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

-(void)displayWaitHavingLife
{
    bgScenePaused = [SKSpriteNode spriteNodeWithImageNamed:@"bgPause.png"];
    bgScenePaused.position = CGPointMake(bgScenePaused.size.width/2, bgScenePaused.size.height/2);
    bgScenePaused.name = @"bgPause";
    [bgScenePaused setUserInteractionEnabled:YES];
    [self addChild:bgScenePaused];
    
    SKLabelNode *waitHavingLivesLabel = [[SKLabelNode alloc] init];
    waitHavingLivesLabel.text = @"waiting for Having a lives";
    waitHavingLivesLabel.fontSize = 22;
    waitHavingLivesLabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    waitHavingLivesLabel.position = CGPointMake(self.size.width/2 , self.size.height/2 + 30);
    [self addChild:waitHavingLivesLabel];
    
    buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"exit.png"];
    buttonPlay.position = CGPointMake(self.size.width/2, self.size.height/2);
    buttonPlay.name = @"exit";
    [self addChild:buttonPlay];
    
}

#pragma mark -
#pragma mark function to administrate touch events


-(int)getOptionVolume
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pListPath= [documentsDirectory stringByAppendingPathComponent:@"lives.plist"];
    
    NSMutableDictionary *lives = [NSMutableDictionary dictionaryWithContentsOfFile:pListPath];
    
    return [[lives objectForKey:@"volume"] intValue];
    
}

#pragma mark -
#pragma mark functions about create/remove/animate letters

- (void)addLetter:(int) positionColumn
{
    
    LETColumn *selectedColumn = [self.arrayColumns objectAtIndex:positionColumn];
    
    // Get letter to add
    unichar letterToAdd = [self getLetterToAdd];
    NSString *nameImage = [[NSString alloc] initWithFormat:@"%d.png",letterToAdd];
    
    // Create sprite : letter
    SKSpriteNode * letter = [SKSpriteNode spriteNodeWithImageNamed:nameImage];
    letter.name = [[NSString alloc] initWithCharacters:&letterToAdd
                                                length:1];
    
    // Determine where to spawn the letter : X and Y
    int actualX = ( selectedColumn.position * 53) - letter.size.width/2 ;
    int actualY = self.frame.size.height;
    
    // Create the letter
    letter.position = CGPointMake(actualX, actualY);
    
    [self addChild:letter];
    
    // Determine target position
    int targetX = actualX;
    int targetY = (selectedColumn.nbrElement == 0) ? 20 + letter.size.height : 20 + (letter.size.height * (selectedColumn.nbrElement + 1));
    
    // increment nbrElement in Selected column
    selectedColumn.nbrElement += 1;
    [selectedColumn.letters addObject:letter];
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(targetX, targetY) duration:self.speedLetter];
    positionColumn = [self getPositionColumn];
    [letter runAction:actionMove completion:^{
        
        if(optionVolume){
            [self initAudioPlayer:@"letterDown"];
            [_audioPlayer play];
        }
        
        // test if all column are full, then the game is over
        if ( [[self.arrayColumns objectAtIndex:0] isFull] ) {
            
            if(optionVolume){
                [self initAudioPlayer:@"gameOver"];
                [_audioBackgroundPlayer stop];
                [_audioPlayer play];
            }
            
            // decrement lives for user
            [self decrementLifesFromView];
            
            [self deleteAllLetters:^{
                
                [self displayGameOver:^{
                    [self setPaused:YES];
                }];
                
            }];

        }else if( ! stopAddLetter ){
            [self addLetter:positionColumn];
        }
    } ];
    
}


-(void)deleteAllLetters
{
    for (LETColumn *column in self.arrayColumns) {
        for (SKSpriteNode *letter in column.letters) {
            letter.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:letter.size];
            [letter setZPosition:0];
            letter.physicsBody.angularDamping = 60;
            letter.physicsBody.angularVelocity = 50;
        }
    }
}


-(void)deleteAllLetters:(void (^)(void))completed
{
    [self deleteAllLetters];
    
    [self runAction:[SKAction waitForDuration:1] completion:^{
        if (completed) {
            completed();
        }
    }];
}


-(unichar)getLetterToAdd
{
    // Get More Word to pu in array words temp
    if ( [self.arrayWordsTemp count] == 0) {
        [self getMoreInArrayWordTemp];
    }
    
    int indexWord = arc4random_uniform((uint32_t)[self.arrayWordsTemp count]);
    NSString *word = [self.arrayWordsTemp objectAtIndex:indexWord];
    
    int indexLetter = arc4random_uniform((uint32_t) word.length);
    
    // remove letter from Word
    NSString *newCutWord = [word stringByReplacingCharactersInRange:NSMakeRange(indexLetter, 1) withString:@""];
    if ( [newCutWord isEqualToString:@""] ) {
        
        [self.arrayWordsTemp removeObjectAtIndex:indexWord];
    }
    else
    {
        [self.arrayWordsTemp replaceObjectAtIndex:indexWord withObject:newCutWord];
    }
    
    return [word characterAtIndex:indexLetter];
}


-(int)getPositionColumn
{
    int positionColumn = 0;
    int nbrletter = [[self.arrayColumns objectAtIndex:0] nbrElement];
    for (LETColumn *column in self.arrayColumns) {
        if( column.nbrElement <= nbrletter ){
            positionColumn = column.position - 1;
            nbrletter = column.nbrElement;
        }
    }
    return positionColumn;
}


-(void)getListWords
{
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:[self.level objectForKey:@"file"]
                                                          ofType:@"plist"];
    self.arrayWords = [NSMutableArray arrayWithContentsOfFile:pListPath];
    self.arrayWordsValide = [NSMutableArray arrayWithContentsOfFile:pListPath];
    
}


-(void)getMoreInArrayWordTemp
{
    int indexWordList;
    while ([self.arrayWordsTemp count] < 4) {
        indexWordList = arc4random_uniform((uint32_t) [self.arrayWords count]);
        [self.arrayWordsTemp addObject:[self.arrayWords objectAtIndex:indexWordList]];
        [self.arrayWords removeObjectAtIndex:indexWordList];
    };
}

#pragma mark -
#pragma mark functions to handle event on user's actions/touches

-(void)validateWord
{
    BOOL valideWord = [self.arrayWordsValide containsObject:self.theWord.text] ? true : false;
    int indexValideWord = (int)[self.arrayWordsValide indexOfObject:self.theWord.text];
    int targetScore = [[self.level objectForKey:@"targetScore"] intValue];

    self.theWord.text = @"";
    
    if ( valideWord ) {
        self.theScore.text = [[NSString alloc] initWithFormat:@"%i",([self.theScore.text intValue] + 1 ) ];
        [self.arrayWordsValide removeObjectAtIndex:indexValideWord];
        
        if(optionVolume){
            [self initAudioPlayer:@"valideWord"];
            [_audioPlayer play];
        }
        
        if( [self.theScore.text intValue] == targetScore )
        {
            [self displayGameWin:^{
                [self setPaused:TRUE];
            }];
            
        }
    }
    else
    {
        if(optionVolume){
            [self initAudioPlayer:@"wrongWord"];
            [_audioPlayer play];
        }
    }
    
    for (SKSpriteNode *letter in self.theWordNodes) {
        
        if( valideWord )
        {
            // Remove letter from Scene
            SKAction *zoom =       [SKAction scaleTo:0.0 duration:0.25];
            SKAction *fadeAway =   [SKAction fadeOutWithDuration:0.25];
            SKAction *removeNode = [SKAction removeFromParent];
            
            SKAction *sequence = [SKAction sequence:@[zoom, fadeAway, removeNode]];
            [letter runAction: sequence];
            
            int letterColumnPosition = ( letter.position.x + letter.size.width/2 ) / 53;
            LETColumn *selectedColumn = [self.arrayColumns objectAtIndex:letterColumnPosition];
            [selectedColumn removeLettersObject:letter];
            [buttonWord runAction:notSelected];
        }
        else
        {
            [letter runAction:notSelected];
            if( [[letter.userData objectForKey:@"unknowned"] isEqual:@YES] ){
                SKTexture *texture = [SKTexture textureWithImageNamed:@"unknowned.png"];
                letter.texture = texture;
            }
        }
        
    }
    [self.theWordNodes removeAllObjects];
}


-(void)startGame
{
    [self addLetter:nbrColumn-1];
}


-(void)pauseGame
{
    [self displayPauseView:^{
        [self setPaused:TRUE];
    }];
}


-(void)resumeGame
{
    [self hidePauseView];
    [self setPaused:FALSE];
}


-(void)replayGame
{
    stopAddLetter = TRUE;
    
    [self setPaused:FALSE];
    [self hidePauseView];
    [self deleteAllLetters];
    
    self.theScore.text = @"0";
    self.theWord.text = @"";
    
    [buttonPause runAction:[SKAction waitForDuration:1] completion:^{
        [self initFromScrach];
        [self displayInstructionAndStartGame];
    }];
}

-(void)replayGameOver
{
    [self hideGameOverView];
    
    [self setPaused:FALSE];
    stopAddLetter = TRUE;
    
    [self deleteAllLetters];
    
    self.theScore.text = @"0";
    self.theWord.text = @"";
    
    [buttonPause runAction:[SKAction waitForDuration:1] completion:^{
        [self initFromScrach];
        stopAddLetter = FALSE;
        [self displayInstructionAndStartGame];
    }];
}

-(void)exitGame
{
    stopAddLetter = YES;
    [self setPaused:FALSE];
    
    [self hidePauseViewAndExitGame];
    
}

-(void)exitGameOver
{
    stopAddLetter = YES;
    [self setPaused:FALSE];
    
    [self hideGameOverViewAndExitGame];
    
}


-(void)updateOptionVolume
{
    optionVolume = optionVolume ? FALSE : TRUE;
    novolume.hidden = optionVolume;
    
    if ( optionVolume ) {
        [volume setTexture:[SKTexture textureWithImageNamed:@"volume"]];
    }else{
        [volume setTexture:[SKTexture textureWithImageNamed:@"volume-disabled"]];
    }
    
    // update optionsvolumes to file lives
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pListPath= [documentsDirectory stringByAppendingPathComponent:@"lives.plist"];
    
    NSMutableDictionary *lives = [NSMutableDictionary dictionaryWithContentsOfFile:pListPath];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ( pListPath )
    {
        if ([manager isWritableFileAtPath:pListPath])
        {
            [lives setValue:[[NSString alloc] initWithFormat:@"%d", optionVolume] forKey:@"volume"];
            [lives writeToFile:pListPath atomically:YES];
        }
    }
}


-(void)waitHavingLive
{
    [self displayWaitHavingLife];
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

-(void)initAudioWinPlayer:(NSString*) file{
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], file];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    _audioWinPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}


#pragma mark -
#pragma mark functions to handle touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    if ([touchedNode.name isEqualToString:@"pause"])
    {
        [buttonPause setTexture:[SKTexture textureWithImageNamed:@"pause-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"play"])
    {
        [buttonPlay setTexture:[SKTexture textureWithImageNamed:@"play-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"replay"])
    {
        [buttonRePlay setTexture:[SKTexture textureWithImageNamed:@"replay-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"replayGameOver"])
    {
        [buttonRePlay setTexture:[SKTexture textureWithImageNamed:@"replay-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"exit"]  )
    {
        [buttonExit setTexture:[SKTexture textureWithImageNamed:@"exit-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"exitGameOver"] )
    {
        [buttonExit setTexture:[SKTexture textureWithImageNamed:@"exit-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"nextLevel"])
    {
       [NextLevel setTexture:[SKTexture textureWithImageNamed:@"nextLevel-event"]];
    }
    
    [self selectLetter:positionInScene];
}

-(void)selectLetter:(CGPoint)touchLocation {
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if ( [touchedNode.name isEqualToString:@"validate"] || [touchedNode.name isEqualToString:@"validateBG"] || [touchedNode.name isEqualToString:@"word"] )
    {
        [self validateWord];
    }
    else if ([touchedNode.name isEqualToString:@"pause"])
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioBackgroundPlayer stop];
            [_audioPlayer play];
        }
        
        [self pauseGame];
    }
    else if ([touchedNode.name isEqualToString:@"play"])
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioBackgroundPlayer play];
            [_audioPlayer play];
        }
        
        [buttonPause setTexture:[SKTexture textureWithImageNamed:@"pause"]];
        [self resumeGame];
    }
    else if ([touchedNode.name isEqualToString:@"replay"])
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioBackgroundPlayer play];
            [_audioPlayer play];
        }
        
        [buttonPause setTexture:[SKTexture textureWithImageNamed:@"pause"]];
        [self replayGame];
    }
    else if ([touchedNode.name isEqualToString:@"replayGameOver"])
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioBackgroundPlayer play];
            [_audioPlayer play];
        }
        
        [self replayGameOver];
    }
    else if ([touchedNode.name isEqualToString:@"exit"] || [touchedNode.name isEqualToString:@"closePopin"] )
    {
        if(optionVolume){
            [self initAudioPlayer:@"exitGame"];
            [_audioPlayer play];
        }
        
        [self exitGame];
    }
    else if ([touchedNode.name isEqualToString:@"exitGameOver"] || [touchedNode.name isEqualToString:@"closePopinGameOver"] )
    {
        if(optionVolume){
            [self initAudioPlayer:@"exitGame"];
            [_audioPlayer play];
        }
        
        [self exitGameOver];
    }
    else if ([touchedNode.name isEqualToString:@"volume"] || [touchedNode.name isEqualToString:@"novolume"])
    {
        [self updateOptionVolume];
    }
    else if ([touchedNode.name isEqualToString:@"nextLevel"])
    {
        if(optionVolume){
            [self initAudioPlayer:@"nextLevel"];
            [_audioPlayer play];
        }
        
        SKScene * gameLevels =  [[LETGameLevels alloc] initWithSizeAndDeblockNextLevel:self.size  nextLevel:([[self.level objectForKey:@"index"] intValue] +1)];
        [self.view presentScene:gameLevels transition:[SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1]];
    }
    else
    {

        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
        }
        
        if ( ![self.theWordNodes containsObject:touchedNode] ) {
        
            [self.theWordNodes addObject:touchedNode];
            if(self.theWord.text == NULL )
                self.theWord.text = [[NSString alloc] initWithFormat:@"%@",touchedNode.name];
            else
                self.theWord.text = [[NSString alloc] initWithFormat:@"%@%@",self.theWord.text,touchedNode.name];

            [touchedNode runAction:selected];
            
             if( [[touchedNode.userData objectForKey:@"unknowned"] isEqual:@YES] ){
                 NSString *nameImage = [[NSString alloc] initWithFormat:@"%@", [touchedNode.userData objectForKey:@"original"] ];
                 SKTexture *texture = [SKTexture textureWithImageNamed:nameImage];
                 touchedNode.texture = texture;
             }
        
        }else if ( [touchedNode isEqual:[self.theWordNodes lastObject]] ){
        
            [self.theWordNodes removeLastObject];
            self.theWord.text = [self.theWord.text substringToIndex:[self.theWord.text length] - 1];
            [touchedNode runAction:notSelected];
            
            if( [[touchedNode.userData objectForKey:@"unknowned"] isEqual:@YES] ){
                SKTexture *texture = [SKTexture textureWithImageNamed:@"unknowned.png"];
                touchedNode.texture = texture;
            }
            
        }
        
        if ( [self.arrayWordsValide containsObject:self.theWord.text] ) {
            [buttonWord runAction:valideWordBg];
        }
        else
        {
            [buttonWord runAction:notSelected];
        }

    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    if ([touchedNode.name isEqualToString:@"play"])
    {
        [buttonPlay setTexture:[SKTexture textureWithImageNamed:@"play"]];
    }
    else if ([touchedNode.name isEqualToString:@"replay"])
    {
        [buttonRePlay setTexture:[SKTexture textureWithImageNamed:@"replay"]];
    }
    else if ([touchedNode.name isEqualToString:@"replayGameOver"])
    {
        [buttonRePlay setTexture:[SKTexture textureWithImageNamed:@"replay"]];
    }
    else if ([touchedNode.name isEqualToString:@"exit"]  )
    {
        [buttonExit setTexture:[SKTexture textureWithImageNamed:@"exit"]];
    }
    else if ([touchedNode.name isEqualToString:@"exitGameOver"] )
    {
        [buttonExit setTexture:[SKTexture textureWithImageNamed:@"exit"]];
    }
    else if ([touchedNode.name isEqualToString:@"nextLevel"])
    {
        [NextLevel setTexture:[SKTexture textureWithImageNamed:@"nextLevel"]];
    }
    
}

#pragma mark -

@end

