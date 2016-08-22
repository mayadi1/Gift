//
//  GVInterestsCollectionViewCell.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

// UICollectionViewCell subclass that represents an interest as a tag.

#import <UIKit/UIKit.h>

@interface GVInterestsCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *interestLabel; // The label which contains the name of the interest.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maximumWidthConstraint;

@end
