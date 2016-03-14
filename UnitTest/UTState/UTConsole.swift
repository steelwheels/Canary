//
//  UTConsole.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/03/12.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTConsoleTest()
{
	let console = CNTextConsole()
	console.print(text: CNConsoleText(string: "Hello, World"))
}
