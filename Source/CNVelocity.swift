/**
 * @file	CNVelocity.swift
 * @brief	Define CNVelocity class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct CNVelocity
{
	private var mX:		CGFloat = 0.0
	private var mY:		CGFloat = 0.0
	
	private var mV:		CGFloat = 0.0
	private var mAngle:	CGFloat	= 0.0

	private static func angle2point(v vval:CGFloat, angle aval:CGFloat) -> (CGFloat, CGFloat) {
		let x = vval * sin(aval)
		let y = vval * cos(aval)
		return (x, y)
	}
	
	private static func point2angle(x xval:CGFloat, y yval:CGFloat) -> (CGFloat, CGFloat) {
		let angle = atan2(xval, yval)
		let speed = sqrt(xval*xval + yval*yval)
		return (speed, angle)
	}
	
	public init(x xval:CGFloat, y yval:CGFloat){
		mX           = xval
		mY           = yval
		(mV, mAngle) = CNVelocity.point2angle(x: xval, y: yval)
	}
	
	public init(v vval:CGFloat, angle aval:CGFloat){
		mV       = vval
		mAngle   = aval
		(mX, mY) = CNVelocity.angle2point(v: vval, angle: aval)
	}
	
	public var x:CGFloat {
		get{ return mX }
		set(newx) {
			mX           = newx
			(mV, mAngle) = CNVelocity.point2angle(x: newx, y: mY)
		}
	}
	public var y:CGFloat {
		get{ return mY }
		set(newy) {
			mY		= newy
			(mV, mAngle) = CNVelocity.point2angle(x: mX, y: newy)
		}
	}
	
	public var v:CGFloat {
		get{ return mV }
		set(newv){
			mV       = newv
			(mX, mY) = CNVelocity.angle2point(v: newv, angle: mAngle)
		}
	}
	public var angle:CGFloat {
		get{ return mAngle }
		set(newangle){
			mAngle   = newangle
			(mX, mY) = CNVelocity.angle2point(v: mV, angle: newangle)
		}
	}
	
	public mutating func set(x xval:CGFloat, y yval:CGFloat){
		mX           = xval
		mY           = yval
		(mV, mAngle) = CNVelocity.point2angle(x: x, y: yval)
	}
	
	public mutating func set(v vval:CGFloat, angle aval:CGFloat){
		mV       = vval
		mAngle   = aval
		(mX, mY) = CNVelocity.angle2point(v: vval, angle: aval)
	}

	public var xAndY:CGPoint {
		get { return CGPointMake(mX, mY) }
	}
	
	public var longDescription: String {
		let xstr = NSString(format: "%.2lf", Double(mX))
		let ystr = NSString(format: "%.2lf", Double(mY))
		let vstr = NSString(format: "%.2lf", Double(mV))
		let astr = NSString(format: "%.2lf", Double(Double(mAngle) / M_PI))
		return "((x:\(xstr), y:\(ystr))=(v:\(vstr), angle:\(astr)PI))"
	}
	
	public var shortDescription: String {
		let vstr = NSString(format: "%.2lf", Double(mV))
		let astr = NSString(format: "%.2lf", Double(Double(mAngle) / M_PI))
		return "(v:\(vstr), angle:\(astr)PI)"
	}
	
	public static func serialize(velocity: CNVelocity) -> Dictionary<String, AnyObject> {
		var dict: Dictionary<String, AnyObject>  = [:]
		dict["x"] = velocity.x
		dict["y"] = velocity.y
		return dict
	}
}



