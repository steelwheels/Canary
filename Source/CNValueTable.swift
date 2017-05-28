/*
 * @file	CNValueTable.swift
 * @brief	Define CNValueTable class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNValueTable
{
	private var mDictionary: NSMutableDictionary
	private var mObservers:	 Array<NSObject>

	public init(){
		mDictionary = NSMutableDictionary(capacity: 16)
		mObservers  = []
	}

	deinit {
		for obs in mObservers {
			let keys = mDictionary.allKeys
			for key in keys {
				if let keystr = key as? String {
					mDictionary.removeObserver(obs, forKeyPath: keystr)
				} else {
					NSLog("Error: Invalid key object")
				}
			}
		}
	}

	public func setProperty(index idx: String, value val: CNValue){
		mDictionary.setValue(val, forKey: idx)
	}

	public func property(index idx: String) -> CNValue? {
		if let obj = mDictionary.value(forKey: idx) {
			if let value = obj as? CNValue {
				return value
			} else {
				fatalError("CNValue object required")
			}
		}
		return nil
	}

	public func addObserver(observer obs: NSObject, propertyNames names: Array<String>)
	{
		for key in names {
			mDictionary.addObserver(obs, forKeyPath: key, options: .new, context: nil)
			mObservers.append(obs)
		}
	}
}
