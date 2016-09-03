/**
 * @file	CNPointExtension.h
 * @brief	Define CNPointExtension class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

extension CGPoint : CNSerializerProtocol
{
	public func dot(_ src: CGPoint) -> CGFloat {
		return (self.x * src.x) + (self.y * src.y)
	}

	public func cross(_ src: CGPoint) -> CGFloat {
		return (self.x * src.y) - (self.y * src.x)
	}

	public func normalize() -> CGPoint {
		let len = sqrt(self.x * self.x + self.y * self.y)
		var result : CGPoint
		if len != 0.0 {
			result = CGPoint(x: self.x/len, y:self.y/len)
		} else {
			result = CGPoint(x:0.0, y:0.0)
		}
		return result
	}

	public func serialize() -> Dictionary<String, AnyObject> {
		let xval = NSNumber(value: Double(self.x))
		let yval = NSNumber(value: Double(self.y))
		let dict : Dictionary<String, AnyObject> = ["x":xval, "y":yval]
		return dict
	}

	public static func unserialize(dictionary dict : Dictionary<String, AnyObject>) -> CGPoint? {
		var x,y : Double
		if let xval = dict["x"] as? NSNumber {
			x = xval.doubleValue
		} else {
			return nil
		}
		if let yval = dict["y"] as? NSNumber {
			y = yval.doubleValue
		} else {
			return nil
		}
		return CGPoint(x:CGFloat(x), y:CGFloat(y))
	}
	
	public var description: String {
		get {
			let xstr = NSString(format: "%.2lf", Double(self.x))
			let ystr = NSString(format: "%.2lf", Double(self.y))
			return "{x:\(xstr), y:\(ystr)}"
		}
	}
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func * (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: left.x * right, y: left.y * right)
}

public func * (left: CGFloat, right: CGPoint) -> CGPoint {
	return CGPoint(x:left * right.x, y:left * right.y)
}

public func / (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x:left.x / right, y:left.y / right)
}

