/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

import java.util.Vector;

// Referenced classes of package com.amarsoft.web.dw:
//            ASColumn

public class ASRow implements Cloneable {

	public ASRow(String sRowNo) {
		ChangedColumns = new Vector();
		AllColumns = new Vector();
		RowNo = sRowNo;
	}

	public ASColumn getColumnFromAllColumns(String actualName) {
		for (int i = 0; i < AllColumns.size(); i++) {
			ASColumn column = (ASColumn) AllColumns.get(i);
			if (actualName.equals(column.getActualName()))
				return column;
		}

		return null;
	}

	public String RowNo;
	public String RowDescribe;
	public Vector ChangedColumns;
	public Vector AllColumns;
	public String RowAuditStr;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 140 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/