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
			visitNumberObject(number)
		} else if let str = object as? NSString {
			visitStringObject(str)
		} else if let date = object as? NSDate {
			visitDateObject(date)
		} else if let dict = object as? NSDictionary {
			visitDictionaryObject(dict)
		} else if let arr = object as? NSArray {
			visitArrayObject(arr)
		} else {
			visitUnknownObject(object)
		}
	}
	
	public func visitNumberObject(number : NSNumber)	{		}
	public func visitStringObject(string : NSString)	{		}
	public func visitDateObject(date : NSDate)		{		}
	public func visitDictionaryObject(dict : NSDictionary)	{		}
	public func visitArrayObject(arr : NSArray)		{		}
	public func visitUnknownObject(obj : NSObject)		{		}
}

