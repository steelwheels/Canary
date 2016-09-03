/*
 * @file	CNState.h
 * @brief	Define CNState class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

/**
   The data object to present the state of the object
 */
open class CNState : NSObject
{
	/** The updated count */
	private dynamic var mStateId = 0
	
	/**
	  Add observer object of this state
	  - Parameter observer: Observer object
	 */
	public func add(stateObserver obs: NSObject){
		self.addObserver(obs, forKeyPath: CNState.stateKey, options: .new, context: nil)
	}
	
	/**
	  Stop the object to observe this state
	  - Parameter observer: Object to stop observing this state
	 */
	public func remove(stateObserver obs: NSObject){
		self.removeObserver(obs, forKeyPath: CNState.stateKey)
	}
	
	/**
	  Increment the update count. This method will be called 
	 */
	public func updateState() -> Void {
		self.mStateId += 1
	}
	
	public static var stateKey: String {
		get{ return "mStateId" }
	}
}
