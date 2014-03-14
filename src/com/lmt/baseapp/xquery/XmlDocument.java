/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.io.*;
import java.util.Vector;
import javax.xml.parsers.*;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XmlDocument
    implements Serializable
{

    public XmlDocument(Node node)
    {
        factory = DocumentBuilderFactory.newInstance();
        domNode = node;
    }

    public XmlDocument(String s)
    {
        factory = DocumentBuilderFactory.newInstance();
        xmlDocName = s;
        try
        {
            DocumentBuilder documentbuilder = factory.newDocumentBuilder();
            xmlDoc = documentbuilder.parse(new File(xmlDocName));
            domNode = xmlDoc.getDocumentElement();
        }
        catch(SAXParseException saxparseexception)
        {
            System.out.println("\n** Parsing error, line " + saxparseexception.getLineNumber() + ", uri " + saxparseexception.getSystemId());
            System.out.println("   " + saxparseexception.getMessage());
            Object obj = saxparseexception;
            if(saxparseexception.getException() != null)
                obj = saxparseexception.getException();
            ((Exception)obj).printStackTrace();
        }
        catch(SAXException saxexception)
        {
            Object obj1 = saxexception;
            if(saxexception.getException() != null)
                obj1 = saxexception.getException();
            ((Exception)obj1).printStackTrace();
        }
        catch(ParserConfigurationException parserconfigurationexception)
        {
            parserconfigurationexception.printStackTrace();
        }
        catch(IOException ioexception)
        {
            ioexception.printStackTrace();
        }
    }

    public String getXmlDocName()
    {
        return xmlDocName;
    }

    public Node getRootNode()
    {
        return domNode;
    }

    public Node getNode(String sChildNode, Node node)
        throws Exception
    {
        NodeList nodelist = node.getChildNodes();
        for(int i = 0; i < nodelist.getLength(); i++)
        {
            Node node1 = nodelist.item(i);
            if(node1.getNodeName().trim().equalsIgnoreCase(sChildNode))
                return node1;
            if(node1.getChildNodes().getLength() <= 0)
                continue;
            Node node2 = getNode(sChildNode, node1);
            if(node2 != null)
                return node2;
        }
        return null;
    }

    public Node getNode(String s, String s1, String s2, Node node)
        throws Exception
    {
        NodeList nodelist = node.getChildNodes();
        for(int i = 0; i < nodelist.getLength(); i++)
        {
            Node node1 = nodelist.item(i);
            if(node1.getNodeName().trim().equalsIgnoreCase(s) && node1.getNodeType() == 1 && node1.getAttributes().getLength() > 0 && node1.getAttributes().getNamedItem(s1).getNodeValue().trim().equalsIgnoreCase(s2))
                return node1;
            if(node1.getChildNodes().getLength() <= 0)
                continue;
            Node node2 = getNode(s, s1, s2, node1);
            if(node2 != null)
                return node2;
        }

        return null;
    }

    public String getNodeValue(Node node)
        throws Exception
    {
        String s = "";
        NodeList nodelist = node.getChildNodes();
        for(int i = 0; i < nodelist.getLength(); i++)
        {
            Node node1 = nodelist.item(i);
            if(node1.getNodeType() == 3 && node1.getNodeValue().trim().length() > 0)
                return node1.getNodeValue();
        }

        return s;
    }

    public void setNodeValue(Node node, String s)
        throws Exception
    {
        NodeList nodelist = node.getChildNodes();
        if(nodelist.getLength() == 0)
        {
            Node node1 = getTextNode(getRootNode()).cloneNode(false);
            node1.setNodeValue(s);
            node.appendChild(node1);
        }
        for(int i = 0; i < nodelist.getLength(); i++)
        {
            Node node2 = nodelist.item(i);
            if(node2.getNodeType() == 3)
            {
                node2.setNodeValue(s);
                return;
            }
        }

    }

    public Node getTextNode(Node node)
        throws Exception
    {
        NodeList nodelist = node.getChildNodes();
        for(int i = 0; i < nodelist.getLength(); i++)
        {
            Node node1 = nodelist.item(i);
            if(node1.getNodeType() == 3)
                return node1;
            if(node1.getChildNodes().getLength() <= 0)
                continue;
            Node node2 = getTextNode(node1);
            if(node2 != null)
                return node2;
        }

        return null;
    }

    public Vector getNodeList(String sChildNode, Node node)
        throws Exception
    {
        Vector vector = new Vector();
        NodeList nodelist = node.getChildNodes();
        for(int i = 0; i < nodelist.getLength(); i++)
        {
            Node node1 = nodelist.item(i);
            if(node1.getNodeName().trim().equalsIgnoreCase(sChildNode))
                vector.addElement(node1);
        }

        return vector;
    }

    public Vector getNodeList(String sChildNode, String sGrandChildNode, Node node)
        throws Exception
    {
        return getNodeList(sGrandChildNode, getNode(sChildNode, node));
    }

    public Vector getAttributeList(Node node)
        throws Exception
    {
        Vector vector = new Vector();
        if(node.getNodeType() == 1 && node.getAttributes().getLength() > 0)
        {
            for(int i = 0; i < node.getAttributes().getLength(); i++)
            {
                String as[] = new String[2];
                as[0] = node.getAttributes().item(i).getNodeName();
                as[1] = node.getAttributes().item(i).getNodeValue();
                vector.addElement(as);
            }

        }
        return vector;
    }

    public String printDOMTree(Node node)
    {
        String s = "";
        short word0 = node.getNodeType();
        switch(word0)
        {
        case 9: // '\t'
            s = s + "<?xml version='1.0' encoding='ISO8859-1'?>";
            s = s + printDOMTree(((Node) (((Document)node).getDocumentElement())));
            break;

        case 1: // '\001'
            s = s + "<";
            s = s + node.getNodeName();
            NamedNodeMap namednodemap = node.getAttributes();
            for(int i = 0; i < namednodemap.getLength(); i++)
            {
                Node node1 = namednodemap.item(i);
                s = s + " " + node1.getNodeName() + "=\"" + node1.getNodeValue() + "\"";
            }

            s = s + ">";
            NodeList nodelist = node.getChildNodes();
            if(nodelist != null)
            {
                int j = nodelist.getLength();
                for(int k = 0; k < j; k++)
                    s = s + printDOMTree(nodelist.item(k));

            }
            break;

        case 5: // '\005'
            s = s + "&";
            s = s + node.getNodeName();
            s = s + ";";
            break;

        case 4: // '\004'
            s = s + "<![CDATA[";
            s = s + node.getNodeValue();
            s = s + "]]>";
            break;

        case 3: // '\003'
            s = s + node.getNodeValue();
            break;

        case 7: // '\007'
            s = s + "<?";
            s = s + node.getNodeName();
            String s1 = node.getNodeValue();
            s = s + " ";
            s = s + s1;
            s = s + "?>";
            break;
        }
        if(word0 == 1)
        {
            s = s + "";
            s = s + "</";
            s = s + node.getNodeName();
            s = s + '>';
        }
        return s;
    }

    public void backup()
        throws Exception
    {
        int i = -1;
        long l = 0L;
        for(int j = 0; j < 5; j++)
        {
            File file = new File(xmlDocName + ".00" + j);
            if(file.lastModified() > l)
            {
                l = file.lastModified();
                i = j;
            }
        }

        if(++i > 4)
            i = 0;
        writeToFile(xmlDocName + ".00" + i, getXmlFileToString().trim());
    }

    public String getXmlFileToString()
        throws Exception
    {
        FileInputStream fileinputstream = new FileInputStream(xmlDocName);
        InputStreamReader inputstreamreader = new InputStreamReader(fileinputstream);
        char ac[] = new char[fileinputstream.available()];
        inputstreamreader.read(ac);
        fileinputstream.close();
        return new String(ac);
    }

    public void writeToFile(String s, String s1)
        throws Exception
    {
        FileWriter filewriter = new FileWriter(s);
        for(int i = 0; i < s1.length(); i++)
            filewriter.write(s1.charAt(i));

        filewriter.close();
    }

    private static final long serialVersionUID = 1L;
    private Document xmlDoc;
    private String xmlDocName;
    private Node domNode;
    private DocumentBuilderFactory factory;
    private final int MaxBackupFileCount = 5;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 81 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/