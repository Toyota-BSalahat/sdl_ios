//
//  SDLHapticInterface.h
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 8/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDLHapticInterface <NSObject>

- (instancetype)initWithWindow:(UIWindow *)window;
- (void)updateInterfaceLayout;
// additional method should be added to allow pure openGL apps to specify an array of spatial data directly

@end
