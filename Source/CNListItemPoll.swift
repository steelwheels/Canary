/**
 * @file	CNListItemPool.h
 * @brief	Define CNListItemPool class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

private var mPoolDictionary: Dictionary<String, AnyObject> = [:]

public class CNListItemPool<T>
{
	private var mFirstItem : CNListItem<T>?
	private var mLock : NSLock

	private init(){
		mFirstItem = nil
		mLock = NSLock()
	}

	public class func allocatePool() -> CNListItemPool<T> {
		let name = String(CNListItemPool<T>.self)
		if let pool = mPoolDictionary[name] {
			if let p = pool as? CNListItemPool<T> {
				return p
			}
		} else {
			let newpool = CNListItemPool<T>()
			mPoolDictionary[name] = newpool
			return newpool
		}
		fatalError("Invalid object type")
	}

	internal func allocateItem(data d: T) -> CNListItem<T> {
		var result: CNListItem<T>
		mLock.lock()
		if let item = mFirstItem {
			item.data  = d
			mFirstItem = item.next
			result = item
		} else {
			result = CNListItem<T>(data: d)
		}
		mLock.unlock()
		result.next = nil
		return result
	}

	internal func releaseItem(item: CNListItem<T>){
		mLock.lock()
		item.next  = mFirstItem
		mFirstItem = item
		mLock.unlock()
	}
}
