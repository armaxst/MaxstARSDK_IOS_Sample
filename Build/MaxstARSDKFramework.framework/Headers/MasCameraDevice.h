//
//  MasCameraDevice.h
//  MaxstAR
//
//  Created by Kimseunglee on 2017. 11. 23..
//  Copyright © 2017년 Maxst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasTrackedImage.h"
#import <simd/SIMD.h>

/**
 * @brief class for camera device handling
 */
@interface MasCameraDevice : NSObject

/**
 * @enum MasFocusMode
 * @brief Camera focus mode
 * @constant FOCUS_MODE_CONTINUOUS_AUTO Continuous focus mode. This focus mode is proper for AR
 * @constant FOCUS_MODE_AUTO Scingle auto focus mode
 */
typedef NS_ENUM(int, MasFocusMode) {
    FOCUS_MODE_CONTINUOUS_AUTO = 1,
    FOCUS_MODE_AUTO = 2,
};

/**
 * @enum MasFlipDirection
 * @brief Video data flip direction
 * @constant HORIZONTAL Flip video horizontally
 * @constant VERTICAL Flip video vertically
 */
typedef NS_ENUM(int, MasFlipDirection) {
    HORIZONTAL = 0,
    VERTICAL = 1,
};

/**
 * @enum MasResultCode
 * @brief Camera Open State
 * @constant Success
 * @constant CameraPermissionIsNotResolved
 * @constant CameraDevicedRestriced
 * @constant CameraPermissionIsNotGranted
 * @constant CameraAlreadyOpened
 * @constant TrackerAlreadyStarted
 * @constant UnknownError
 */
typedef NS_ENUM(int, MasResultCode) {
    Success = 0,
    
    CameraPermissionIsNotResolved = 100,
    CameraDevicedRestriced = 101,
    CameraPermissionIsNotGranted = 102,
    CameraAlreadyOpened = 103,
    
    TrackerAlreadyStarted = 200,
    
    UnknownError = 1000,
};

/**
 * @brief Start camera preview
 * @param cameraId 0 is rear camera, 1 is face camera. camera index may depends on device.
 * @param width prefer camera width
 * @param height prefer camera height
 * @return MasResultCode
 */
- (MasResultCode)start:(int)cameraId width:(int)width height:(int)height;

- (MasResultCode)start:(NSString *)path;

/**
 * @brief Stop camera preview
 */
- (void)stop;

/**
 * @brief Set up the fusion camera
 */
- (void)setFusionEnable;

/**
 * @brief Get Camera Width.
 * @return camera preview width
 */
- (int)getWidth;

/**
 * @brief Get Camera Height.
 * @return camera preview height
 */
- (int)getHeight;

/**
 * @brief Set Camera Focus
 * @return true if focus setting success
 */
- (bool)setFocusMode:(MasFocusMode)mode;

/**
 * @brief Set Camera Zoom Scale
 * @param zoomScale Zoom value
 * @return result Zoom.
 */
- (bool)setZoom:(float)zoomScale;

/**
 * @brief Get Camera Device Max Zoom value.
 * @return Max Zoom value.
 */
- (int)getMaxZoomValue;

/**
 * @brief Turn on/off flash light
 */
- (bool)setFlashLightMode:(bool)toggle;

/**
 * @brief Turn on/off auto white balance lock
 */
- (bool)setAutoWhiteBalanceLock:(bool)toggle;

/**
 * @brief Flip video
 * @param direction Flip direction
 * @param toggle true for set, false for reset
 */
- (void)flipVideo:(MasFlipDirection)direction toggle:(bool)toggle;

/**
 * @brief Set near, far plane
 * @param near near plane value
 * @param far far plane value
 */
- (void)setClippingPlane:(float)near far:(float)far;


/**
 * @brief Check Screen is Horizontal.
 * @return return Horizontal value.
 */
- (bool)isFlipHorizontal;


/**
 * @brief Check Screen is Vertical.
 * @return return Vertical value.
 */
- (bool)isFlipVertical;


/**
 * @brief Set Parameter Value.
 * @param filePath Parameter file Path.
 */
- (void)setCalibrationData:(NSString *)filePath;

/**
 * @brief Set new image data for tracking and background rendering (Free, Enterprise license key can activate this interface)
 * @param data image data bytes.
 * @param length image length
 * @param width image width
 * @param height image height
 * @param format image format
 */
- (void)setNewFrame:(Byte *)data length:(int)length width:(int)width height:(int)height format:(MasColorFormat)format;

/**
 * @brief Set new image data for tracking and background rendering (Free, Enterprise license key can activate this interface)
 * @param data image data bytes.
 * @param length image length
 * @param width image width
 * @param height image height
 * @param format image format
 * @param timestamp image timestamp
 */
- (void)setNewFrameAndTimestamp:(Byte *)data  length:(int)length width:(int)width height:(int)height format:(MasColorFormat)format timestamp:(unsigned long long int)timestamp;

/**
 * @brief Get projection matrix. This is used for augmented objects projection and background rendering
 * @return 4x4 matrix (Column major)
 */
- (matrix_float4x4)getProjectionMatrix;

/**
 * @brief Get projection matrix for background plane rendering
 * @return 4x4 matrix (Column major)
 */
- (matrix_float4x4)getBackgroundPlaneProjectionMatrix;


/**
 * @brief Get background scale info for background plane rendering
 * @return scale value.
 */
- (float *)getBackgroundPlaneInfo;

/**
 * @brief Get Camera Intrinsic.
 * @return {"width":width,"height":height,"fx":fx,"fy":fy,"px":px,"py":py}  fx = focal length x, fy =focal length y, px = principal point x, py = principal point y
 */
- (NSString *)getCameraIntrinsic;
@end
