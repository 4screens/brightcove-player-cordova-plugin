#import <UIKit/UIKit.h>

#import "BCOVPlayerSDK.h"
#import "IMAAdsRenderingSettings.h"


@interface BrightcovePluginViewController : UIViewController <BCOVPlaybackControllerDelegate, IMAWebOpenerDelegate>
- (void)requestContentFromCatalog;
- (void)setup;
@property NSString * kViewControllerCatalogToken;
@property NSString * kViewControllerPlaylistID;
@property NSString * kViewControllerIMALanguage;
@property NSString * kViewControllerIMAVMAPResponseAdTag;
@property NSString * kViewControllerVideoURL;
@end