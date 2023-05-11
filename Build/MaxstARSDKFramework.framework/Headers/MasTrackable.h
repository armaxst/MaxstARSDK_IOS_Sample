//
//  MasTrackerable.h
//  MaxstAR
//
//  Created by Kimseunglee on 2017. 11. 24..
//  Copyright © 2017년 Maxst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/SIMD.h>

/**
 * @brief Container for individual tracking information
 */
@interface MasTrackable : NSObject
- (instancetype)init:(void*)trackable;

/**
 * @brief Get tracking pose.
 * @return 4x4 matrix for tracking pose
 */
- (matrix_float4x4) getPose;

/**
 * @brief Get target name.
 * @return tracking target name (file name without extension)
 */
- (NSString*) getName;

/**
 * @brief Get target id.
 * @return tracking target id
 */
- (NSString*) getId;

/**
 * @brief Get target Cloud Name.
 * @return tracking target Cloud Name (for use Cloud Recognition)
 */
- (NSString*) getCloudName;

/**
 * @brief Get target Width.
 * @return tracking target width
 */
- (float) getWidth;

/**
 * @brief Get target Height.
 * @return tracking target height
 */
- (float) getHeight;

/**
 * @brief Get target Cloud MetaData.
 * @return tracking target Cloud MetaData (for use Cloud Recognition)
 */
- (NSString*) getCloudMetaData;
@end
