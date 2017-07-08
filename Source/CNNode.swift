/**
 * @file	CNNode.h
 * @brief	Define CNNode class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public typealias CNWeakNodeReference = CNWeakReference<CNNode>

/*
 * Note: The owner of the node is a CNGraphObject
 */
public class CNNode: Equatable
{
	/* Unique id in the graph */
	private var mUniqueId:		Int
	private var mInputEdges:	Array<CNWeakEdgeReference>
	private var mOutputEdges:	Array<CNWeakEdgeReference>
	private var mTriggerCallback:	((_ node: CNNode) -> Void)?

	public var uniqueId		: Int { get { return mUniqueId }}
	public var didVisited		: Bool


	public init(uniqueId uid: Int, triggerCallback callback: @escaping (_ node: CNNode) -> Void){
		mUniqueId		= uid	/* The ID is managed by owner graph (See CNGraph) */
		mInputEdges		= []
		mOutputEdges		= []
		mTriggerCallback	= callback
		didVisited		= false
	}

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

	public func trigger() {
		if let callback = mTriggerCallback {
			callback(self)
		}
	}

	public var description: String {
		get {
			let innum  = mInputEdges.count
			let outnum = mOutputEdges.count
			return "n\(uniqueId): I\(innum) O\(outnum)"
		}
	}
}

public func == (left : CNNode, right : CNNode) -> Bool {
	return left.uniqueId == right.uniqueId
}
