/**
 * @file	CNListItem.h
 * @brief	Define CNListItem class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNListItem<T>
{
	public var next: CNListItem?
	public var data: T
	
	private init(data d: T){
		next = nil
		data = d
	}
	
	deinit {
		next = nil
	}
	
	public class func allocate(pool: CNListItemPool<T>, data d: T) -> CNListItem<T> {
		return pool.allocateItem(data: d)
	}
	
	public func add(pool: CNListItemPool<T>, data d: T) -> CNListItem<T> {
		let newitem  = CNListItem<T>.allocate(pool, data: d)
		newitem.next = next
		next         = newitem
		return newitem
	}
	
	public class func release(pool: CNListItemPool<T>, listItem: CNListItem<T>){
		pool.releaseItem(listItem)
	}

	public func remove(pool: CNListItemPool<T>) -> Bool {
		if let nextitem = next {
			let nextnext = nextitem.next
			next         = nextnext
			pool.releaseItem(nextitem)
			return true
		} else {
			return false
		}
	}
}


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
		return result
	}
	
	internal func releaseItem(item: CNListItem<T>){
		mLock.lock()
		item.next  = mFirstItem
		mFirstItem = item
		mLock.unlock()
	}
}

