//
//  UIImage+ImageBubbles.m
//  PRMobile
//
//  Created by Jeremy Stone on 2/25/14.
//  Copyright (c) 2014 Solutionreach. All rights reserved.
//

#import "UIImage+ImageBubbles.h"

/*
 Note:  Some of the below code taken/modified from JSMessagesViewController
 
 http://cocoadocs.org/docsets/JSMessagesViewController
 under The MIT License
 Copyright (c) 2013 Jesse Squires
 http://opensource.org/licenses/MIT
 
 */


@implementation UIImage (ImageBubbles)

- (UIImage *)js_imageFlippedHorizontal
{
  return [UIImage imageWithCGImage:self.CGImage
                             scale:self.scale
                       orientation:UIImageOrientationUpMirrored];
}

- (UIImage *)js_stretchableImageWithCapInsets:(UIEdgeInsets)capInsets
{
  return [self resizableImageWithCapInsets:capInsets
                              resizingMode:UIImageResizingModeStretch];
}


- (UIImage *)js_imageMaskWithImageView:(UIImageView *)maskImageView
{
  // get the mask from the likely manipulated image via the UIImageView
  UIGraphicsBeginImageContextWithOptions(maskImageView.frame.size, YES, [UIScreen mainScreen].scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  [maskImageView.layer renderInContext:context];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // use the mask built above to get our resulting image
  CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
  
  UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextScaleCTM(ctx, 1.0f, -1.0f);
  CGContextTranslateCTM(ctx, 0.0f, -(imageRect.size.height));
  
  CGContextClipToMask(ctx, imageRect, image.CGImage);
  CGContextDrawImage(ctx, imageRect, self.CGImage);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

- (UIImage *)js_imageMaskWithColor:(UIColor *)maskColor
{
  CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
  
  UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextScaleCTM(ctx, 1.0f, -1.0f);
  CGContextTranslateCTM(ctx, 0.0f, -(imageRect.size.height));
  
  CGContextClipToMask(ctx, imageRect, self.CGImage);
  CGContextSetFillColorWithColor(ctx, maskColor.CGColor);
  CGContextFillRect(ctx, imageRect);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

@end
