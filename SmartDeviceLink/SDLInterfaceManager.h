//
//  SDLInterfaceManager.h
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 7/30/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLHapticInterface.h"
#import "SDLHapticHitTester.h"

@interface SDLInterfaceManager : NSObject <SDLHapticInterface, SDLHapticHitTester>
- (instancetype)initWithWindow:(UIWindow *)window;
- (void)updateInterfaceLayout;

@end
