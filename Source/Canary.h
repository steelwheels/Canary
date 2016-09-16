//
//  Canary.h
//  Canary
//
//  Created by Tomoo Hamada on 2016/01/07.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

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


