//
//  GVBuyGiftViewController.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

// UIViewController subclass that presents a UIWebView which gives the user the possibility to buy the gift

#import <UIKit/UIKit.h>
#import "GVGift.h"

@interface GVBuyGiftViewController : UIViewController

@property (weak, nonatomic) GVGift *giftToPresent;
@property (weak, nonatomic) IBOutlet UIWebView *giftWebView;

@end
