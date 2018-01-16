/**
 * @file	CNColor.h
 * @brief	Define CNColor class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation
import Darwin.ncurses

public enum CNColor: Int32 {
	case Black	= 0
	case Red	= 1
	case Green	= 2
	case Yellow	= 3
	case Blue	= 4
	case Magenta	= 5
	case Cyan	= 6
	case White	= 7

	public func toDarwinColor() -> Int32 {
		var result: Int32
		switch self {
		case .Black:	result = Darwin.COLOR_BLACK
		case .Red:	result = Darwin.COLOR_RED
		case .Green:	result = Darwin.COLOR_GREEN
		case .Yellow:	result = Darwin.COLOR_YELLOW
		case .Blue:	result = Darwin.COLOR_BLUE
		case .Magenta:	result = Darwin.COLOR_MAGENTA
		case .Cyan:	result = Darwin.COLOR_CYAN
		case .White:	result = Darwin.COLOR_WHITE
		}
		return result
	}
}

