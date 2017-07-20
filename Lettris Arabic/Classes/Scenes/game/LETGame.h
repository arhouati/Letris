//
//  LETGame.h
//  Lettris Arabic
//
//  Created by Abdelkader on 12/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LETGame : SKScene {
    
    int nbrColumn;
    int maxLetterByColumn;
    
    AVAudioPlayer *_audioPlayer;
    AVAudioPlayer *_audioBackgroundPlayer;
    AVAudioPlayer *_audioWinPlayer;
    
    /* View Word Nodes */
    SKSpriteNode *bgButtonPause;
    SKSpriteNode *bgTopBar;
    SKSpriteNode *bgScenePaused;
    SKSpriteNode *logoLevelWon;
    SKSpriteNode *bgPopinLevels;
    SKSpriteNode *buttonClosePopinLevels;
    
    SKSpriteNode *buttonPause;
    SKSpriteNode *buttonExit;
    SKSpriteNode *buttonPlay;
    SKSpriteNode *buttonRePlay;
    SKSpriteNode *buttonWord;
    SKSpriteNode *NextLevel;
    
    SKSpriteNode *volume;
    SKSpriteNode *novolume;
    
    SKSpriteNode *heart;
    SKLabelNode *topBarInscription;
    
    SKLabelNode *GameOverMessage1;
    SKLabelNode *GameOverMessage2;
    
    /* Action */
    SKAction *notSelected;
    SKAction *selected;
    SKAction *valideWordBg;
    SKAction *buttonDesactived;
    
    /* Boolean */
    BOOL stopAddLetter;
    BOOL optionVolume;
    BOOL replayAcived;
}

@property (nonatomic,retain) NSMutableArray *arrayColumns;
@property (nonatomic,retain) NSMutableArray *arrayWords;
@property (nonatomic,retain) NSMutableArray *arrayWordsValide;
@property (nonatomic,retain) NSMutableArray *arrayWordsTemp;
@property (nonatomic,retain) NSMutableArray *theWordNodes;

@property (nonatomic,retain) SKLabelNode *theWord;
@property (nonatomic,retain) SKLabelNode *theScore;
@property (nonatomic,retain) SKLabelNode *instruction;
@property (nonatomic,retain) SKLabelNode *numberHeartLabel;

@property (nonatomic) int numberHeart;


// Level Game Properties
@property (nonatomic,retain) NSMutableDictionary *level;
@property (nonatomic) int speedLetter;
@property (nonatomic,retain) NSString *instrucionMessage;

-(id)initWithSize:(CGSize)size currentLevel:(NSMutableDictionary *)level;
-(void)initFromScrach;

-(void)displayInstructionAndStartGame;
-(void)displayWordView;
-(void)displayTopBarView;
-(void)hideTopBarView;
-(void)decrementLifesFromView;
-(void)displayGameWin:(void (^)(void))completed;
-(void)displayPauseView:(void (^)(void))completed;
-(void)hidePauseView;
-(void)displayGameOver:(void (^)(void))completed;
-(void)hideGameOverView;
-(void)hidePauseViewAndExitGame;
-(void)hideGameOverViewAndExitGame;
-(void)displayExitGameView;

-(int)getNumberLifes;
-(void)displayWaitHavingLife;

-(int)getOptionVolume;

- (void)addLetter:(int) positionColumn;
-(void)deleteAllLetters;
-(void)deleteAllLetters:(void (^)(void))completed;
-(unichar)getLetterToAdd;
-(int)getPositionColumn;
-(void)getListWords;
-(void)getMoreInArrayWordTemp;
-(void)validateWord;
-(void)startGame;
-(void)pauseGame;
-(void)resumeGame;
-(void)replayGame;
-(void)replayGameOver;
-(void)exitGame;
-(void)exitGameOver;
-(void)updateOptionVolume;
-(void)waitHavingLive;
-(void)initAudioPlayer:(NSString*) file;
-(void)initAudioBackgroundPlayer:(NSString*) file;
-(void)initAudioWinPlayer:(NSString*) file;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)selectLetter:(CGPoint)touchLocation;
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

