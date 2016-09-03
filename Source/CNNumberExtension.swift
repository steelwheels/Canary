/**
 * @file	NSNumberExtension.h
 * @brief	Define CNList class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public enum NSNumberKind:Int {
	case booleanNumber
	case int8Number
	case uInt8Number
	case int16Number
	case uInt16Number
	case int32Number
	case uInt32Number
	case int64Number
	case uInt64Number
	case doubleNumber
	case floatNumber

	public var description:String {
		get {
			var result: String
			switch self {
			case .booleanNumber:	result = "boolean"
			case .int8Number:	result = "int8"
			case .uInt8Number:	result = "uInt8"
			case .int16Number:	result = "int16"
			case .uInt16Number:	result = "uInt16"
			case .int32Number:	result = "int32"
			case .uInt32Number:	result = "uInt32"
			case .int64Number:	result = "int64"
			case .uInt64Number:	result = "uInt64"
			case .doubleNumber:	result = "double"
			case .floatNumber:	result = "float"
			}
			return result
		}
	}
}

extension NSNumber
{	
	public func hasBool() -> Bool
	{
		let boolID = CFBooleanGetTypeID()	// the type ID of CFBoolean
		let numID = CFGetTypeID(self)		// the type ID of num
		return numID == boolID
	}

	public var kind: NSNumberKind {
		get { return decodeKind() }
	}

	internal func decodeKind() -> NSNumberKind {
		if(hasBool()){
			return .booleanNumber
		} else {
			var result: NSNumberKind
			switch String(cString: self.objCType) {
			case "c": result = .int8Number
			case "C": result = .uInt8Number
			case "s": result = .int16Number
			case "S": result = .uInt16Number
			case "i": result = .int32Number
			case "I": result = .uInt32Number
			case "q": result = .int64Number
			case "Q": result = .uInt64Number
			case "f": result = .floatNumber
			case "d": result = .doubleNumber
			default:  fatalError("Unknown number kind")
			}
			return result
		}
	}
}

/*
open class NSNumber: NSNumber
{
	private var mNumberKind: NSNumberKind? = nil

	public override init(value v: Bool){
		super.init(value: v)
		mNumberKind = .booleanNumber
	}

	public override init(value v: Int8){
		super.init(value: v)
		mNumberKind = .int8Number
	}

	public override init(value v: UInt8){
		super.init(value: v)
		mNumberKind = .uInt8Number
	}

	public override init(value v: Int16){
		super.init(value: v)
		mNumberKind = .int16Number
	}

	public override init(value v: UInt16){
		super.init(value: v)
		mNumberKind = .uInt16Number
	}

	public override init(value v: Int32){
		super.init(value: v)
		mNumberKind = .int32Number
	}

	public override init(value v: UInt32){
		super.init(value: v)
		mNumberKind = .uInt32Number
	}

	public override init(value v: Int64){
		super.init(value: v)
		mNumberKind = .int64Number
	}

	public override init(value v: UInt64){
		super.init(value: v)
		mNumberKind = .uInt64Number
	}

	public override init(value v: Float){
		super.init(value: v)
		mNumberKind = .floatNumber
	}

	public override init(value v: Double){
		super.init(value: v)
		mNumberKind = .doubleNumber
	}

	/*
	public convenience init(booleanValue v: Bool){
		self.init(value: v)
		mNumberKind = .booleanNumber
	}

	public convenience init(int8Value v: Int8){
		self.init(value: v)
		mNumberKind = .int8Number
	}

	public convenience init(uInt8Value v: UInt8){
		self.init(value: v)
		mNumberKind = .uInt8Number
	}

	public convenience init(int16Value v: Int16){
		self.init(value: v)
		mNumberKind = .int16Number
	}

	public convenience init(uInt16Value v: UInt16){
		self.init(value: v)
		mNumberKind = .uInt16Number
	}

	public convenience init(int32Value v: Int32){
		self.init(value: v)
		mNumberKind = .int32Number
	}

	public convenience init(uInt32Value v: UInt32){
		self.init(value: v)
		mNumberKind = .uInt32Number
	}

	public convenience init(int64Value v: Int64){
		self.init(value: v)
		mNumberKind = .int64Number
	}

	public convenience init(uInt64Value v: UInt64){
		self.init(value: v)
		mNumberKind = .uInt64Number
	}

	public convenience init(floatValue v: Float){
		self.init(value: v)
		mNumberKind = .floatNumber
	}

	public convenience init(doubleValue v: Double){
		self.init(value: v)
		mNumberKind = .doubleNumber
	}
*/
	public required convenience init(integerLiteral v: Int) {
		self.init(value: Int64(v))
		mNumberKind = .int64Number
	}
	
	public required convenience init(floatLiteral v: Double) {
		self.init(value: Double(v))
		mNumberKind = .doubleNumber
	}
	
	public required convenience init(booleanLiteral v: Bool) {
		self.init(value: v)
		mNumberKind = .booleanNumber
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public var kind: NSNumberKind {
		get {
			if let kind = mNumberKind {
				return kind
			} else {
				let newkind = super.decodeKind()
				mNumberKind = newkind
				return newkind
			}
		}
	}
}
*/


