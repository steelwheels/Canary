//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2016/08/14.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation

print("Hello, World!")

print("*** UTURLTest")
let result0 = UTURLTest()

let result = result0
if result0 {
	print("[SUMMARY] PASSED")
	exit(0)
} else {
	print("[SUMMARY] Faield")
	exit(1)
}
