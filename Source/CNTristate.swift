/*
 * @file	CNTristate.h
 * @brief	Define CNTristate class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

/**
  The data type to present tri-state: Yes, No and Unknown
 */
public enum CNTristate {
	case Unknown
	case No
	case Yes
	
	public var description: String {
		get {
			var descstr = "?"
			switch self {
			case .Unknown:	descstr = "Unknown"
			case .No:	descstr = "No"
			case .Yes:	descstr = "Yes"
			}
			return descstr
		}
	}
}
