//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/30.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation

println("*** UnitTest for Canary Framework ***")

var result = true

func test(title : String, result : Bool)
{
	print("\(title) ... ")
	if result {
		println("OK")
	} else {
		println("NG")
	}
}

println("[UTDocument] ")
let docres = UTDocument()
println("\(docres)")
result = result && docres

print("TEST RESULT ... ")
if result {
	println("OK")
} else {
	println("NG")
}


