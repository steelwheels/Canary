/**
 * @file		UTGraphicsSerializer.h
 * @brief	Unit test for CNGraphicsSerializer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Canary

public func UTGraphicsSerializer() -> Bool {
	var result = true
	result = UTPointSerializer() && result
	result = UTSizeSerializer() && result
	return result
}

private func UTPointSerializer() -> Bool {
	let point = CGPoint(x: 1.2, y: 3.4)
	let pointdict = CNGraphicsSerializer.serializePoint(point)
	print("pointdict = \(pointdict) -> ", terminator: "")
	
	var result = false
	let (retpt, pterrp) = CNGraphicsSerializer.unserializePoint(pointdict)
	if let pterror = pterrp {
		print("NG (\(pterror.toString())")
	} else {
		if(retpt.x == point.x && retpt.y == point.y){
			print("OK")
			result = true
		} else {
			print("NG \(retpt.x) != \(point.x) or \(retpt.y) != \(point.y)")
		}
	}
	return result
}

private func UTSizeSerializer() -> Bool {
	let size = CGSize(width: 5.6, height: 7.8)
	let sizedict = CNGraphicsSerializer.serializeSize(size)
	print("sizedict = \(sizedict) -> ", terminator: "")
	
	var result = false
	let (retsz, szerrp) = CNGraphicsSerializer.unserializeSize(sizedict)
	if let szerror = szerrp {
		print("NG (\(szerror.toString())")
	} else {
		if(retsz.width == size.width && retsz.height == size.height){
			print("OK")
			result = true
		} else {
			print("NG \(retsz.width) != \(size.width) or \(retsz.height) != \(size.height)")
		}
	}
	return result
}
