//
//  GVGiftTableViewCell.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGiftTableViewCellDelegate.h"

@interface GVGiftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) id<GVGiftTableViewCellDelegate> delegate;


@end
