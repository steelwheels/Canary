/**
 * @file	CNCurses.swift
 * @brief	Define CNCurses class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation
import Darwin.ncurses

public class CNCurses
{
	public enum Color: Int {
		case Black	= 0
		case Red	= 1
		case Green	= 2
		case Yellow	= 3
		case Blue	= 4
		case Magenta	= 5
		case Cian	= 6
		case White	= 7
	}

	public init() {
	}

	public func setup() {
		initscr()
		start_color()
		self.visiblePrompt = false
		self.doBuffering   = false
		self.doEcho        = false
		refresh()
	}

	public func finalize(){
		endwin()
	}

	public var width: Int {
		get { return Int(getmaxx(stdscr)) }
	}

	public var height: Int {
		get { return Int(getmaxy(stdscr)) }
	}

	public func clear(){
		erase()
		refresh()
	}

	private var mVisiblePrompt: Bool = false
	public var visiblePrompt: Bool {
		get { return mVisiblePrompt }
		set(value) {
			curs_set(value ? 0 : 1)
			mVisiblePrompt = value ;
		}
	}

	private var mDoBuffering: Bool = false
	public var doBuffering: Bool {
		get { return mDoBuffering }
		set(value) {
			if value {
				nocbreak()
			} else {
				cbreak()
			}
			mDoBuffering = value
		}
	}

	private var mDoEcho: Bool = false
	public var doEcho: Bool {
		get { return mDoEcho }
		set(value) {
			if value {
				echo()
			} else {
				noecho()
			}
			mDoEcho = value
		}
	}

	public func setForegroundColor(color col: Color){
		let colid  = col.rawValue
		let colstr = "\u{16}[3\(colid)m"
		put(string: colstr)
	}

	public func setBackgroundColor(color col: Color){
		let colid  = col.rawValue
		let colstr = "\u{16}[4\(colid)m"
		put(string: colstr)
	}

	public func moveTo(x xval: Int, y yval: Int){
		move(Int32(yval), Int32(xval))
	}

	public func getKey() -> Int32? {
		let result: Int32?
		let key = getch()
		if key != Darwin.ERR {
			result = key
		} else {
			result = nil
		}
		return result
	}

	public func put(string s: String){
		addstr(s)
	}
}

