/**
 * @file	CNObjectVisitor.h
 * @brief	Define CNObjectVisitor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNObjectVisitor : NSObject
{
	public func acceptObject(object : NSObject){
		if let number = object as? NSNumber {
			visit(number: number)
		} else if let str = object as? NSString {
			visit(string: str)
		} else if let date = object as? NSDate {
			visit(date: date)
		} else if let dict = object as? NSDictionary {
			visit(dictionary: dict)
		} else if let arr = object as? NSArray {
			visit(array: arr)
		} else {
			visit(object: object)
		}
	}
	
	public func visit(number n: NSNumber)		{		}
	public func visit(string s: NSString)		{		}
	public func visit(date d: NSDate)		{		}
	public func visit(dictionary d: NSDictionary)	{		}
	public func visit(array  a: NSArray)		{		}
	public func visit(object o: NSObject)		{		}
}

