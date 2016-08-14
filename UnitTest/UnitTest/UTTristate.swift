//
//  UTTristate.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/06/05.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTTristateTest() -> Bool
{
	printTristate(.Unknown)
	return true
}

internal func printTristate(state: CNTristate)
{
	print("state = \(state.description)")
}
