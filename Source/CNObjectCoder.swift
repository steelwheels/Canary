/*
 * @file	CNObjectCoder.swift
 * @brief	Define CNObjectCoder class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

/*
public class CNObjectCoder
{
	public static func encode(notation src: CNObjectNotation) -> String {
		return CNObjectCoder.encodeToString(indent: 0, notation: src)
	}

	private static func encodeToString(indent idt: Int, notation src: CNObjectNotation) -> String {
		var result	: String = indentString(indent: idt) + "("
		var hasmulti	: Bool   = false

		if let label = src.label {
			result += "\(label): "
		}
		result += src.className + " "
		switch src.value {
		case .ObjectValue(let array):
			hasmulti = true
			result += "\n"
			for elmobj in array {
				result += CNObjectCoder.encodeToString(indent: idt+1, notation: elmobj) + "\n"
			}
		case .PrimitiveValue(let value):
			result += value.description
		}
		if hasmulti {
			result += indentString(indent: idt)
		}
		return result + ")"
	}

	private static func indentString(indent idt: Int) -> String {
		var result = ""
		for _ in 0..<idt {
			result += " "
		}
		return result
	}

	public static func decode(string src:String) -> (NSError?, CNObjectNotation?) {
		let start = src.startIndex
		let end   = src.endIndex
		return decodeFromString(sourceString: src, sourceRange: start..<end, lineNo: 1)
	}

	private static func decodeFromString(sourceString src:String, sourceRange srcrange: Range<String.Index>, lineNo line:Int) -> (NSError?, CNObjectNotation?) {
		/* skip spaces */
		let (range0, line0) = skipSpaces(sourceString: src, sourceRange: srcrange, lineNo: line)
		/* check 1st "(" */
		let (match1, range1) = matchChar(sourceString: src, sourceRange: range0, matchingFunc: {
			(c: Character) -> Bool in
			return c == "("
		})
		if !match1 {
			let error  = NSError.parseError(message: "\"(\" is expected at line \(line0)")
			return (error, nil)
		}
		/* skip spaces */
		let (range2, line2) = skipSpaces(sourceString: src, sourceRange: range1, lineNo: line0)
		/* get label (option) */

		
		return (error, result)
	}

	private static func skipSpaces(sourceString src:String, sourceRange range: Range<String.Index>, lineNo line:Int) -> (Range<String.Index>, Int) {
		var i	   : String.Index = range.lowerBound
		var lno	   : Int	  = line
		let eidx   : String.Index = range.upperBound
		while i < eidx {
			if src[i].isSpace() {
				if src[i] == "\n" {
					lno += 1
				}
				i = src.index(after: i)
			} else {
				break
			}
		}
		return (i..<eidx, lno)
	}

	private static func matchChar(sourceString srcstr: String, sourceRange range: Range<String.Index>, matchingFunc matchfunc: (_ c: Character) -> Bool) -> (Bool, Range<String.Index>) {
		var matched = false
		var sidx    = range.lowerBound
		let eidx    = range.upperBound
		if sidx < eidx {
			if matchfunc(srcstr[sidx]) {
				matched = true
				sidx    = srcstr.index(after: sidx)
			}
		}
		return (matched, sidx..<eidx)
	}
}
*/
