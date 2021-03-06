/**
 * @file	CNColor.swift
 * @brief	Define CNColor class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation
#if os(OSX)
	import Darwin.ncurses
#endif // os(OSX)

public enum CNColor: Int32 {
	case Black	= 0
	case Red	= 1
	case Green	= 2
	case Yellow	= 3
	case Blue	= 4
	case Magenta	= 5
	case Cyan	= 6
	case White	= 7

	public static let Min: CNColor = CNColor.Black
	public static let Max: CNColor = CNColor.White

	public func description() -> String {
		let result: String
		switch self {
		case .Black:	result = "Black"
		case .Red:	result = "Red"
		case .Green:	result = "Green"
		case .Yellow:	result = "Yellow"
		case .Blue:	result = "Blue"
		case .Magenta:	result = "Magenta"
		case .Cyan:	result = "Cyan"
		case .White:	result = "White"
		}
		return result
	}

#if os(OSX)
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
#endif // os(OSX)
}

