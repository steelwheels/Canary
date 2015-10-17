/**
 * @file   CNTextDumper.h
 * @brief  Define CNTextDumper class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextDumperParam : CNTextVisitorParam {
	var console : CNConsole
	public init(console cons: CNConsole){
		console = cons
		super.init()
	}
}

public class CNTextDumper : CNTextVisitor
{	
	public func dumpToConsole(console : CNConsole, text: CNTextElement){
		let param = CNTextDumperParam(console: console)
		text.accept(self, param: param)
		console.flush()
	}
	
	public override func visitSection(section : CNTextSection, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let console = dparam.console
		
		/* Put string */
		let title = section.title
		if(title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
			console.addWord(title)
			console.addNewline()
			console.incIndent()
		}
		
		/* Put contentents */
		for element in section.elements {
			element.accept(self, param: param)
		}
		
		if(title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
			console.decIndent()
		}
	}
	
	public override func visitDictionary(dictionary : CNTextDictionary, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let console = dparam.console
		
		var issingle = true
		for (_, value) in dictionary.elements {
			if !isSingle(value) {
				issingle = false
				break
			}
		}

		console.addWord(dictionary.header)
		if !issingle {
			console.addNewline()
			console.incIndent()
		}
		
		var is1st = true
		for (key, value) in dictionary.elements {
			if is1st {
				is1st = false
			} else {
				console.addWord(", ")
				if !issingle {
					console.addNewline()
				}
			}
			console.addWord(key)
			console.addWord(":")
			value.accept(self, param: param)
		}
		if !issingle {
			console.decIndent()
		}
		
		console.addWord(dictionary.footer)
		console.addNewline()
	}
	
	public override func visitArray(array : CNTextArray, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let console = dparam.console
		
		var issingle = true
		for value in array.elements {
			if !isSingle(value) {
				issingle = false
				break
			}
		}
		
		console.addWord(array.header)
		if !issingle {
			console.addNewline()
		}
		var is1st = true
		for element in array.elements {
			if is1st {
				is1st = false
			} else {
				console.addWord(", ")
			}
			element.accept(self, param: dparam)
			if !issingle {
				console.addNewline()
			}
		}
		console.addWord(array.footer)
		console.addNewline()
	}
	
	
	private func isSingle(element : CNTextElement) -> Bool {
		var result : Bool
		if let _ = element as? CNTextString {
			result = true
		} else {
			result = false
		}
		return result
	}

	public override func visitLine(line : CNTextLine, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let console = dparam.console
		for str in line.strings {
			str.accept(self, param: param)
		}
		console.addNewline()
	}
	
	public override func visitString(str : CNTextString, param: CNTextVisitorParam){
		let dparam  = param as! CNTextDumperParam
		let console = dparam.console
		console.addWord(str.string)
	}
}
