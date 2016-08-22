//
//  GVInterestsCollectionViewCell.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.//

#import "GVInterestsCollectionViewCell.h"

@implementation GVInterestsCollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected == NO) {
        self.backgroundColor = [UIColor orangeColor];
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [[UIColor orangeColor] getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    else
        self.backgroundColor = [UIColor colorWithRed:0 green:122/255 blue:255 alpha:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
