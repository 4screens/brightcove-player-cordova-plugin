#import <Cordova/CDV.h>
#import "BrightcovePluginViewController.h"

@interface BrightcovePlayerPlugin : CDVPlugin <BrightcovePlayerPluginViewDelegate>

@property NSString *token;
@property NSString *lang;
@property BrightcovePluginViewController *brightcoveView;
@property UIStoryboard *storyboard;

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)setLanguage:(CDVInvokedUrlCommand*)command;
- (void)playByUrl:(CDVInvokedUrlCommand*)command;
- (void)playById:(CDVInvokedUrlCommand*)command;
- (BOOL)validateUrl:(NSString *)url;
- (void)initBrightcoveView;

@end