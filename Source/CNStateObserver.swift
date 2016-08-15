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
	private var mCallback : ((state : CNState) -> Void)? = nil
	
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
	
	public var callback : ((state : CNState) -> Void)? {
		get { return mCallback }
		set(newcallback) { mCallback = newcallback }
	}

	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				if let callback = mCallback {
					callback(state: state)
				}
			}
		}
	}
}
