package com.lmt.app.util.xml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class Document
{
  private org.w3c.dom.Document xmlDoc;
  private File xmlFile;
  private org.w3c.dom.Element domRootNode;
  private Element rootElement;
  private DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
  private final int MaxBackupFileCount = 5;

  public Document(String paramString)
    throws Exception
  {
    this(new File(paramString));
  }

  public Document(File paramFile)
    throws Exception
  {
    this(new FileInputStream(paramFile));
  }

  public Document(InputStream paramInputStream)
    throws Exception
  {
    try
    {
      DocumentBuilder localDocumentBuilder = this.factory.newDocumentBuilder();
      this.xmlDoc = localDocumentBuilder.parse(paramInputStream);
      this.domRootNode = this.xmlDoc.getDocumentElement();
      this.rootElement = new Element(this.domRootNode);
    }
    catch (SAXParseException localSAXParseException)
    {
      throw localSAXParseException;
    }
    catch (SAXException localSAXException)
    {
      throw localSAXException;
    }
    catch (ParserConfigurationException localParserConfigurationException)
    {
      throw localParserConfigurationException;
    }
    catch (IOException localIOException)
    {
      throw localIOException;
    }
  }

  public org.w3c.dom.Document getDomDocument()
  {
    return this.xmlDoc;
  }

  public String getXmlDocName()
  {
    return this.xmlFile.getPath();
  }

  public Node getRootNode()
  {
    return this.domRootNode;
  }

  public Element getRootElement()
  {
    return this.rootElement;
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
/**
 * 1 ELEMENT_NODE 元素 <element/>
2 ATTRIBUTE_NODE 属性<node attribute=""/>
3 TEXT_NODE <node>text_node</node>
4 CDATA_SECTION_NODE CDATA <![CDATA[ ]]>
5 ENTITY_REFERENCE_NODE 实体引用 & amp ;
6 ENTITY_NODE <!ENTITY copyright "Copyright 2001 ]> 
7 PROCESSING_INSTRUCTION_NODE PI <?xml  ?>
8 COMMENT_NODE 注释 <!-- -->
9 DOCUMENT_NODE 文档 整个文档
10 DOCUMENT_TYPE_NODE DOCTYPE <!DOCTYPE >
11 DOCUMENT_FRAGMENT_NODE 零碎片断
12 NOTATION_NODE 符号

 * @param paramNode
 * @return
 */
  public String printDOMTree(Node paramNode)
  {
    String str = "";
    int i = paramNode.getNodeType();
    Object localObject;
    NodeList localNodeList;
    int k;
    int m;
    switch (i){
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
      File localFile = new File(getXmlDocName() + ".00" + j);
      localFile.lastModified();
      if (localFile.lastModified() <= l)
        continue;
      l = localFile.lastModified();
      i = j;
    }
    i += 1;
    if (i > 4)
      i = 0;
    writeToFile(getXmlDocName() + ".00" + i, getXmlFileToString().trim());
  }

  public String getXmlFileToString()
    throws Exception
  {
    FileInputStream localFileInputStream = new FileInputStream(getXmlDocName());
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