/**
 * @file	CNPointExtension.h
 * @brief	Define CNPointExtension class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

extension CGPoint : CNSerializerProtocol
{
	public func serialize() -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["x":self.x, "y":self.y]
		return dict
	}

	public static func unserialize(dict : Dictionary<String, AnyObject>) -> CGPoint? {
		var x,y : CGFloat
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
	
	public var description: String {
		get {
			let xstr = NSString(format: "%.2lf", Double(self.x))
			let ystr = NSString(format: "%.2lf", Double(self.y))
			return "{x:\(xstr), y:\(ystr)}"
		}
	}
}
