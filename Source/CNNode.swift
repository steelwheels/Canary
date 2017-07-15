/**
 * @file	CNNode.swift
 * @brief	Define CNNode class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public typealias CNWeakNodeReference = CNWeakReference<CNNode>

/*
 * Note: The owner of the node is a CNGraph
 */
public class CNNode: Equatable
{
	/* Unique id in the graph */
	private var mUniqueId		: Int
	private var mName		: String
	private weak var mOwner		: AnyObject?
	private var mInputEdges		: Array<CNWeakEdgeReference>
	private var mOutputEdges	: Array<CNWeakEdgeReference>

	public var uniqueId		: Int { get { return mUniqueId }}
	public var didVisited		: Bool


	public init(uniqueId uid: Int, name nm: String, owner own: AnyObject){
		mUniqueId		= uid	/* The ID is managed by owner graph (See CNGraph) */
		mName			= nm
		mOwner			= own
		mInputEdges		= []
		mOutputEdges		= []
		didVisited		= false
	}

	public var name: String { get { return mName } }
	public var owner: AnyObject? { get { return mOwner } }
	
	public var inputEdges:  Array<CNWeakEdgeReference> { get { return mInputEdges  } }
	public var outputEdges: Array<CNWeakEdgeReference> { get { return mOutputEdges } }

	public func addInputEdge(edge newedge: CNEdge){
		for curedge in mInputEdges {
			if newedge == curedge.object {
				/* already added */
				return
			}
		}
		mInputEdges.append(CNWeakEdgeReference(object: newedge))
	}

	public func addOutputEdge(edge newedge: CNEdge){
		for curedge in mOutputEdges {
			if newedge == curedge.object {
				/* already added */
				return
			}
		}
		mOutputEdges.append(CNWeakEdgeReference(object: newedge))
	}

	public var description: String {
		get {
			return "n:\(mName)"
		}
	}
}

public func == (left : CNNode, right : CNNode) -> Bool {
	return left.uniqueId == right.uniqueId
}
