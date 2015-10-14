/**
 * @file	CNClassUtil.h
 * @brief	Define utility functions for Class operation
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

/**
 * @par Reference
 *	http://qiita.com/morizotter/items/9739d789d69924fd1897 (Japanese)
 */
public func CNTypeName(obj : AnyObject) -> String {
	let pathname  = NSStringFromClass(obj.dynamicType)
	var classname : String
	if let range = pathname.rangeOfString(".") {
		classname = pathname.substringFromIndex(range.endIndex)
	} else {
		classname = pathname
	}
	return classname
}
