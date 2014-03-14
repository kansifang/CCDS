/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.ui;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class HTMLTab
{

    public HTMLTab()
    {
    }

    public static String[][] getTabArrayWithSql(String s, Transaction transaction)
        throws Exception
    {
        String as[][] = new String[50][3];
        int i = 0;
        ASResultSet LSResultSet = null;
        String s1 = s;
        for(LSResultSet = transaction.getASResultSet(s1); LSResultSet.next();)
        {
            as[i][0] = LSResultSet.getString(1);
            as[i][1] = LSResultSet.getString(2);
            as[i][2] = LSResultSet.getString(3);
            i++;
        }

        LSResultSet.getStatement().close();
        String as1[][] = new String[i + 5][3];
        for(int j = 0; j < i; j++)
        {
            as1[j][0] = as[j][0];
            as1[j][1] = as[j][1];
            as1[j][2] = as[j][2];
        }

        return as1;
    }

    public static String[][] addTabArray(String as[][], String as1[])
        throws Exception
    {
        String as2[][] = new String[as.length][3];
        int i = 0;
        do
        {
            if(i >= as.length)
                break;
            as2[i][0] = as[i][0];
            as2[i][1] = as[i][1];
            as2[i][2] = as[i][2];
            if(as[i][1] == null || as[i][1].equals(""))
            {
                as2[i][0] = as1[0];
                as2[i][1] = as1[1];
                as2[i][2] = as1[2];
                break;
            }
            i++;
        } while(true);
        return as2;
    }

    public static String genTabArray(String as[][], String s, String s1)
        throws Exception
    {
        String s2 = "";
        int i = 0;
        for(int j = 0; j < as.length && as[j][0] != null; j++)
        {
            if(as[j][0].equals("false"))
                i--;
            else
                s2 = s2 + "tabstrip[" + i + "] = new Array(\"block_" + (i + 1) + "\",\"" + as[j][1] + "\",\"javascript:if(" + as[j][2] + "!=false) hc_drawTabToTable('" + s + "',tabstrip," + (i + 1) + "," + s1 + ");\");\n";
            i++;
        }

        return s2;
    }

    public static String genTabArray(String as[][], String s, String s1, int i, int j)
        throws Exception
    {
        String s2 = "";
        int k = 0;
        for(int l = 0; l < as.length && as[l][0] != null; l++)
        {
            if(as[l][0].equals("false"))
            {
                k--;
            } else
            {
                as[l][2] = StringFunction.replace(as[l][2], "TabContentFrame", "TabContentFrame" + l);
                as[l][2] = StringFunction.replace(as[l][2], "#FrameName", "TabContentFrame" + l);
                as[l][2] += ";tabstrip[" + l + "][4]='LOADED'";
                s2 = s2 + "tabstrip[" + k + "] = new Array(\"block_" + (k + 1) + "\"," + "\"" + as[l][1] + "\"," + "\"javascript:if(checkTabAction(" + l + ")!=false){if(tabstrip[" + l + "][4]!='LOADED'){" + as[l][2] + ";}hc_drawTabToTable_plus('" + s + "',tabstrip," + (k + 1) + "," + s1 + ",document.all('" + s + "_beginIndexID').value," + j + ");}\"," + "\"javascript:if(checkTabAction(" + l + ")!=false){if(true){" + as[l][2] + ";}hc_drawTabToTable_plus('" + s + "',tabstrip," + (k + 1) + "," + s1 + ",document.all('" + s + "_beginIndexID').value," + j + ");}\");" + "\n";
            }
            k++;
        }

        return s2;
    }

    public static String genTabHTML(String s, String s1, String s2, String s3, String s4, String s5)
        throws Exception
    {
        String s6 = "";
        s6 = s6 + "\t<table " + s + "> \n";
        s6 = s6 + "\t\t<tr> \n";
        s6 = s6 + "\t\t   <td valign='top' colspan=2 class='tabhead'></td> \n";
        s6 = s6 + "\t\t</tr>\n";
        s6 = s6 + "\t\t<tr>\n";
        s6 = s6 + "\t\t   <td valign='top' align='left' id=\"" + s2 + "\" class=\"tabtd\"> \n";
        s6 = s6 + "\t\t  </td> \n";
        s6 = s6 + "\t\t   <td valign='top' class=\"tabbar\"> \n";
        s6 = s6 + s1;
        s6 = s6 + "\t\t  </td> \n";
        s6 = s6 + "\t\t</tr> \n";
        s6 = s6 + "\t\t<tr> \n";
        s6 = s6 + "\t\t\t<td class='tabcontent' align='center' valign='top' colspan=2> \n";
        s6 = s6 + "\t\t\t\t<table cellspacing=0 cellpadding=4 border=0\twidth='100%' height='100%'> \n";
        s6 = s6 + "\t\t\t\t\t<tr>  \n";
        s6 = s6 + "\t\t\t\t\t\t<td valign=\"top\"> \n";
        s6 = s6 + "\t\t\t\t\t\t\t<iframe\tname=\"" + s3 + "\" src=\"" + s4 + "\" " + s5 + "></iframe> \n";
        s6 = s6 + "\t\t\t\t\t\t</td> \n";
        s6 = s6 + "\t\t\t\t\t</tr> \n";
        s6 = s6 + "\t\t\t   </table> \n";
        s6 = s6 + "\t\t  </td> \n";
        s6 = s6 + "\t  </tr> \n";
        s6 = s6 + "   </table> \n";
        return s6;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 174 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/