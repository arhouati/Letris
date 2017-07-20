//
//  LETGame2.m
//  ولد، بنت، جماد...
//
//  Created by Abdelkader Rhouati on 7/4/17.
//  Copyright © 2017 ibda3. All rights reserved.
//

#import "LETGame2.h"
#import "LETColumn.h"
#import "LETGameLevels.h"
#import <Foundation/Foundation.h>


@implementation LETGame2

#pragma mark functions about create/remove/animate letters

- (void)addLetter:(int) positionColumn
{
    
    LETColumn *selectedColumn = [self.arrayColumns objectAtIndex:positionColumn];
    
    // Get letter to add
    unichar letterToAdd = [self getLetterToAdd];
    NSString *nameImage = [[NSString alloc] initWithFormat:@"%d.png",letterToAdd];
    
    // Create sprite : letter
    __block SKSpriteNode * letter = [SKSpriteNode spriteNodeWithImageNamed:nameImage];
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
        
        int index = [self randomNumberBetween:0 maxNumber:5];
        if( index == 0 || index == 2 ){
            SKTexture *texture = [SKTexture textureWithImageNamed:@"unknowned.png"];
            letter.texture = texture;
            letter.userData = [[NSMutableDictionary alloc] init];
            [letter.userData setObject:@YES forKey:@"unknowned"];
        }else{
            letter.userData = [[NSMutableDictionary alloc] init];
            [letter.userData setObject:@NO forKey:@"unknowned"];
        }
        
        [letter.userData setObject:nameImage forKey:@"original"];
        
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

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform(max - min + 1);
}

@end
