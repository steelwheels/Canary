/**
 * @file	CNList.h
 * @brief	Define CNList class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public enum CNListCommand<T> {
	case Copy
	case Skip
	case Stop
	case Replace(data: T)
	case Insert(data: T)
	case Add(data: T)
}

/**
  Single linked list
 */
public class CNList<T> : SequenceType
{
	/**
	  First list item
	 */
	private var pool:      CNListItemPool<T>
	public  var firstItem: CNListItem<T>?
	public  var lastItem:  CNListItem<T>?
	public  var count: Int
	
	public init(){
		pool      = CNListItemPool.allocatePool()
		firstItem = nil
		lastItem  = nil
		count     = 0
	}
	
	public init(list: CNList<T>){
		pool      = CNListItemPool.allocatePool()
		firstItem = nil
		lastItem  = nil
		count     = 0
		list.forEach({ data in self.append(data: data) })
	}

	deinit {
		var item: CNListItem<T>? = firstItem
		while let i = item {
			let next = i.next
			CNListItem.release(pool, listItem: i)
			item = next
		}
		firstItem = nil
		lastItem  = nil
	}

	/**
	  Add data to the list
	  - parameter previousItem:	Previous list item to append the source data
	  - parameter data:		Source data
	  - return:			Generated list item which has the source data
	 */
	public func add(previousItem: CNListItem<T>?, data d: T) -> CNListItem<T> {
		if let pitem = previousItem {
			let newitem = CNListItem<T>.allocate(pool, data: d)
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
			if pitem.remove(pool) {
				if pitem.next == nil {
					lastItem = pitem
				}
				count  -= 1
				result = true
			}
		} else {
			if let fitem = firstItem {
				let nitem = fitem.next
				CNListItem<T>.release(pool, listItem: fitem)
				firstItem = nitem
				count  -= 1
				result = true
			}
		}
		return result
	}

	public func append(data d: T) -> CNListItem<T> {
		let newitem = CNListItem<T>.allocate(pool, data: d)
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
		let newitem = CNListItem<T>.allocate(pool, data: d)
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

	public func operate(operateFunc: (T) -> CNListCommand<T>) -> CNList<T> {
		let newlist = CNList<T>()
		var curitem:  CNListItem<T>? = firstItem
		list_loop: while let item = curitem {
			/* Get command from user function */
			let command = operateFunc(item.data)
			switch command {
				case .Copy:
					newlist.append(data: item.data)
				case .Skip:
					break
				case .Stop:
					break list_loop
				case .Replace(let d):
					newlist.append(data: d)
				case .Insert(let d):
					newlist.append(data: d)
					newlist.append(data: item.data)
				case .Add(let d):
					newlist.append(data: item.data)
					newlist.append(data: d)
			}
			curitem = item.next
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

