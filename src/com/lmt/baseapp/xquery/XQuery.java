/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

import org.w3c.dom.Node;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ui.HTMLControls;

// Referenced classes of package com.amarsoft.xquery:
//            XmlDocument, XCode, XRelatedDataObject, XJoinClause, 
//            XConditionMap, XScheme, XConditionColumn, XColumn, 
//            XParameter, XAttribute, XDataObject

public class XQuery extends XmlDocument
{

    public XQuery(String xmlPath, String sQueryType, String sresourcesPath)
        throws Exception
    {
        super(xmlPath + "QueryConfiguration.xml");
        relatedDataObjects = new Vector();
        joinClauses = new Vector();
        conditionMaps = new Vector();
        availableDisplayColumns = "";
        availableGroupColumns = "";
        availableSummaryColumns = "";
        resourcesPath = "/bank/Resources/";
        schemes = new Vector();
        resourcesPath = sresourcesPath;
        init(xmlPath, sQueryType);
    }

    public XQuery(String xmlPath, String sQueryType)
        throws Exception
    {
        super(xmlPath + "QueryConfiguration.xml");
        relatedDataObjects = new Vector();
        joinClauses = new Vector();
        conditionMaps = new Vector();
        availableDisplayColumns = "";
        availableGroupColumns = "";
        availableSummaryColumns = "";
        resourcesPath = "/bank/Resources/";
        schemes = new Vector();
        init(xmlPath, sQueryType);
    }

    public void init(String xmlPath, String sQueryType)
        throws Exception
    {
        querytype = sQueryType;
        code = new XCode(xmlPath+ "CodeConfiguration.xml");
        Node node = super.getNode("Query", "name", sQueryType, getRootNode());
        Vector vector = getAttributeList(node);
        attributes = XAttribute.setAttributeList(attributes, vector);
        Vector vector1 = super.getNodeList("RelatedDataObjects", "RelatedDataObject", node);
        for(int i = 0; i < vector1.size(); i++){
            Node node2 = (Node)vector1.get(i);
            Vector vector2 = getAttributeList(node2);
            relatedDataObjects.addElement(new XRelatedDataObject(vector2, xmlPath+ "DataObjectConfiguration.xml"));
        }
        vector1 = super.getNodeList("JoinClauses", "JoinClause", node);
        for(int j = 0; j < vector1.size(); j++){
            Node node3 = (Node)vector1.get(j);
            Vector vector3 = getAttributeList(node3);
            joinClauses.addElement(new XJoinClause(vector3));
        }
        vector1 = super.getNodeList("ConditionMaps", "ConditionMap", node);
        for(int k = 0; k < vector1.size(); k++){
            Node node4 = (Node)vector1.get(k);
            Vector vector4 = getAttributeList(node4);
            conditionMaps.addElement(new XConditionMap(vector4, node4));
        }
        Node node1 = super.getNode("AvailableGroupColumns", node);
        availableGroupColumns = getNodeValue(node1);
        node1 = super.getNode("AvailableSummaryColumns", node);
        availableSummaryColumns = getNodeValue(node1);
        node1 = super.getNode("AvailableDisplayColumns", node);
        availableDisplayColumns = getNodeValue(node1);
        node1 = super.getNode("DisAvailableGroupColumns", node);
        DisAvailableGroupColumns = getNodeValue(node1);
        node1 = super.getNode("DisAvailableSummaryColumns", node);
        DisAvailableSummaryColumns = getNodeValue(node1);
        node1 = super.getNode("DisAvailableDisplayColumns", node);
        DisAvailableDisplayColumns = getNodeValue(node1);
        String as[] = StringFunction.toStringArray(DisAvailableGroupColumns, "|");
        for(int l = 0; l < as.length; l++)
            availableGroupColumns = StringFunction.replace(availableGroupColumns, "|" + as[l] + "|", "|");

        as = StringFunction.toStringArray(DisAvailableSummaryColumns, "|");
        for(int i1 = 0; i1 < as.length; i1++)
            availableSummaryColumns = StringFunction.replace(availableSummaryColumns, "|" + as[i1] + "|", "|");

        as = StringFunction.toStringArray(DisAvailableDisplayColumns, "|");
        for(int j1 = 0; j1 < as.length; j1++)
            availableDisplayColumns = StringFunction.replace(availableDisplayColumns, "|" + as[j1] + "|", "|");

        vector1 = super.getNodeList("Schemes", "Scheme", node);
        for(int k1 = 0; k1 < vector1.size(); k1++)
        {
            Node node5 = (Node)vector1.get(k1);
            Vector vector5 = getAttributeList(node5);
            schemes.addElement(new XScheme(vector5, node5));
        }

    }

    public String getConditionString(Transaction transaction, String s, String s1)
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        for(int i = 0; i < conditionMaps.size(); i++)
        {
            int j = 6;
            int k = 0;
            int l = 2;
            int i1 = 3;
            String s2 = "FREE";
            XConditionMap xconditionmap = (XConditionMap)conditionMaps.get(i);
            String s3 = XAttribute.getAttributeValue(xconditionmap.attributes, "totalColumns");
            j = (new Integer(s3)).intValue();
            s3 = XAttribute.getAttributeValue(xconditionmap.attributes, "defaultColspan");
            l = (new Integer(s3)).intValue();
            s3 = XAttribute.getAttributeValue(xconditionmap.attributes, "defaultColspanForLongType");
            i1 = (new Integer(s3)).intValue();
            s2 = XAttribute.getAttributeValue(xconditionmap.attributes, "defaultPosition");
            String s4 = XAttribute.getAttributeValue(xconditionmap.attributes, "caption");
            s3 = "ConditonMap" + String.valueOf(i);
            stringbuffer.append("<TR bordercolor='#CCCCCC'><TD colspan='2'>");
            stringbuffer.append("<TABLE border=0 cellPadding=0 cellSpacing=0 style='CURSOR: hand' width='100%'>\r");
            stringbuffer.append("<TBODY>");
            stringbuffer.append("<TR bgcolor='#EEEEEE' id=" + s3 + "Tab vAlign=center height='20'>");
            stringbuffer.append("<TD align=right valign='middle'><IMG alt='' border=0 id=" + s3 + "Tab3 onclick=\"showHideContent('" + s3 + "');\"  src='" + resourcesPath + "expand.gif' style='CURSOR: hand' width='15' height='15'></TD>" + "\r");
            stringbuffer.append("<TD align=left width='100%' valign='middle' onclick=\"javascript:" + s3 + "Tab3.click();\"><FONT color=#000000 id=" + s3 + "Tab2 >&nbsp;" + s4 + "</td>" + "\r");
            stringbuffer.append("<TD align=right valign='top'><IMG alt='' border=0 id=" + s3 + "Tab1 src='" + resourcesPath + "curve1.gif' width='0' height='0'></TD>" + "\r");
            stringbuffer.append("</TR></TBODY></TABLE>");
            stringbuffer.append("<DIV id=" + s3 + "Content style='BORDER-BOTTOM: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid; BORDER-RIGHT: #ffffff 1px solid; WIDTH: 100%;display:none'>" + "\r");
            stringbuffer.append("<table class='conditionmap' width='100%' align='left' border='1' cellspacing='1' cellpadding='0' bgcolor='#E4E4E4' bordercolor='#F5F5F5'>\r");
            for(int j1 = 0; j1 < xconditionmap.conditionColumns.size(); j1++){
                XConditionColumn xconditioncolumn = (XConditionColumn)xconditionmap.conditionColumns.get(j1);
                String s5 = XAttribute.getAttributeValue(xconditioncolumn.attributes, "relatedDataObject");
                if(xconditioncolumn == null)
                    continue;
                Vector vector = getDataObjectColumns(xconditioncolumn);
                for(int k1 = 0; k1 < vector.size(); k1++)
                {
                    XColumn xcolumn = (XColumn)vector.get(k1);
                    String s6 = XAttribute.getAttributeValue(xconditioncolumn.attributes, "colspan");
                    int l1;
                    if(s6.equals("") || s6 == null)
                    {
                        if(XAttribute.getAttributeValue(xcolumn.attributes, "dataType").trim().equalsIgnoreCase("NUMBERSCOPE") || XAttribute.getAttributeValue(xcolumn.attributes, "dataType").trim().equalsIgnoreCase("DATETIME"))
                            l1 = i1;
                        else
                            l1 = l;
                    } else
                    {
                        l1 = (new Integer(s6)).intValue();
                    }
                    s6 = XAttribute.getAttributeValue(xconditioncolumn.attributes, "position");
                    String s7;
                    if(s6.equals("") || s6 == null)
                        s7 = s2;
                    else
                        s7 = s6;
                    if(s7.equals("NEWROW") || s7.equals("FULLROW") || l1 > k)
                    {
                        if(k > 0)
                            stringbuffer.append("<td colspan='" + (new Integer(k)).toString() + "'>&nbsp;</td></tr>" + "\r");
                        k = j;
                        stringbuffer.append("<tr>");
                    }
                    stringbuffer.append("<td colpsan=1 >&nbsp;" + XAttribute.getAttributeValue(xcolumn.attributes, "header") + "</td><td colspan=" + (new Integer(l1 - 1)).toString() + " >");
                    stringbuffer.append(getColumnConditionString(xcolumn, transaction, s5, s, s1));
                    stringbuffer.append("</td>");
                    k -= l1;
                    if(!s7.equals("FULLROW"))
                        continue;
                    if(k > 0)
                        stringbuffer.append("<td colspan='" + (new Integer(k)).toString() + "'>&nbsp;</td></tr>" + "\r");
                    k = 0;
                }
            }
            stringbuffer.append("</table></DIV></td></tr>");
        }
        return stringbuffer.toString();
    }

    public String getCodeConditionString(String as[], String s, Transaction transaction, Vector vector)
        throws Exception{
        String s1 = "<select name='" + s + "' multiple size=1 readonly=true onclick=\"javascript:ShowSelect('" + s + "')\">";
        s1 = s1 + "<option value=''> </option>";
        String s2 = getStringWithParameterReplaced(as[1], vector);
        String s3 = getStringWithParameterReplaced(as[2], vector);
        String s4 = getStringWithParameterReplaced(as[3], vector);
        s1 = s1 + HTMLControls.generateDropDownSelect(transaction, s2, 1, 2, s4);
        s1 = s1 + s3;
        s1 = s1 + "</select></td>";
        return s1;
    }

    public String getCodeConditionString(Transaction transaction, String s, String s1)
        throws Exception
    {
        String s2 = "<input class='platinputbox' type='text' name='NOTCONDITION_" + s1 + "' readonly=true onclick=\"javascript:ShowSelect('" + s + "','" + s1 + "')\">";
        s2 = s2 + "<input type='hidden' name='" + s + "' value=''>";
        s2 = s2 + "</td>";
        return s2;
    }

    public String getStringWithParameterReplaced(String s, Vector vector)
        throws Exception
    {
        String s1 = s;
        for(int i = 0; i < vector.size(); i++)
        {
            XParameter xparameter = (XParameter)vector.get(i);
            String as[] = new String[2];
            as[0] = XAttribute.getAttributeValue(xparameter.attributes, "name");
            as[1] = XAttribute.getAttributeValue(xparameter.attributes, "value");
            s1 = StringFunction.replace(s1, "%" + as[0].trim() + "%", as[1]);
        }
        return s1;
    }

    public String convertVectorToString(Vector vector, int i)
        throws Exception
    {
        String s = "";
        for(int j = 0; j < vector.size(); j++)
        {
            String as[] = (String[])vector.get(j);
            if(j == 0)
                s = as[i];
            else
                s = s + "," + as[i];
        }

        return s;
    }

    public Vector convertStringArrayToParameterVector(String as[][])
        throws Exception
    {
        Vector vector = new Vector();
        for(int i = 0; i < as.length; i++)
        {
            Vector vector1 = new Vector();
            String as1[] = new String[2];
            as1[0] = "name";
            as1[1] = as[i][0];
            vector1.addElement(as1);
            as1 = new String[2];
            as1[0] = "value";
            as1[1] = as[i][1];
            vector1.addElement(as1);
            as1 = new String[2];
            as1[0] = "caption";
            as1[1] = as[i][2];
            vector1.addElement(as1);
            XParameter xparameter = new XParameter(vector1);
            vector.addElement(xparameter);
        }

        return vector;
    }

    public XRelatedDataObject getRelatdDataObject(String s)
        throws Exception
    {
        for(int i = 0; i < relatedDataObjects.size(); i++)
        {
            XRelatedDataObject xrelateddataobject = (XRelatedDataObject)relatedDataObjects.get(i);
            if(XAttribute.getAttributeValue(xrelateddataobject.attributes, "name").trim().equalsIgnoreCase(s))
                return xrelateddataobject;
        }

        return null;
    }

    public XScheme getScheme(String s)
        throws Exception
    {
        for(int i = 0; i < schemes.size(); i++)
        {
            XScheme xscheme = (XScheme)schemes.get(i);
            if(XAttribute.getAttributeValue(xscheme.attributes, "name").trim().equalsIgnoreCase(s))
                return xscheme;
        }

        return null;
    }

    public Vector getDataObjectColumns(XConditionColumn xconditioncolumn)
        throws Exception
    {
        Vector vector = new Vector();
        String s = XAttribute.getAttributeValue(xconditioncolumn.attributes, "columnName").trim();
        String s1 = XAttribute.getAttributeValue(xconditioncolumn.attributes, "exceptcolumnName").trim();
        String s2 = XAttribute.getAttributeValue(xconditioncolumn.attributes, "relatedDataObject").trim();
        XDataObject xdataobject = getRelatdDataObject(s2).dataObject;
        for(int i = 0; i < xdataobject.columns.size(); i++)
        {
            XColumn xcolumn = (XColumn)xdataobject.columns.get(i);
            String s3 = XAttribute.getAttributeValue(xcolumn.attributes, "name").trim();
            if((s.equalsIgnoreCase(s3) || s.equalsIgnoreCase("*")) && !s1.equalsIgnoreCase(s3) && s1.indexOf("|" + s3) < 0 && s1.indexOf(s3 + "|") < 0)
                vector.addElement(xcolumn);
        }

        return vector;
    }

    public String getColumnConditionString(XColumn xcolumn, Transaction transaction, String s, String s1, String s2)
        throws Exception
    {
        String s3 = XAttribute.getAttributeValue(xcolumn.attributes, "dataType").trim();
        String s4 = XAttribute.getAttributeValue(xcolumn.attributes, "name").trim();
        String s5 = XAttribute.getAttributeValue(xcolumn.attributes, "type").trim();
        String s6 = XAttribute.getAttributeValue(xcolumn.attributes, "alias").trim();
        String s7 = XAttribute.getAttributeValue(xcolumn.attributes, "tag");
        String s8 = "";
        String s9 = s4;
        if(s5.equals(""))
            s5 = "Where";
        else
        if(s5.equalsIgnoreCase("Arg"))
        {
            if(s3.equalsIgnoreCase("DATETIME"))
                s3 = "String";
            if(s3.equalsIgnoreCase("NUMBERSCOPE"))
                s3 = "Number";
        }
        if(!xcolumn.isFuncOrSP() && !s5.equalsIgnoreCase("Arg"))
        {
            s9 = s + "." + s9;
            if(s6.length() > 0)
                s9 = s9 + " as " + s6;
        }
        if(s3.equalsIgnoreCase("STRING"))
        {
            String as[] = getCodeItemDefinition(XAttribute.getAttributeValue(xcolumn.attributes, "name"));
            if(as[1].trim().equals(""))
            {
                s9 = s9 + ";String;" + s5 + ";like";
                s8 = s8 + "<input class='platinputbox' type='text' name='" + s9 + "'> " + s7;
            } else
            {
                String as1[][] = {
                    {
                        "CodeItemName", as[0].trim(), ""
                    }, {
                        "ColumnName", s4, ""
                    }, {
                        "ColumnNameWithoutID", StringFunction.replace(s4, "ID", "Name"), ""
                    }, {
                        "RelatedDataObjectName", s, ""
                    }, {
                        "LeftEmbrace", "<", ""
                    }, {
                        "RightEmbrace", ">", ""
                    }, {
                        "EnvironmentOrgID", s2, ""
                    }, {
                        "QueryType", querytype, ""
                    }
                };
                Vector vector = convertStringArrayToParameterVector(as1);
                s8 = s8 + getCodeConditionString(as, s9, transaction, vector);
            }
        }
        if(s3.equalsIgnoreCase("NUMBER"))
        {
            s9 = s9 + ";Number;" + s5 + ";=";
            s8 = s8 + "<input  class='platinputbox' type='text' name='" + s9 + "'> " + s7;
        }
        if(s3.equalsIgnoreCase("DATETIME"))
        {
            String s10 = s9 + ";String;" + s5 + ";>=";
            String s13 = s9 + ";String;" + s5 + ";<=";
            s8 = s8 + "<input  class='platinputbox' readonly style='cursor:hand' onclick=\"javascript:selectDate('" + s10 + "')\" type='text' name='" + s10 + "'> \u81F3 ";
            s8 = s8 + "<input  class='platinputbox' readonly style='cursor:hand' onclick=\"javascript:selectDate('" + s13 + "')\" type='text' name='" + s13 + "'> " + s7;
        }
        if(s3.equalsIgnoreCase("MONTH"))
        {
            String s11 = s9 + ";String;" + s5 + ";>=";
            String s14 = s9 + ";String;" + s5 + ";<=";
            s8 = s8 + "<input  class='platinputbox' readonly style='cursor:hand' onclick=\"javascript:selectMonth('" + s11 + "')\" type='text' name='" + s11 + "'> \u81F3 ";
            s8 = s8 + "<input  class='platinputbox' readonly style='cursor:hand' onclick=\"javascript:selectMonth('" + s14 + "')\" type='text' name='" + s14 + "'> " + s7;
        }
        if(s3.equalsIgnoreCase("NUMBERSCOPE"))
        {
            String s12 = s9 + ";Number;" + s5 + ";>=";
            String s15 = s9 + ";Number;" + s5 + ";<=";
            s8 = s8 + "<input  class='platinputbox' type='text' name='" + s12 + "'> \u81F3 ";
            s8 = s8 + "<input  class='platinputbox' type='text' name='" + s15 + "'> " + s7;
        }
        return s8;
    }

    public String getFromString()
        throws Exception
    {
        String s = "";
        for(int i = 0; i < relatedDataObjects.size(); i++)
        {
            XRelatedDataObject xrelateddataobject = (XRelatedDataObject)relatedDataObjects.get(i);
            if(i == 0)
                s = " from " + xrelateddataobject.getFromItem();
            else
                s = s + " , " + xrelateddataobject.getFromItem();
        }

        return s;
    }

    public String getWhereString()
        throws Exception
    {
        String s = "";
        for(int i = 0; i < joinClauses.size(); i++)
        {
            XJoinClause xjoinclause = (XJoinClause)joinClauses.get(i);
            if(i == 0)
                s = " where " + xjoinclause.getJoinItem();
            else
                s = s + " and " + xjoinclause.getJoinItem();
        }

        return s;
    }

    public String[] getCodeItemDefinition(String s)
        throws Exception
    {
        String as[] = getColumnDefinition(s);
        String s1;
        String s2;
        if(as[9] == null || as[9].trim().length() == 0)
        {
            s1 = "null";
            s2 = "null";
        } else
        {
            String as1[] = StringFunction.toStringArray(as[9].trim(), "|");
            s1 = as1[0];
            s2 = as1[1];
        }
        return code.getCodeDefinition(s1, s2);
    }

    public Vector getCodeRelatedColumns(String s, String s1)
        throws Exception
    {
        Vector vector = new Vector();
        if(s.trim().length() == 0)
            return vector;
        String as[] = StringFunction.toStringArray(s, "|");
        for(int i = 0; i < as.length; i++)
        {
            String s2 = as[i];
            String as1[] = getColumnDefinition(s2);
            String as2[] = getCodeItemDefinition(s2);
            if(as2[1].trim().length() > 0)
            {
                String as3[][] = {
                    {
                        "CodeItemName", as2[0].trim(), ""
                    }, {
                        "ColumnName", as1[8], ""
                    }, {
                        "ColumnNameWithoutID", StringFunction.replace(as1[3], "ID", "Name"), ""
                    }, {
                        "RelatedDataObjectName", as1[0], ""
                    }, {
                        "LeftEmbrace", "<", ""
                    }, {
                        "RightEmbrace", ">", ""
                    }
                };
                Vector vector1 = convertStringArrayToParameterVector(as3);
                String s3 = getStringWithParameterReplaced(as2[4], vector1);
                String s4 = as1[0] + "_" + (StringFunction.indexOf(as1[3], "(", "'", "'", 0) <= 0 ? as1[3] : as1[4]) + "_name";
                if(s4.length() > 18)
                {
                    String s5 = String.valueOf(i);
                    s4 = s4.substring(0, 18 - s5.length()) + s5;
                }
                if(s1.equals("1"))
                {
                    String as5[] = new String[3];
                    as5[0] = s2;
                    as5[1] = as1[3];
                    as5[2] = as1[5] + "[\u4EE3\u7801]";
                    vector.addElement(as5);
                    as5 = new String[3];
                    as5[0] = s3 + " as " + s4;
                    as5[1] = s4;
                    as5[2] = as1[5] + "[\u540D\u79F0]";
                    vector.addElement(as5);
                    continue;
                }
                String as6[] = new String[4];
                as6[0] = s3 + " as " + s4;
                as6[1] = s4;
                as6[2] = as1[5];
                if(StringFunction.indexOf(as1[3], "(", "'", "'", 0) > 0)
                    as6[3] = as1[3];
                else
                    as6[3] = as1[0] + "." + as1[3];
                vector.addElement(as6);
            } else
            {
                String as4[] = new String[3];
                as4[0] = s2;
                as4[1] = as1[3];
                as4[2] = as1[5];
                vector.addElement(as4);
            }
        }

        return vector;
    }

    public String[] getColumnDefinition(String s)
        throws Exception
    {
        Vector vector = getAllColumnsList();
        for(int i = 0; i < vector.size(); i++)
        {
            String as[] = (String[])vector.get(i);
            if(as[3].trim().equals(s.trim()) || as[7].trim().equals(s.trim()) || as[8].trim().equals(s.trim()))
            {
                String as1[] = as;
                return as1;
            }
        }

        return null;
    }

    public String[][] getSchemeDefinition(String s)
        throws Exception
    {
        XScheme xscheme = getScheme(s);
        return xscheme.attributes;
    }

    public String getHeaders(String s)
        throws Exception
    {
        String s1 = "";
        if(s.trim().length() == 0)
            return s1;
        String as[] = StringFunction.toStringArray(s.trim(), "|");
        for(int i = 0; i < as.length; i++)
        {
            String s2;
            String as1[];
            if((as1 = getColumnDefinition(as[i])) == null)
                s2 = "\u65E0\u6B64\u5B57\u6BB5\uFF0C\u5B57\u6BB5\u540D\uFF1A" + as[i];
            else
                s2 = as1[5];
            if(i == 0)
                s1 = (i + 1) + ".   " + s2;
            else
                s1 = s1 + "|" + (i + 1) + ".   " + s2;
        }

        return s1;
    }

    public Vector getAllColumnsList()
        throws Exception
    {
        Vector vector = new Vector();
        for(int i = 0; i < relatedDataObjects.size(); i++)
        {
            XRelatedDataObject xrelateddataobject = (XRelatedDataObject)relatedDataObjects.get(i);
            String s = XAttribute.getAttributeValue(xrelateddataobject.attributes, "name");
            String s1 = XAttribute.getAttributeValue(xrelateddataobject.attributes, "caption");
            XDataObject xdataobject = xrelateddataobject.dataObject;
            String s2 = XAttribute.getAttributeValue(xdataobject.attributes, "name");
            for(int j = 0; j < xdataobject.columns.size(); j++)
            {
                XColumn xcolumn = (XColumn)xdataobject.columns.get(j);
                String s3 = XAttribute.getAttributeValue(xcolumn.attributes, "name");
                String s4 = XAttribute.getAttributeValue(xcolumn.attributes, "type");
                String s5 = XAttribute.getAttributeValue(xcolumn.attributes, "alias");
                String s6 = XAttribute.getAttributeValue(xcolumn.attributes, "header");
                String s7 = XAttribute.getAttributeValue(xcolumn.attributes, "dataType");
                String s8 = XAttribute.getAttributeValue(xcolumn.attributes, "code");
                String s9;
                if(!xcolumn.isFuncOrSP())
                    s9 = s + "." + s3;
                else
                    s9 = s3;
                String s10;
                if(s5.length() > 0)
                    s10 = s9 + " as " + s5;
                else
                    s10 = s9;
                String as[] = new String[11];
                as[0] = s;
                as[1] = s1;
                as[2] = s2;
                as[3] = s3;
                as[4] = s5;
                as[5] = s6;
                as[6] = s7;
                as[7] = s10;
                as[8] = s9;
                as[9] = s8;
                as[10] = s4;
                vector.addElement(as);
            }

        }

        return vector;
    }

    private static final long serialVersionUID = 1L;
    public String attributes[][] = {
        {
            "name", ""
        }, {
            "caption", ""
        }
    };
    public Vector relatedDataObjects;
    public Vector joinClauses;
    public Vector conditionMaps;
    public String availableDisplayColumns;
    public String availableGroupColumns;
    public String availableSummaryColumns;
    public String resourcesPath;
    public String DisAvailableGroupColumns;
    public String DisAvailableSummaryColumns;
    public String DisAvailableDisplayColumns;
    public Vector schemes;
    public XCode code;
    public String querytype;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 132 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/