//
//  GVCollectionViewFlowLayout.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <UIKit/UIKit.h>

// Custom Collection View Flow Layout that sets a fixed spaced between cells

@interface GVCollectionViewFlowLayout : UICollectionViewFlowLayout

@end

@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end