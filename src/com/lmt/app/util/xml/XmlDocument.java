package com.lmt.app.util.xml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Vector;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XmlDocument
{
  private org.w3c.dom.Document xmlDoc;
  private String xmlDocName;
  private Node domNode;
  private DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
  private final int MaxBackupFileCount = 5;

  public XmlDocument(Node paramNode)
  {
    this.domNode = paramNode;
  }

  public XmlDocument(InputStream paramInputStream)
  {
    try
    {
      DocumentBuilder localDocumentBuilder = this.factory.newDocumentBuilder();
      this.xmlDoc = localDocumentBuilder.parse(paramInputStream);
      this.domNode = this.xmlDoc.getDocumentElement();
    }
    catch (SAXParseException localSAXParseException)
    {
      System.out.println("\n** Parsing error, line " + localSAXParseException.getLineNumber() + ", uri " + localSAXParseException.getSystemId());
      System.out.println("   " + localSAXParseException.getMessage());
      Object localObject = localSAXParseException;
      if (localSAXParseException.getException() != null)
        localObject = localSAXParseException.getException();
      ((Exception)localObject).printStackTrace();
    }
    catch (SAXException localSAXException)
    {
      Object localObject = localSAXException;
      if (localSAXException.getException() != null)
        localObject = localSAXException.getException();
      ((Exception)localObject).printStackTrace();
    }
    catch (ParserConfigurationException localParserConfigurationException)
    {
      localParserConfigurationException.printStackTrace();
    }
    catch (IOException localIOException)
    {
      localIOException.printStackTrace();
    }
  }

  public XmlDocument(String paramString)
  {
    this.xmlDocName = paramString;
    try
    {
      DocumentBuilder localDocumentBuilder = this.factory.newDocumentBuilder();
      this.xmlDoc = localDocumentBuilder.parse(new File(this.xmlDocName));
      this.domNode = this.xmlDoc.getDocumentElement();
    }
    catch (SAXParseException localSAXParseException)
    {
      System.out.println("\n** Parsing error, line " + localSAXParseException.getLineNumber() + ", uri " + localSAXParseException.getSystemId());
      System.out.println("   " + localSAXParseException.getMessage());
      Object localObject = localSAXParseException;
      if (localSAXParseException.getException() != null)
        localObject = localSAXParseException.getException();
      ((Exception)localObject).printStackTrace();
    }
    catch (SAXException localSAXException)
    {
      Object localObject = localSAXException;
      if (localSAXException.getException() != null)
        localObject = localSAXException.getException();
      ((Exception)localObject).printStackTrace();
    }
    catch (ParserConfigurationException localParserConfigurationException)
    {
      localParserConfigurationException.printStackTrace();
    }
    catch (IOException localIOException)
    {
      localIOException.printStackTrace();
    }
  }

  public String getXmlDocName()
  {
    return this.xmlDocName;
  }

  public Node getRootNode()
  {
    return this.domNode;
  }

  public Node getNode(String paramString, Node paramNode)
    throws Exception
  {
    NodeList localNodeList = paramNode.getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode1 = localNodeList.item(i);
      if (localNode1.getNodeName().trim().equalsIgnoreCase(paramString))
        return localNode1;
      if (localNode1.getChildNodes().getLength() <= 0)
        continue;
      Node localNode2 = getNode(paramString, localNode1);
      if (localNode2 != null)
        return localNode2;
    }
    return null;
  }

  public Node getNode(String paramString1, String paramString2, String paramString3, Node paramNode)
    throws Exception
  {
    NodeList localNodeList = paramNode.getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode1 = localNodeList.item(i);
      if ((localNode1.getNodeName().trim().equalsIgnoreCase(paramString1)) && (localNode1.getNodeType() == 1) && (localNode1.getAttributes().getLength() > 0) && (localNode1.getAttributes().getNamedItem(paramString2).getNodeValue().trim().equalsIgnoreCase(paramString3)))
        return localNode1;
      if (localNode1.getChildNodes().getLength() <= 0)
        continue;
      Node localNode2 = getNode(paramString1, paramString2, paramString3, localNode1);
      if (localNode2 != null)
        return localNode2;
    }
    return null;
  }

  public String getNodeValue(Node paramNode)
    throws Exception
  {
    String str = "";
    NodeList localNodeList = paramNode.getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode = localNodeList.item(i);
      if ((localNode.getNodeType() == 3) && (localNode.getNodeValue().trim().length() > 0))
        return localNode.getNodeValue();
    }
    return str;
  }

  public void setNodeValue(Node paramNode, String paramString)
    throws Exception
  {
    NodeList localNodeList = paramNode.getChildNodes();
    if (localNodeList.getLength() == 0)
    {
      Node localNode1 = getTextNode(getRootNode()).cloneNode(false);
      localNode1.setNodeValue(paramString);
      paramNode.appendChild(localNode1);
    }
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode2 = localNodeList.item(i);
      if (localNode2.getNodeType() != 3)
        continue;
      localNode2.setNodeValue(paramString);
      return;
    }
  }

  public Node getTextNode(Node paramNode)
    throws Exception
  {
    NodeList localNodeList = paramNode.getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode1 = localNodeList.item(i);
      if (localNode1.getNodeType() == 3)
        return localNode1;
      if (localNode1.getChildNodes().getLength() <= 0)
        continue;
      Node localNode2 = getTextNode(localNode1);
      if (localNode2 != null)
        return localNode2;
    }
    return null;
  }

  public Vector getNodeList(String paramString, Node paramNode)
    throws Exception
  {
    Vector localVector = new Vector();
    NodeList localNodeList = paramNode.getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode = localNodeList.item(i);
      if (!localNode.getNodeName().trim().equalsIgnoreCase(paramString))
        continue;
      localVector.addElement(localNode);
    }
    return localVector;
  }

  public Vector getNodeList(String paramString1, String paramString2, Node paramNode)
    throws Exception
  {
    return getNodeList(paramString2, getNode(paramString1, paramNode));
  }

  public Vector getAttributeList(Node paramNode)
    throws Exception
  {
    Vector localVector = new Vector();
    if ((paramNode.getNodeType() == 1) && (paramNode.getAttributes().getLength() > 0))
      for (int i = 0; i < paramNode.getAttributes().getLength(); i++)
      {
        String[] arrayOfString = new String[2];
        arrayOfString[0] = paramNode.getAttributes().item(i).getNodeName();
        arrayOfString[1] = paramNode.getAttributes().item(i).getNodeValue();
        localVector.addElement(arrayOfString);
      }
    return localVector;
  }

  public String printDOMTree(Node paramNode)
  {
    String str = "";
    int i = paramNode.getNodeType();
    Object localObject;
    NodeList localNodeList;
    int k;
    int m;
    switch (i)
    {
    case 9:
      str = str + "<?xml version='1.0' encoding='ISO8859-1'?>";
      str = str + printDOMTree(((org.w3c.dom.Document)paramNode).getDocumentElement());
      break;
    case 1:
      str = str + "<";
      str = str + paramNode.getNodeName();
      localObject = paramNode.getAttributes();
      for (int j = 0; j < ((NamedNodeMap)localObject).getLength(); j++)
      {
        Node localNode = ((NamedNodeMap)localObject).item(j);
        str = str + " " + localNode.getNodeName() + "=\"" + localNode.getNodeValue() + "\"";
      }
      str = str + ">";
      localNodeList = paramNode.getChildNodes();
      if (localNodeList == null)
        break;
      k = localNodeList.getLength();
      m = 0;
      while (m < k)
      {
        str = str + printDOMTree(localNodeList.item(m));
        m++;
      }
    case 5:
    	  str = str + "&";
          str = str + paramNode.getNodeName();
          str = str + ";";
          break;
    case 4:
    	  str = str + "<![CDATA[";
          str = str + paramNode.getNodeValue();
          str = str + "]]>";
          break;
    case 3:
    	str = str + paramNode.getNodeValue();
        break;
    case 7:
        str = str + "<?";
        str = str + paramNode.getNodeName();
        localObject = paramNode.getNodeValue();
        str = str + " ";
        str = str + (String)localObject;
        str = str + "?>";
    case 2:
    case 6:
    case 8:
    }
    if (i == 1)
    {
      str = str + "";
      str = str + "</";
      str = str + paramNode.getNodeName();
      str = str + '>';
    }
    return (String)str;
  }

  public void backup()
    throws Exception
  {
    int i = -1;
    long l = 0L;
    for (int j = 0; j < 5; j++)
    {
      File localFile = new File(this.xmlDocName + ".00" + j);
      localFile.lastModified();
      if (localFile.lastModified() <= l)
        continue;
      l = localFile.lastModified();
      i = j;
    }
    i += 1;
    if (i > 4)
      i = 0;
    writeToFile(this.xmlDocName + ".00" + i, getXmlFileToString().trim());
  }

  public String getXmlFileToString()
    throws Exception
  {
    FileInputStream localFileInputStream = new FileInputStream(this.xmlDocName);
    InputStreamReader localInputStreamReader = new InputStreamReader(localFileInputStream);
    char[] arrayOfChar = new char[localFileInputStream.available()];
    localInputStreamReader.read(arrayOfChar);
    localFileInputStream.close();
    return new String(arrayOfChar);
  }

  public void writeToFile(String paramString1, String paramString2)
    throws Exception
  {
    FileWriter localFileWriter = new FileWriter(paramString1);
    for (int i = 0; i < paramString2.length(); i++)
      localFileWriter.write(paramString2.charAt(i));
    localFileWriter.close();
  }
}