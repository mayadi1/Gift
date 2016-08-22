//
//  SwipeGiftViewDelegate.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GVGiftView;


@protocol SwipeGiftViewDelegate <NSObject>

- (void)giftViewIsBeingSwiped:(UIPanGestureRecognizer *)panGestureRecognizer;

@end

@interface SwipeGiftViewDelegate


@end