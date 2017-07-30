//
//  SDLTableViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 7/30/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLTableViewController.h"
#import "SDLNotificationConstants.h"

@interface SDLTableViewController ()

@end

@implementation SDLTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLProjectionViewUpdate object:nil];
}

@end
