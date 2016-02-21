/*
 * @file	CNCombinedState.h
 * @brief	Define CNCombinedState class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNCombinedState : CNState
{
	private var mSourceStates: Array<CNState> = []
	
	deinit {
		for srcstate in sourceStates {
			srcstate.removeStateObserver(self)
		}
	}
	
	public func addSourceState(state: CNState){
		mSourceStates.append(state)
		state.addStateObserver(self)
	}
	
	public var sourceStates: Array<CNState> {
		get{ return mSourceStates }
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let _ = object as? CNState {
			if keyPath == CNState.stateKey {
				updateState()
			}
		}
	}
}