/**
 * @file	CNOrderedList.h
 * @brief	Define CNOrderedList class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNOrderedList<T> : CNList<T>
{
	private let	compareMethod:	(_:T, _:T) -> ComparisonResult
	public init(compareMethod comp: ((_:T, _:T) -> ComparisonResult)){
		compareMethod	= comp
		super.init()
	}
	
	public func add(data d: T){
		var previtem: CNListItem<T>? = nil
		var item = firstItem
		while let curitem = item {
			if compareMethod(curitem.data, d) != .orderedAscending {
				/* curitem < newdata */
				super.add(previousItem: previtem, data: d)
				return /* added */
			}
			item     = curitem.next
			previtem = curitem
		}
		super.add(previousItem: previtem, data: d)
	}
	
}

