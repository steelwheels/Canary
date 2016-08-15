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
			return NSError.fileError(message: "Invalid URL: \(url)")
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
	
	internal class func decode(dictionary dict : NSDictionary) -> CNBookmarks {
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
	
	internal func dump(){
		Swift.print("(CNBookmarks \(bookmarkDictionary))")
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
			mBookmarks = CNBookmarks.decode(dictionary: pref)
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
	
	public func loadFromUserDefaults(path p:String) -> NSURL? {
		return mBookmarks.searchBookmark(pathString: p)
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
	
	public func dump(){
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


