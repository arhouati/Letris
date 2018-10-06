//
//  LETHowToViewController.h
//  ولد، بنت، جماد...
//
//  Created by Abdelkader Rhouati on 1/24/17.
//  Copyright © 2017 ibda3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LETHowToViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger maxPage;

@property (weak, nonatomic) IBOutlet UIImageView *imageSlider;
@property (weak, nonatomic) IBOutlet UITextView *textSlider;
@property (weak, nonatomic) IBOutlet UILabel *titleSlider;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlItem;


- (IBAction)closeButton:(id)sender;


@end
