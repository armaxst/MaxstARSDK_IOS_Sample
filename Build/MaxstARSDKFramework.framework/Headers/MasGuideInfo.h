//
//  MasGuideInfo.h
//  MaxstARSDKFramework
//
//  Created by Kimseunglee on 2018. 3. 21..
//  Copyright © 2018년 Maxst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasTagAnchor.h"

@interface MasGuideInfo : NSObject

- (instancetype)init:(void *)guideInfo;

/**
 * @brief Get a percentage of progress during an initialization step of SLAM
 * @return Slam initializing progress
 */
- (float)getInitializingProgress;

/**
 * @brief Get keyframe count
 * @return keyframe count
 */
- (int)getKeyframeCount;

/**
 * @brief Get the number of features for guide
 * @return feature point count
 */
- (int)getGuideFeatureCount;

/**
 * @return Get 2d screen positions of features for guide
 */
- (float *)getGuideFeatureBuffer;

/**
 * @brief Get a bounding box of a scanned object
 * @return buffer including bounding box information
 */
- (float *)getBoundingBox;

/**
 * @brief Get Anchors of a scanned object
 * @return buffer including Anchor information
 */
- (NSMutableArray<MasTagAnchor *> *)getTagAnchors;

/**
 * @brief Get number of anchors
 * @return number of anchors
 */
- (int)getTagAnchorCount;

/**
 * @brief Get anchors Id
 * @return anchors Id
 */
- (int)getTagAnchorsId;
@end
