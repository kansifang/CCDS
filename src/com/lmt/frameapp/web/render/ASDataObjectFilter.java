/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

import java.util.Vector;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.config.dal.ASCodeDefinition;
import com.lmt.frameapp.script.Expression;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ui.HTMLControls;

// Referenced classes of package com.amarsoft.web.dw:
//            ASColumn

public class ASDataObjectFilter {

	public ASDataObjectFilter(Transaction Sqlca, String sArgFilterID,
			ASColumn acArgColumn, String sOptions) throws Exception {
		sFilterID = null;
		sFilterColumnID = null;
		sFilterColumnName = null;
		sOperators = null;
		sOperatorHtml = null;
		sFilterHtmlTemplate = null;
		sFilterHtmlText = null;
		sType = null;
		sCheckFormat = null;
		sEditStyle = null;
		sEditSource = null;
		sDefaultValues = null;
		sDefaultOperator = null;
		sOperator = null;
		sFilterWhereClause = null;
		if (acArgColumn == null) {
			throw new Exception(
					"\u521B\u5EFAFilter\u5B9E\u4F8B\u51FA\u9519:\u4F20\u5165\u4E86\u7A7A\u7684ASColumn");
		} else {
			sFilterID = sArgFilterID;
			sFilterColumnID = acArgColumn.getDBName();
			acColumn = acArgColumn;
			initFilterOptions(Sqlca, acArgColumn);
			initFilterOptions(Sqlca, sOptions);
			initFilterInputs(Sqlca);
			initFilterHtml(Sqlca);
			return;
		}
	}

	private void initFilterOptions(Transaction Sqlca, ASColumn acFilterColumn)
        throws Exception
    {
        String sSql;
        ASCodeDefinition filterTypes;
        sType = acColumn.getAttribute("Type");
        sCheckFormat = acFilterColumn.getAttribute("CheckFormat");
        sEditStyle = acFilterColumn.getAttribute("EditStyle");
        sSql = "";
        filterTypes = (ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", Sqlca).getAttribute("DOFilterType");
        if(filterTypes == null)
            throw new Exception("DOFilterType\u672A\u5B9A\u4E49");
        for (int i = 0; i < filterTypes.items.size(); i++) {
			ASValuePool item = filterTypes.getItem(i);
			if (item.getAttribute("IsInUse") != null&& !item.getAttribute("IsInUse").equals("1")
					||sType != null&& !sType.equals("")&& (item.getAttribute("Attribute4") == null||((String) item.getAttribute("Attribute4")).indexOf(sType) < 0)
					||sCheckFormat != null&& !sCheckFormat.equals("")&& (item.getAttribute("Attribute5") == null 
					|| ((String) item.getAttribute("Attribute5")).indexOf(sCheckFormat) < 0))
				continue;
			Object tmpOperator = item.getAttribute("ItemNo");
			if (tmpOperator != null) {
				tmpOperator = (String) tmpOperator;
				sOperators += ((String) (tmpOperator));
			}
		}
        if(sEditStyle != null && sEditStyle.equals("2"))
        {
            sFilterHtmlTemplate = "DropDownSelect";
        } else
        {
            ASCodeDefinition checkFormats = (ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", Sqlca).getAttribute("CheckFormat");
            if(checkFormats == null)
                throw new Exception((new StringBuilder()).append("\u6CA1\u6709\u627E\u5230checkFormat\u5B9A\u4E49. ").append(sSql).toString());
            sFilterHtmlTemplate = checkFormats.getItemAttribute(sCheckFormat, "ItemDescribe");
            if(sFilterHtmlTemplate == null)
                throw new Exception((new StringBuilder()).append("checkFormat\u5B9A\u4E49\u4E0D\u5168,\u9879\u76EE").append(sCheckFormat).append("\u7F3A\u5C11ItemDescribe\u5B9A\u4E49. ").append(sSql).toString());
        }
        sFilterColumnName = acFilterColumn.getAttribute("Header");
        sEditStyle = acFilterColumn.getAttribute("EditStyle");
        sEditSource = acFilterColumn.getAttribute("EditSource");
        return;
    }

	private void initFilterOptions(Transaction Sqlca, String sOptions)
			throws Exception {
		int iOptionsCount;
		int iPos;
		int iPosEnd;
		String sTmpOperators;
		String sTmpFilterHtmlTemplate;
		String sTmpFilterColumnName;
		String sTmpEditStyle;
		String sTmpEditSource;
		String sTmpDefaultValues;
		String sTmpDefaultOperator;
		try {
			if (sOptions == null || sOptions.equals(""))
				return;
		} catch (Exception ex) {
			throw new Exception(
					(new StringBuilder())
							.append("\u521D\u59CB\u5316Filter\u9009\u9879\u51FA\u9519\uFF1AOptions\u683C\u5F0F\u9519\u8BEF\u3002")
							.append(sOptions).append("<br>")
							.append(ex.toString()).toString());
		}
		iOptionsCount = StringFunction.getSeparateSum(sOptions, ";");
		if (sOptions.substring(sOptions.length() - 1, sOptions.length()).equals(";"))
			iOptionsCount--;
		sFilterOptions = new String[iOptionsCount][2];
		iPos = 0;
		iPosEnd = 0;
		iPosEnd = sOptions.indexOf(";", iPos);
		for (int i = 0; i < sFilterOptions.length; i++) {
			iPosEnd = sOptions.indexOf(";", iPos);
			if (iPosEnd < 0)
				iPosEnd = sOptions.length();
			String sSegment = sOptions.substring(iPos, iPosEnd);
			String sTmpOptionsID = StringFunction.getSeparate(sSegment, "=", 1).trim();
			String sTmpOptionsValue = StringFunction.getSeparate(sSegment, "=",2).trim();
			sFilterOptions[i][0] = (new StringBuilder()).append("#{").append(sTmpOptionsID).append("}").toString();
			sFilterOptions[i][1] = sTmpOptionsValue;
			iPos = iPosEnd + 1;
		}

		sTmpOperators = StringFunction.getProfileString(sOptions, "Operators");
		sTmpFilterHtmlTemplate = StringFunction.getProfileString(sOptions,
				"HtmlTemplate");
		sTmpFilterColumnName = StringFunction.getProfileString(sOptions,
				"ColumnName");
		sTmpEditStyle = StringFunction.getProfileString(sOptions, "EditStyle");
		sTmpEditSource = StringFunction
				.getProfileString(sOptions, "EditSource");
		sTmpDefaultValues = StringFunction.getProfileString(sOptions,
				"DefaultValues");
		sTmpDefaultOperator = StringFunction.getProfileString(sOptions,
				"DefaultOperator");
		if (sTmpOperators != null && !sTmpOperators.equals(""))
			sOperators = sTmpOperators;
		if (sTmpFilterHtmlTemplate != null
				&& !sTmpFilterHtmlTemplate.equals(""))
			sFilterHtmlTemplate = sTmpFilterHtmlTemplate;
		if (sTmpFilterColumnName != null && !sTmpFilterColumnName.equals(""))
			sFilterColumnName = sTmpFilterColumnName;
		if (sTmpEditStyle != null && !sTmpEditStyle.equals(""))
			sEditStyle = sTmpEditStyle;
		if (sTmpEditSource != null && !sTmpEditSource.equals(""))
			sEditSource = sTmpEditSource;
		if (sTmpDefaultValues != null && !sTmpDefaultValues.equals(""))
			sDefaultValues = sTmpDefaultValues;
		if (sTmpDefaultOperator != null && !sTmpDefaultOperator.equals(""))
			sDefaultOperator = sTmpDefaultOperator;
		if (sDefaultOperator != null)
			sOperator = sDefaultOperator;
	}

	private void initFilterHtml(Transaction Sqlca) throws Exception {
		String sSql = "";
		try {
			ASCodeDefinition filterHtmlTextDefs = (ASCodeDefinition) ASConfigure
					.getSysConfig("ASCodeSet", Sqlca).getAttribute(
							"DOFilterHtmlTemplate");
			if (filterHtmlTextDefs == null)
				throw new Exception(
						(new StringBuilder())
								.append("\u6CA1\u6709\u627E\u5230FilterHtml\u6A21\u7248\u5B9A\u4E49\u3002")
								.append(sSql).toString());
			sFilterHtmlText = filterHtmlTextDefs.getItemAttribute(
					sFilterHtmlTemplate, "RelativeCode");
			if (sFilterHtmlText == null)
				throw new Exception(
						(new StringBuilder())
								.append("\u6CA1\u6709\u627E\u5230FilterHtml\u6A21\u7248\u5B9A\u4E49\u3002")
								.append(sSql).toString());
		} catch (Exception ex) {
			throw new Exception((new StringBuilder())
					.append("\u751F\u6210FilterHtml\u51FA\u9519\u3002<br>")
					.append(ex.toString()).toString());
		}
	}

	private void initFilterInputs(Transaction Sqlca) throws Exception {
		String sSql = "";
		String sInputsDef = "";
		if (sFilterHtmlTemplate == null || sFilterHtmlTemplate.equals(""))
			throw new Exception(
					(new StringBuilder())
							.append("\u6CA1\u6709\u627E\u5230FilterHtmlTemplate\u3002FilterColumnID:")
							.append(sFilterColumnID).toString());
		try {
			ASCodeDefinition filterHtmlTextDefs = (ASCodeDefinition) ASConfigure
					.getSysConfig("ASCodeSet", Sqlca).getAttribute(
							"DOFilterHtmlTemplate");
			if (filterHtmlTextDefs == null)
				throw new Exception(
						(new StringBuilder())
								.append("\u6CA1\u6709\u627E\u5230FilterHtml\u6A21\u7248\u5B9A\u4E49\u3002")
								.append(sSql).toString());
			sInputsDef = filterHtmlTextDefs.getItemAttribute(
					sFilterHtmlTemplate, "ItemAttribute");
			if (sInputsDef == null)
				throw new Exception(
						(new StringBuilder())
								.append("\u6CA1\u6709\u627E\u5230FilterInputs\u6A21\u7248\u5B9A\u4E49\u3002")
								.append(sSql).toString());
			String sTempInputs[] = StringFunction
					.toStringArray(sInputsDef, ",");
			if (sTempInputs.length <= 0)
				throw new Exception(
						(new StringBuilder())
								.append("FilterInputs\u6A21\u7248\u5B9A\u4E49\u9519\u8BEF\u3002")
								.append(sSql).toString());
			sFilterInputs = new String[sTempInputs.length][2];
			for (int i = 0; i < sTempInputs.length; i++) {
				sTempInputs[i] = StringFunction.replace(sTempInputs[i],
						"#{FilterID}", sFilterID);
				sFilterInputs[i][0] = sTempInputs[i];
				if (sDefaultValues != null && !sDefaultValues.equals("")) {
					String sInputDefaultValue = StringFunction.getSeparate(
							sDefaultValues, "@", i + 1);
					sFilterInputs[i][1] = sInputDefaultValue;
				}
			}

		} catch (Exception ex) {
			throw new Exception(
					(new StringBuilder())
							.append("\u751F\u6210 FilterInputs \u51FA\u9519\u3002FilterHtmlTemplate:")
							.append(sFilterHtmlTemplate).append("<br>")
							.append(ex.toString()).toString());
		}
	}

	private void generateFilterHtml(Transaction Sqlca) throws Exception {
		try {
			sFilterHtmlText = StringFunction.replace(sFilterHtmlText,
					"#{FilterID}", sFilterID);
			if (sFilterColumnName != null)
				sFilterHtmlText = StringFunction.replace(sFilterHtmlText,
						"#{ColumnName}", sFilterColumnName);
			if (sFilterColumnID != null)
				sFilterHtmlText = StringFunction.replace(sFilterHtmlText,
						"#{ColumnID}", sFilterColumnID);
			if (sOperators != null) {
				String sOperatorsSelectOptionsHtml = "";
				ASCodeDefinition operatorsDef = (ASCodeDefinition) ASConfigure
						.getSysConfig("ASCodeSet", Sqlca).getAttribute(
								"DOFilterType");
				if (operatorsDef == null)
					throw new Exception(
							"\u6CA1\u6709\u627E\u5230DOFilter\u64CD\u4F5C\u7B26\u5B9A\u4E49\uFF01");
				Vector vValues = new Vector();
				Vector vNames = new Vector();
				for (int i = 0; i < operatorsDef.items.size(); i++) {
					ASValuePool item = operatorsDef.getItem(i);
					if (sOperators
							.indexOf((String) item.getAttribute("ItemNo")) >= 0) {
						vValues.add((String) item.getAttribute("ItemNo"));
						vNames.add((String) item.getAttribute("ItemName"));
					}
				}

				String sValues[] = new String[vValues.size()];
				String sNames[] = new String[vNames.size()];
				for (int i = 0; i < sValues.length; i++)
					sValues[i] = (String) vValues.get(i);

				for (int i = 0; i < sNames.length; i++)
					sNames[i] = (String) vNames.get(i);

				sOperatorsSelectOptionsHtml = HTMLControls
						.generateDropDownSelect(sValues, sNames, sOperator);
				if (sOperatorsSelectOptionsHtml == null)
					throw new Exception(
							"\u6CA1\u6709\u627E\u5230DOFilter\u64CD\u4F5C\u7B26\u5B9A\u4E49\uFF01");
				sFilterHtmlText = StringFunction.replace(sFilterHtmlText,
						"#{Operators}", sOperatorsSelectOptionsHtml);
			}
			if (sEditSource != null) {
				String sEditSourceType = StringFunction.getSeparate(
						sEditSource, ":", 1);
				String sEditSourceCode = StringFunction.getSeparate(
						sEditSource, ":", 2);
				for (int i = 0; i < sFilterInputs.length; i++) {
					if (sEditSourceType != null
							&& sEditSourceType.equals("Sql")) {
						sFilterHtmlText = StringFunction.replace(
								sFilterHtmlText,
								(new StringBuilder()).append("#{Options#{")
										.append(sFilterInputs[i][0])
										.append("}}").toString(), HTMLControls
										.generateDropDownSelect(Sqlca,
												sEditSourceCode, 1, 2,
												sFilterInputs[i][1]));
						continue;
					}
					if (sEditSourceType != null
							&& sEditSourceType.equals("Code")) {
						sFilterHtmlText = StringFunction
								.replace(
										sFilterHtmlText,
										(new StringBuilder())
												.append("#{Options#{")
												.append(sFilterInputs[i][0])
												.append("}}").toString(),
										HTMLControls
												.generateDropDownSelect(
														Sqlca,
														(new StringBuilder())
																.append("select ItemNo,ItemName from CODE_LIBRARY where CodeNo='")
																.append(sEditSourceCode)
																.append("' and (IsInUse is null or IsInUse='1')")
																.toString(), 1,
														2, sFilterInputs[i][1]));
						continue;
					}
					if (sEditSourceType == null
							|| !sEditSourceType.equals("CodeTable"))
						continue;
					int iCountRow = 0;
					iCountRow = StringFunction.getSeparateSum(sEditSourceCode,
							",") / 2;
					String sNames[] = new String[iCountRow];
					String sValues[] = new String[iCountRow];
					for (int j = 0; j < iCountRow; j++) {
						sNames[j] = StringFunction.getSeparate(sEditSourceCode,
								",", (j + 1) * 2 - 1);
						sValues[j] = StringFunction.getSeparate(
								sEditSourceCode, ",", (j + 1) * 2);
					}

					sFilterHtmlText = StringFunction.replace(
							sFilterHtmlText,
							(new StringBuilder()).append("#{Options#{")
									.append(sFilterInputs[i][0]).append("}}")
									.toString(), HTMLControls
									.generateDropDownSelect(sNames, sValues,
											sFilterInputs[i][1]));
				}

			}
			for (int i = 0; i < sFilterInputs.length; i++) {
				if (sFilterInputs[i][1] == null)
					sFilterInputs[i][1] = "";
				sFilterHtmlText = StringFunction.replace(
						sFilterHtmlText,
						(new StringBuilder()).append("#{")
								.append(sFilterInputs[i][0]).append("}")
								.toString(), sFilterInputs[i][1]);
			}

			if (sFilterOptions != null)
				sFilterHtmlText = StringFunction.macroReplace(sFilterOptions,
						sFilterHtmlText, "#{", "}");
			sFilterHtmlText = pretreatExpression(Sqlca, sFilterHtmlText);
		} catch (Exception ex) {
			throw new Exception((new StringBuilder())
					.append("generateFilterHtml \u51FA\u9519:")
					.append(ex.toString()).toString());
		}
	}

	public String getFilterHtml(Transaction Sqlca) throws Exception {
		generateFilterHtml(Sqlca);
		return sFilterHtmlText;
	}

	public String getFilterWhereClause(Transaction Sqlca) throws Exception {
		String sRequiredFieldString = "";
		String sRequiredFields[] = null;
		String sWhereClause = "";
		ASCodeDefinition filterTypes = (ASCodeDefinition) ASConfigure
				.getSysConfig("ASCodeSet", Sqlca).getAttribute("DOFilterType");
		if (filterTypes == null)
			throw new Exception("DOFilterType\u672A\u5B9A\u4E49");
		ASValuePool item = filterTypes.getItem(sOperator);
		if (item != null) {
			sRequiredFieldString = (String) item.getAttribute("Attribute1");
			if (sRequiredFieldString != null)
				sRequiredFields = StringFunction.toStringArray(
						sRequiredFieldString.trim(), ",");
			sWhereClause = (String) item.getAttribute("RelativeCode");
			if (sWhereClause == null)
				sWhereClause = "";
			sWhereClause = sWhereClause.trim();
		}
		if (sRequiredFieldString != null && !sRequiredFieldString.equals("")) {
			for (int i = 0; i < sRequiredFields.length; i++) {
				sRequiredFields[i] = StringFunction.replace(sRequiredFields[i],
						"#{FilterID}", sFilterID);
				String sTempInputValue = StringFunction.getAttribute(
						sFilterInputs, sRequiredFields[i]);
				if (sTempInputValue == null || sTempInputValue.equals(""))
					return "";
			}

		}
		sWhereClause = StringFunction.replace(sWhereClause, "#{FilterID}",
				sFilterID);
		sWhereClause = StringFunction.replace(sWhereClause, "#{ColumnName}",
				sFilterColumnName);
		sWhereClause = StringFunction.replace(sWhereClause, "#{ColumnID}",
				sFilterColumnID);
		for (int i = 0; i < sFilterInputs.length; i++) {
			if (sFilterInputs[i][1] == null)
				continue;
			if (sFilterHtmlTemplate.equals("PopMutipleSelect")
					&& sFilterInputs[i][1] != null
					&& !sFilterInputs[i][1].equals("")) {
				String sWhereClause2 = "";
				String inputDatas[] = sFilterInputs[i][1].split(",");
				if (sWhereClause.indexOf((new StringBuilder()).append("#{")
						.append(sFilterInputs[i][0]).append("}").toString()) <= 0)
					continue;
				for (int j = 0; j < inputDatas.length; j++)
					sWhereClause2 = (new StringBuilder())
							.append(sWhereClause2)
							.append(StringFunction.replace(
									sWhereClause,
									(new StringBuilder()).append("#{")
											.append(sFilterInputs[i][0])
											.append("}").toString(),
									inputDatas[j])).append(" or ").toString();

				sWhereClause = sWhereClause2.substring(0,
						sWhereClause2.length() - 4);
			} else {
				sWhereClause = StringFunction.replace(
						sWhereClause,
						(new StringBuilder()).append("#{")
								.append(sFilterInputs[i][0]).append("}")
								.toString(), sFilterInputs[i][1]);
			}
		}

		if (sFilterOptions != null)
			sWhereClause = StringFunction.macroReplace(sFilterOptions,
					sWhereClause, "#{", "}");
		sWhereClause = pretreatExpression(Sqlca, sWhereClause);
		sWhereClause = StringFunction.replace(sWhereClause, "<#SQ#>", "'");
		return sWhereClause;
	}

	public String pretreatExpression(Transaction Sqlca, String sExpressionText)
			throws Exception {
		String sReturn = sExpressionText;
		String sBeginSign = "#{";
		String sEndSign = "}";
		int iPosBeginSign = sReturn.indexOf(sBeginSign, 0);
		int iPosEndSign = sReturn.indexOf(sEndSign, iPosBeginSign);
		for (; iPosBeginSign != -1; iPosBeginSign = sReturn.indexOf(sBeginSign,
				iPosBeginSign)) {
			iPosEndSign = sReturn.indexOf(sEndSign, iPosBeginSign);
			sReturn = (new StringBuilder())
					.append(sReturn.substring(0, iPosBeginSign)).append("NULL")
					.append(sReturn.substring(iPosEndSign + sEndSign.length()))
					.toString();
		}

		sBeginSign = "<$";
		sEndSign = "$>";
		String sExpression = "";
		String sResult = "";
		iPosBeginSign = sReturn.indexOf(sBeginSign, 0);
		iPosEndSign = sReturn.indexOf(sEndSign, iPosBeginSign);
		for (; iPosBeginSign != -1; iPosBeginSign = sReturn.indexOf(sBeginSign,
				iPosBeginSign)) {
			iPosEndSign = sReturn.indexOf(sEndSign, iPosBeginSign);
			try {
				sExpression = sReturn.substring(
						iPosBeginSign + sBeginSign.length(), iPosEndSign);
				sResult = Expression.getExpressionValue(sExpression, Sqlca)
						.toStringValue();
			} catch (Exception ex) {
				throw new Exception((new StringBuilder())
						.append("script\u9519\u8BEF:").append(ex.toString())
						.append(" script:").append(sExpression).toString());
			}
			sReturn = (new StringBuilder())
					.append(sReturn.substring(0, iPosBeginSign))
					.append(sResult)
					.append(sReturn.substring(iPosEndSign + sEndSign.length()))
					.toString();
		}

		return sReturn;
	}

	public String sFilterID;
	public String sFilterColumnID;
	public String sFilterColumnName;
	public String sOperators;
	public String sOperatorHtml;
	public String sFilterHtmlTemplate;
	public String sFilterHtmlText;
	public String sType;
	public String sCheckFormat;
	public String sEditStyle;
	public String sEditSource;
	public String sDefaultValues;
	public String sDefaultOperator;
	public String sFilterInputs[][];
	public String sFilterOptions[][];
	public ASColumn acColumn;
	public String sOperator;
	public String sFilterWhereClause;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 171 ms
	Jad reported messages/errors:
Couldn't fully decompile method initFilterOptions
Couldn't resolve all exception handlers in method initFilterOptions
	Exit status: 0
	Caught exceptions:
*/