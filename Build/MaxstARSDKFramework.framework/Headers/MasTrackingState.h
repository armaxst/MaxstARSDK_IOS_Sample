//
//  MasTrackingState.h
//  MaxstARSDKFramework
//
//  Created by Kimseunglee on 2017. 12. 8..
//  Copyright © 2017년 Maxst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasTrackedImage.h"
#import "MasTrackingResult.h"
#import <simd/SIMD.h>
#if defined (__IOS__)
#import <ARKit/ARKit.h>
#endif
/**
 * @brief Tracking state container
 */
@interface MasTrackingState : NSObject

typedef NS_ENUM(int, TrackingStatus) {
    START = 1,
    STOP = 2,
    RECOGNITION = 3,
    TRACKING = 4,
    CLOUD_CONNECTING = 5,
    CLOUD_NETWORK_ERROR = 6,
    STATUS_UNKNOWN = 7,
};

- (instancetype)init:(void *)trackingState;


/**
 * @brief Get current Tracking status.(for CloudRecognizer)
 * @return TrackingStatus
*/

- (TrackingStatus)getTrackingStatus;

/**
 * @brief Get image used for tracking
 * @return MasTrackedImage
 */
- (MasTrackedImage *)getImage;

/**
 * @brief Get tracking result
 * @return MasTrackingResult result
 */
- (MasTrackingResult *)getTrackingResult;

/**
 * @brief Get QRCode / Barcode recognition result
 * @return QRCode or barcode text
 */
- (NSString *)getCodeScanResult;
@end
