//
//  UTObjectVisitor.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/08/19.
//  Copyright 2016, 2017 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTObjectVisitor() -> Bool
{
	let  visitor = UTVisitor()

	accept(visitor: visitor, object: 1 as AnyObject)
	accept(visitor: visitor, object: NSNumber(value: 3.14))
	accept(visitor: visitor, object: "String object" as AnyObject)
	accept(visitor: visitor, object: NSString(string: "NSString object"))

	accept(visitor: visitor, object: NSDictionary(dictionary: ["a":0, "b":1]))
	accept(visitor: visitor, object: NSArray(array: [1, 2, 3]))
	accept(visitor: visitor, object: NSArray(array: ["a", "b", "c"]))
	accept(visitor: visitor, object: NSArray(arrayLiteral: NSNumber(value: 1.1), NSNumber(value: 2.2), NSNumber(value: 3.3)))

	return true
}

private func accept(visitor v: UTVisitor, object o: AnyObject)
{
	v.acceptObject(object: o)
}

class UTVisitor : CNObjectVisitor
{
	public override func visit(number n: NSNumber) {
		print("visit(number: \(n.description))")
	}
	public override func visit(string s: String){
		print("visit(string: \(s))")
	}
	public override func visit(date d: Date){
		print("visit(data: \(d.description))")
	}
	public override func visit(dictionary d: [String:AnyObject]){
		print("visit(dictionary: \(d.description))")
	}
	public override func visit(array  a: [AnyObject]){
		print("visit(array: \(a.description))")
	}
	public override func visit(object o: AnyObject){
		if let type = o.className as NSString? {
			print("visit(object: \(type.description):\(o))")
		} else {
			print("")
		}
	}
}
