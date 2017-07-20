//
//  LETColumn.m
//  Lettris Arabic
//
//  Created by Abdelkader on 12/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import "LETColumn.h"

// max Letter in column


@implementation LETColumn

-(id) initWithPositionAndNbrElement:(int)postion nbrElement:(int)nbrElement
{
    self.letters = [[NSMutableArray alloc] init];
    self.position = postion;
    self.nbrElement = nbrElement;
    
    self.maxElementByColumn = 8;
    return self;
}

-(id) initWithPositionAndNbrElementAndMaxLetter:(int)postion nbrElement:(int)nbrElement  maxLetter:(int)maxLetter
{
    self.letters = [[NSMutableArray alloc] init];
    self.position = postion;
    self.nbrElement = nbrElement;
    
    self.maxElementByColumn = maxLetter;
    return self;

}


-(void)removeLettersObject:(SKSpriteNode *)letter
{
    SKSpriteNode *currentElement;
    self.nbrElement--;
    
    int targetY;
        
    [self.letters removeObject:letter];
    
    for (int i = 0; i < [self.letters count]; i++) {
        
        currentElement = [self.letters objectAtIndex:i];

        targetY = (i == 0) ? 20 + currentElement.size.height : 20 + (currentElement.size.height * (i + 1));
        
        SKAction * actionMove = [SKAction moveToY:targetY duration:1.0];
        [currentElement runAction:actionMove];
    }
}


-(BOOL) isFull
{
    if (self.nbrElement > self.maxElementByColumn)
    {
        return true;
    }
    else
    {
        return false;
    }
}


@end
