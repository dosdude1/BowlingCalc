//
//  UIPopoverController+iPhone.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/17/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "UIPopoverController+iPhone.h"


/*! Override the method that disables the popover view controller on the iPhone */
@implementation UIPopoverController (iPhone)

+ (BOOL)_popoversDisabled {
    return NO;
}

@end
