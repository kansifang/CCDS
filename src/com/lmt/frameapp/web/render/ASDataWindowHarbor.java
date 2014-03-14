/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

import java.util.Vector;

// Referenced classes of package com.amarsoft.web.dw:
//            ASDataWindowDock

public class ASDataWindowHarbor {

	public ASDataWindowHarbor(String sID) {
		htmlTemplateID = "";
		htmlTemplate = "";
		docks = new Vector();
		id = sID;
		docks.add(new ASDataWindowDock("default"));
		htmlTemplate = "${DOCK:default}";
	}

	public int docksCount() {
		return docks.size();
	}

	public void setHtmlTemplate(String sHtml) throws Exception {
		htmlTemplate = sHtml;
		docks.clear();
		int iPosBegin = 0;
		int iPosEnd = 0;
		String sBeginSign = "${DOCK:";
		String sEndSign = "}";
		for (iPosBegin = htmlTemplate.indexOf(sBeginSign); iPosBegin >= 0; iPosBegin = htmlTemplate
				.indexOf(sBeginSign, iPosEnd)) {
			iPosEnd = htmlTemplate.indexOf(sEndSign, iPosBegin);
			String sDockID = htmlTemplate.substring(
					iPosBegin + sBeginSign.length(), iPosEnd);
			docks.add(new ASDataWindowDock(sDockID));
		}

		if (docksCount() < 1)
			throw new Exception(
					"\u8BBE\u7F6Edatawindow html\u6A21\u7248\u51FA\u9519:\u6A21\u7248\u4E2D\u6CA1\u6709\u5B9A\u4E49\u6CCA\u4F4D(DOCK)\u3002");
		else
			return;
	}

	public String getHtmlTemplate() {
		return htmlTemplate;
	}

	public ASDataWindowDock getDock(int i) {
		return (ASDataWindowDock) docks.get(i);
	}

	public String id;
	public String name;
	public String htmlTemplateID;
	public String htmlTemplate;
	public Vector docks;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 156 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/