/**
 * @file	CNObjectVisitor.h
 * @brief	Define CNObjectVisitor class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

open class CNObjectVisitor : NSObject
{
	public func acceptObject(object : AnyObject){
		if let number = object as? NSNumber {
			visit(number: number)
		} else if let str = object as? String {
			visit(string: str)
		} else if let date = object as? Date {
			visit(date: date)
		} else if let dict = object as? [String:AnyObject] {
			visit(dictionary: dict)
		} else if let arr = object as? [AnyObject] {
			visit(array: arr)
		} else {
			visit(object: object)
		}
	}
	
	open func visit(number n: NSNumber)			{		}
	open func visit(string s: String)			{		}
	open func visit(date d: Date)				{		}
	open func visit(dictionary d: [String:AnyObject])	{		}
	open func visit(array  a: [AnyObject])			{		}
	open func visit(object o: AnyObject)			{		}
}

