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
#import "SDLNotificationConstants.h"

@interface SDLProtocolIndexServer ()
@property (nullable, strong, nonatomic) GCDWebServer *protocolIndexServer;
@property (nonnull, strong, nonatomic) NSMutableArray *availableDelays;
@property (nonnull, strong, nonatomic) NSMutableArray *inUseDelays;
//@property (assign, nonatomic) double delayCounter;
@property (assign, nonatomic) BOOL sdlConnected;
@property (nullable, strong, nonatomic) NSTimer *timeoutResetTimer;
@end

@implementation SDLProtocolIndexServer

+ (SDLProtocolIndexServer *)sharedInstance {
    static SDLProtocolIndexServer *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    if (!sharedInstance) {
        sharedInstance = [[SDLProtocolIndexServer alloc] init];
    }
    
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        //_delayCounter = 2.5;
        _sdlConnected = false;
        _availableDelays = [@[@3,@4,@5,@6,@7,@8,@9,@10] mutableCopy];
        _inUseDelays = [NSMutableArray new];
        _protocolIndexServer = [[GCDWebServer alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdlDisconnect:) name:@"SDLDed" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdlConnect:) name:SDLDidBecomeReady object:nil];
        
        __weak typeof(self) weakSelf = self;
        
        _timeoutResetTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:true block:^(NSTimer * _Nonnull timer) { //this logic should be more robust.
            NSNumber *releasedDelay = [weakSelf.inUseDelays firstObject];
            if (releasedDelay) {
                [weakSelf.inUseDelays removeObject:releasedDelay];
                [weakSelf.availableDelays addObject:releasedDelay];
            }
        }];
        
        [_protocolIndexServer addDefaultHandlerForMethod:@"GET"
                                            requestClass:[GCDWebServerRequest class]
                                            processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                                @synchronized(weakSelf.availableDelays) {
                                                    if (weakSelf.sdlConnected) {
                                                        NSNumber *selectedDelay = [weakSelf.availableDelays firstObject];
                                                        if (selectedDelay) {
                                                            [weakSelf.availableDelays removeObject:selectedDelay];
                                                            [weakSelf.inUseDelays addObject:selectedDelay];
                                                        }
                                                        NSDictionary *jsonDict = @{ @"delay" : [NSNumber numberWithDouble:selectedDelay.doubleValue?:-1] };
                                                        SDLLogD(@"App connection approved, sending delay value: %f", selectedDelay.doubleValue?:-1);
                                                        return [GCDWebServerDataResponse responseWithJSONObject: jsonDict];
                                                    } else {
                                                        NSDictionary *jsonDict = @{ @"delay" : [NSNumber numberWithDouble:-1] };
                                                        SDLLogD(@"[SoC]: Requesting app to standby");
                                                        return [GCDWebServerDataResponse responseWithJSONObject: jsonDict];
                                                    }
                                                }
                                            }];
        
        NSDictionary *options = @{
                                  GCDWebServerOption_Port : @8888,
                                  GCDWebServerOption_AutomaticallySuspendInBackground : @false
                                  };
        NSError *error = nil;
        [_protocolIndexServer startWithOptions:options error:&error];
        
        if (error) {
            SDLLogD(@"Server binding failed. Probably an instance running already.");
            return nil;
        }
        
        SDLLogD(@"TCP Transport initialization");
    }
    
    return self;
}

-(void)sdlDisconnect:(NSNotification *)notif {
    self.availableDelays = [@[@3,@4,@5,@6,@7,@8,@9,@10] mutableCopy];
    self.inUseDelays = [NSMutableArray new];
    SDLLogD(@"SoC Disconnected");
    self.sdlConnected = false;
}

-(void)sdlConnect:(NSNotification *)notif {
    SDLLogD(@"SoC Connected");
    self.sdlConnected = true;
}

-(void)dispose {
    [self.protocolIndexServer stop];
    self.sdlConnected = false;
    self.protocolIndexServer = nil;
}

@end
