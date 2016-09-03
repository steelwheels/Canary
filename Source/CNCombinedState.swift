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
		for srcstate in mSourceStates {
			srcstate.remove(stateObserver: self)
		}
	}
	
	public func addSourceState(state: CNState){
		mSourceStates.append(state)
		state.add(stateObserver: self)
	}
	
	public var sourceStates: Array<CNState> {
		get{ return mSourceStates }
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
		if let _ = object as? CNState {
			if keyPath == CNState.stateKey {
				updateState()
			}
		}
	}
}
