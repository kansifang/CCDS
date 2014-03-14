package com.lmt.app.util.xml;

import java.util.ArrayList;
import java.util.List;
import org.w3c.dom.Attr;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Element
{
  private org.w3c.dom.Element domElement;

  public Element(org.w3c.dom.Element paramElement)
  {
    this.domElement = paramElement;
  }

  public org.w3c.dom.Element getDomElement()
  {
    return this.domElement;
  }

  public String getName()
  {
    return getDomElement().getTagName();
  }

  public String getTextTrim()
  {
    Node localNode = getTextNode(getDomElement());
    if (localNode != null)
      return localNode.getNodeValue().trim();
    return null;
  }

  public String getChildTextTrim(String paramString)
  {
    Element localElement = getChild(paramString);
    if (localElement == null)
      return null;
    return localElement.getTextTrim();
  }

  private Node getTextNode(Node paramNode)
  {
    NodeList localNodeList = paramNode.getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode = localNodeList.item(i);
      if (localNode.getNodeType() == 3)
        return localNode;
    }
    return null;
  }

  public Element getChild(String paramString)
  {
    Element localElement = null;
    NodeList localNodeList = getDomElement().getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode = localNodeList.item(i);
      if ((localNode.getNodeType() != 1) || (!localNode.getNodeName().equals(paramString)))
        continue;
      localElement = new Element((org.w3c.dom.Element)localNode);
      break;
    }
    return localElement;
  }

  public List getNodeList(String paramString)
  {
    return getChildren(paramString);
  }

  public List getChildren(String paramString)
  {
    ArrayList localArrayList = new ArrayList();
    NodeList localNodeList = getDomElement().getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode = localNodeList.item(i);
      if ((localNode.getNodeType() != 1) || (!localNode.getNodeName().equals(paramString)))
        continue;
      localArrayList.add(new Element((org.w3c.dom.Element)localNode));
    }
    return localArrayList;
  }

  public List getChildren()
  {
    ArrayList localArrayList = new ArrayList();
    NodeList localNodeList = getDomElement().getChildNodes();
    for (int i = 0; i < localNodeList.getLength(); i++)
    {
      Node localNode = localNodeList.item(i);
      if (localNode.getNodeType() != 1)
        continue;
      localArrayList.add(new Element((org.w3c.dom.Element)localNode));
    }
    return localArrayList;
  }

  public String getAttributeValue(String paramString)
  {
    return getAttributeValue(paramString, null);
  }

  public String getAttributeValue(String paramString1, String paramString2)
  {
    String str = getDomElement().getAttribute(paramString1);
    return str.equals("") ? paramString2 : str;
  }

  public Attribute getAttribute(String paramString)
  {
    Attr localAttr = getDomElement().getAttributeNode(paramString);
    return localAttr == null ? null : new Attribute(paramString, localAttr.getValue());
  }

  public List getAttributeList()
    throws Exception
  {
    ArrayList localArrayList = new ArrayList();
    NamedNodeMap localNamedNodeMap = getDomElement().getAttributes();
    for (int i = 0; i < localNamedNodeMap.getLength(); i++)
      localArrayList.add(new Attribute(localNamedNodeMap.item(i).getNodeName(), localNamedNodeMap.item(i).getNodeValue()));
    return localArrayList;
  }
}