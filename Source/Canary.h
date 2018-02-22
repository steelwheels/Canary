/*
 * @file	Canary.h
 * @brief	Objective-C header file for Canary Framework
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <Cocoa/Cocoa.h>
#endif

//! Project version number for Canary.
FOUNDATION_EXPORT double CanaryVersionNumber;

//! Project version string for Canary.
FOUNDATION_EXPORT const unsigned char CanaryVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Canary/PublicHeader.h>





