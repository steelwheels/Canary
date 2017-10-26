/**
* @file	UTGraph.swift
* @brief	Unit test for CNGraph class
* @par Copyright
*   Copyright (C) 2017 Steel Wheels Project
*/

import Canary

public func UTGraphTest(console cons: CNConsole) -> Bool
{
	let owner = NSNumber(booleanLiteral: true)

	cons.print(string: "* Graph1\n")
	let graph = CNGraph()
	let n0 = allocateNode(name: "n0", graph: graph, owner: owner)
	let n1 = allocateNode(name: "n1", graph: graph, owner: owner)
	let e0 = allocateEdge(graph: graph)
	CNGraph.link(from: n0, to: n1, by: e0)
	dump(console: cons, graph: graph)

	cons.print(string: "* Graph2\n")
	let n2 = allocateNode(name: "n2", graph: graph, owner: owner)
	let e1 = allocateEdge(graph: graph)
	CNGraph.link(from: n1, to: n2, by: e1)
	dump(console: cons, graph: graph)

	cons.print(string: "* Graph3\n")
	let n3 = allocateNode(name: "n3", graph: graph, owner: owner)
	let e2 = allocateEdge(graph: graph)
	CNGraph.link(from: n3, to: n2, by: e2)
	dump(console: cons, graph: graph)
	
	return true
}

private func allocateNode(name nm:String, graph g: CNGraph, owner own: AnyObject) -> CNNode {
	return g.allocateNode(name: nm, owner: own)
}

private func allocateEdge(graph g: CNGraph) -> CNEdge {
	return g.allocateEdge()
}

private func dump(console cons: CNConsole, graph src: CNGraph)
{
	let text = src.dump()
	text.print(console: cons)
}

