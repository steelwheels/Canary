/*
 * @file	CNJSON.swift
 * @brief	Define CNJSON class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import Foundation

public class CNJSON
{
	public class func merge(destination dst: inout Dictionary<String, Any>, source src: Dictionary<String, Any>){
		for srckey in src.keys {
			if let srcval = src[srckey] {
				merge(destination: &dst, sourceKey: srckey, sourceValue: srcval)
			} else {
				NSLog("Internal error: key \(srckey)")
			}
		}
	}

	private class func merge(destination dst: inout Dictionary<String, Any>, sourceKey srckey: String, sourceValue srcval: Any){
		if let dstval = dst[srckey] {
			if var dstinfo = dstval as? Dictionary<String, Any>, let srcinfo = srcval as? Dictionary<String, Any> {
				/* merge children */
				merge(destination: &dstinfo, source: srcinfo)
			} else if var dstarr = dstval as? Array<Any>, let srcarr = srcval as? Array<Any> {
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

