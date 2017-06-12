/*
 * @file	CNFileURL.swift
 * @brief	Extend CNFileURL class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

/**
 * Extend the URL methods to open, load, save, close the files in the sand-box
 */
public extension URL
{
#if os(OSX)
	public static func openPanel(title tl: String, fileTypes types: Array<String>?) -> URL?
	{
		let panel = NSOpenPanel()

		panel.title = tl
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.allowedFileTypes = types

		var result: URL? = nil
		switch panel.runModal() {
		case NSFileHandlingPanelOKButton:
			let urls = panel.urls
			if urls.count == 1 {
				let preference = CNBookmarkPreference.sharedPreference
				preference.saveToUserDefaults(URLs: urls)
				preference.synchronize()

				result = urls[0]
			} else {
				NSLog("Invalid result: \(urls)")
			}
		case NSFileHandlingPanelCancelButton:
			break
		default:
			break
		}
		return result
	}
#endif

	/**
	 Open the panel to select the file to save the current context
	
	 - returns:			Yes when the file is seleted to save
	 - parameter title:		Title of the save panel
	 - parameter outputDirectory:	Default parent directory to save the file
	 - parameter saveFileCallback:	Callback function to be called when the file is selected
	 */
#if os(OSX)
	public static func savePanel(title tl: String, outputDirectory outdir: URL?, saveFileCallback callback: @escaping ((_: URL) -> Bool))
	{
		let panel = NSSavePanel()
		panel.title = tl
		panel.canCreateDirectories = true
		panel.showsTagField = false
		if let odir = outdir {
			panel.directoryURL = odir
		}
		panel.begin(completionHandler: { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				if let newurl = panel.url {
					if callback(newurl) {
						let preference = CNBookmarkPreference.sharedPreference
						preference.saveToUserDefaults(URL: newurl)
						preference.synchronize()
					}
				}
			}
		})
	}
#endif

	public static func relativePath(sourceURL src: URL, baseDirectory base: URL) -> URL {
		let srccomp = src.pathComponents
		let basecomp = base.pathComponents
		let common = findLastCommonComponent(array0: srccomp, array1: basecomp)
		if common > 0 {
			var resultpath = ""
			let updirs = basecomp.count - common
			for _ in 0..<updirs {
				resultpath = "../" + resultpath
			}
			var is1st : Bool = true
			for comp in common ... srccomp.count-1 {
				if is1st {
					is1st = false
				} else {
					resultpath = resultpath + "/"
				}
				resultpath = resultpath + srccomp[comp]
			}
			return URL(fileURLWithPath: resultpath)
		}
		return src
	}

	public func loadContents() -> (NSString?, NSError?) {
		if startAccessingSecurityScopedResource() {
			do {
				let contents = try NSString(contentsOf: self, encoding: String.Encoding.utf8.rawValue)
				stopAccessingSecurityScopedResource()
				return (contents, nil)
			}
			catch {
				stopAccessingSecurityScopedResource()
				let error = NSError.fileError(message: "Can not access: \(path)")
				return (nil, error)
			}
		} else {
			let error = NSError.fileError(message: "Can not access: \(path)")
			return (nil, error)
		}
	}

	private static func findLastCommonComponent(array0 s0: Array<String>, array1 s1: Array<String>) -> Int {
		let s0count = s0.count
		let s1count = s1.count
		let count   = s0count < s1count ? s0count : s1count
		
		for i in 0..<count {
			if s0[i] != s1[i] {
				return i
			}
		}
		return count - 1
	}
}

