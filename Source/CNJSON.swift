/*
 * @file	CNJSON.swift
 * @brief	Define CNJSON class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import Foundation

public class CNJSON
{
	public class func merge(destination dst: inout NSMutableDictionary, source src: NSDictionary){
		for srckey in src.allKeys {
			if let keystr = srckey as? String {
				if let srcval = src.value(forKey: keystr) {
					merge(destination: &dst, sourceKey: keystr, sourceValue: srcval)
				} else {
					NSLog("Internal error: key \(keystr)")
				}
			} else {
				NSLog("Internal error: key \(srckey)")
			}
		}
	}

	private class func merge(destination dst: inout NSMutableDictionary, sourceKey srckey: String, sourceValue srcval: Any){
		if let dstval = dst[srckey] {
			if var dstinfo = dstval as? NSMutableDictionary, let srcinfo = srcval as? NSDictionary {
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

