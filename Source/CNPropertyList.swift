/**
 * @file	CNPropertyList.swift
 * @brief	Define CNPropertyList class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNPropertyList
{
	public static var version: String? {
		get {
			if let str = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? NSString {
				return String(str)
			}
			return nil
		}
	}
}
