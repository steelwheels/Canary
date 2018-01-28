/**
 * @file	CNGraph.swift
 * @brief	Define CNGraphDumper class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

extension CNGraph
{
	public func dump() -> CNTextSection {
		resetVisitedFlag()

		let root = CNTextSection()
		var docontinue = true
		while docontinue {
			docontinue = false
			for node in self.nodes {
				if isPrintableNode(node: node){
					dumpNode(section: root, node: node)
					docontinue = true
				}
			}
		}
		return root
	}

	private func dumpNode(section sect: CNTextSection, node src: CNNode){
		let nodetxt = CNTextLine(string: src.description)
		sect.add(text: nodetxt)

		src.didVisited = true
		for edge in src.outputEdges {
			edge.object.didVisited = true
		}

		let subsect = CNTextSection()
		for edge in src.outputEdges {
			if let subnode = edge.object.toNode {
				if isPrintableNode(node: subnode) {
					dumpNode(section: subsect, node: subnode)
				}
			} else {
				fatalError("No toNode")
			}
		}
		if subsect.count > 0 {
			sect.add(text: subsect)
		}
	}

	private func isPrintableNode(node src: CNNode) -> Bool {
		if !src.didVisited {
			var printable = true
			for edge in src.inputEdges {
				if !edge.object.didVisited {
					printable = false
					break
				}
			}
			return printable
		} else {
			return false
		}
	}

}
