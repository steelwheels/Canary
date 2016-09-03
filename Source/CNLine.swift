/**
 * @file	CNLine3.h
 * @brief	Define CNLine3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct CNLine {
	public var fromPoint:	CGPoint
	public var toPoint:	CGPoint

	public init(fromPoint fp: CGPoint, toPoint tp: CGPoint){
		fromPoint = fp
		toPoint	  = tp
	}
}

public struct CNLine3 {
	public var fromPoint:	CNPoint3
	public var toPoint:	CNPoint3

	public init(fromPoint fp: CNPoint3, toPoint tp: CNPoint3){
		fromPoint = fp
		toPoint	  = tp
	}
}
