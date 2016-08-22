//
//  GVSwipeGiftsViewController.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVSwipeGiftsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Firebase/Firebase.h>
#import "GVGift.h"
#import "GVGiftStore.h"




@interface GVSwipeGiftsViewController()<SwipeGiftViewDelegate>

// Subviews of the ViewController's view.
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *savedGiftsButton;
@property (weak, nonatomic) IBOutlet UILabel *noMoreGiftsLabel;

// GVSwipeGiftsViewController also acts as the animation controller.
@property (assign, nonatomic) CGPoint swipeGiftViewOriginalCenter;
@property (assign, nonatomic) CATransform3D swipeGiftViewOriginalTransform;
@property (assign, nonatomic) CGFloat swipingThreshold;
@property (assign, nonatomic) CGPoint currentTranslation;
@property (assign, nonatomic) SwipeDirection currentDirection;

// This property must be the first thing that is initialized. It holds the UUIDs of the gifts that conform to the chosen interests.


@end

@implementation GVSwipeGiftsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dislikeButtonPressed:(id)sender {
    __weak GVSwipeGiftsViewController *weakSelf = self;
    
    [self animateSwipeWithCompletion:^(BOOL finished) {
        [weakSelf removeFrontGiftViewFromSuperView:SwipeLeftDirection];
    } direction:SwipeLeftDirection];
}

- (IBAction)likeButtonPressed:(id)sender {
    __weak GVSwipeGiftsViewController *weakSelf = self;
    
    [self animateSwipeWithCompletion:^(BOOL finished) {
        [weakSelf removeFrontGiftViewFromSuperView:SwipeRightDirection];
    } direction:SwipeRightDirection];
}

// Treat the pan gesture
- (void)giftViewIsBeingSwiped:(UIPanGestureRecognizer *)panGestureRecognizer {
    GVGiftView *giftView = (GVGiftView *)panGestureRecognizer.view;
    CGPoint translationPoint = [panGestureRecognizer translationInView:self.view];
    self.currentTranslation = translationPoint;
    
    // Actualize the direction of the swiping gesture
    if (translationPoint.x < 0)
        self.currentDirection = SwipeLeftDirection;
    else
        self.currentDirection = SwipeRightDirection;
    
    // Setting the initial position at which the view will return if the user is not really decided.
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.swipeGiftViewOriginalCenter = giftView.center;
        self.swipeGiftViewOriginalTransform = giftView.layer.transform;
    }
    
    // When the user lifts up his finger it has to be seen if he decided or not.
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // If the user dragged the photo almost to the end of the screen (which is the swiping threshold property) that means he's decided.
        if (fabs(translationPoint.x) >= self.swipingThreshold) {
            [self removeFrontGiftViewFromSuperView:self.currentDirection];
        }
        else {
            __weak GVSwipeGiftsViewController *weakSelf = self;
            
            [UIView animateWithDuration:0.15f animations:^{
                giftView.center = CGPointMake(weakSelf.swipeGiftViewOriginalCenter.x,self.swipeGiftViewOriginalCenter.y);
                giftView.layer.transform = weakSelf.swipeGiftViewOriginalTransform;
            } completion:nil];
          
        }
    }
    // Moving the giftView according to the paning gesture translation.
    else {
        giftView.center = CGPointMake(self.swipeGiftViewOriginalCenter.x + translationPoint.x,self.swipeGiftViewOriginalCenter.y);
        giftView.layer.transform = CATransform3DMakeRotation(M_PI/180 * (translationPoint.x/100 * 6), 0.0, 0.0, 1.0f);
    }

}

// Adds a GVGiftView instance on the screen. The view hierarchy is based on the FIFO principle (sendSubviewToBack message is sent to the GVGiftView instance)

- (GVGiftView *)addGiftViewFromIndex:(int)index {
    GVGiftView *swipeGiftView = [[GVGiftView alloc] init];
    
    swipeGiftView.translatesAutoresizingMaskIntoConstraints = NO;
    swipeGiftView.layer.shouldRasterize = NO;
    
    [self.view addSubview:swipeGiftView];
    
    NSLayoutConstraint *layoutConstraintTop = [NSLayoutConstraint constraintWithItem:swipeGiftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:75];
    
    NSLayoutConstraint *layoutConstraintBottom = [NSLayoutConstraint constraintWithItem:swipeGiftView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomSeparator attribute:NSLayoutAttributeTop multiplier:1 constant:-10];
    
    NSLayoutConstraint *layoutConstraintLeading = [NSLayoutConstraint constraintWithItem:swipeGiftView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    
    NSLayoutConstraint *layoutConstraintTrailing = [NSLayoutConstraint constraintWithItem:swipeGiftView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5];
    
    [self.view addConstraint:layoutConstraintTop];
    [self.view addConstraint:layoutConstraintBottom];
    [self.view addConstraint:layoutConstraintLeading];
    [self.view addConstraint:layoutConstraintTrailing];
    
    [self.view sendSubviewToBack:swipeGiftView];
    swipeGiftView.delegate = self;
    
    
    NSString *uuid = [self.foundGifts objectAtIndex:index];
    GVGift *gift = [GVGiftStore loadGVGiftFromUUID:uuid];
    
    swipeGiftView.titleLabel.text = gift.title;
    swipeGiftView.priceLabel.text = gift.price;
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    [imageManager downloadImageWithURL:[NSURL URLWithString:gift.imageUrlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        swipeGiftView.giftImageView.image = image;
    }];
    
    return swipeGiftView;
    
}

// Animates the finish of the swipe gesture.
// Manages the foundGifts property.
- (void)removeFrontGiftViewFromSuperView:(SwipeDirection)swipeDirection {
    int integerDirection;
    
    if (swipeDirection == SwipeLeftDirection)
        integerDirection = -1;
    else
        integerDirection = 1;
 
    CGRect destination = self.frontSwipeGiftView.frame;
    while (!CGRectIsNull(CGRectIntersection(self.frontSwipeGiftView.superview.bounds, destination))) {
            destination = CGRectMake(CGRectGetMinX(destination) + integerDirection * self.swipingThreshold,
                                     CGRectGetMinY(destination),
                                     CGRectGetWidth(destination),
                                     CGRectGetHeight(destination));
    }
    
    __weak GVSwipeGiftsViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.15f animations:^{
        self.frontSwipeGiftView.center = CGPointMake(CGRectGetMidX(destination),CGRectGetMidY(destination));
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.frontSwipeGiftView removeFromSuperview];
            
            if (swipeDirection == SwipeLeftDirection)
                [weakSelf userDislikedGift];
            else
                [weakSelf userLikedGift];
            
            if ([self.foundGifts count] >= 2) {
                weakSelf.frontSwipeGiftView = weakSelf.backSwipeGiftView;
                weakSelf.backSwipeGiftView = [weakSelf addGiftViewFromIndex:(int)[self.foundGifts count]-2];
            }
            if ([self.foundGifts count] == 1) {
                weakSelf.frontSwipeGiftView = weakSelf.backSwipeGiftView;
            }
            if ([self.foundGifts count] == 0) {
                self.noMoreGiftsLabel.hidden = NO;
                weakSelf.dislikeButton.enabled = NO;
                weakSelf.likeButton.enabled = NO;
            }
        }
    }];
}

// These methods are called right after the front GVGiftView is removed from the screen
- (void)userDislikedGift {
    NSString *uuid = [self.foundGifts lastObject];
    GVGift *gift = [GVGiftStore loadGVGiftFromUUID:uuid];
    gift.swiped = YES;
    [[GVGiftStore sharedStore] saveChanges];
    
    [self.foundGifts removeLastObject];
}

- (void)userLikedGift {
    NSString *uuid = [self.foundGifts lastObject];
    GVGift *gift = [GVGiftStore loadGVGiftFromUUID:uuid];
    gift.swiped = YES;
    gift.saved = YES;

    NSMutableArray *savedArray = [[GVGiftStore sharedStore] giftsSaved];
    [savedArray addObject:gift];
    [[GVGiftStore sharedStore] saveChanges];
    
    [self.foundGifts removeLastObject];
}

// Animate swipe (called when the user pressed the button, instead swiping himself the picture)
- (void)animateSwipeWithCompletion:(void (^)(BOOL finished))completion direction:(SwipeDirection)swipeDirection {
    self.swipeGiftViewOriginalCenter = CGPointMake(self.frontSwipeGiftView.center.x, self.frontSwipeGiftView.center.y);
    
    int integerDirection;
    
    if (swipeDirection == SwipeLeftDirection)
        integerDirection = -1;
    else
        integerDirection = 1;

    __weak GVSwipeGiftsViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.15f animations:^{
        weakSelf.frontSwipeGiftView.center = CGPointMake(weakSelf.swipeGiftViewOriginalCenter.x + integerDirection * weakSelf.swipingThreshold, weakSelf.swipeGiftViewOriginalCenter.y);
        weakSelf.frontSwipeGiftView.layer.transform = CATransform3DMakeRotation(M_PI/180 * (weakSelf.swipingThreshold * integerDirection/100 * 6), 0.0, 0.0, 1.0f);
    } completion:^(BOOL finished) {
        if (finished)
            completion(YES);
    }];
}

// Initialize the data and setup the first GVGiftsViews.
- (void)initialize {
    // Filter the gifts from the sharedStore
    _foundGifts = [[NSMutableArray alloc] init];
    for (NSString *interest in self.interestsSelected) {
        NSMutableArray *array = [[[GVGiftStore sharedStore] giftsDictionaryByInterest] objectForKey:interest];
        for (NSString *uuid in array) {
            GVGift *gift = [GVGiftStore loadGVGiftFromUUID:uuid];
            if (![_foundGifts containsObject:uuid] && gift.swiped == NO) {

                [_foundGifts addObject:uuid];
            }
        }
    }
    
    // Setup the swipe views
    if ([self.foundGifts count] >= 2) {
        self.frontSwipeGiftView = [self addGiftViewFromIndex:(int)([self.foundGifts count])-1];
        self.backSwipeGiftView = [self addGiftViewFromIndex:(int)([self.foundGifts count])-2];
        self.noMoreGiftsLabel.hidden = YES;
    }
    if ([self.foundGifts count] == 1) {
        self.frontSwipeGiftView = [self addGiftViewFromIndex:(int)([self.foundGifts count]-1)];
        self.noMoreGiftsLabel.hidden = YES;
    }
    if ([self.foundGifts count] == 0) {
        self.dislikeButton.enabled = NO;
        self.likeButton.enabled = NO;
        self.noMoreGiftsLabel.hidden = NO;
    }
    
    self.dislikeButton.layer.cornerRadius = 10.0;
    self.likeButton.layer.cornerRadius = 10.0;
    
    [self.dislikeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBounds.size.width;
    _swipingThreshold = screenWidth/2 - 10;
}

- (IBAction)newSearchButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
