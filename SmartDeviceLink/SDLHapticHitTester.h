//
//  SDLHapticInterface.h
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 8/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouch;

@protocol SDLHapticHitTester <NSObject>

- (nullable UIView *)viewForSDLTouch:(SDLTouch *_Nonnull)touch;

@end
