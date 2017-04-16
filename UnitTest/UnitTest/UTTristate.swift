/**
 * @file	UTTriState.swift
 * @brief	Unit test for CNTriState class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Foundation
import Canary

public func UTTristateTest() -> Bool
{
	printTristate(state: .Unknown)
	return true
}

internal func printTristate(state stat: CNTristate)
{
	print("state = \(stat.description)")
}

