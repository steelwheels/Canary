/**
 * @file	CNConsoleText.h
 * @brief	Define CNCConsoleText class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation


public class CNConsoleWord
{
	public var string :	String = ""
	public var attributes :	Dictionary<String, AnyObject>	= [:]

	public init(string str: String){
		string     = str
		attributes = [:]
	}

	public init(string str: String, attribute attr: Dictionary<String, AnyObject>?){
		string = str
		if let dict = attr {
			for (key, value) in dict {
				attributes[key] = value
			}
		}
	}

	public func setForegroundColor(color c: NSColor){
		attributes[NSForegroundColorAttributeName] = c
	}

	public func setBackgroundColor(color c: NSColor){
		attributes[NSBackgroundColorAttributeName] = c
	}
}

public class CNConsoleText
{
	public var words : Array<CNConsoleWord> = []

	public init(words src: Array<CNConsoleWord>){
		words = src
	}

	public init(word src: CNConsoleWord){
		words = [src]
	}

	public init(string src: String){
		let word = CNConsoleWord(string: src)
		words = [word]
	}

	public init(strings src: Array<String>){
		words = []
		for elm in src {
			let line = CNConsoleWord(string: elm)
			words.append(line)
		}
	}

	public init(color c: NSColor, string s: String){
		let word = CNConsoleWord(string: s, attribute: [NSForegroundColorAttributeName: c])
		words = [word]
	}

	public init(){
		words = []
	}
}

