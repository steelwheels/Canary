/**
 * @file	CNConsole.h
 * @brief	Define CNConsole class
 * @par Copyright
 *   Copyright (C) 2015-2016 Steel Wheels Project
 */

import Foundation

open class CNConsole
{
	public init(){

	}

	open func print(string str: String){
		Swift.print(str, terminator: "")
	}

	open func error(string str: String){
		Swift.print(str, terminator: "")
	}

	open func scan() -> String? {
		return nil
	}
}

public class CNFileConsole : CNConsole
{
	var inputHandle:	FileHandle
	var outputHandle:	FileHandle
	var errorHandle:	FileHandle

	public init(input ihdl: FileHandle, output ohdl: FileHandle, error ehdl: FileHandle){
		inputHandle	= ihdl
		outputHandle	= ohdl
		errorHandle	= ehdl
	}

	public override init() {
		inputHandle	= FileHandle.standardInput
		outputHandle	= FileHandle.standardOutput
		errorHandle	= FileHandle.standardError
	}

	public override func print(string str: String){
		if let data = str.data(using: .utf8) {
			outputHandle.write(data)
		}
	}

	public override func error(string str: String){
		if let data = str.data(using: .utf8) {
			errorHandle.write(data)
		} else {
			print(string: str)
		}
	}

	public override func scan() -> String? {
		return String(data: inputHandle.availableData, encoding: .utf8)
	}
}

public class CNIndentedConsole: CNConsole
{
	private var mConsole:		CNConsole
	private var mIndentValue:	Int
	private var mIndentString:	String

	public init(console cons: CNConsole){
		mConsole 	= cons
		mIndentValue	= 0
		mIndentString	= ""
	}

	public override func print(string str: String){
		mConsole.print(string: mIndentString + str)
	}

	public override func error(string str: String){
		mConsole.error(string: mIndentString + str)
	}

	public override func scan() -> String? {
		return mConsole.scan()
	}

	public func incrementIndent() {
		updateIndent(indent: mIndentValue + 1)
	}

	public func decrementIndent() {
		if mIndentValue > 0 {
			updateIndent(indent: mIndentValue - 1)
		}
	}

	public func updateIndent(indent idt: Int) {
		var result = ""
		for _ in 0..<idt {
			result = result + "  "
		}
		mIndentValue  = idt
		mIndentString = result
	}
}

public class CNPipeConsole: CNConsole
{
	public var toConsole: 		CNConsole?
	public var inputPipe:		Pipe
	public var errorPipe:		Pipe
	public var outputPipe:		Pipe

	public override init(){
		toConsole	= nil
		inputPipe	= Pipe()
		errorPipe	= Pipe()
		outputPipe	= Pipe()
		super.init()

		inputPipe.fileHandleForReading.readabilityHandler = {
			(_ handle: FileHandle) -> Void in
			if let str = String(data: handle.availableData, encoding: String.Encoding.utf8) {
				self.print(string: str)
			} else {
				NSLog("Error decoding data: \(handle.availableData)")
			}
		}
		errorPipe.fileHandleForReading.readabilityHandler = {
			(_ handle: FileHandle) -> Void in
			if let str = String(data: handle.availableData, encoding: String.Encoding.utf8) {
				self.error(string: str)
			} else {
				NSLog("Error decoding data: \(handle.availableData)")
			}
		}
		outputPipe.fileHandleForWriting.writeabilityHandler = {
			(filehandle: FileHandle) -> Void in
			if let str = self.scan() {
				if let data = str.data(using: .utf8) {
					filehandle.write(data)
				} else {
					NSLog("Error encoding data: \(str)")
				}
			}
		}
	}

	open override func print(string str: String){
		if let cons = toConsole {
			cons.print(string: str)
		}
	}

	open override func error(string str: String){
		if let cons = toConsole {
			cons.error(string: str)
		}
	}

	open override func scan() -> String? {
		if let cons = toConsole {
			return cons.scan()
		} else {
			return nil
		}
	}
}

#if os(OSX)
public class CNCursesConsole: CNConsole
{
	public enum ConsoleMode {
		case Shell
		case Screen
	}

	private var mConsoleMode:	ConsoleMode
	private var mDefaultConsole:	CNConsole
	private var mCurses:		CNCurses
	private var mForegroundColor:	CNColor
	private var mBackgroundColor:	CNColor

	public init(defaultConsole cons: CNConsole){
		mConsoleMode		= .Shell
		mDefaultConsole		= cons
		mCurses			= CNCurses()
		mForegroundColor	= .White
		mBackgroundColor	= .Black
	}

	public func setMode(mode m: ConsoleMode){
		if mConsoleMode != m {
			switch m {
			case .Shell:
				mCurses.finalize()
			case .Screen:
				mCurses.setup()
			}
			mConsoleMode = m
		}
	}

	public var visiblePrompt: Bool {
		get {
			var result: Bool
			switch mConsoleMode {
			case .Screen:	result = mCurses.visiblePrompt
			case .Shell:	result = true
			}
			return result
		}
		set(value){
			switch mConsoleMode {
			case .Screen:	mCurses.visiblePrompt = value
			case .Shell:	break
			}
		}
	}

	public var doBuffering: Bool {
		get {
			var result: Bool
			switch mConsoleMode {
			case .Screen:	result = mCurses.doBuffering
			case .Shell:	result = true
			}
			return result
		}
		set(value){
			switch mConsoleMode {
			case .Screen:	mCurses.doBuffering = value
			case .Shell:	break
			}
		}
	}

	public var doEcho: Bool {
		get {
			var result: Bool
			switch mConsoleMode {
			case .Screen:	result = mCurses.doEcho
			case .Shell:	result = true
			}
			return result
		}
		set(value){
			switch mConsoleMode {
			case .Screen:	mCurses.doEcho = value
			case .Shell:	break
			}
		}
	}

	public var screenWidth: Int {
		get {
			let result: Int
			switch mConsoleMode {
			case .Shell:	result = 0 	// Unknown
			case .Screen:	result = mCurses.screenWidth
			}
			return result
		}
	}

	public var screenHeight: Int {
		get {
			let result: Int
			switch mConsoleMode {
			case .Shell:	result = 0 	// Unknown
			case .Screen:	result = mCurses.screenHeight
			}
			return result
		}
	}

	public var cursorX: Int {
		get {
			let result: Int
			switch mConsoleMode {
			case .Shell:	result = 0 	// Unknown
			case .Screen:	result = mCurses.cursorX
			}
			return result
		}
	}

	public var cursorY: Int {
		get {
			let result: Int
			switch mConsoleMode {
			case .Shell:	result = 0 	// Unknown
			case .Screen:	result = mCurses.cursorY
			}
			return result
		}
	}

	public func setColor(foregroundColor fcol: CNColor, backgroundColor bcol: CNColor){
		switch mConsoleMode {
		case .Shell:	break
		case .Screen:	mCurses.setColor(foregroundColor: fcol, backgroundColor: bcol)
		}
	}

	public func moveTo(x xval:Int, y yval:Int) {
		switch mConsoleMode {
		case .Shell:	break
		case .Screen:	mCurses.moveTo(x: xval, y: yval)
		}
	}
	
	open func getKey() -> Int32? {
		let result: Int32?
		switch mConsoleMode {
		case .Shell:
			result = nil
		case .Screen:
			result = mCurses.getKey()
		}
		return result
	}

	open override func print(string str: String){
		switch mConsoleMode {
		case .Shell:
			mDefaultConsole.print(string: str)
		case .Screen:
			mCurses.put(string: str)
		}
	}

	open override func error(string str: String){
		switch mConsoleMode {
		case .Shell:
			mDefaultConsole.error(string: str)
		case .Screen:
			mCurses.put(string: str)
		}
	}

	open override func scan() -> String? {
		let result: String?
		switch mConsoleMode {
		case .Shell:
			result = mDefaultConsole.scan()
		case .Screen:
			var tmpres: String? = nil
			if let v = mCurses.getKey() {
				if 0<=v && v<=0xff {
					let lv = UInt8(v)
					let c  = Character(UnicodeScalar(lv))
					tmpres = "\(c)"
				}
			}
			result = tmpres
		}
		return result
	}
}
#endif // os(OSX)

public class CNSenderConsole: CNConsole
{
	private var mConnection	: CNConnection?

	public override init(){
		mConnection = nil
	}

	public var connection: CNConnection? {
		get {
			return mConnection
		}
		set(newconn){
			if let conn = newconn {
				conn.sender = self
			}
			mConnection = newconn
		}
	}

	open override func print(string str: String){
		if let conn = mConnection {
			if let receiver = conn.receiver as? CNReceiverConsole {
				receiver.print(string: str)
			} else {
				NSLog("Invalid object")
			}
		}
	}

	open override func error(string str: String){
		if let conn = mConnection {
			if let receiver = conn.receiver as? CNReceiverConsole {
				receiver.error(string: str)
			} else {
				NSLog("Invalid object")
			}
		}
	}

	open override func scan() -> String? {
		if let conn = mConnection {
			if let receiver = conn.receiver as? CNReceiverConsole {
				return receiver.scan()
			} else {
				NSLog("Invalid object")
			}
		}
		return nil
	}
}

public class CNReceiverConsole: CNConsole
{
	private var mConnection	: CNConnection?

	public var printCallback	: ((_ str: String) -> Void)?
	public var errorCallback	: ((_ str: String) -> Void)?
	public var scanCallback		: (() -> String)?

	public override init(){
		mConnection	= nil
		printCallback	= nil
		errorCallback	= nil
		scanCallback	= nil
	}

	public var connection: CNConnection? {
		get {
			return mConnection
		}
		set(newconn){
			if let conn = newconn {
				conn.receiver = self
			}
			mConnection = newconn
		}
	}

	open override func print(string str: String){
		if let callback = printCallback {
			callback(str)
		}
	}

	open override func error(string str: String){
		if let callback = errorCallback {
			callback(str)
		}
	}

	open override func scan() -> String? {
		if let callback = scanCallback {
			return callback()
		} else {
			return nil
		}
	}
}


