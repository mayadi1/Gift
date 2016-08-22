//
//  GVSwipeGiftsViewController.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//



// UIViewController subclass that presents the gifts in form of GiftView objects.

#import <UIKit/UIKit.h>
#import "GVGiftView.h"

@interface GVSwipeGiftsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

typedef NS_ENUM (NSInteger,SwipeDirection) {
    SwipeLeftDirection,
    SwipeRightDirection
};
// This property must be the first thing that is initialized. It holds the UUIDs of the gifts that conform to the chosen interests.
@property (copy, nonatomic) NSMutableArray *foundGifts;

// Subviews of the ViewController's view.
@property (weak, nonatomic) GVGiftView *frontSwipeGiftView;
@property (weak, nonatomic) GVGiftView *backSwipeGiftView;

@property (nonatomic, copy) NSMutableArray *interestsSelected; // Contains the interests(NSStrings) previously chosen.

- (GVGiftView *)addGiftViewFromIndex:(int)index; // Adds GiftView on the screen using the model object GVGift at the index of the foundGifts array.


@end
