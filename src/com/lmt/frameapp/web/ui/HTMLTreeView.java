/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.ui;

import java.util.ArrayList;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.SpecialTools;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ASComponent;

// Referenced classes of package com.amarsoft.web.ui:
//            TreeViewItem, ASSet, ASWebInterface

public class HTMLTreeView {

	public HTMLTreeView(String sTreeViewName) {
		TargetWindow = "";
		ImageDirectory = "";
		BackgroundDirectory = "";
		BackgroundImage = "";
		BackgroundColor = "#DCDCDC";
		LinkColor = "#000000";
		Items = new ArrayList();
		TriggerClickEvent = false;
		toRegister = false;
		sServletURL = null;
		Sqlca = null;
		CurComp = null;
		TreeViewName = sTreeViewName;
	}

	public HTMLTreeView(String sTreeViewName, String sTargetWindow) {
		TargetWindow = "";
		ImageDirectory = "";
		BackgroundDirectory = "";
		BackgroundImage = "";
		BackgroundColor = "#DCDCDC";
		LinkColor = "#000000";
		Items = new ArrayList();
		TriggerClickEvent = false;
		toRegister = false;
		sServletURL = null;
		Sqlca = null;
		CurComp = null;
		TreeViewName = sTreeViewName;
		TargetWindow = sTargetWindow;
	}

	public HTMLTreeView(Transaction tmpSqlca, ASComponent tmpCurComp,
			String sTmpServletURL, String sTreeViewName, String sTargetWindow) {
		TargetWindow = "";
		ImageDirectory = "";
		BackgroundDirectory = "";
		BackgroundImage = "";
		BackgroundColor = "#DCDCDC";
		LinkColor = "#000000";
		Items = new ArrayList();
		TriggerClickEvent = false;
		toRegister = false;
		sServletURL = null;
		Sqlca = null;
		CurComp = null;
		Sqlca = tmpSqlca;
		CurComp = tmpCurComp;
		sServletURL = sTmpServletURL;
		TreeViewName = sTreeViewName;
		TargetWindow = sTargetWindow;
	}

	public TreeViewItem getItemByValue(String sValue) {
		for (int i = 0; i < Items.size(); i++) {
			TreeViewItem tviTemp = (TreeViewItem) Items.get(i);
			if (tviTemp.getValue().equals(sValue))
				return tviTemp;
		}

		return null;
	}

	public int getItemCount() {
		return Items.size();
	}

	public TreeViewItem getItem(String sID) {
		for (int i = 0; i < Items.size(); i++) {
			TreeViewItem tviTemp = (TreeViewItem) Items.get(i);
			if (tviTemp.getId().equals(sID))
				return tviTemp;
		}

		return null;
	}

	public String insertFolder(String sParentID, String sName, String sScript,
			int iOrder) {
		return insertFolder(sParentID, sName, "", sScript, iOrder);
	}

	public String insertFolder(String sParentID, String sName, String sValue,
			String sScript, int iOrder) {
		String sID = String.valueOf(getItemCount() + 1);
		return insertFolder(sID, sParentID, sName, sValue, sScript, iOrder);
	}

	public String insertFolder(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder) {
		TreeViewItem tviFold = new TreeViewItem(sID, sParentID, "folder",
				sName, sValue, sScript, iOrder, "");
		Items.add(tviFold);
		return sID;
	}

	public String insertFolder(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder, String sPicture) {
		TreeViewItem tviFold = new TreeViewItem(sID, sParentID, "folder",
				sName, sValue, sScript, iOrder, sPicture);
		Items.add(tviFold);
		return sID;
	}

	public String insertPage(String sParentID, String sName, String sScript,
			int iOrder) {
		return insertPage(sParentID, sName, "", sScript, iOrder);
	}

	public String insertPage(String sParentID, String sName, String sValue,
			String sScript, int iOrder) {
		String sID = String.valueOf(getItemCount() + 1);
		return insertPage(sID, sParentID, sName, sValue, sScript, iOrder);
	}

	public String insertPage(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder) {
		TreeViewItem tviPage = new TreeViewItem(sID, sParentID, "page", sName,
				sValue, sScript, iOrder, "");
		Items.add(tviPage);
		return sID;
	}

	public String insertPage(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder, String sPicture) {
		TreeViewItem tviPage = new TreeViewItem(sID, sParentID, "page", sName,
				sValue, sScript, iOrder, sPicture);
		Items.add(tviPage);
		return sID;
	}

	public void initWithCode(String sCodeNo, Transaction sqlca)
			throws Exception {
		initWithSql(
				"ItemNo",
				"ItemName",
				"",
				"ItemDescribe",
				"ItemAttribute",
				(new StringBuilder())
						.append("from CODE_LIBRARY where CodeNo='")
						.append(sCodeNo).append("' and IsInUse = '1' ")
						.toString(), " Order By SortNo,ItemNo ", sqlca);
	}

	public void initWithCode(String sCodeNo, String sWhere, Transaction sqlca)
			throws Exception {
		if (sWhere != null && !sWhere.equals(""))
			initWithSql(
					"ItemNo",
					"ItemName",
					"",
					"ItemDescribe",
					"ItemAttribute",
					(new StringBuilder())
							.append("from CODE_LIBRARY where CodeNo='")
							.append(sCodeNo).append("' and ").append(sWhere)
							.toString(), sqlca);
		else
			initWithSql(
					"ItemNo",
					"ItemName",
					"",
					"ItemDescribe",
					"ItemAttribute",
					(new StringBuilder())
							.append("from CODE_LIBRARY where CodeNo='")
							.append(sCodeNo).append("'").toString(), sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColScript,
			String sFrom, Transaction sqlca) throws Exception {
		initWithSql(sColID, sColName, sColID, sColScript, sFrom, sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sFrom,
			Transaction sqlca) throws Exception {
		initWithSql(sColID, sColName, "", "", sFrom, sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColValue,
			String sColScript, String sFrom, Transaction sqlca)
			throws Exception {
		initWithSql(sColID, sColName, sColValue, sColScript, "", sFrom, sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColValue,
			String sColScript, String sColPicture, String sFrom,
			Transaction sqlca) throws Exception {
		initWithSql(sColID, sColName, sColValue, sColScript, sColPicture,
				sFrom, (new StringBuilder()).append(" Order By ")
						.append(sColID).toString(), sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColValue,
			String sColScript, String sColPicture, String sFrom,
			String sOrderBy, Transaction Sqlca) throws Exception {
		String sShowLength = "length";
		String sql1 = "";
		String sDBName = Sqlca.conn.getMetaData()
				.getDatabaseProductName().toUpperCase();
		if (sDBName.indexOf("INFORMIX") != -1 || sDBName.indexOf("DB2") != -1
				|| sDBName.indexOf("ORACLE") != -1) {
			sShowLength = "length";
			sql1 = (new StringBuilder()).append("select distinct ")
					.append(sShowLength).append("(").append(sColID)
					.append(") ").append(sFrom).append(" Order by ")
					.append(sShowLength).append("(").append(sColID).append(")")
					.toString();
		} else if (sDBName.indexOf("ADAPTIVE SERVER ENTERPRISE") != -1) {
			sShowLength = "len";
			sql1 = (new StringBuilder()).append("select distinct ")
					.append(sShowLength).append("(").append(sColID)
					.append(") ").append(sFrom).append(" Order by ")
					.append(sShowLength).append("(").append(sColID).append(")")
					.toString();
		} else if (sDBName.indexOf("MICROSOFT SQL SERVER") != -1) {
			sShowLength = "len";
			sql1 = (new StringBuilder()).append("select  ").append(sShowLength)
					.append("(").append(sColID).append(") ").append(sFrom)
					.append(" Group by ").append(sShowLength).append("(")
					.append(sColID).append(") ").append(" Order by ")
					.append(sShowLength).append("(").append(sColID).append(")")
					.toString();
		}
		sColID = sColID.trim();
		sColName = sColName.trim();
		sColValue = sColValue.trim();
		sColScript = sColScript.trim();
		sColPicture = sColPicture.trim();
		ASResultSet rsLevel = Sqlca.getASResultSet(sql1);
		int iLastLength = 0;
		String sWhere = " where ";
		String sGroup = "";
		String sParentID = "";
		String sValue = "";
		String sScript = "";
		String sPicture = "";
		String sLastParentID = "";
		String sSelect = "";
		ASSet assTemp = new ASSet();
		assTemp.addElement(sColID.trim());
		assTemp.addElement(sColName.trim());
		assTemp.addElement(sColValue.trim());
		assTemp.addElement(sColScript.trim());
		assTemp.addElement(sColPicture.trim());
		for (int i = 0; i < assTemp.getSize(); i++) {
			String sTemp = (String) assTemp.getElement(i);
			if (!sTemp.equals(""))
				sSelect = (new StringBuilder()).append(sSelect).append(",")
						.append(sTemp).toString();
		}

		sSelect = (new StringBuilder()).append("select ")
				.append(sSelect.substring(1)).toString();
		int iGroup = sFrom.indexOf(" group by ");
		if (iGroup >= 0) {
			sGroup = sFrom.substring(iGroup);
			sFrom = sFrom.substring(0, iGroup);
		}
		if (sFrom.indexOf(" where ") >= 0)
			sWhere = " and ";
		while (rsLevel.next()) {
			int iCurLength = rsLevel.getInt(1);
			String sSql = (new StringBuilder()).append(sSelect).append(" ")
					.append(sFrom).append(sWhere).append(" ")
					.append(sShowLength).append("(").append(sColID)
					.append(")=").append(iCurLength).append(sGroup).append(" ")
					.append(sOrderBy).toString();
			ARE.getLog().trace(sSql);
			ASResultSet rsItem = Sqlca.getASResultSet(sSql);
			int iOrder = 0;
			do {
				if (!rsItem.next())
					break;
				String sID = rsItem.getString(sColID);
				String sName = DataConvert.toString(rsItem.getString(sColName));
				if (!sColValue.equals(""))
					sValue = rsItem.getString(sColValue);
				if (!sColScript.equals(""))
					sScript = DataConvert
							.toString(rsItem.getString(sColScript));
				if (!sColPicture.equals(""))
					sPicture = DataConvert.toString(rsItem
							.getString(sColPicture));
				iOrder++;
				if (iLastLength == 0) {
					sParentID = "root";
				} else {
					sParentID = sID.substring(0, iLastLength);
					TreeViewItem tviParent = getItem(sParentID);
					if (tviParent != null) {
						sParentID = tviParent.getId();
						tviParent.setType("folder");
					} else {
						sParentID = "-1";
					}
					if (!sParentID.equals(sLastParentID))
						iOrder = 1;
					sLastParentID = sParentID;
				}
				if (!sParentID.equals("-1"))
					insertPage(sID, sParentID, sName, sValue, sScript, iOrder,
							sPicture);
			} while (true);
			rsItem.getStatement().close();
			iLastLength = iCurLength;
		}
		rsLevel.getStatement().close();
	}

	public String generateHTMLTreeView() throws Exception {
		StringBuffer sbHTMLTreeView = new StringBuffer();
		sbHTMLTreeView.append((new StringBuilder())
				.append("imageDirectory = '").append(ImageDirectory)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder())
				.append("backgroundDirectory = '").append(BackgroundDirectory)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder())
				.append("backgroundImage = '").append(BackgroundImage)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder())
				.append("backgroundColor = '").append(BackgroundColor)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder()).append("linkColor = '")
				.append(LinkColor).append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder()).append("addItem('root','")
				.append(TreeViewName)
				.append("','root','','root','','',0,'');\r\n").toString());
		for (int i = 0; i < Items.size(); i++) {
			TreeViewItem tviTemp = (TreeViewItem) Items.get(i);
			if (!toRegister)
				sbHTMLTreeView
						.append((new StringBuilder())
								.append("addItem('")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getId()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getName()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getValue()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getParentID()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getType()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getScript()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getPicture()))
								.append("',")
								.append(tviTemp.getOrder())
								.append(",'")
								.append(SpecialTools
										.real2Amarsoft(TargetWindow))
								.append("');\r\n").toString());
			else
				sbHTMLTreeView.append(ASWebInterface.generateControl(
						Sqlca,
						CurComp,
						sServletURL,
						"",
						"TreeNode",
						tviTemp.getName(),
						"",
						(new StringBuilder())
								.append("addItem('")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getId()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getName()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getValue()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getParentID()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getType()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getScript()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getPicture()))
								.append("',")
								.append(tviTemp.getOrder())
								.append(",'")
								.append(SpecialTools
										.real2Amarsoft(TargetWindow))
								.append("');\r\n").toString(), ImageDirectory));
		}

		sbHTMLTreeView.append("drawMenu();\r\n");
		if (TriggerClickEvent)
			sbHTMLTreeView.append(" myTriggerClickEvent=true;\r\n");
		return sbHTMLTreeView.toString();
	}

	public String TreeViewName;
	public String TargetWindow;
	public String ImageDirectory;
	public String BackgroundDirectory;
	public String BackgroundImage;
	public String BackgroundColor;
	public String LinkColor;
	public ArrayList Items;
	public boolean TriggerClickEvent;
	public boolean toRegister;
	public String sServletURL;
	public Transaction Sqlca;
	public ASComponent CurComp;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 156 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/