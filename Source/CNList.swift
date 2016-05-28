/**
 * @file	CNList.h
 * @brief	Define CNList class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public enum CNListCommand {
	case Nop
	case Stop
}

public class CNList<T> : SequenceType
{
	public var firstItem: CNListItem<T>?
	public var lastItem:  CNListItem<T>?
	public var count: Int
	
	public init(){
		firstItem = nil
		lastItem  = nil
		count     = 0
	}
	
	public init(list: CNList<T>){
		firstItem = nil
		lastItem  = nil
		count     = 0
		list.forEach({ data in self.append(data: data) })
	}

	public func add(previousItem: CNListItem<T>?, data d: T) -> CNListItem<T> {
		if let pitem = previousItem {
			let newitem = CNListItem<T>(data: d)
			if let nextitem = pitem.next {
				newitem.next = nextitem
				pitem.next   = newitem
			} else {
				/* pitem is last item */
				pitem.next = newitem
				lastItem   = newitem
			}
			count += 1
			return newitem
		} else {
			return prepend(data: d)
		}
	}
	
	public func remove(previousItem: CNListItem<T>?) -> Bool {
		var result = false
		if let pitem = previousItem {
			if pitem.remove() {
				if pitem.next == nil {
					lastItem = pitem
				}
				count  -= 1
				result = true
			}
		} else {
			if let fitem = firstItem {
				let nitem = fitem.next
				firstItem = nitem
				count  -= 1
				result = true
			}
		}
		return result
	}

	public func append(data d: T) -> CNListItem<T> {
		let newitem = CNListItem<T>(data: d)
		if let litem = lastItem {
			litem.next = newitem
			lastItem = newitem
		} else {
			firstItem = newitem
			lastItem  = newitem
		}
		count += 1
		return newitem
	}
	
	public func prepend(data d: T) -> CNListItem<T> {
		let newitem = CNListItem<T>(data: d)
		if let fitem = firstItem {
			newitem.next = fitem
			firstItem    = newitem
		} else {
			firstItem = newitem
			lastItem  = newitem
		}
		count += 1
		return newitem
	}
	
	public func forEach(forEachFunc: (T) -> Void) {
		var curitem:  CNListItem<T>? = firstItem
		while let item = curitem {
			forEachFunc(item.data)
			curitem  = item.next
		}
	}
	
	public func map(mapFunc: (T) -> T) -> CNList<T> {
		let newlist = CNList<T>()
		var curitem:  CNListItem<T>? = firstItem
		while let item = curitem {
			let newdata = mapFunc(item.data)
			newlist.append(data: newdata)
			curitem  = item.next
		}
		return newlist
	}

	/**
	 Support SequenceType
	 */
	public func generate() -> CNListGenerator<T> {
		return CNListGenerator(list: self)
	}
}

public class CNListGenerator<T>: GeneratorType
{
	private var mList:        CNList<T>
	private var mCurrentItem: CNListItem<T>?
	
	public init(list: CNList<T>){
		mList = list
		mCurrentItem = mList.firstItem
	}
	
	public func next() -> T? {
		if let item = mCurrentItem {
			let data = item.data
			mCurrentItem = item.next
			return data
		} else {
			return nil
		}
	}
}

