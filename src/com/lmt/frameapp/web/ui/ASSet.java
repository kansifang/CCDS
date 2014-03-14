/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.ui;

import java.util.Vector;

public class ASSet {

	public ASSet() {
		vSet = new Vector();
	}

	public boolean addElement(String sElement) {
		int iCount = vSet.size();
		for (int i = 0; i < iCount; i++) {
			String sTemp = (String) vSet.get(i);
			if (sTemp.equals(sElement))
				return false;
		}

		vSet.addElement(sElement);
		return true;
	}

	public Object getElement(int iIndex) {
		return vSet.get(iIndex);
	}

	public int getSize() {
		return vSet.size();
	}

	private Vector vSet;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 172 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/