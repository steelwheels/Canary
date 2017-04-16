/**
 * @file	UTList.swift
 * @brief	Unit test for CNList class
 * @par Copyright
 *   Copyright (C) 2016, 2017 Steel Wheels Project
 */

import Canary

public func UTListTest() -> Bool
{
	let list0 = CNList<Int>()
	printList(title: "initial state", list: list0)
	
	list0.append(data: 0)
	printList(title: "list0: add", list: list0)
	
	let list1 = CNList(list: list0)
	printList(title: "list1: init", list: list1)
	
	list1.prepend(data: 1)
	printList(title: "list1: prepend", list: list1)
	
	list1.add(previousItem: nil, data: 2)
	list1.add(previousItem: list1.firstItem, data:3)
	list1.add(previousItem: list1.lastItem, data:4)
	list1.add(previousItem: list1.firstItem!.next, data:5)
	printList(title: "list1: add", list: list1)
	
	let _ = list0.remove(previousItem: nil)
	printList(title: "list0 remove", list: list0)
	
	let list2 = list1.map(mapFunc: { data in data * 2 })
	printList(title: "list2 *2", list: list2)
	
	let list3 = list1.operate(operateFunc: { (data) -> CNListCommand<Int> in
		/* Skip odd value */
		var result: CNListCommand<Int>
		if data % 2 == 1 {
			result = .Skip
		} else {
			result = .Copy
		}
		return result
	})
	printList(title: "list3", list: list3)
	
	let list4 = CNList<Int>()
	for i in 0..<10 {
		list4.append(data: i)
	}
	let list5 = list4.operate(operateFunc: { (data) -> CNListCommand<Int> in
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
	printList(title: "list5", list: list5)
	
	//CNListItemPool<Int>.allocatePool()
	
	return true
}

internal func printList(title tl:String, list ls: CNList<Int>){
	print("\(tl) \(ls.count) [", terminator: "")
	ls.forEach({value in print("\(value) ", terminator: "")})
	print("]")
}
