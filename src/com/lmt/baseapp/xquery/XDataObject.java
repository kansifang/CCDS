/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;
import org.w3c.dom.Node;

// Referenced classes of package com.amarsoft.xquery:
//            XmlDocument, XColumn, XAttribute

public class XDataObject extends XmlDocument
{

    public XDataObject(String s, String s1)
        throws Exception
    {
        super(s);
        columns = new Vector();
        Node node = super.getNode("DataObject", "name", s1, super.getRootNode());
        attributes = XAttribute.setAttributeList(attributes, getAttributeList(node));
        Vector vector = super.getNodeList("Columns", "Column", node);
        for(int i = 0; i < vector.size(); i++)
        {
            Node node1 = (Node)vector.get(i);
            columns.addElement(new XColumn(getAttributeList(node1)));
        }

    }

    private static final long serialVersionUID = 1L;
    public String attributes[][] = {
        {
            "name", ""
        }, {
            "type", ""
        }
    };
    public Vector columns;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 74 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/