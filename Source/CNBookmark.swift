/*
 * @file	CNBookmark.swift
 * @brief	Extend CNBookmark class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

internal func keyForURL(URL url: NSURL) -> String {
	if let path = url.path {
		return path
	} else {
		return "<nil>"
	}
}

internal class CNBookmarkElement
{
	internal var URL	: NSURL
	internal var bookmark	: NSData
	
	internal init(URL url: NSURL, bookmark bm: NSData){
		URL		= url
		bookmark	= bm
	}
	
	internal func encode() -> NSDictionary {
		let result = NSDictionary(dictionary: [
			CNBookmarkElement.urlKey():URL,
			CNBookmarkElement.bookmarkKey():bookmark
		])
		return result
	}
	
	internal class func decode(dict : NSDictionary) -> CNBookmarkElement? {
		var url : NSURL
		if let uval = dict.valueForKey(urlKey()) as? NSURL {
			url = uval
		} else {
			NSLog("\"URL\" value is not exist")
			return nil
		}
		var bookmark : NSData
		if let bval = dict.valueForKey(bookmarkKey()) as? NSData {
			bookmark = bval
		} else {
			NSLog("\"Bookmark\" value is not exist")
			return nil
		}
		return CNBookmarkElement(URL: url, bookmark: bookmark)
	}
	
	private class func urlKey()      -> String { return "url" }
	private class func bookmarkKey() -> String { return "bookmark" }
}

public class CNBookmark
{
	private var mElement  : CNBookmarkElement
	private var mChildren : Dictionary<String, CNBookmark>
	
	public init(URL murl: NSURL, bookmark bm: NSData){
		mElement  = CNBookmarkElement(URL: murl, bookmark: bm)
		mChildren = [:]
	}
	
	internal init(element : CNBookmarkElement, children: Dictionary<String, CNBookmark>) {
		mElement	= element
		mChildren	= children
	}
	
	public func addChild(path: String, bookmark : CNBookmark) {
		mChildren[path] = bookmark
	}
	
	public func searchByPath(path : String, doRecursive: Bool) -> CNBookmark? {
		if let bookmark = mChildren[path] {
			return bookmark
		}
		if doRecursive {
			for bookmark in mChildren.values {
				if let bm = bookmark.searchByPath(path, doRecursive: true) {
					return bm
				}
			}
		}
		return nil
	}
	
	public func encode() -> NSDictionary {
		let elmdict = mElement.encode()
		let childdict = NSMutableDictionary(capacity: 4)
		for key in mChildren.keys {
			if let child = mChildren[key] {
				childdict[key] = child.encode()
			} else {
				fatalError("Invalid key: \(key)")
			}
		}
		let result = NSDictionary(dictionary: [
			CNBookmark.elementKey()  : elmdict,
			CNBookmark.childrenKey() : childdict
		])
		return result
	}
	
	public class func decode(dict : NSDictionary) -> CNBookmark? {
		var element : CNBookmarkElement
		if let elmdict = dict.valueForKey(elementKey()) as? NSDictionary {
			if let elmobj = CNBookmarkElement.decode(elmdict) {
				element = elmobj
			} else {
				return nil
			}
		} else {
			NSLog("\"element\" value is not found")
			return nil
		}
		var children : Dictionary<String, CNBookmark> = [:]
		if let childdict = dict.valueForKey(childrenKey()) as? NSDictionary {
			for keyobj in childdict.allKeys {
				if let value = childdict.objectForKey(keyobj) as? NSDictionary,
				   let keystr = keyobj as? String {
					if let childobj = CNBookmark.decode(value) {
						children[keystr] = childobj
					}
				} else {
					fatalError("Invalid key: \(keyobj)")
				}
			}
		}
		return CNBookmark(element: element, children: children)
	}
	
	public func dump(level: UInt, path: String) {
		let indent = indentStr(level)
		let urlstr = mElement.URL.path
		print("\(indent) path: \(path)")
		print("\(indent) - \(urlstr)")
		
		for cpath in mChildren.keys {
			if let cbookmark = mChildren[cpath] {
				cbookmark.dump(level+1, path: cpath)
			} else {
				fatalError("Can not happen")
			}
		}
	}
	
	public func indentStr(level: UInt) -> String {
		var str = ""
		for var i:UInt=0 ; i<level ; i++ {
			str = str + "  "
		}
		return str
	}
	
	private class func elementKey()	 -> String { return "element"	}
	private class func childrenKey() -> String { return "children"	}
}

public class CNBookmarks
{
	private var mBookmarks : Dictionary<String, CNBookmark>
	
	public init(bookmarks : Dictionary<String, CNBookmark>){
		mBookmarks = bookmarks
	}
	
	public init(){
		mBookmarks = [:]
	}
	
	public func addBookmark(mainURL mainurl: NSURL, relativeURL: NSURL?) -> CNBookmark {
		var result : CNBookmark ;
		if let relurl = relativeURL {
			var relbookmark : CNBookmark? = searchByURL(URL: relurl, doRecursive: true)
			if relbookmark == nil {
				relbookmark  = addBookmark(mainURL: relurl, relativeURL: nil)
			}
			let maindata     = allocateBookmarkData(mainURL: mainurl, relativeURL: relurl)
			let mainbookmark = CNBookmark(URL: mainurl, bookmark: maindata)
			relbookmark!.addChild(keyForURL(URL: mainurl), bookmark: mainbookmark)
			result = mainbookmark
		} else {
			if let bookmark = searchByURL(URL: mainurl, doRecursive: false) {
				/* Already exist */
				result = bookmark
			} else {
				let maindata = allocateBookmarkData(mainURL: mainurl, relativeURL: nil)
				result = CNBookmark(URL: mainurl, bookmark: maindata)
				mBookmarks[keyForURL(URL: mainurl)] = result
			}
		}
		return result
	}
	
	public func clear() {
		mBookmarks = [:]
	}
	
	public func searchByURL(URL url : NSURL, doRecursive: Bool) -> CNBookmark? {
		let key = keyForURL(URL: url)
		if let bookmark = mBookmarks[key] {
			return bookmark
		}
		if doRecursive {
			for bookmark in mBookmarks.values {
				if let bm = bookmark.searchByPath(key, doRecursive: true) {
					return bm
				}
			}
		}
		return nil
	}
	
	public func encode() -> NSDictionary {
		let result = NSMutableDictionary(capacity: 4)
		for key in mBookmarks.keys {
			if let value = mBookmarks[key] {
				let dict = value.encode()
				result.setValue(dict, forKey: key)
			} else {
				fatalError("Invalid key: \(key)")
			}
		}
		return result
	}
	
	public class func decode(dict : NSDictionary) -> CNBookmarks {
		var result : Dictionary<String, CNBookmark> = [:]
		for keyobj in dict.allKeys {
			if let value = dict.objectForKey(keyobj) as? NSDictionary,
			   let keystr = keyobj as? String {
				if let element = CNBookmark.decode(value) {
					result[keystr] = element
				}
			}
		}
		return CNBookmarks(bookmarks: result)
	}
	
	public func dump() {
		print("bookmarks {")
		for path in mBookmarks.keys {
			if let bookmark = mBookmarks[path] {
				bookmark.dump(0, path: path)
			} else {
				fatalError("Can not happen")
			}
		}
		print("}")
	}
	
	private func allocateBookmarkData(mainURL mainurl: NSURL, relativeURL relurl: NSURL?) -> NSData {
		do {
			let data = try mainurl.bookmarkDataWithOptions(.WithSecurityScope, includingResourceValuesForKeys: nil, relativeToURL: relurl)
			return data
		}
		catch {
			fatalError("Can not allocate bookmark")
		}
	}
}

