//
//  GVGiftTableViewCellDelegate.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GVGiftTableViewCellDelegate <NSObject>

- (void)didPressBuyAtIndexPath:(NSIndexPath *)indexPath;


@end
