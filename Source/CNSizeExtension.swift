/**
 * @file	CNSozeExtension.h
 * @brief	Define CNSizeExtension class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

extension CGSize : CNSerializerProtocol
{
	public func serialize() -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["width":width, "height":height]
		return dict
	}
	
	public static func unserialize(dict : Dictionary<String, AnyObject>) -> CGSize? {
		var width, height : CGFloat
		if let w = dict["width"] as? CGFloat {
			width = w
		} else {
			return nil
		}
		if let h = dict["height"] as? CGFloat {
			height = h
		} else {
			return nil
		}
		return CGSizeMake(width, height)
	}
}
