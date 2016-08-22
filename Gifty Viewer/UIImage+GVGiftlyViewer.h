//
//  UIImage+GVGiftlyViewer.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GVGiftlyViewer)

+ (UIColor *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;


@end
