/**
 * @file	CNEdge.swift
 * @brief	Define CNEdge class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public typealias CNWeakEdgeReference	= CNWeakReference<CNEdge>

/*
 * Note: The owner of the edge is a CNGraph
 */
public class CNEdge: Equatable
{
	private var		mUniqueId:	Int

	public var uniqueId: Int { get { return mUniqueId }}

	public weak var	fromNode:	CNNode?
	public weak var	toNode:		CNNode?
	public var	didVisited:	Bool

	public init(uniqueId uid: Int){
		mUniqueId	= uid
		fromNode	= nil
		toNode		= nil
		didVisited	= false
	}
}

public func == (left : CNEdge, right : CNEdge) -> Bool {
	return left.uniqueId == right.uniqueId
}
