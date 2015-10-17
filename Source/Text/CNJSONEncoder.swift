/**
* @file	CNJSONEncoder.h
* @brief	Define CNJsonEncoder class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation

public class CNJSONEncoder : CNObjectVisitor
{
	private var resultText : CNTextElement = CNTextString(string: "")
	
	public func encode(object : NSObject) -> CNTextElement {
		acceptObject(object)
		return resultText
	}
	
	public override func visitNumberObject(number : NSNumber){
		resultText = CNTextString(string: "\(number)")
	}
	
	public override func visitStringObject(string : NSString){
		resultText = CNTextString(string: String(string))
	}
	
	public override func visitDateObject(date : NSDate){
		resultText = CNTextString(string: "\(date)")
	}
	
	public override func visitDictionaryObject(dict : NSDictionary){
		let newdict = CNTextDictionary()
		for (key, value) in dict {
			/* convert key */
			var keytext : String
			if let keystr = key as? String {
				keytext = keystr
			} else {
				keytext = "<error>"
			}
			/* convert value */
			var valtext : CNTextElement
			if let valobj = value as? NSObject {
				acceptObject(valobj)
				valtext = resultText
			} else {
				valtext = CNTextString(string: "<error>")
			}
			/* Add as element */
			newdict.elements[keytext] = valtext
		}
		resultText = newdict
	}
	
	public override func visitArrayObject(arr : NSArray){
		let newarr = CNTextArray()
		for value in arr {
			/* convert value */
			var valtext : CNTextElement
			if let valobj = value as? NSObject {
				acceptObject(valobj)
				valtext = resultText
			} else {
				valtext = CNTextString(string: "<error>")
			}
			/* Add as element */
			newarr.elements.append(valtext)
		}
		resultText = newarr
	}
	
	public override func visitUnknownObject(obj : NSObject){
		resultText = CNTextString(string: "<unknown>")
	}
}
