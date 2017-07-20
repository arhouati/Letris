//
//  LETGameStart.m
//  Lettris Arabic
//
//  Created by Abdelkader on 14/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import "LETGameStart.h"
#import "LETGameLevels.h"

#import "LETColumn.h"

#import <AVFoundation/AVFoundation.h>

static AVAudioPlayer *_audioPlayer;
static AVAudioPlayer *_audioBackgroundPlayer;

// objects used to add letters introduction
static NSMutableArray *arrayColumns;
static NSArray *lettersCode;

// Buttons
static SKSpriteNode *buttonPlay;
static SKSpriteNode *buttonAudio;
static SKSpriteNode *novolume;
static SKSpriteNode *buttonHowTo;

// Name Game
static SKSpriteNode *nameGame;

// Boolean
static Boolean optionVolume;

@implementation LETGameStart

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        // create Writable file levels
        NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"levels"
                                                              ofType:@"plist"];
        NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"levels.plist"];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ( ![manager fileExistsAtPath:writableDBPath] )
        {
            [manager copyItemAtPath:pListPath toPath:writableDBPath error:nil];
        }
        
        // create Writable file Lives
        NSString *pListPathLives = [[NSBundle mainBundle] pathForResource:@"lives"
                                                              ofType:@"plist"];
        
        NSString *writableDBPathLives = [documentsDirectory stringByAppendingPathComponent:@"lives.plist"];
        
        if ( ![manager fileExistsAtPath:writableDBPathLives] )
        {
            [manager copyItemAtPath:pListPathLives toPath:writableDBPathLives error:nil];
        }
        
        // create Writable file Lives
        NSString *pListPathSteps = [[NSBundle mainBundle] pathForResource:@"steps"
                                                                   ofType:@"plist"];
        
        NSString *writableDBPathSteps = [documentsDirectory stringByAppendingPathComponent:@"steps.plist"];
        
        if ( ![manager fileExistsAtPath:writableDBPathSteps] )
        {
            [manager copyItemAtPath:pListPathSteps toPath:writableDBPathSteps error:nil];
        }
        
        // GET OptionVolume from lives file
        optionVolume = [self getOptionVolume];

        // Set Background Scene
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg-scene-game"];
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.name = @"BACKGROUND";
        [background setUserInteractionEnabled:YES];
        [self addChild:background];
        
        //[self displaylettersIntroduction];
        [self displayNameGame];
        [self displayIadBanner];
        
    }
    return self;
}

#pragma mark -
#pragma mark fonctions add graphics components to scene levels

-(void)displayNameGame
{
    
    nameGame = [SKSpriteNode spriteNodeWithImageNamed:@"name-game"];
    nameGame.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) +70);
    nameGame.name = @"nameGame";
    nameGame.alpha = -2;
    [nameGame setUserInteractionEnabled:YES];
    [self addChild:nameGame];
    
    [nameGame runAction:[SKAction fadeInWithDuration:1] completion:^{
        
        if(optionVolume){
            [self initAudioPlayer:@"displayButtonStart"];
            [_audioPlayer play];
        }
        
        [self  displayButtons];
        [self displayButtonsOptions];
    }];
}


-(void)hideNameGame:(void (^)(void))completed
{
    [nameGame runAction:[SKAction fadeOutWithDuration:0.9] completion:^{
        if(completed) completed();
    }];
}

-(void)displayButtons
{
    
    if(optionVolume){
        [self initAudioBackgroundPlayer:@"displayButtonPlay"];
        [_audioBackgroundPlayer play];
    }
    
    buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"start-game"];
    buttonPlay.position = CGPointMake(self.size.width/2, - 50);
    buttonPlay.name = @"play";
    [self addChild:buttonPlay];
    
    SKAction *move1 = [SKAction moveToY:self.size.height/2 - 60 duration:0.5];
    SKAction *move2 = [SKAction moveToY:self.size.height/2 - 60 duration:0.2];
    SKAction *sequence = [SKAction sequence:@[move1, move2]];
    
    [buttonPlay runAction:sequence];

}

-(void)hideButtons
{
    
    SKAction *move1 = [SKAction moveByX:0 y:5 duration:0.2];
    SKAction *move2 = [SKAction moveToY:-50 duration:0.5];
    SKAction *sequence = [SKAction sequence:@[move1, move2]];
    
    [buttonPlay runAction:sequence];
    
}

-(void)displayButtonsOptions
{
    
    if(optionVolume){
        [self initAudioPlayer:@"displayButtonStart"];
        [_audioPlayer play];
    }
    
    if ( optionVolume ) {
        buttonAudio = [SKSpriteNode spriteNodeWithImageNamed:@"volume"];
    }else{
        buttonAudio = [SKSpriteNode spriteNodeWithImageNamed:@"volume-disabled"];
    }
    
    buttonAudio.position = CGPointMake(self.size.width -45, self.size.height -40);
    buttonAudio.name = @"volume";
    [self addChild:buttonAudio];
    
    novolume = [SKSpriteNode spriteNodeWithImageNamed:@"novolume.png"];
    novolume.position = CGPointMake(buttonAudio.position.x + 10, buttonAudio.position.y -10);
    novolume.name = @"novolume";
    novolume.hidden = optionVolume;
    [novolume setZPosition:2];
    [self addChild:novolume];
    
    buttonHowTo = [SKSpriteNode spriteNodeWithImageNamed:@"howto"];
    buttonHowTo.position = CGPointMake(45, self.size.height -40);
    buttonHowTo.name = @"howto";
    [self addChild:buttonHowTo];
    
    [buttonHowTo runAction:[SKAction fadeInWithDuration:0.1]];
    [buttonPlay runAction:[SKAction fadeInWithDuration:0.1]];
    [novolume runAction:[SKAction fadeInWithDuration:0.1]];

    
    
}

-(void)hideButtonsOptions
{
    [buttonHowTo runAction:[SKAction fadeOutWithDuration:0.1]];
    [buttonAudio runAction:[SKAction fadeOutWithDuration:0.1]];
    [novolume runAction:[SKAction fadeOutWithDuration:0.1]];
}

-(void)displayIadBanner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayBanner"
                                                        object:self
                                                      userInfo:nil];
}

-(void)hideIadBanner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideBanner"
                                                        object:self
                                                      userInfo:nil];
}

-(void)displayHowtoView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayHowToView"
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

#pragma mark -
#pragma mark fonctions to add letters introductions

-(void)displaylettersIntroduction
{
    
    lettersCode = @[@"1575",@"1576",@"1577",@"1578",@"1579",@"1580",@"1581",@"1582",@"1582",@"1583",@"1584",@"1585",@"1586",@"1587",@"1588",@"1589",@"1590",@"1591",@"1592",@"1593",@"1594",@"1601",@"1602",@"1603",@"1604",@"1605",@"1606",@"1607",@"1608",@"1610"];
    
    // Initialize positions columns
    arrayColumns = [[NSMutableArray alloc] initWithObjects:[[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:1 nbrElement:0 maxLetter:9],
                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:2 nbrElement:0 maxLetter:9],
                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:3 nbrElement:0 maxLetter:9],
                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:4 nbrElement:0 maxLetter:9],
                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:5 nbrElement:0 maxLetter:9],
                    [[LETColumn alloc] initWithPositionAndNbrElementAndMaxLetter:6 nbrElement:0 maxLetter:9],
                    nil];
    
    
    [self addLetter:5];
    
    
}

- (void)addLetter:(int) positionColumn
{
    
    LETColumn *selectedColumn = [arrayColumns objectAtIndex:positionColumn];
    
    // Get letter to add
    NSString *letterToAdd = [self getLetterToAdd];
    NSString *nameImage = [[NSString alloc] initWithFormat:@"%@",letterToAdd];
    
    // Create sprite : letter
    SKSpriteNode * letter = [SKSpriteNode spriteNodeWithImageNamed:nameImage];
    [letter setUserInteractionEnabled:YES];
    
    // Determine where to spawn the letter : X and Y
    int actualX = ( selectedColumn.position * 53) - letter.size.width/2 ;
    int actualY = self.frame.size.height;
    
    // Create the letter
    letter.position = CGPointMake(actualX, actualY);
    
    [self addChild:letter];
    
    // Determine target position
    int targetX = actualX;
    int targetY = (selectedColumn.nbrElement == 0) ? letter.size.height -25 : (letter.size.height * (selectedColumn.nbrElement + 1)) -25;
    
    // increment nbrElement in Selected column
    selectedColumn.nbrElement += 1;
    [selectedColumn.letters addObject:letter];
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(targetX, targetY) duration:0];
    positionColumn = [self getPositionColumn];
    [letter runAction:actionMove completion:^{
        
        // test if all column are full, then the game is over
        if ( [[arrayColumns objectAtIndex:0] isFull] ) {

            [self deleteAllLetters];
            
            [self displayNameGame];

        }else
        {
            [self addLetter:positionColumn];
        }
    } ];
    
}

-(void)deleteAllLetters
{
    for (LETColumn *column in arrayColumns) {
        for (SKSpriteNode *letter in column.letters) {
            letter.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:letter.size];
            [letter setZPosition:0];
            letter.physicsBody.angularDamping = 60;
            letter.physicsBody.angularVelocity = 50;
        }
    }
}


-(NSString *)getLetterToAdd
{
    
    int indexletter = arc4random_uniform((uint32_t)[lettersCode count]);
    
    return [lettersCode objectAtIndex:indexletter];
}


-(int)getPositionColumn
{
    int positionColumn = 0;
    int nbrletter = [[arrayColumns objectAtIndex:0] nbrElement];
    for (LETColumn *column in arrayColumns) {
        if( column.nbrElement <= nbrletter ){
            positionColumn = column.position - 1;
            nbrletter = column.nbrElement;
        }
    }
    return positionColumn;
}

-(void)updateOptionVolume
{
    optionVolume = optionVolume ? FALSE: TRUE;
    novolume.hidden = optionVolume;
    
    if ( optionVolume ) {
        [buttonAudio setTexture:[SKTexture textureWithImageNamed:@"volume"]];
    }else{
        [buttonAudio setTexture:[SKTexture textureWithImageNamed:@"volume-disabled"]];
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
#pragma mark function to administrate touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    if ( [touchedNode.name isEqualToString:@"play"] ) {
        [buttonPlay setTexture:[SKTexture textureWithImageNamed:@"start-game-event"]];
    }
    else if ([touchedNode.name isEqualToString:@"howto"] )
    {
        [buttonHowTo setTexture:[SKTexture textureWithImageNamed:@"howto-event"]];
    }
    
    [self actionEvent:positionInScene];
}


-(void)actionEvent:(CGPoint)touchLocation {
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if ( [touchedNode.name isEqualToString:@"play"] ) {
        
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
        }
        
        [self hideButtons];
        [self hideButtonsOptions];
        [self hideIadBanner];
        [self hideNameGame:^{
            
            SKScene * gameLevels = [[LETGameLevels alloc] initWithSize:self.size];
            [self.view presentScene:gameLevels transition:[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:0]];
            
        }];
    }
    else if ([touchedNode.name isEqualToString:@"volume"] || [touchedNode.name isEqualToString:@"novolume"] )
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
        }
        [self updateOptionVolume];
        
    }
    else if ([touchedNode.name isEqualToString:@"howto"] )
    {
        if(optionVolume){
            [self initAudioPlayer:@"click"];
            [_audioPlayer play];
        }
        
        [self displayHowtoView];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    if ( [touchedNode.name isEqualToString:@"play"] ) {
        [buttonPlay setTexture:[SKTexture textureWithImageNamed:@"start-game"]];
    }
    else if ([touchedNode.name isEqualToString:@"howto"] )
    {
        [buttonHowTo setTexture:[SKTexture textureWithImageNamed:@"howto"]];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    if ( [touchedNode.name isEqualToString:@"play"] ) {
        [buttonPlay setTexture:[SKTexture textureWithImageNamed:@"start-game"]];
    }
    else if ([touchedNode.name isEqualToString:@"howto"] )
    {
        [buttonHowTo setTexture:[SKTexture textureWithImageNamed:@"howto"]];
    }

}

@end
