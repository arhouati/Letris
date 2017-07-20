//
//  LETGameLevels.h
//  Lettris Arabic
//
//  Created by Abdelkader on 22/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LETGameLevels : SKScene

@property (nonatomic,retain) NSMutableArray *levels;
@property (nonatomic,retain) NSMutableArray *steps;

@property (nonatomic,retain) NSMutableArray *stepsNodes;


@property (nonatomic,retain) SKLabelNode *numberHeartLabel;

@property (nonatomic) int numberHeart;


-(id)initWithSizeAndDeblockNextLevel:(CGSize)size  nextLevel:(int)indexNextLevel;


@end
