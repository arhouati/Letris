//
//  LETViewController.m
//  Lettris Arabic
//
//  Created by Abdelkader on 12/11/13.
//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import "LETViewController.h"
#import "LETGameStart.h"

#import "LETHowToSliderViewController.h"

#import "iRate.h"

SKView * skView;
SKScene * scene;

@implementation LETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interstitial = [self createAndLoadInterstitial];
    
    // Configure the view.
    skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    scene = [LETGameStart sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // hide and dislay banner using notificaiton from scene
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBanner)
                                                 name:@"hideBanner"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayBanner)
                                                 name:@"displayBanner"
                                               object:nil];
    
    // Google Banner Ads
    
    self.banner.adUnitID = @"ca-app-pub-0794359614832638/6144592029";
    self.banner.rootViewController = self;
    [self.banner loadRequest:[GADRequest request]];
    
    // dislay banner iAd Interstitial
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayBannerInterstitial)
                                                 name:@"displayBannerInterstitial"
                                               object:nil];
    
    // Display HowToView
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayHowToView)
                                                 name:@"displayHowToView"
                                               object:nil];
    
    // display rate/review view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rateApp)
                                                 name:@"displayRateApp"
                                               object:nil];
    
    
    // Present the scene.
    [skView presentScene:scene];
    
    // code for animation
    //[scene setPaused:TRUE];
    // [self performSelector:@selector(loadingViewFade) withObject:nil];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) loadingViewFade
{
    self.loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    self.loadingView.image = [UIImage imageNamed:@"LaunchImage.png"];
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:3.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.loadingView.alpha = 0.0;
    [UIView commitAnimations];
    
    //Create and add the Activity Indicator to loadingView
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(160, 290);
    activityIndicator.hidesWhenStopped = NO;
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(120, 310, 160, 30)];
    text.backgroundColor = [UIColor clearColor];
    text.textColor       = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:25];
    text.text = @"إنتظار ...";
    [self.loadingView addSubview:text];
    [self.loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    [self.loadingView removeFromSuperview];
    [scene setPaused:false];


}

#pragma mark function for handling iad banner

- (void)displayBanner{

    [UIView transitionWithView:self.banner
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.banner.hidden = NO;
                    }
                    completion:NULL];
    
}

- (void)hideBanner{

    [UIView transitionWithView:self.banner
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.banner.hidden = YES;
                    }
                    completion:NULL];
}

- (void)displayBannerInterstitial{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

#pragma mark ADInterstitialViewDelegate methods

- (GADInterstitial*)createAndLoadInterstitial {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-0794359614832638/3083818024"];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9b" ];
    [self.interstitial loadRequest:request];
    
    self.interstitial.delegate = self;
    
    return self.interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

#pragma mark handler howto view
- (void)displayHowToView{
    
    LETHowToSliderViewController *howToScreen = [[LETHowToSliderViewController alloc] initWithNibName:nil bundle:nil];
    howToScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:howToScreen animated:YES completion:NULL];
    
}

#pragma mark handler Rate APP
- (void)rateApp {
    
    [iRate sharedInstance].messageTitle = @" ولد، بنت، جماد...";
    [iRate sharedInstance].message = @"لقد أكملت جميع مستويات هذه النسخة الأولية، إذا  أحببت  اللعبة، لا تتردد في مساعدتنا بترك تعليق أو التصويت للعبة على المتجر.";

    [[iRate sharedInstance] promptForRating];
}


@end
