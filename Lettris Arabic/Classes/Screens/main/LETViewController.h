//
//  LETViewController.h
//  Lettris Arabic
//

//  Copyright (c) 2013 ibda3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@import GoogleMobileAds;

@interface LETViewController : UIViewController <UIAlertViewDelegate, GADInterstitialDelegate>

@property (nonatomic, strong) UIImageView *loadingView;
@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property(nonatomic, strong) GADInterstitial *interstitial;

- (void)displayBanner;
- (void)hideBanner;

@end
