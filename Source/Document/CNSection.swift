/**
 * @file	CNSection.h
 * @brief	Define CNSection class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNSection : CNDocumentObject
{
	public var headerText	: CNTextLine			= CNTextLine()
	public var footerText	: CNTextLine			= CNTextLine()
	public var contents	: Array<CNDocumentObject>	= []
}
