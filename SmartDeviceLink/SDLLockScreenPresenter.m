//
//  SDLLockScreenPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenPresenter.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenPresenter ()
@property(nonatomic, strong) UIWindow *lockScreenWindow;
@end


@implementation SDLLockScreenPresenter

/*
 viewManager.sdlWindow.resignKey()
 viewManager.sdlWindow.isHidden = true
 UIApplication.shared.windows.first?.makeKeyAndVisible()
 
 viewManager.sdlWindow.windowLevel = UIWindowLevelNormal - 1
 viewManager.sdlWindow.isHidden = false
 */

- (void)present {
    if (!self.lockViewController) {
        return;
    }
    
    if (!self.lockScreenWindow) {
        self.lockScreenWindow = [[UIWindow alloc] init];
        self.lockScreenWindow.windowLevel = UIWindowLevelAlert + 1;
        self.lockScreenWindow.rootViewController = self.lockViewController;
        self.lockScreenWindow.backgroundColor = [UIColor clearColor];
    }
    
    self.lockScreenWindow.hidden = false;
    
    //[[self.class sdl_getCurrentViewController] presentViewController:self.viewController animated:YES completion:nil];
}

- (void)dismiss {
    if (!self.lockViewController) {
        return;
    }
    
    [self.lockScreenWindow resignKeyWindow];
    self.lockScreenWindow.hidden = true;
    [[UIApplication sharedApplication].windows.firstObject makeKeyAndVisible];
    
    //[self.viewController dismissViewControllerAnimated:true completion:nil];
    //[self.viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)presented {
    if (!self.lockViewController) {
        return NO;
    }
    
    return (self.lockViewController.isViewLoaded && (self.lockViewController.view.window || self.lockViewController.isBeingPresented));
}

+ (UIViewController *)sdl_getCurrentViewController {
    return [SDLLockScreenPresenter topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [SDLLockScreenPresenter topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [SDLLockScreenPresenter topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [SDLLockScreenPresenter topViewController:rootViewController];
    }
    return rootViewController;
}

@end

NS_ASSUME_NONNULL_END

