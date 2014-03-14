/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

import com.lmt.baseapp.util.StringFunction;

public class ASDataWindowDock {

	public ASDataWindowDock(String sID) {
		id = sID;
	}

	public void setAttribute(String sAttributeID, String sAttributeValue) {
		StringFunction.setAttribute(attributes, sAttributeID, sAttributeValue);
	}

	public String getAttribute(String sAttributeID) {
		return StringFunction.getAttribute(attributes, sAttributeID);
	}

	public String id;
	public String name;
	public String attributes[][] = { { "TableWidth", "100%" },
			{ "TableAttribute", " border=0 cellspacing=0 cellpadding=0" },
			{ "TotalColumns", "12" }, { "DefaultColspan", "6" },
			{ "DefaultColspanForLongType", "12" }, { "DefaultPosition", "" } };
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 296 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/