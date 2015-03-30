//
// BCOVIMASessionProvider.h
// BCOVIMA
//
// Copyright (c) 2014 Brightcove, Inc. All rights reserved.
// License: https://accounts.brightcove.com/en/terms-and-conditions
//

#import <Foundation/Foundation.h>

#import "BCOVPlayerSDK.h"

/**
 * Session provider implementation that delivers playback sessions with support
 * for Interactive Media Ads.
 *
 * Instances of this class should not be created directly by clients of the
 * Brightcove Player SDK for iOS; instead use the `-[BCOVPlayerSDKManager createIMASessionProviderWithSettings:adsRenderingSettings:adsRequestPolicy:upstreamSessionProvider:]`
 * factory method (which is added as a category method).
 */
@interface BCOVIMASessionProvider : NSObject <BCOVPlaybackSessionProvider>

@end
