//
//  SDLInterfaceManager.h
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 7/30/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLInterfaceManager : NSObject
- (instancetype)initWithWindow:(UIWindow *)window;
- (void)updateInterfaceLayout;

#pragma mark debug functions
- (void)highlightAllViews;
@end
