/*
 * @file	CNSerializerProtocol.h
 * @brief	Define CNSerializerProtocol class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public protocol CNSerializerProtocol
{
	func serialize() -> Dictionary<String, AnyObject>
	static func unserialize(src: Dictionary<String, AnyObject>) -> Self?
}


