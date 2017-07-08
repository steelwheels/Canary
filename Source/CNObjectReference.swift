/**
 * @file	CNObjecttReference.h
 * @brief	Define CNObjectReference structure
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public struct CNWeakReference<OBJTYPE: AnyObject>
{
	private weak var mObject: OBJTYPE?
	public init (object obj: OBJTYPE){
		mObject = obj
	}
	public var object: OBJTYPE {
		if let o = mObject {
			return o
		} else {
			fatalError("Can not happen")
		}
	}
}
