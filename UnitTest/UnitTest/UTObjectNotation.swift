/**
 * @file	UTObjectNotation.swift
 * @brief	Unit test for CNObjectNotation class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTObjectNotation() -> Bool
{
	let obj0 = CNObjectNotation(identifier: "obj0", primitiveValue: CNValue.BooleanValue(value: true), lineNo: 1)
	let obj1 = CNObjectNotation(identifier: "obj1", primitiveValue: CNValue.DoubleValue(value: 12.3), lineNo: 1)
	let obj2 = CNObjectNotation(identifier: "obj2", primitiveValue: CNValue.StringValue(value: "Hello, world"), lineNo: 1)
	let obj3 = CNObjectNotation(identifier: "obj3", script: "exit(0)", lineNo: 1)
	let obj4 = CNObjectNotation(identifier: "obj4", className: "ClassA", properties: [obj2, obj3], lineNo: 1)

	for obj in [obj0, obj1, obj2, obj3, obj4] {
		encode(object: obj)
	}
	return true
}

private func encode(object: CNObjectNotation)
{
	print(CNEncodeObjectNotation(notation: object))
}
