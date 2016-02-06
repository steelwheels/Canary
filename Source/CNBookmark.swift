/*
 * @file	CNBookmark.swift
 * @brief	Extend CNBookmark class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

internal class CNBookmarks
{
	private var bookmarkDictionary : NSMutableDictionary
	
	internal init(){
		bookmarkDictionary = NSMutableDictionary(capacity: 8)
	}
	
	internal func addBookmark(URL url: NSURL) -> NSError? {
		if let path = url.path {
			if let _ = bookmarkDictionary.objectForKey(path) as? NSData {
				/* Already store */
			} else {
				let data = allocateBookmarkData(URL: url)
				bookmarkDictionary.setObject(data, forKey: path)
			}
			return nil
		} else {
			return NSError.fileError("Invalid URL: \(url)")
		}
	}

	internal func searchBookmark(pathString path: String) -> NSURL? {
		if let data = bookmarkDictionary.objectForKey(path) as? NSData {
			if let url = CNBookmarks.resolveURL(bookmarkData: data) {
				return url
			} else {
				NSLog("Broken bookmark data for key \"\(path)\"")
			}
		}
		return nil
	}
	
	internal class func decode(dict : NSDictionary) -> CNBookmarks {
		let newbookmarks = CNBookmarks()
		newbookmarks.bookmarkDictionary.setDictionary(dict as [NSObject : AnyObject])
		return newbookmarks
	}

	internal func encode() -> NSDictionary {
		return bookmarkDictionary
	}
	
	internal func clear() {
		bookmarkDictionary.removeAllObjects()
	}
	
	private func allocateBookmarkData(URL url: NSURL) -> NSData {
		do {
			let data = try url.bookmarkDataWithOptions(.WithSecurityScope, includingResourceValuesForKeys: nil, relativeToURL: nil)
			return data
		}
		catch {
			let urlstr = url.absoluteString
			fatalError("Can not allocate bookmark: \"\(urlstr)")
		}
	}
	
	private class func resolveURL(bookmarkData bmdata: NSData) -> NSURL? {
		do {
			var isstale: ObjCBool = false;
			let newurl = try NSURL(byResolvingBookmarkData: bmdata, options: .WithSecurityScope, relativeToURL: nil, bookmarkDataIsStale: &isstale)
			return newurl
		}
		catch {
			NSLog("Failed to resolve bookmark")
			return nil
		}
	}
}

public class CNBookmarkPreference
{
	public static let sharedPreference = CNBookmarkPreference()
	private var mBookmarks : CNBookmarks
	
	private init(){
		if let pref = CNBookmarkPreference.rootPreferences() {
			mBookmarks = CNBookmarks.decode(pref)
		} else {
			mBookmarks = CNBookmarks()
		}
	}
	
	public func saveToUserDefaults(URL url: NSURL)
	{
		mBookmarks.addBookmark(URL: url)
	}
	
	public func saveToUserDefaults(URLs urls: Array<NSURL>)
	{
		for url in urls {
			mBookmarks.addBookmark(URL: url)
		}
	}
	
	public func loadFromUserDefaults(path:String) -> NSURL? {
		return mBookmarks.searchBookmark(pathString: path)
	}
	
	public func clear(){
		mBookmarks.clear()
	}
	
	public func synchronize() {
		let dict = mBookmarks.encode()
		let preference = NSUserDefaults.standardUserDefaults()
		preference.setObject(dict, forKey: CNBookmarkPreference.bookmarkPreferekceKey())
		preference.synchronize()
	}
	
	private class func rootPreferences() -> NSDictionary? {
		let preference = NSUserDefaults.standardUserDefaults()
		if let dict = preference.dictionaryForKey(CNBookmarkPreference.bookmarkPreferekceKey()) {
			return dict
		} else {
			return nil
		}
	}
	
	private class func bookmarkPreferekceKey() -> String {
		return "bookmarks"
	}
}

/*

public class CNBookmarkPreference
{
	public static let sharedPreference = CNBookmarkPreference()
	
	private var mBookmarks : CNBookmarks
	
	private init(){
		if let pref = CNBookmarkPreference.rootPreferences() {
			mBookmarks = CNBookmarks.decode(pref)
		} else {
			mBookmarks = CNBookmarks()
		}
	}
	
	public func saveToUserDefaults(mainURL mainurl: NSURL, relativeFileURL relfile: NSURL?)
	{
		mBookmarks.addBookmark(mainURL: mainurl, relativeFileURL: relfile)
	}
	
	public func loadFromUserDefaults(mainpath:String, relativeFileURL relurl : NSURL?) -> CNFileURL? {
		return mBookmarks.loadFromUserDefaults(mainpath, relativeFileURL: relurl)
	}
	
	public func clear() {
		mBookmarks.clear()
	}
	
	public func synchronize() {
		let dict = mBookmarks.encode()
		let preference = NSUserDefaults.standardUserDefaults()
		preference.setObject(dict, forKey: CNBookmarkPreference.bookmarkPreferekceKey())
		preference.synchronize()
	}
	
	public func dump() {
		mBookmarks.dump()
	}
	
	private class func rootPreferences() -> NSDictionary? {
		let preference = NSUserDefaults.standardUserDefaults()
		if let dict = preference.dictionaryForKey(CNBookmarkPreference.bookmarkPreferekceKey()) {
			return dict
		} else {
			return nil
		}
	}
	
	private class func bookmarkPreferekceKey() -> String {
		return "bookmarks"
	}
}

*/

/*


internal class CNBookmarkElement
{
	internal var URL		: NSURL
	internal var bookmarkData	: NSData
	
	internal init(URL url: NSURL, bookmark bm: NSData){
		URL		= url
		bookmarkData	= bm
	}
	
	internal func encode() -> NSData {
		return bookmarkData
	}
	
	internal class func decode(bookmarkData bmdata: NSData, relatedURL relurl: NSURL?) -> CNBookmarkElement? {
		do {
			var isstale: ObjCBool = false;
			let newurl = try NSURL(byResolvingBookmarkData: bmdata, options: .WithSecurityScope, relativeToURL: relurl, bookmarkDataIsStale: &isstale)
			return CNBookmarkElement(URL: newurl, bookmark: bmdata)
		}
		catch {
			NSLog("Failed to resolve bookmark")
			return nil
		}
	}
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
	
	public var URL : NSURL {
		return mElement.URL
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
		let elmdata = mElement.encode()
		let childdict = NSMutableDictionary(capacity: 4)
		for key in mChildren.keys {
			if let child = mChildren[key] {
				childdict[key] = child.encode()
			} else {
				fatalError("Invalid key: \(key)")
			}
		}
		let result = NSDictionary(dictionary: [
			CNBookmark.elementKey()  : elmdata,	/* NSData	*/
			CNBookmark.childrenKey() : childdict	/* NSDictionary */
		])
		return result
	}
	
	public class func decode(dict : NSDictionary, relatedURL relurl: NSURL?) -> CNBookmark? {
		var element : CNBookmarkElement
		if let elmdata = dict.valueForKey(elementKey()) as? NSData {
			if let elmobj = CNBookmarkElement.decode(bookmarkData: elmdata, relatedURL: relurl) {
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
				if let childdict = childdict.objectForKey(keyobj) as? NSDictionary,
				   let keystr = keyobj as? String {
					if let childobj = CNBookmark.decode(childdict, relatedURL: element.URL) {
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
	
	public func addBookmark(mainURL mainurl: NSURL, relativeFileURL: NSURL?) -> CNBookmark {
		var result : CNBookmark ;
		if let relfile = relativeFileURL, relpath = relfile.path {
			var relbookmark : CNBookmark?
			if let bm = searchByPath(relpath, doRecursive: true) {
				relbookmark = bm
			} else {
				relbookmark = addBookmark(mainURL: relfile, relativeFileURL: nil)
			}
			let maindata     = allocateBookmarkData(mainURL: mainurl, relativeFileURL: relfile)
			let mainbookmark = CNBookmark(URL: mainurl, bookmark: maindata)
			relbookmark?.addChild(relpath, bookmark: mainbookmark)
			result = mainbookmark
		} else {
			if let mainpath = mainurl.path {
				if let bookmark = searchByPath(mainpath, doRecursive: false) {
					result = bookmark
				} else {
					let maindata = allocateBookmarkData(mainURL: mainurl, relativeFileURL: nil)
					result = CNBookmark(URL: mainurl, bookmark: maindata)
					mBookmarks[mainpath] = result
				}
			} else {
				fatalError("Invalid main URL")
			}
		}
		return result
	}

	public func loadFromUserDefaults(mainPath:String, relativeFileURL: NSURL?) -> CNFileURL? {
		var result : CNFileURL? = nil
		if let relurl = relativeFileURL, relpath = relurl.path {
			if let relbookmark = searchByPath(relpath, doRecursive: true){
				if let mainbookmark = relbookmark.searchByPath(mainPath, doRecursive: false) {
					result = CNFileURL(mainURL: mainbookmark.URL)
				}
			}
		} else {
			if let bookmark = mBookmarks[mainPath] {
				result = CNFileURL(mainURL: bookmark.URL)
			}
		}
		return result
	}
	
	public func clear() {
		mBookmarks = [:]
	}
	
	private func searchByPath(path: String, doRecursive: Bool) -> CNBookmark? {
		if let bookmark = mBookmarks[path] {
			return bookmark
		}
		if doRecursive {
			for bookmark in mBookmarks.values {
				if let result = bookmark.searchByPath(path, doRecursive: true) {
					return result
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
		var bookdict : Dictionary<String, CNBookmark> = [:]
		for keyobj in dict.allKeys {
			if let value = dict.objectForKey(keyobj) as? NSDictionary,
			   let keystr = keyobj as? String {
				if let element = CNBookmark.decode(value, relatedURL: nil) {
					bookdict[keystr] = element
				}
			}
		}
		return CNBookmarks(bookmarks: bookdict)
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
	
	private func allocateBookmarkData(mainURL mainurl: NSURL, relativeFileURL relurl: NSURL?) -> NSData {
		do {
			let data = try mainurl.bookmarkDataWithOptions(.WithSecurityScope, includingResourceValuesForKeys: nil, relativeToURL: relurl)
			return data
		}
		catch {
			var relstr  : String
			if let url = relurl {
				relstr  = url.absoluteString
			} else {
				relstr  = "<nil>"
			}
			fatalError("Can not allocate bookmark: target=\"\(mainurl.absoluteString)\", reldir=\"\(relstr)\"")
		}
	}
}

*/


