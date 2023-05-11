//
//  MasSurfaceThumbnail.h
//  MaxstARSDKFramework
//
//  Created by Kimseunglee on 2017. 12. 10..
//  Copyright © 2017년 Maxst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasTrackedImage.h"

/**
 * @brief Contains surface thumbnail image information of first keyframe
 */
@interface MasSurfaceThumbnail : NSObject

- (instancetype)init:(void*)surfaceThumbnail;

/**
 * @brief Get thumbnail image width.
 * @return image width
 */
- (int) getWidth;

/**
 * @brief Get thumbnail image height.
 * @return image height
 */
- (int) getHeight;

/**
 * @brief Get thumbnail image bytes per pixel.
 * @return image bytes per pixel
 */
- (int) getBpp;

/**
 * @brief Get thumbnail image bytes per pixel.
 * @return image color format
 */
- (MasColorFormat) getFormat;

/**
 * @brief Get thumbnail image data length.
 * @return image data length
 */
- (int) getLength;

/**
 * @brief Get thumbnail image data pointer.
 * @return thumbnail image data pointer
 */
- (unsigned char*) getData;

@end
