/**
 * @file	CNObject.h
 * @brief	Define CNObject class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

#if os(iOS)
	extension NSObject {
		public var className: String
		{
			return NSStringFromClass(type(of: self))
		}
	}
#endif

