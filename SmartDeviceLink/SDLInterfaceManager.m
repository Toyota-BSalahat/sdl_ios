//
//  SDLInterfaceManager.m
//  SmartDeviceLink-iOS
//
//  Created by Brandon Salahat on 7/30/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLInterfaceManager.h"
#import "SDLNotificationConstants.h"

@interface SDLInterfaceManager()
@property (nonatomic, strong) UIWindow *projectionWindow;
@property (nonatomic, strong) NSMutableArray<UIView *> *focusableViews;
@end

@implementation SDLInterfaceManager

- (instancetype)initWithWindow:(UIWindow *)window {
    if ((self = [super init])) {
        self.projectionWindow = window;
        self.focusableViews = [NSMutableArray new];
        [self updateInterfaceLayout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectionViewUpdated:) name:SDLProjectionViewUpdate object:nil];
        
    }
    return self;
}

- (void)updateInterfaceLayout {
    self.focusableViews = [NSMutableArray new];
    [self parseViewHierarchy:[[self.projectionWindow subviews] lastObject]];
    
    NSUInteger preferredViewIndex = [self.focusableViews indexOfObject:[[[self.projectionWindow subviews] lastObject] preferredFocusedView]];
    if (preferredViewIndex != NSNotFound && _focusableViews.count > 1) {
        [self.focusableViews exchangeObjectAtIndex:preferredViewIndex withObjectAtIndex:0];
    }
    
    [self highlightAllViews];
    
    //Create and send RPC
}

- (void)parseViewHierarchy:(UIView *)currentView {
    if (currentView == nil) {
        NSLog(@"Error: Cannot parse nil view");
        return;
    }
    
    NSArray *focusableSubviews = [currentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.canBecomeFocused;
    }]];
    
    if (currentView.canBecomeFocused && focusableSubviews.count == 0) {
        [self.focusableViews addObject:currentView];
        return;
    } else if (currentView.subviews.count > 0) {
        NSArray *subviews = currentView.subviews;
        
        for (UIView *childView in subviews) {
            childView.layer.borderWidth = 1.0;
            childView.layer.borderColor = [[UIColor redColor] CGColor];
            [self parseViewHierarchy:childView];
        }
    } else {
        return;
    }
}

#pragma mark notifications
- (void)projectionViewUpdated:(NSNotification *)notification {
    [self updateInterfaceLayout];
}

#pragma mark debug functions
- (void)highlightAllViews {
    for (UIView *view in self.focusableViews) {
        view.layer.borderColor = [[UIColor blueColor] CGColor];
        view.layer.borderWidth = 2.0;
    }
}

@end
