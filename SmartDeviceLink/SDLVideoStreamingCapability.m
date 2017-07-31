//
//  SDLVideoStreamingCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLImageResolution.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingFormat.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingCapability

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithVideoStreaming:(nullable SDLImageResolution *)preferredResolution maxBitrate:(nullable NSNumber *)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    self = [self init];
    if (!self) {
        return self;
    }

    self.maxBitrate = maxBitrate;
    self.preferredResolution = preferredResolution;
    self.supportedFormats = [supportedFormats mutableCopy];

    return self;
}

- (void)setPreferredResolution:(nullable SDLImageResolution *)preferredResolution {
    [store sdl_setObject:preferredResolution forName:SDLNamePreferredResolution];
}

- (nullable SDLImageResolution *)preferredResolution {
    return [store sdl_objectForName:SDLNamePreferredResolution];
}

- (void)setMaxBitrate:(nullable NSNumber *)maxBitrate {
    [store sdl_setObject:maxBitrate forName:SDLNameMaxBitrate];
}

- (nullable NSNumber *)maxBitrate {
    return [store sdl_objectForName:SDLNameMaxBitrate];
}

- (void)setSupportedFormats:(nullable NSMutableArray *)supportedFormats {
    [store sdl_setObject:supportedFormats forName:SDLNameSupportedFormats];
}

- (nullable NSMutableArray *)supportedFormats {
    return [store sdl_objectForName:SDLNameSupportedFormats];
}

@end

NS_ASSUME_NONNULL_END
