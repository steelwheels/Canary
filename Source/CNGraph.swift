/**
 * @file	CNGraph.swift
 * @brief	Define CNGraph class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNGraph
{
	private var mNextNodeUniqId	: Int
	private var mNextEdgeUniqId	: Int

	private var mNodes:	Array<CNNode>
	private var mEdges:	Array<CNEdge>

	public var nodes: Array<CNNode> { get { return mNodes }}
	public var edges: Array<CNEdge>  { get { return mEdges }}

	public init(){
		mNextNodeUniqId		= 0
		mNextEdgeUniqId		= 0
		mNodes			= []
		mEdges			= []
	}

	public func allocateNode(name nm: String, owner own: AnyObject) -> CNNode {
		let newnode = CNNode(uniqueId: mNextNodeUniqId, name: nm, owner: own)
		mNodes.append(newnode)
		mNextNodeUniqId += 1
		return newnode
	}

	public func allocateEdge() -> CNEdge {
		let newedge = CNEdge(uniqueId: mNextEdgeUniqId)
		mEdges.append(newedge)
		mNextEdgeUniqId += 1
		return newedge
	}

	public func resetVisitedFlag() {
		for node in mNodes {
			node.didVisited = false
		}
		for edge in mEdges {
			edge.didVisited = false
		}
	}

	public class func link(from fnode: CNNode, to tnode: CNNode, by edge: CNEdge){
		fnode.addOutputEdge(edge: edge)
		edge.fromNode = fnode
		edge.toNode   = tnode
		tnode.addInputEdge(edge: edge)
	}

	public class func isConnected(from fnode: CNNode, to tnode: CNNode) -> (Bool, Array<CNNode>) {
		return isConnected(from: fnode, to: tnode, fromPath: [])
	}

	private class func isConnected(from fnode: CNNode, to tnode: CNNode, fromPath path: Array<CNNode>) -> (Bool, Array<CNNode>) {
		for edge in fnode.outputEdges {
			if let nextnode = edge.object.toNode {
				var newpath : Array<CNNode> = []
				newpath.append(contentsOf: path)
				newpath.append(nextnode)
				if nextnode == tnode {
					return (true, newpath)
				} else {
					let (retval, retpath) = isConnected(from: nextnode, to: tnode, fromPath: newpath)
					if retval {
						return (retval, retpath)
					}
				}
			} else {
				fatalError("No output edge")
			}
		}
		return (false, [])
	}
}

