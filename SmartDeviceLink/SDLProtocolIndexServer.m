//
//  SDLProtocolIndexServer.m
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 12/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLProtocolIndexServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "SDLLogMacros.h"
#import "SDLLogManager.h"

@interface SDLProtocolIndexServer ()
    @property (nullable, strong, nonatomic) GCDWebServer *protocolIndexServer;
    @property (assign, nonatomic) int delayCounter;
    @property (nullable, strong, nonatomic) NSTimer *timeoutResetTimer;
@end

@implementation SDLProtocolIndexServer

- (instancetype)init {
    if (self = [super init]) {
        _delayCounter = 1;
        _protocolIndexServer = [[GCDWebServer alloc] init];
        
        __weak typeof(self) weakSelf = self;

        _timeoutResetTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 repeats:true block:^(NSTimer * _Nonnull timer) {
            weakSelf.delayCounter = 0;
        }];
        
        [_protocolIndexServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      NSDictionary *jsonDict = @{ @"delay" : [NSNumber numberWithInteger:weakSelf.delayCounter] };
                                      weakSelf.delayCounter++;
                                      return [GCDWebServerDataResponse responseWithJSONObject: jsonDict];
        }];
        
        NSDictionary *options = @{
                                  GCDWebServerOption_Port : @8888,
                                  GCDWebServerOption_AutomaticallySuspendInBackground : @false
                                  };
        NSError *error = nil;
        [_protocolIndexServer startWithOptions:options error:&error];
        
        SDLLogD(@"TCP Transport initialization");
    }
    
    return self;
}

@end
