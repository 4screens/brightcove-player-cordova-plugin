#import "BCOVIMA.h"

#import "BrightcovePluginViewController.h"


// ** Customize these values with your own account information **


@interface BrightcovePluginViewController () <BCOVPlaybackControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) BCOVCatalogService *catalogService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;

@property (nonatomic, assign) BOOL adIsPlaying;
@property (nonatomic, assign) BOOL isBrowserOpen;
@property (nonatomic, strong) id<NSObject> notificationReceipt;
@property BCOVPlayerSDKManager *manager;


- (void)requestContentFromCatalog;

@end


@implementation BrightcovePluginViewController

NSString * kViewControllerIMAVMAPResponseAdTag = nil;

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark Setup Methods

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_notificationReceipt];
}

- (void)viewDidLoad
{
    NSLog(@"VideoID: %@, Token: %@, Lang: %@, Vast: %@, VideoURL: %@", self.kViewControllerPlaylistID, self.kViewControllerCatalogToken, self.kViewControllerIMALanguage, self.kViewControllerIMAVMAPResponseAdTag, self.kViewControllerVideoURL);
    if (self.kViewControllerIMAVMAPResponseAdTag != nil && [self.kViewControllerIMAVMAPResponseAdTag length]) {
        kViewControllerIMAVMAPResponseAdTag = self.kViewControllerIMAVMAPResponseAdTag;
    }
    
    [super viewDidLoad];

    [self setup];
    
    self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0.0, 1.0);
    
    self.playbackController.view.frame = self.videoContainer.bounds;
    self.playbackController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.videoContainer insertSubview:self.playbackController.view atIndex:0];
}

- (void)setup
{
    NSLog(@"%@", self.kViewControllerCatalogToken);
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    
    self.manager = manager;
    

    IMASettings *imaSettings = [[IMASettings alloc] init];
    imaSettings.language = self.kViewControllerIMALanguage;

    IMAAdsRenderingSettings *renderSettings = [[IMAAdsRenderingSettings alloc] init];
    renderSettings.webOpenerPresentingController = self;
    renderSettings.webOpenerDelegate = self;

    IMAAdDisplayContainer *adDisplayContainer = [[IMAAdDisplayContainer alloc] initWithAdContainer:self.videoContainer companionSlots:nil];
    
    BCOVIMAAdsRequestPolicy *adsRequestPolicy = [BCOVIMAAdsRequestPolicy videoPropertiesVMAPAdTagUrlAdsRequestPolicyWithAdDisplayContainer:adDisplayContainer];
    
    self.playbackController = [manager createIMAPlaybackControllerWithSettings:imaSettings adsRenderingSettings:renderSettings adsRequestPolicy:adsRequestPolicy viewStrategy:[manager defaultControlsViewStrategy]];
    self.playbackController.delegate = self;
    self.playbackController.autoAdvance = YES;
    self.playbackController.autoPlay = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (self.kViewControllerCatalogToken != nil && [self.kViewControllerCatalogToken length] && self.kViewControllerPlaylistID != nil && [self.kViewControllerPlaylistID length])
    {
      self.catalogService = [[BCOVCatalogService alloc] initWithToken:self.kViewControllerCatalogToken];
      [self requestContentFromCatalog];
    } else if (self.kViewControllerVideoURL != nil && [self.kViewControllerVideoURL length]){
      [self playVideoFromUrl];
    }
    

    [self resumeAdAfterForeground];
}

- (void)resumeAdAfterForeground
{

    BrightcovePluginViewController * __weak weakSelf = self;

    self.notificationReceipt = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {

        BrightcovePluginViewController *strongSelf = weakSelf;

        if (strongSelf.adIsPlaying && !strongSelf.isBrowserOpen)
        {
          [strongSelf.playbackController resumeAd];
        }

    }];
}

#pragma mark Data manipulation methods

- (void)playVideoFromUrl
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    NSURL *videoUrl = [[NSURL alloc] initWithString:self.kViewControllerVideoURL];
    
    BCOVSource *source = [[BCOVSource alloc] initWithURL:videoUrl];
    
    BCOVVideo *video = [[BCOVVideo alloc] initWithSource:source cuePoints:nil properties:[NSDictionary dictionary]];
    
    NSMutableArray *videoArray = [self retrieveVideoArray:video];
    
    [self.playbackController setVideos:videoArray];
}

- (void)requestContentFromCatalog
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self.catalogService findVideoWithReferenceID:self.kViewControllerPlaylistID parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        if (video)
        {
            NSMutableArray *videoArray = [self retrieveVideoArray:video];
            [self.playbackController setVideos:videoArray];
        }
        else
        {
            NSLog(@"BrightcovePluginViewController Debug - Error retrieving video: %@", error);
        }
        
    }];
}

- (NSMutableArray *)retrieveVideoArray:(BCOVVideo *)video{
    NSMutableArray *videoArray = [NSMutableArray arrayWithCapacity:1];
    if (self.kViewControllerIMAVMAPResponseAdTag != nil && [self.kViewControllerIMAVMAPResponseAdTag length])
    {
        [videoArray addObject:[BrightcovePluginViewController updateVideoWithVMAPTag:video]];
    } else {
        [videoArray addObject:video];
    }
    
    return videoArray;
}

+ (BCOVVideo *)updateVideoWithVMAPTag:(BCOVVideo *)video
{
    return [video update:^(id<BCOVMutableVideo> mutableVideo) {

        NSDictionary *adProperties = @{ kBCOVIMAAdTag : kViewControllerIMAVMAPResponseAdTag };

        NSMutableDictionary *propertiesToUpdate = [mutableVideo.properties mutableCopy];
        [propertiesToUpdate addEntriesFromDictionary:adProperties];
        mutableVideo.properties = propertiesToUpdate;

    }];
}

#pragma mark BCOVPlaybackControllerDelegate Methods

- (void)playbackController:(id<BCOVPlaybackController>)controller didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    NSLog(@"ViewController Debug - Advanced to new session.");
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    NSString *type = lifecycleEvent.eventType;

    if ([type isEqualToString:kBCOVIMALifecycleEventAdsLoaderLoaded])
    {
        NSLog(@"BrightcovePluginViewController Debug - Ads loaded.");
    }
    else if ([type isEqualToString:kBCOVIMALifecycleEventAdsManagerDidReceiveAdEvent])
    {
        IMAAdEvent *adEvent = lifecycleEvent.properties[@"adEvent"];

        switch (adEvent.type)
        {
            case kIMAAdEvent_STARTED:
                NSLog(@"BrightcovePluginViewController Debug - Ad Started.");
                self.adIsPlaying = YES;
                break;
            case kIMAAdEvent_COMPLETE:
                NSLog(@"BrightcovePluginViewController Debug - Ad Completed.");
                self.adIsPlaying = NO;
                break;
            case kIMAAdEvent_ALL_ADS_COMPLETED:
                NSLog(@"BrightcovePluginViewController Debug - All ads completed.");
                break;
            default:
                break;
        }
    }
}

#pragma mark UI Styling

- (void)clearInstance{
    self.view = nil;
    self.videoContainer = nil;
    self.manager = nil;
    self.playbackController = nil;
    self.notificationReceipt = nil;
    self.catalogService = nil;
    self.kViewControllerIMAVMAPResponseAdTag = nil;
    self.kViewControllerPlaylistID = nil;
    self.kViewControllerVideoURL = nil;
    self.kViewControllerCatalogToken = nil;
    self.kViewControllerIMALanguage = nil;
}

- (IBAction)dismissVideoView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self.playbackController pause];
        [self.playbackController pauseAd];
        [self clearInstance];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end