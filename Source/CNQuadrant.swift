/**
 * @file	CNQuadrant.swift
 * @brief	Define CNQuadrant class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics

public enum CNQuadrant {
	case firstQuadrant
	case secondQuadrant
	case thirdQuadrant
	case fourthQuadrant
	
	public static func quadrantByAngle(angle src: CGFloat) -> CNQuadrant {
		let PI = CGFloat(M_PI)
		var quadrant: CNQuadrant
		if PI*0.0<=src && src<PI*0.5 {
			quadrant = .firstQuadrant
		} else if PI*0.5<=src && src<PI*1.0 {
			quadrant = .secondQuadrant
		} else if PI*1.0<=src && src<PI*1.5 {
			quadrant = .thirdQuadrant
		} else { // if PI*1.5<=src && src<PI*2.0
			quadrant = .fourthQuadrant
		}
		return quadrant
	}
}
