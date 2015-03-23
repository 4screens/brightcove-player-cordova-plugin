#import <Cordova/CDV.h>

@interface BrightcovePlayerPlugin : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)setLanguage:(CDVInvokedUrlCommand*)command;
- (void)playByUrl:(CDVInvokedUrlCommand*)command;
- (void)playById:(CDVInvokedUrlCommand*)command;
- (BOOL)validateUrl:(NSString *)url;

@end