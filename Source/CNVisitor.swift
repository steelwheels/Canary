/**
 * @file	CNVisitor.h
 * @brief	Define CNVisitor class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

open class CNVisitor
{
	public init() {
	}

	public func accept(any anyobj: Any)
	{
		/**
		 * FIX ME: the order to determine the data type is IMPORTANT
		 */
		if let v = anyobj as? NSNumber {
			accept(number: v)
		} else if let v = anyobj as? Date {
			visit(date: v)
		} else if let v = anyobj as? Array<Any> {
			visit(array: v)
		} else if let v = anyobj as? Set<AnyHashable> {
			visit(set: v)
		} else if let v = anyobj as? Dictionary<AnyHashable, Any> {
			visit(dictionary: v)
		} else if let v = anyobj as? Bool {
			visit(bool: v)
		} else if let v = anyobj as? Character {
			visit(character: v)
		} else if let v = anyobj as? Int {
			visit(int: v)
		} else if let v = anyobj as? UInt {
			visit(uInt: v)
		} else if let v = anyobj as? Float {
			visit(float: v)
		} else if let v = anyobj as? Double {
			visit(double: v)
		} else if let v = anyobj as? String {
			visit(string: v)
		} else {
			visit(any: anyobj)
		}
	}

	public func accept(number obj: NSNumber) {
		switch obj.decodeKind() {
		case .int8Number:
			visit(int: Int(obj.int8Value))
		case .int16Number:
			visit(int: Int(obj.int16Value))
		case .int32Number:
			visit(int: Int(obj.int32Value))
		case .int64Number:
			visit(int: Int(obj.int64Value))
		case .uInt8Number:
			visit(uInt: UInt(obj.uint8Value))
		case .uInt16Number:
			visit(uInt: UInt(obj.uint16Value))
		case .uInt32Number:
			visit(uInt: UInt(obj.uint32Value))
		case .uInt64Number:
			visit(uInt: UInt(obj.uint64Value))
		case .floatNumber:
			visit(float: obj.floatValue)
		case .doubleNumber:
			visit(double: obj.doubleValue)
		}
	}

	open func visit(bool		val: Bool)				{		}
	open func visit(character	val: Character)				{		}
	open func visit(int		val: Int)				{		}
	open func visit(uInt		val: UInt)				{		}
	open func visit(float		val: Float)				{		}
	open func visit(double		val: Double)				{		}
	open func visit(string		val: String)				{		}
	open func visit(date		val: Date)				{		}
	open func visit(array		val: Array<Any>)			{		}
	open func visit(set		val: Set<AnyHashable>)			{		}
	open func visit(dictionary	val: Dictionary<AnyHashable, Any>)	{		}
	open func visit(any		val: Any)				{		}
}
