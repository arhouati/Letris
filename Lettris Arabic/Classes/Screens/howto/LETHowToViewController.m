//
//  LETHowToViewController.m
//  ولد، بنت، جماد...
//
//  Created by Abdelkader Rhouati on 1/24/17.
//  Copyright © 2017 ibda3. All rights reserved.
//

#import "LETHowToViewController.h"

@interface LETHowToViewController ()

@end

@implementation LETHowToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageSlider.image = [UIImage imageNamed:[NSString stringWithFormat:@"howto_%ld",_index +1]];
    
    
    NSString *howtoTextFile = [[NSBundle mainBundle] pathForResource:@"howto-text" ofType:@"plist"];
    NSMutableArray *howtoTextArray = [[NSMutableArray alloc] initWithContentsOfFile:howtoTextFile];
    
    NSMutableDictionary *howtoTextDic = [howtoTextArray objectAtIndex:_index];
    
    _titleSlider.text = [NSString stringWithFormat:@"%@",[howtoTextDic objectForKey:@"title"]];

    _textSlider.text = [NSString stringWithFormat:@"%@",[howtoTextDic objectForKey:@"text"]];
    
    [_pageControlItem setNumberOfPages:_maxPage];

    [_pageControlItem setCurrentPage:_index];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

@end
