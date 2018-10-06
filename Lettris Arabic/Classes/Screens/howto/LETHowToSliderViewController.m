//
//  LETHowToSliderViewController.m
//  ولد، بنت، جماد...
//
//  Created by Abdelkader Rhouati on 1/25/17.
//  Copyright © 2017 ibda3. All rights reserved.
//

#import "LETHowToSliderViewController.h"
#import "LETHowToViewController.h"

@interface LETHowToSliderViewController ()

@end

@implementation LETHowToSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    maxPage = 8;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    LETHowToViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma Handler Page Controller interface 

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(LETHowToViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(LETHowToViewController *)viewController index];
    
    
    index++;
    
    if (index == maxPage) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (LETHowToViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    LETHowToViewController *childViewController = [[LETHowToViewController alloc] initWithNibName:nil bundle:nil];
    
    childViewController.index = index;
    childViewController.maxPage = maxPage;
    
    return childViewController;
    
}


@end
