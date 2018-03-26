/**
 * @file	CNKey.swift
 * @brief	Define CNKey class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)

import Foundation
import Darwin.ncurses

public class CNKey {
	public static let Up		: Int32	= Darwin.KEY_UP
	public static let Down		: Int32	= Darwin.KEY_DOWN
	public static let Left		: Int32	= Darwin.KEY_LEFT
	public static let Right		: Int32	= Darwin.KEY_RIGHT
	public static let Backspace	: Int32	= Darwin.KEY_BACKSPACE
	public static let Delete	: Int32	= Darwin.KEY_DC
	public static let Insert	: Int32	= Darwin.KEY_IC

	public class func description(key k: Int32) -> String? {
		let result : String?
		switch k {
		case CNKey.Up:		result = "Up"
		case CNKey.Down:	result = "Down"
		case CNKey.Left:	result = "Left"
		case CNKey.Right:	result = "Right"
		case CNKey.Backspace:	result = "Backspace"
		case CNKey.Delete:	result = "Delete"
		case CNKey.Insert:	result = "Insert"
		default:		result = nil
		}
		return result
	}
}

#endif // os(OSX)

