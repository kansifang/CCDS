/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.ui;

import java.util.StringTokenizer;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class HTMLControls
{

    public HTMLControls()
    {
    }

    public static String generateTable(ASResultSet rs, String sTableStyle, String sTRStyle, String sTDStyle)
        throws Exception
    {
        String sHtmlTable = null;
        for(sHtmlTable = "<table " + sTableStyle + ">"; rs.next(); sHtmlTable = sHtmlTable + "</tr>")
        {
            sHtmlTable = sHtmlTable + "<tr " + sTRStyle + ">";
            for(int i = 1; i <= rs.getColumnCount(); i++)
            {
                String sTmp = rs.getString(i);
                if(rs.wasNull())
                    sTmp = "";
                sHtmlTable = sHtmlTable + "<td " + sTDStyle + ">" + sTmp + "</td>";
            }

        }

        sHtmlTable = sHtmlTable + "</table>";
        return sHtmlTable;
    }

    public static String generateTable(ASResultSet rs)
        throws Exception
    {
        return generateTable(rs, "", "", "");
    }

    public static String generateTable(String sTableArray[][], String sTableStyle, String sColStyle, String sRowStyle, String sValueStyle)
        throws Exception
    {
        String sHtmlTable = null;
        int iRowCount = sTableArray.length;
        int iColCount = sTableArray[0].length;
        sHtmlTable = "<table " + sTableStyle + ">";
        for(int i = 0; i <= iRowCount - 1; i++)
        {
            sHtmlTable = sHtmlTable + "<tr>";
            for(int j = 0; j <= iColCount - 1; j++)
            {
                String sTmp = sTableArray[i][j];
                if(sTmp == null || sTmp.equals(""))
                    sTmp = "&nbsp;";
                if(j == 0)
                {
                    sHtmlTable = sHtmlTable + "<td " + sRowStyle + ">" + sTmp + "</td>";
                    continue;
                }
                if(i == 0)
                    sHtmlTable = sHtmlTable + "<td " + sColStyle + ">" + sTmp + "</td>";
                else
                    sHtmlTable = sHtmlTable + "<td " + sValueStyle + ">" + sTmp + "</td>";
            }

            sHtmlTable = sHtmlTable + "</tr>";
        }

        sHtmlTable = sHtmlTable + "</table>";
        return sHtmlTable;
    }

    public static String generateDropDownSelect(ASResultSet rs, String sValueCol, String sNameCol, String sDefault)
        throws Exception
    {
        String sTmp = null;
        sTmp = "<option value=''></option>";
        while(rs.next()) 
        {
            String sValue = rs.getString(sValueCol);
            String sName = rs.getString(sNameCol);
            if(sValue == null)
                sValue = "";
            if(sName == null)
                sName = "";
            sName = StringFunction.replace(sName, " ", "&nbsp;");
            if(sValue.equals(sDefault))
                sTmp = sTmp + "<option selected value='" + sValue + "' >" + sName + "</option>";
            else
                sTmp = sTmp + "<option value='" + sValue + "' >" + sName + "</option>";
        }
        return sTmp;
    }

    public static String generateDropDownSelect(ASResultSet rs, int iValue, int iName, String sDefault)
        throws Exception
    {
        String sTmp = null;
        while(rs.next()) 
        {
            String sValue = rs.getString(iValue);
            String sName = rs.getString(iName);
            if(sValue == null)
                sValue = "";
            if(sName == null)
                sName = "";
            sName = StringFunction.replace(sName, " ", "&nbsp;");
            if(sValue.equals(sDefault))
                sTmp = sTmp + "<option selected value='" + sValue + "' >" + sName + "</option>";
            else
                sTmp = sTmp + "<option value='" + sValue + "' >" + sName + "</option>";
        }
        return sTmp;
    }

    public static String generateDropDownSelectWithABlankOption(ASResultSet rs, int iValue, int iName, String sDefault)
        throws Exception
    {
        String sTmp = null;
        sTmp = "<option value=''></option>";
        while(rs.next()) 
        {
            String sValue = rs.getString(iValue);
            String sName = rs.getString(iName);
            if(sValue == null)
                sValue = "";
            if(sName == null)
                sName = "";
            sName = StringFunction.replace(sName, " ", "&nbsp;");
            if(sValue.equals(sDefault))
                sTmp = sTmp + "<option selected value='" + sValue + "' >" + sName + "</option>";
            else
                sTmp = sTmp + "<option value='" + sValue + "' >" + sName + "</option>";
        }
        return sTmp;
    }

    public static String generateDropDownSelect(String sValues[], String sNames[], String sDefault)
        throws Exception
    {
        String sTmp = null;
        sTmp = "";
        for(int i = 0; i < sValues.length; i++)
            if(sValues[i].equals(sDefault))
                sTmp = sTmp + "<option selected value='" + sValues[i] + "' >" + StringFunction.replace(sNames[i], " ", "&nbsp;") + "</option>";
            else
                sTmp = sTmp + "<option value='" + sValues[i] + "' >" + StringFunction.replace(sNames[i], " ", "&nbsp;") + "</option>";

        return sTmp;
    }

    public static String generateDropDownSelectWithABlankOption(String sValues[], String sNames[], String sDefault)
        throws Exception
    {
        String sTmp = null;
        sTmp = "<option value=''></option>";
        for(int i = 0; i < sValues.length; i++)
            if(sValues[i].equals(sDefault))
                sTmp = sTmp + "<option selected value='" + sValues[i] + "' >" + StringFunction.replace(sNames[i], " ", "&nbsp;") + "</option>";
            else
                sTmp = sTmp + "<option value='" + sValues[i] + "' >" + StringFunction.replace(sNames[i], " ", "&nbsp;") + "</option>";

        return sTmp;
    }

    public static String generateDropDownSelect(Transaction sqlca, String sSQLText, int iValue, int iName, String sDefault)
        throws Exception
    {
        ASResultSet rs = sqlca.getResultSet(sSQLText);
        String sTemp = generateDropDownSelect(rs, iValue, iName, sDefault);
        rs.getStatement().close();
        return sTemp;
    }

    public static String generateDropDownSelect(Transaction sqlca, String sTableName, String sColName, String sDefault)
        throws Exception
    {
        String sSQLText = null;
        String sDelim = "^";
        String sTmp = "";
        sSQLText = "select pbc_cmnt from pbcatcol where pbc_tnam = '" + sTableName + "' and pbc_cnam = '" + sColName + "'";
        ASResultSet rs;
        for(rs = sqlca.getResultSet(sSQLText); rs.next();)
            sTmp = rs.getString(1);

        rs.getStatement().close();
        for(StringTokenizer st = new StringTokenizer(sTmp, sDelim); st.hasMoreTokens();)
            sSQLText = st.nextToken(sDelim);

        return generateDropDownSelect(sqlca, sSQLText, 1, 2, sDefault);
    }

    public static String generateDropDownSelect(Transaction sqlca, String sCodeType, String sDefault)
        throws Exception
    {
        String sSqlText = "select ItemNo,ItemName from CODE_LIBRARY where CodeNo = '" + sCodeType + "' and IsInUse = '1' order by SortNo,ItemNo";
        return generateDropDownSelect(sqlca, sSqlText, 1, 2, sDefault);
    }

    public static String generateButton(String sText, String sTips, String sScript, String sResourcesPath)
    {
        String sButton = "";
        sButton = "<script language=javascript>hc_drawButtonWithTip(\"" + sText + "\",\"" + sTips + "\",\"" + sScript + "\",\"" + sResourcesPath + "\");</script>\n";
        return sButton;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta_g.jar
	Total time: 160 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/