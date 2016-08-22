//
//  GVSwipeGiftView.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SwipeGiftViewDelegate.h"

IB_DESIGNABLE

// View that presents the image of the gift image, gift price and gift name.
// It is loaded from the xib file with the same name as this class.

@interface GVGiftView : UIView

@property (nonatomic, weak) id<SwipeGiftViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIImageView *giftImageView; // The image of this UIImageView is an image of the gift
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // Name of the gift
@property (weak, nonatomic) IBOutlet UILabel *priceLabel; // Price of the gift
@property (weak, nonatomic) IBOutlet UIView *descriptionView; // This view contains the priceLabel and the titleLabel

@end
