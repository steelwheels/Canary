/*
 * @file		CNState.h
 * @brief	Define CNState class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNState : NSObject
{
	private dynamic var mStateId = 0
	
	public func addStateObserver(observer: NSObject){
		self.addObserver(observer, forKeyPath: CNState.stateKey, options: .New, context: nil)
	}
	
	public func removeStateObserver(observer: NSObject){
		self.removeObserver(observer, forKeyPath: CNState.stateKey)
	}
	
	public func updateState() -> Void {
		self.mStateId += 1
	}
	
	public static var stateKey: String {
		get{ return "mStateId" }
	}
}
