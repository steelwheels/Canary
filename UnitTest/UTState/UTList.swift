//
//  UTList.swift
//  Canary
//
//  Created by Tomoo Hamada on 2016/05/28.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Canary

public func UTList()
{
	let list0 = CNList<Int>()
	printList("initial state", list: list0)
	
	list0.append(data: 0)
	printList("list0: add", list: list0)
	
	let list1 = CNList(list: list0)
	printList("list1: init", list: list1)
	
	list1.prepend(data: 1)
	printList("list1: prepend", list: list1)
	
	list1.add(nil, data: 2)
	list1.add(list1.firstItem, data:3)
	list1.add(list1.lastItem, data:4)
	list1.add(list1.firstItem!.next, data:5)
	printList("list1: add", list: list1)
	
	list0.remove(nil)
	printList("list0 remove", list: list0)
	
	let list2 = list1.map({ data in data * 2 })
	printList("list2 *2", list: list2)
	
	let list3 = list1.operate({ (data) -> CNListCommand<Int> in
		/* Skip odd value */
		var result: CNListCommand<Int>
		if data % 2 == 1 {
			result = .Skip
		} else {
			result = .Copy
		}
		return result
	})
	printList("list3", list: list3)
	
	let list4 = CNList<Int>()
	for i in 0..<10 {
		list4.append(data: i)
	}
	let list5 = list4.operate({ (data) -> CNListCommand<Int> in
		switch data {
		case 0:
			return .Insert(data: 10)
		case 1:
			return .Add(data: 11)
		case 2:
			return .Skip
		case 3:
			return .Replace(data: 33)
		default:
			return .Copy
		}
	})
	printList("list5", list: list5)
	
	CNListItemPool<Int>.allocatePool()
}

internal func printList(title:String, list: CNList<Int>){
	print("\(title) \(list.count) [", terminator: "")
	list.forEach({value in print("\(value) ", terminator: "")})
	print("]")
}