//
//  MasTrackerManager.h
//  MaxstAR
//
//  Created by Kimseunglee on 2017. 12. 7..
//  Copyright © 2017년 Maxst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasTrackingState.h"
#import "MasTrackingResult.h"
#import "MasSurfaceThumbnail.h"
#import "MasGuideInfo.h"

/**
 * @brief Control AR Engine
 */
@interface MasTrackerManager : NSObject

/**
 * @enum TrackerType
 * @brief Tracker Type
 * @constant TRACKER_TYPE_CODE_SCANNER Code scanner
 * @constant TRACKER_TYPE_IMAGE Planar image tracker
 * @constant TRACKER_TYPE_MARKER Marker tracker
 * @constant TRACKER_TYPE_OBJECT Object tracker (Object data should be created via Visual SLAM Tool)
 * @constant TRACKER_TYPE_INSTANT Instant tracker
 * @constant TRACKER_TYPE_CLOUD_RECOGNIZER Cloud Recognition Image tracker
 * @constant TRACKER_TYPE_QR_TRACKER QR Code tracker
 * @constant TRACKER_TYPE_IMAGE_FUSION Image Fusion tracker
 * @constant TRACKER_TYPE_OBJECT_FUSION Object Fusion tracker
 * @constant TRACKER_TYPE_QR_FUSION QR Code Fusion tracker
 * @constant TRACKER_TYPE_MARKER_FUSION Maker Fusion tracker
 * @constant TRACKER_TYPE_SPACE Space tracker
 * @constant TRACKER_TYPE_INSTANT_FUSION Instant Fusion tracker
 */
typedef NS_ENUM(int, TrackerType) {
	/**Code scanner*/
    TRACKER_TYPE_CODE_SCANNER = 0x01,
	/**Planar image tracker*/
    TRACKER_TYPE_IMAGE = 0x02,
	/**Code scanner*/
    TRACKER_TYPE_MARKER = 0X04,
	/**Object tracker (Object data should be created via SLAM tracker)*/
    TRACKER_TYPE_OBJECT = 0X08,
	/**Instant tracker*/
	TRACKER_TYPE_INSTANT = 0x20,
	/**Cloud recognizer*/
	TRACKER_TYPE_CLOUD_RECOGNIZER = 0x30,
    /** QR-Code tracker*/
    TRACKER_TYPE_QR_TRACKER = 0x40,
    /** Image Fusion tracker */
    TRACKER_TYPE_IMAGE_FUSION = 0x80,
    /** Object Fusion tracker */
    TRACKER_TYPE_OBJECT_FUSION = 0x100,
    /** QR-Code Fusion tracker */
    TRACKER_TYPE_QR_FUSION = 0x400,
    /** Marker Fusion tracker */
    TRACKER_TYPE_MARKER_FUSION = 0x800,
    /** Space tracker*/
    TRACKER_TYPE_SPACE = 0x8000,
    /** Instant Fusion tracker */
    TRACKER_TYPE_INSTANT_FUSION = 0x10000,
};

/**
 * @enum TrackingOption
 * @brief Additional tracking option.
 * @constant NORMAL_TRACKING Normal Tracking (Image Tracker Only)
 * @constant EXTENDED_TRACKING Extended Tracking (Image Tracker Only)
 * @constant MULTI_TRACKING Multi Target Tracking (Image Tracker Only)
 * @constant JITTER_REDUCTION_ACTIVATION Jitter Reduction Activation (Marker, Image, and object trackers)
 * @constant JITTER_REDUCTION_DEACTIVATION Jitter Reduction Deactivation (Marker, Image, and object trackers)
 * @constant CLOUD_RECOGNITION_AUTO_ACTIVATION Coud Recognition Auto activation (Cloud Recognition)
 * @constant CLOUD_RECOGNITION_AUTO_DEACTIVATION Coud Recognition Auto Deactivation (Cloud Recognition)
 */
typedef NS_ENUM(int, TrackingOption) {
	/**Normal Tracking (Image Tracker Only)*/
    NORMAL_TRACKING = 0x01,
	/**Extended Tracking (Image Tracker Only)*/
    EXTENDED_TRACKING = 0x02,
    /**Enhanced Tracking (Marker Tracker Only)*/
    ENHANCED_TRACKING = 0x80,
	/**Multi Target Tracking (Image Tracker Only)*/
    MULTI_TRACKING = 0x04,
	/**Jitter Reduction Activation (Marker, Image, and object trackers)*/
    JITTER_REDUCTION_ACTIVATION = 0x08,
	/**Jitter Reduction Deactivation (Marker, Image, and object trackers)*/
    JITTER_REDUCTION_DEACTIVATION = 0x10,
    /**Cloud Recognition Auto Activation (Cloud Tracker Only)*/
    CLOUD_RECOGNITION_AUTO_ACTIVATION = 0x20,
    /**Cloud Recognition Auto Deactivation (Cloud Tracker Only)*/
    CLOUD_RECOGNITION_AUTO_DEACTIVATION = 0x40,
};

/**
 * @brief Start AR engine. Only one tracking engine could be run at one time
 * @param trackerMask tracking engine type
 */
- (void)startTracker:(TrackerType)trackerMask;

/**
 * @brief Stop tracking engine
 */
- (void)stopTracker;

/**
 * @brief Remove all tracking data (Map data and tracking result)
 */
- (void)destroyTracker;

/**
 * @brief Add map file to candidate list.
 * @param trackingFileName absolute file path
 */
- (void)addTrackerData:(NSString *)trackingFileName;

/**
 * @brief Remove map file from candidate list.
 * @param trackingFileName map file name. This name should be same which added.
 * If set "" (empty) file list will be cleared.
 */
- (void)removeTrackerData:(NSString *)trackingFileName;

/**
 * @brief Load map files in candidate list to memory. This method don't block main(UI) thread
 */
- (void)loadTrackerData;

/**
 * @brief Get map files loading state. This is for UI expression.
 * @return true if map loading is completed
 */
- (bool)isTrackerDataLoadCompleted;

/**
 * @brief Check if Fusion is supported.
 * @return true if Fusion is supports.
 */
- (bool)isFusionSupported;

/**
 * @brief Check the status of the Fusion Tracker.
 * @return 1 is stable
 *         -1 is unstable
 */
- (int)getFusionTrackingState;

/**
 * @brief Update tracking state. This function should be called before getTrackingResult and background rendering
 * @return Tracking state container
 */
- (MasTrackingState *)updateTrackingState;

/**
 * @brief Start to find the surface of an environment from a camera image
 */
- (void)findSurface;

/**
 * @brief Stop to find the surface
 */
- (void)quitFindingSurface;

/**
 * @brief find the tracker ID of the current screen image.
 */
- (void)findImageOfCloudRecognition;

/**
 * @brief Save the surface data to file
 * @param outputFileName file path (should be absolute path)
 * @return MasSurfaceThumbnail instance if true else null
 */
- (MasSurfaceThumbnail *)saveSurfaceData:(NSString *)outputFileName;

- (void)setVocabulary:(NSString *)filePath;

/**
 * @brief Get 3d world coordinate corresponding to given 2d screen position
 * @param screen screen touch x, y position
 * @param world world position x, y, z
 */
- (void)getWorldPositionFromScreenCoordinate:(float *)screen world:(float *)world;

/**
 * @brief Get surface mesh information of the found surface after the findSurface method has been called
 * @return MasSurfaceMesh instance
 */
- (MasGuideInfo *)getGuideInformation;

/**
 * @brief Set tracking options. 1, 2, 4 cannot run simultaneously.
 * @param option
 *        1 : Normal Tracking (Image Tracker Only)
 *        2 : Extended Tracking (Image Tracker Only)
 *        4 : Multiple Target Tracking (Image Tracker Only)
 */
- (void)setTrackingOption:(TrackingOption)option;
- (void)saveFrames;

/**
 * @brief Set secret ID and key for access of cloud recognition
 * @param secretId secret ID
 * @param secretKey secret key
 */
- (void)setCloudRecognitionSecretId:(NSString *)secretId secretKey:(NSString *)secretKey;

@end

