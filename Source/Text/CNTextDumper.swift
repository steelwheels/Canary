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

		if issingle {
			var is1st = true
			console.addWord(dictionary.header)
			for (key, value) in dictionary.elements {
				if is1st {
					is1st = false
				} else {
					console.addWord(", ")
				}
				putDictionaryElement(key, element: value, param: dparam)
			}
			console.addWord(dictionary.footer)
			console.addNewline()
		} else {
			var is1st = true
			console.addWord(dictionary.header)
			console.addNewline()
			for (key, value) in dictionary.elements {
				if is1st {
					is1st = false
				} else {
					console.addWord(", ")
				}
				putDictionaryElement(key, element: value, param: dparam)
				console.addNewline()
			}
			console.addWord(dictionary.footer)
			console.addNewline()
		}
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
	
	private func putDictionaryElement(key : String, element: CNTextElement, param : CNTextDumperParam) {
		param.console.addWord(key)
		param.console.addWord(": ")
		element.accept(self, param: param)
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
