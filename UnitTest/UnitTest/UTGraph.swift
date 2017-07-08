/**
* @file	UTGraph.swift
* @brief	Unit test for CNGraph class
* @par Copyright
*   Copyright (C) 2017 Steel Wheels Project
*/

import Canary

public func UTGraphTest() -> Bool
{
	let console = CNFileConsole(file: CNTextFile.stdout)

	console.print(string: "* Graph1\n")
	let graph = CNGraph()
	let n0 = allocateNode(graph: graph)
	let n1 = allocateNode(graph: graph)
	let e0 = allocateEdge(graph: graph)
	CNGraph.link(from: n0, to: n1, by: e0)
	dump(console: console, graph: graph)

	console.print(string: "* Graph2\n")
	let n2 = allocateNode(graph: graph)
	let e1 = allocateEdge(graph: graph)
	CNGraph.link(from: n1, to: n2, by: e1)
	dump(console: console, graph: graph)

	console.print(string: "* Graph3\n")
	let n3 = allocateNode(graph: graph)
	let e2 = allocateEdge(graph: graph)
	CNGraph.link(from: n3, to: n2, by: e2)
	dump(console: console, graph: graph)
	
	return true
}

private func allocateNode(graph g: CNGraph) -> CNNode {
	return g.allocateNode(allocFunc: {
		(_ uid: Int) -> CNNode in
		return CNNode(uniqueId: uid, triggerCallback: {
			(_ node:CNNode) -> Void in
			Swift.print("*trigger*")
		})
	})
}

private func allocateEdge(graph g: CNGraph) -> CNEdge {
	return g.allocateEdge(allocFunc: {
		(_ uid: Int) -> CNEdge in
		return CNEdge(uniqueId: uid)
	})
}

private func dump(console cons: CNConsole, graph src: CNGraph)
{
	let text = src.dump()
	text.print(console: cons)
}

