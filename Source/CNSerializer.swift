/**
 * @file	CNSerializer.h
 * @brief	Define CNGraphicsSerializer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNSerializer
{
	public class func serializePoint(point : CGPoint) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["x":point.x, "y":point.y]
		return dict
	}
	
	public class func unserializePoint(dict : Dictionary<String, AnyObject>) -> CGPoint? {
		var x, y: CGFloat
		if let tx = dict["x"] as? CGFloat {
			x = tx
		} else {
			return nil
		}
		if let ty = dict["y"] as? CGFloat {
			y = ty
		} else {
			return nil
		}
		return CGPointMake(x, y)
	}
	
	public class func serializeSize(size : CGSize) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["width":size.width, "height":size.height]
		return dict
	}
	
	public class func unserializeSize(dict : Dictionary<String, AnyObject>) -> CGSize? {
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

