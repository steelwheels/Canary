/**
 * @file	CNOrderedList.h
 * @brief	Define CNOrderedList class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNOrderedList<T> : CNList<T>
{
	private let	compareMethod:	(source0:T, source1:T) -> NSComparisonResult
	
	public init(compareMethod comp: (source0:T, source1:T) -> NSComparisonResult){
		compareMethod	= comp
		super.init()
	}
	
	public func add(data d: T){
		var previtem: CNListItem<T>? = nil
		var item = firstItem
		while let curitem = item {
			if compareMethod(source0: curitem.data, source1: d) != .OrderedAscending {
				/* curitem < newdata */
				super.add(previtem, data: d)
				return /* added */
			}
			item     = curitem.next
			previtem = curitem
		}
		super.add(previtem, data: d)
	}
	
}

