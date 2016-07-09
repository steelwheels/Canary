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

	private static func angle2point(v:CGFloat, angle:CGFloat) -> (CGFloat, CGFloat) {
		let x = v * sin(angle)
		let y = v * cos(angle)
		return (x, y)
	}
	
	private static func point2angle(x:CGFloat, y:CGFloat) -> (CGFloat, CGFloat) {
		let angle = atan2(x, y)
		let speed = sqrt(x*x + y*y)
		return (speed, angle)
	}
	
	public init(x:CGFloat, y:CGFloat){
		mX           = x
		mY           = y
		(mV, mAngle) = CNVelocity.point2angle(x, y: y)
	}
	
	public init(v:CGFloat, angle:CGFloat){
		mV       = v
		mAngle   = angle
		(mX, mY) = CNVelocity.angle2point(v, angle: angle)
	}
	
	public var x:CGFloat {
		get{ return mX }
		set(newx) {
			mX           = newx
			(mV, mAngle) = CNVelocity.point2angle(newx, y: mY)
		}
	}
	public var y:CGFloat {
		get{ return mY }
		set(newy) {
			mY		= newy
			(mV, mAngle) = CNVelocity.point2angle(mX, y: newy)
		}
	}
	
	public var v:CGFloat {
		get{ return mV }
		set(newv){
			mV       = newv
			(mX, mY) = CNVelocity.angle2point(newv, angle: mAngle)
		}
	}
	public var angle:CGFloat {
		get{ return mAngle }
		set(newangle){
			mAngle   = newangle
			(mX, mY) = CNVelocity.angle2point(mV, angle: newangle)
		}
	}
	
	public mutating func set(x:CGFloat, y:CGFloat){
		mX           = x
		mY           = y
		(mV, mAngle) = CNVelocity.point2angle(x, y: y)
	}
	
	public mutating func set(v:CGFloat, angle:CGFloat){
		mV       = v
		mAngle   = angle
		(mX, mY) = CNVelocity.angle2point(v, angle: angle)
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



