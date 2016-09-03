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
	
	public init(data d: T){
		next = nil
		data = d
	}
	
	deinit {
		next = nil
	}
	
	public class func allocate(pool p: CNListItemPool<T>, data d: T) -> CNListItem<T> {
		return p.allocateItem(data: d)
	}
	
	public func add(pool p: CNListItemPool<T>, data d: T) -> CNListItem<T> {
		let newitem  = CNListItem<T>.allocate(pool: p, data: d)
		newitem.next = next
		next         = newitem
		return newitem
	}
	
	public class func release(pool p: CNListItemPool<T>, listItem i: CNListItem<T>){
		p.releaseItem(item: i)
	}

	public func remove(pool p: CNListItemPool<T>) -> Bool {
		if let nextitem = next {
			let nextnext = nextitem.next
			next         = nextnext
			p.releaseItem(item: nextitem)
			return true
		} else {
			return false
		}
	}
}


