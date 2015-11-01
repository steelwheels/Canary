/**
 * @file	CNGraphicsSerializer.h
 * @brief	Define CNGraphicsSerializer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNGraphicsSerializer {
	public class func serializePoint(point : CGPoint) -> Dictionary<String, AnyObject> {
		let xnum = NSNumber(double: Double(point.x))
		let ynum = NSNumber(double: Double(point.y))
		let dict : Dictionary<String, AnyObject> = ["x":xnum, "y":ynum]
		return dict
	}
	
	public class func unserializePoint(dict : Dictionary<String, AnyObject>) -> (CGPoint, NSError?) {
		var value = CGPoint(x: 0.0, y: 0.0)
		var error : NSError?
		let (xval, xerrp) = CNPrimitiveSerializer.unserializeCGFloat(dict, member: "x")
		if let xerror = xerrp {
			error = xerror
		} else {
			let (yval, yerrp) = CNPrimitiveSerializer.unserializeCGFloat(dict, member: "y")
			if let yerror = yerrp {
				error = yerror
			} else {
				value = CGPoint(x: Double(xval), y: Double(yval))
				error = nil
			}
		}
		return (value, error)
	}
	
	public class func serializeSize(size : CGSize) -> Dictionary<String, AnyObject> {
		let wnum = NSNumber(double: Double(size.width))
		let hnum = NSNumber(double: Double(size.height))
		let dict : Dictionary<String, AnyObject> = ["width":wnum, "height":hnum]
		return dict
	}
	
	public class func unserializeSize(dict : Dictionary<String, AnyObject>) -> (CGSize, NSError?) {
		var value = CGSize(width: 0.0, height: 0.0)
		var error : NSError?
		let (wval, werrp) = CNPrimitiveSerializer.unserializeCGFloat(dict, member: "width")
		if let werror = werrp {
			error = werror
		} else {
			let (hval, herrp) = CNPrimitiveSerializer.unserializeCGFloat(dict, member: "height")
			if let herror = herrp {
				error = herror
			} else {
				value = CGSize(width: Double(wval), height: Double(hval))
				error = nil
			}
		}
		return (value, error)
	}
}

