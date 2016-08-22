//
//  GVInterestsViewController.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

// UIViewController subclass that presents the interests a user can choose from. The GVInterestsCollectionViewCells (interests) are located in a standard UICollectionView and their layout is managed by a customized FlowLayout.

#import <UIKit/UIKit.h>

@interface GVInterestsViewController : UIViewController

@property (nonatomic, copy) NSMutableArray *interestsList; // Set the interests here.

// Subviews
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
