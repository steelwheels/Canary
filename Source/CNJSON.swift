/*
 * @file	CNJSON.swift
 * @brief	Define CNJSON class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import Foundation

public class CNJSON
{
	public class func merge(destination dst: inout Dictionary<String, AnyObject>, source src: Dictionary<String, AnyObject>){
		for srckey in src.keys {
			if let srcval = src[srckey] {
				merge(destination: &dst, sourceKey: srckey, sourceValue: srcval)
			} else {
				NSLog("Internal error: key \(srckey)")
			}
		}
	}

	private class func merge(destination dst: inout Dictionary<String, AnyObject>, sourceKey srckey: String, sourceValue srcval: AnyObject){
		if let dstval = dst[srckey] {
			if var dstinfo = dstval as? Dictionary<String, AnyObject>, let srcinfo = srcval as? Dictionary<String, AnyObject> {
				/* merge children */
				merge(destination: &dstinfo, source: srcinfo)
			} else if var dstarr = dstval as? Array<AnyObject>, let srcarr = srcval as? Array<AnyObject> {
				/* merge array */
				dstarr.append(contentsOf: srcarr)
			} else {
				/* Replace value */
				dst[srckey] = srcval
			}
		} else {
			/* add as new value */
			dst[srckey] = srcval
		}
	}
}

