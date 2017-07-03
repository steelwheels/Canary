/**
 * @file	CNStack.swift
 * @brief	Define CNStack class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class CNStack<T>
{
	private var mBody: Array<T>

	public init(){
		mBody = []
	}

	public func push(_ element: T){
		mBody.append(element)
	}

	public func pop() -> T? {
		let count = mBody.count
		if count >= 1 {
			let element = mBody[count-1]
			mBody.removeLast()
			return element
		} else {
			return nil
		}
	}

	public func peekTop() -> T? {
		let count = mBody.count
		if count >= 1 {
			return mBody[count-1]
		} else {
			return nil
		}
	}
}

