/**
 * @file	CNNodeTable.swift
 * @brief	Define CNNodeTable class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNNodeTable
{
	private weak var mOwner:	AnyObject?
	private var mNodeTable:		Dictionary<String, CNWeakNodeReference>

	public init(owner own: AnyObject){
		mOwner     = own
		mNodeTable = [:]
	}

	public func addNodes(names nms: Array<String>, baseName bnm: String, inGraph graph: CNGraph){
		for name in nms {
			let nname = bnm + "." + name
			let node  = graph.allocateNode(name: nname, owner: owner)
			mNodeTable[name] = CNWeakReference<CNNode>(object: node)
		}
	}

	public func node(byName name: String) -> CNNode? {
		if let ref = mNodeTable[name] {
			return ref.object
		}
		return nil
	}

	private var owner: AnyObject {
		get {
			if let obj = mOwner {
				return obj
			}
			fatalError("No owner")
		}
	}
}
