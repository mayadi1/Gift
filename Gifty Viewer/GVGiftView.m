//
//  GVSwipeGiftView.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.//

#import "GVGiftView.h"
#import <QuartzCore/QuartzCore.h>

@interface GVGiftView()

@property (nonatomic, weak) UIPanGestureRecognizer *panGestureRecognizer;

@end


@implementation GVGiftView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}


// This loads the contentView (that contains all view properties) from the xib.
- (void)setup {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"GVGiftView")];
    UINib *nib = [UINib nibWithNibName:@"GVGiftView" bundle:bundle];
    
    UIView *contentView = [nib instantiateWithOwner:self options:nil][0];
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:contentView];
    
    [self.giftImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.descriptionView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(isBeingSwiped)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    _panGestureRecognizer = panGestureRecognizer;
}

// The delegate (GVSwipeGiftsViewController) treats the animation of the swipe and its consequences.
- (void)isBeingSwiped {
    [self.delegate giftViewIsBeingSwiped:self.panGestureRecognizer];
}

@end
