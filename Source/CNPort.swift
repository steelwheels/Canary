/**
 * @file	CNPort.h
 * @brief	Define CNPort class
 * @par Copyright
 *   Copyright (C) 2015-2017 Steel Wheels Project
 */

import Foundation

open class CNPort<T>
{
	private var mConnections: Array<CNConnection<T>>

	public init(){
		mConnections = []
	}
	public var connections: Array<CNConnection<T>> {
		get { return mConnections }
	}
	open func add(connection conn: CNConnection<T>){
		mConnections.append(conn)
	}
	public func remove(connection conn: CNConnection<T>){
		var docont = true
		while docont {
			docont = false
			let count = mConnections.count
			for i in 0..<count {
				if mConnections[i] === conn {
					docont = true
					break
				}
			}
		}
	}
}

public class CNInputPort<T>: CNPort<T>
{
	private var mReceivers: Array<(_ data: T) -> Void>
	public override init(){
		mReceivers = []
	}
	public func add(callback cbfunc: @escaping (_ data: T) -> Void){
		mReceivers.append(cbfunc)
	}
	public override func add(connection conn: CNConnection<T>){
		super.add(connection: conn)
		conn.inputPort = self
	}
	public func input(data d: T) -> Void {
		for receiver in mReceivers {
			receiver(d)
		}
	}
}

public class CNOutputPort<T>: CNPort<T>
{
	public override init(){
		super.init()
	}
	public override func add(connection conn: CNConnection<T>){
		super.add(connection: conn)
		conn.outputPort = self
	}
	public func output(data d: T){
		for conn in connections {
			if let iport = conn.inputPort {
				iport.input(data: d)
			}
		}
	}
}

public class CNConnection<T> {
	public var inputPort:  CNInputPort<T>?
	public var outputPort: CNOutputPort<T>?

	public init(inputPort iport: CNInputPort<T>, outputPort oport: CNOutputPort<T>){
		inputPort	= iport
		outputPort	= oport
	}
	public init(){
		inputPort	= nil
		outputPort	= nil
	}
	deinit {
		if let iport = inputPort {
			iport.remove(connection: self)
			inputPort = nil
		}
		if let oport = outputPort {
			oport.remove(connection: self)
			outputPort = nil
		}
	}
}

