/*
 * @file	CNValueCoder.swift
 * @brief	Define CNValueCoder class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNValueCoder
{
	public static func encode(value val: CNValue) -> CNObjectNotation {
		return encodeValue(label: nil, value: val)
	}

	private static func encodeValue(label lab:String?, value val: CNValue) -> CNObjectNotation {
		var result: CNObjectNotation
		switch val {
		case .BooleanValue(_), .IntValue(_), .UIntValue(_), .FloatValue(_), .DoubleValue(_), .StringValue(_):
			result = CNObjectNotation(label: lab, primitiveValue: val)
		case .ArrayValue(let array):
			var elements: Array<CNObjectNotation> = []
			for elm in array {
				elements.append(CNValueCoder.encodeValue(label: nil, value: elm))
			}
			result = CNObjectNotation(label: lab, className: val.typeDescription, objectValues: elements)
		case .SetValue(let set):
			var elements: Array<CNObjectNotation> = []
			for elm in set {
				elements.append(CNValueCoder.encodeValue(label: nil, value: elm))
			}
			result = CNObjectNotation(label: lab, className: val.typeDescription, objectValues: elements)
		case .DictionaryValue(let dict):
			var elements: Array<CNObjectNotation> = []
			for (keyelm, valelm) in dict {
				elements.append(CNValueCoder.encodeValue(label: keyelm, value: valelm))
			}
			result = CNObjectNotation(label: lab, className: val.typeDescription, objectValues: elements)
		}
		return result
	}

	public static func decode(object obj: CNObjectNotation) -> (NSError?, CNValue?) {
		var error: NSError? = nil
		var value: CNValue? = nil
		switch obj.value {
		case .PrimitiveValue(let val):
			error = nil
			value = val
		case .ObjectValue(let array):
			switch obj.className {
			case "Array":
				var data: Array<CNValue> = []
				for subobj in array {
					let (sube, subv) = CNValueCoder.decode(object: subobj)
					if let e = sube {
						return (e, nil)
					} else {
						if let v = subv {
							data.append(v)
						} else {
							fatalError("No valid object")
						}
					}
				}
				error = nil
				value = CNValue.ArrayValue(value: data)
			case "Set":
				var data: Set<CNValue> = []
				for subobj in array {
					let (sube, subv) = CNValueCoder.decode(object: subobj)
					if let e = sube {
						return (e, nil)
					} else {
						if let v = subv {
							data.insert(v)
						} else {
							fatalError("No valid object")
						}
					}
				}
				error = nil
				value = CNValue.SetValue(value: data)
			case "Dictionary":
				var data: Dictionary<String, CNValue> = [:]
				for subobj in array {
					let (sube, subv) = CNValueCoder.decode(object: subobj)
					if let e = sube {
						return (e, nil)
					} else {
						if let v = subv, let l = subobj.label {
							data[l] = v
						} else {
							fatalError("No valid object")
						}
					}
				}
				error = nil
				value = CNValue.DictionaryValue(value: data)
			default:
				error = NSError.parseError(message: "Unknown class name: \(obj.className)")
				value = nil
			}
		}

		return (error, value)
	}
}
