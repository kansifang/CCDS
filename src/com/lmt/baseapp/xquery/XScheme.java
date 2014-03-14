/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;
import org.w3c.dom.Node;

// Referenced classes of package com.amarsoft.xquery:
//            XmlDocument, XAttribute

public class XScheme extends XmlDocument
{

    public XScheme(Vector vector, Node node)
        throws Exception
    {
        super(node);
        attributes = XAttribute.setAttributeList(attributes, vector);
        Node node1 = super.getNode("DisplayColumns", node);
        attributes = XAttribute.setAttributeValue(attributes, "displayColumns", getNodeValue(node1));
        node1 = super.getNode("OrderColumns", node);
        attributes = XAttribute.setAttributeValue(attributes, "orderColumns", getNodeValue(node1));
        node1 = super.getNode("GroupColumns", node);
        attributes = XAttribute.setAttributeValue(attributes, "groupColumns", getNodeValue(node1));
        node1 = super.getNode("SummaryColumns", node);
        attributes = XAttribute.setAttributeValue(attributes, "summaryColumns", getNodeValue(node1));
    }

    private static final long serialVersionUID = 1L;
    public String attributes[][] = {
				        { "name", ""},
				        {"caption", ""},
				        {"displayColumns", ""}, 
				        {"orderColumns", ""},
				        {"groupColumns", ""},
				        {"summaryColumns", ""}
    			};
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 80 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/