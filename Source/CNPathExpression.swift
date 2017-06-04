/**
 * @file	CNPathExpression.swift
 * @brief	Define CNPathExpression class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNPathExpression
{
	public var pathElements: Array<String>

	public init(){
		pathElements = []
	}

	public init(pathElements elms: Array<String>){
		pathElements = elms
	}

	public var description: String {
		get {
			var result = ""
			var is1st  = true
			for elm in pathElements {
				if is1st {
					is1st = false
				} else {
					result += "."
				}
				result += elm
			}
			return result
		}
	}

	public func append(path str:String){
		pathElements.append(str)
	}

}
