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
	
	public func add(data d: T) -> CNListItem<T> {
		let newitem  = CNListItem(data: d)
		newitem.next = next
		next         = newitem
		return newitem
	}
	
	public func remove() -> Bool {
		if let nextitem = next {
			let nextnext = nextitem.next
			next         = nextnext
			return true
		} else {
			return false
		}
	}
}
