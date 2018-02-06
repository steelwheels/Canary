/**
 * @file	CNAuthorize.swift
 * @brief	Define CNAuthorize class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Contacts
import Foundation

public class CNAddressBook
{
	private var mState: CNAuthorizeState

	public init(){
		mState = .Undetermined
	}

	public var state: CNAuthorizeState { get { return mState }}

	public func authorize() -> CNAuthorizeState {
		if mState == .Undetermined {
			let status = CNContactStore.authorizationStatus(for: .contacts)
			switch status {
			case .authorized:
				mState = .Authorized
			case .denied:
				mState = .Denied
			case .notDetermined, .restricted:
				let store = CNContactStore()
				mState = .Examinating
				store.requestAccess(for: .contacts, completionHandler: {
					(_ granted: Bool, _ error: Error?) -> Void in
					if granted {
						self.mState = .Authorized
					} else {
						self.mState = .Denied
					}
				})
			}
		}
		return mState
	}

	public func contacts() -> Array<Dictionary<String, Any>>? {
		if mState == .Authorized {
			let keys    = [
				CNContactIdentifierKey		as CNKeyDescriptor,
				CNContactTypeKey		as CNKeyDescriptor,
				CNContactBirthdayKey		as CNKeyDescriptor,
				CNContactNamePrefixKey		as CNKeyDescriptor,
				CNContactGivenNameKey		as CNKeyDescriptor,
				CNContactMiddleNameKey		as CNKeyDescriptor,
				CNContactFamilyNameKey		as CNKeyDescriptor
			]
			let request = CNContactFetchRequest(keysToFetch: keys)
			do {
				let store = CNContactStore()
				var result: Array<Dictionary<String, Any>> = []
				try store.enumerateContacts(with: request, usingBlock: {
					(contact, pointer) in
					result.append(CNAddressBook.contactToDictionary(contact: contact))
				})
				return result
			}
			catch {
				return nil
			}
		} else {
			return nil
		}
	}

	private class func contactToDictionary(contact cont: CNContact) -> Dictionary<String, Any> {
		var result: Dictionary<String, Any> = [:]

		appendDictionary(destination: &result, property: "identifier", 	value: cont.identifier)

		let typestr: String
		switch cont.contactType {
		case .organization:	typestr = "organization"
		case .person:		typestr = "person"
		}
		appendDictionary(destination: &result, property: "contactType", value: typestr)

		if let birthday = cont.birthday {
			appendDictionary(destination: &result, property: "namePrefix", 	value:	birthday.description)
		}
		appendDictionary(destination: &result, property: "namePrefix", 	value:	cont.namePrefix)
		appendDictionary(destination: &result, property: "givenName", 	value:	cont.givenName)
		appendDictionary(destination: &result, property: "middleName",	value:	cont.middleName)
		appendDictionary(destination: &result, property: "familyName",	value:	cont.familyName)
		return result
	}

	private class func appendDictionary(destination dst: inout Dictionary<String, Any>, property prop: String, value val: String) {
		if val.lengthOfBytes(using: .utf8) > 0 {
			dst[prop] = val
		}
	}
}

