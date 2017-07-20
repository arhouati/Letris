//
//  LETColumn.h
//  Lettris Arabic
//
//  Created by Abdelkader on 12/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface LETColumn : NSObject

@property (nonatomic, retain) NSMutableArray *letters;
@property (nonatomic) int position;
@property (nonatomic) int nbrElement;
@property (nonatomic) int maxElementByColumn;


-(id) initWithPositionAndNbrElement:(int)postion nbrElement:(int)nbrElement;
-(id) initWithPositionAndNbrElementAndMaxLetter:(int)postion nbrElement:(int)nbrElement  maxLetter:(int)maxLetter;
-(void)removeLettersObject:(SKSpriteNode *)letter;
-(BOOL) isFull;

@end
