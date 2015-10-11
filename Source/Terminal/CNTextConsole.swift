/**
 * @file	CNTextConsole.h
 * @brief	Define CNCTextonsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNTextConsole : CNConsole
{
	private var is1ststring = true
	
	public override func putString(str : String){
		if is1ststring {
			putIndent()
			is1ststring = false
		}
		print(str, separator: "", terminator: "")
	}
	
	public override func putNewline(){
		print("", separator: "", terminator: "\n")
		is1ststring = true
	}
	
	private func putIndent(){
		let indentstr = indentString()
		print(indentstr, separator:"", terminator:"")
	}
}

