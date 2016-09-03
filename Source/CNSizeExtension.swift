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
		let wval = NSNumber(value: Double(width))
		let hval = NSNumber(value: Double(height))
		let dict : Dictionary<String, AnyObject> = ["width":wval, "height":hval]
		return dict
	}
	
	public static func unserialize(dictionary dict : Dictionary<String, AnyObject>) -> CGSize? {
		var width, height : Double
		if let wval = dict["width"] as? NSNumber {
			width = wval.doubleValue
		} else {
			return nil
		}
		if let hval = dict["height"] as? NSNumber {
			height = hval.doubleValue
		} else {
			return nil
		}
		return CGSize(width: CGFloat(width), height: CGFloat(height))
	}
	
	public var description: String {
		get {
			let wstr = NSString(format: "%.2lf", self.width)
			let hstr = NSString(format: "%.2lf", self.height)
			return "{width:\(wstr), height:\(hstr)}"
		}
	}
}
