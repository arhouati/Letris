//
//  LETHowToSliderViewController.h
//  ولد، بنت، جماد...
//
//  Created by Abdelkader Rhouati on 1/25/17.
//  Copyright © 2017 ibda3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LETHowToSliderViewController : UIViewController <UIPageViewControllerDataSource> {
    NSInteger maxPage;
}

@property (strong, nonatomic) UIPageViewController *pageController;

@end
