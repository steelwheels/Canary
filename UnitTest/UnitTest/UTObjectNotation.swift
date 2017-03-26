//  UTObjectCoder.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/09/10.
//  Copyright (C) 2016, 2017 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTObjectNotation() -> Bool
{
	let prim0 = CNObjectNotation(label: "lab0", primitiveValue: CNValue.BooleanValue(value: true))
	let prim1 = CNObjectNotation(label: "lab1", primitiveValue: CNValue.StringValue(value: "Hello"))
	let obj2  = CNObjectNotation(label: nil, className: "Dictionary", objectValues: [prim0, prim1])

	encode(object: prim0)
	encode(object: prim1)
	encode(object: obj2)
	return true
}

private func encode(object: CNObjectNotation)
{
	print(CNObjectCoder.encode(notation: object))
}
