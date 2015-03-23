#import "BrightcovePlayer.h"
#import <Cordova/CDV.h>

@implementation BrightcovePlayerPlugin

NSString *token = nil;
NSString *lang = nil;

- (void)init:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;

  if ([[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]]) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty Brightcove token!"];
  } else{
    self.token = [command.arguments objectAtIndex:0];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Inited"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setLanguage:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
    
  if ([[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]]) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please set language!"];
  } else {
    self.lang = [command.arguments objectAtIndex:0];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Language inited"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)playByUrl:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
    
  if ([[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]]) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"URL is empty!"];
  } else {
    NSString* url = [command.arguments objectAtIndex:0];
      
    if ([self validateUrl:url]) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Playing now with URL: %@", url]];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"URL is not valid!"];
    }
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)playById:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    if (self.token == nil && ![self.token length]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please init the brightcove with token!"];
    } else {
    
      if ([[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty video ID!"];
      } else {
        NSString* url = [command.arguments objectAtIndex:0];
        
        if ([self validateUrl:url]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Playing now with Brightcove ID: %@", url]];
        }
      }
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (BOOL)validateUrl:(NSString *)url {
  NSURL *testURL = [NSURL URLWithString:url];
  if (testURL == nil) {
    return NO;
  }
  else {
    return YES;
  }
}

@end