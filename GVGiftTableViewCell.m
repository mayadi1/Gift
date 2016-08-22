//
//  GVGiftTableViewCell.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVGiftTableViewCell.h"

@implementation GVGiftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.buyButton.layer.cornerRadius = 10.0;
    self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.buyButton addTarget:self action:@selector(buyButtonPressed) forControlEvents:UIControlEventTouchDown];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buyButtonPressed {
    UITableView *tableView = (UITableView *)self.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];

    [self.delegate didPressBuyAtIndexPath:indexPath];
}

@end
