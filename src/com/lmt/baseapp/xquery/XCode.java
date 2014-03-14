/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

import org.w3c.dom.Node;

import com.lmt.baseapp.util.StringFunction;

// Referenced classes of package com.amarsoft.xquery:
//            XmlDocument, XCodeItem, XParameter, XAttribute

public class XCode extends XmlDocument
{

    public XCode(String s)
        throws Exception
    {
        super(s);
        codeItems = new Vector();
        parameters = new Vector();
        Vector vector = super.getNodeList("CodeItems", "CodeItem", super.getRootNode());
        for(int i = 0; i < vector.size(); i++)
        {
            Node node = (Node)vector.get(i);
            Vector vector1 = getAttributeList(node);
            XCodeItem xcodeitem = new XCodeItem(vector1);
            codeItems.addElement(xcodeitem);
        }

        vector = super.getNodeList("CodeItems", "Parameters", super.getRootNode());
        for(int j = 0; j < vector.size(); j++)
        {
            Node node1 = (Node)vector.get(j);
            Vector vector2 = getAttributeList(node1);
            XParameter xparameter = new XParameter(vector2);
            parameters.addElement(xparameter);
        }

    }

    public String[] getCodeDefinition(String s, String s1)
        throws Exception
    {
        String as[] = {
            "", "", "", "", "", ""
        };
        for(int i = 0; i < codeItems.size(); i++)
        {
            XCodeItem xcodeitem = (XCodeItem)codeItems.get(i);
            String s2 = XAttribute.getAttributeValue(xcodeitem.attributes, "name");
            String s3 = XAttribute.getAttributeValue(xcodeitem.attributes, "type");
            if(s.equalsIgnoreCase(s2) && StringFunction.getOccurTimesIgnoreCase(s3.trim(), s1.trim()) > 0)
            {
                as[0] = s1.trim();
                as[1] = XAttribute.getAttributeValue(xcodeitem.attributes, "codeListScript");
                as[2] = XAttribute.getAttributeValue(xcodeitem.attributes, "tagAfterCodeList");
                as[3] = XAttribute.getAttributeValue(xcodeitem.attributes, "codeListInitialCheckedItem");
                as[4] = XAttribute.getAttributeValue(xcodeitem.attributes, "displayNameScript");
                return as;
            }
        }

        return as;
    }

    private static final long serialVersionUID = 1L;
    public Vector codeItems;
    public Vector parameters;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 76 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/