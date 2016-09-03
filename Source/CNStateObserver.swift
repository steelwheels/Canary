/*
 * @file	CNStateObserver.h
 * @brief	Define CNStateObserver class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNStateObserver : NSObject
{
	private dynamic var mState : CNState? = nil
	private var mCallback : ((_ : CNState) -> Void)? = nil
	
	deinit {
		if let curstate = mState {
			curstate.remove(stateObserver: self)
		}
	}
	
	public var state : CNState? {
		get	{
			return mState
		}
		set(newstate){
			if let curstate = mState {
				curstate.remove(stateObserver: self)
			}
			if let nextstate = newstate {
				nextstate.add(stateObserver: self)
			}
			mState = newstate
		}
	}
	
	public var callback : ((_ : CNState) -> Void)? {
		get { return mCallback }
		set(newcallback) { mCallback = newcallback }
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				if let callback = mCallback {
					callback(state)
				}
			}
		}
	}
}
