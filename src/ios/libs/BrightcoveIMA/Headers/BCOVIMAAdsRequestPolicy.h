//
// BCOVIMAAdsRequestPolicy.h
// BCOVIMA
//
// Copyright (c) 2014 Brightcove, Inc. All rights reserved.
// License: https://accounts.brightcove.com/en/terms-and-conditions
//

#import <Foundation/Foundation.h>


@protocol BCOVPlaybackSession;

@class BCOVCuePointProgressPolicy;
@class IMAAdDisplayContainer;

/**
 * Policy object to generate IMAAdsRequests for use by a
 * given input playback session.
 */
@interface BCOVIMAAdsRequestPolicy : NSObject

#pragma mark VMAP

/**
 * Returns an ads request policy that checks the BCOVVideo object in each
 * playback session for the VMAP ad tag URL to request. If the video object's
 * properties contains an entry whose key is `kBCOVIMAAdTag`, the value
 * of that entry is assumed to be a NSString containing the VMAP ad tag URL.
 * That URL will be used to construct a VMAP IMAAdsRequest for that playback 
 * session.
 *
 * @param adDisplayContainer IMAAdDisplayContainer instance used to create an
 * IMAAdsRequest.
 * @return An ads request policy that generates VMAP IMAAdsRequests from
 * information in each playback session's `BCOVVideo.properties`.
 */
+ (instancetype)videoPropertiesVMAPAdTagUrlAdsRequestPolicyWithAdDisplayContainer:(IMAAdDisplayContainer *)adDisplayContainer;

/**
 * Returns an ads request policy that generates a VMAP IMAAdsRequest with the
 * specified ad tag URL and companion slots for every playback session.
 *
 * @param VMAPAdTagUrl The ad tag URL to include in the IMAAdsRequest this
 * policy generates. Currently, only VMAP ad tag URLs are supported.
 * @param adDisplayContainer IMAAdDisplayContainer instance used to create an
 * IMAAdsRequest.
 * @return An ads request policy that generates VMAP IMAAdsRequests from
 * the specified parameters.
 */
+ (instancetype)adsRequestPolicyWithVMAPAdTagUrl:(NSString *)VMAPAdTagUrl adDisplayContainer:(IMAAdDisplayContainer *)adDisplayContainer;

#pragma mark VAST

/**
 * Returns an ads request policy that checks each BCOVVideo for BCOVCuePoints
 * of type 'kBCOVIMACuePointTypeAd'. If the cuepoint object's
 * properties contains an entry whose key is `kBCOVIMAAdTag`, the value
 * of that entry is assumed to be a NSString containing the VAST ad tag URL.
 * That URL will be used to construct a VAST IMAAdsRequest for that playback
 * session.
 *
 * @param adsCuePointProgressPolicy The cue point progress policy specified for
 * VAST ads requests cue points. If this parameter is nil, `+[BCOVCuePointProgressPolicy progressPolicyProcessingCuePoints:BCOVProgressPolicyProcessAllCuePoints resumingPlaybackFrom:BCOVProgressPolicyResumeFromContentPlayhead ignoringPreviouslyProcessedCuePoints:NO]`
 * will be used as default.
 * @param adDisplayContainer IMAAdDisplayContainer instance used to create an
 * IMAAdsRequest.
 * @return An ads request policy that generates VAST IMAAdsRequests from
 * information in each playback video's `BCOVCuePoint.properties`.
 */
+ (instancetype)adsRequestPolicyWithVASTAdTagsInCuePointsAndAdsCuePointProgressPolicy:(BCOVCuePointProgressPolicy *)adsCuePointProgressPolicy adDisplayContainer:(IMAAdDisplayContainer *)adDisplayContainer;

/**
 * Returns an ads request policy that checks each BCOVVideo for BCOVCuePoints
 * of type 'kBCOVIMACuePointTypeAd'. The cuepoint properies will be appended on
 * ad tag as query parameters. That URL will be used to construct a VAST IMAAdsRequest
 * for that playback session.
 *
 * @param adTag The ad tag URL to include in the IMAAdsRequest this
 * policy generates.
 * @param adsCuePointProgressPolicy The cue point progress policy specified for
 * VAST ads requests cue points. If this parameter is nil, `+[BCOVCuePointProgressPolicy progressPolicyProcessingCuePoints:BCOVProgressPolicyProcessAllCuePoints resumingPlaybackFrom:BCOVProgressPolicyResumeFromContentPlayhead ignoringPreviouslyProcessedCuePoints:NO]`
 * will be used as default.
 * @param adDisplayContainer IMAAdDisplayContainer instance used to create an 
 * IMAAdsRequest.
 * @return An ads request policy that generates VAST IMAAdsRequests from
 * `adTag` and information in each playback video's `BCOVCuePoint.properties`.
 */
+ (instancetype)adsRequestPolicyFromCuePointPropertiesWithAdTag:(NSString *)adTag adsCuePointProgressPolicy:(BCOVCuePointProgressPolicy *)adsCuePointProgressPolicy adDisplayContainer:(IMAAdDisplayContainer *)adDisplayContainer;
@end
