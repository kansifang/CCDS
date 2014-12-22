package com.lmt.app.crawler.removenoise.SST;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.ListIterator;

import org.w3c.dom.DOMConfiguration;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.bootstrap.DOMImplementationRegistry;
import org.w3c.dom.ls.DOMImplementationLS;
import org.w3c.dom.ls.LSSerializer;

/**
 * ElementNode 中可能包括分叉多个StyleNode 放在 children 里面
 * 
 * @author Administrator
 * 
 */
public class ElementNode {
	private Node node;
	private String tagName;
	private String nodeValue;
	private boolean isText;
	private HashMap<String, String> atrrMap = new HashMap<String, String>();
	private ArrayList<StyleNode> children = new ArrayList<StyleNode>();
	private ArrayList<String> contents = new ArrayList<String>();
	// 衰减因子，越大，节点重要性越大，反之，后代（即所属自风格节点越重要）
	private static double RAMDA = 0.9;

	protected ElementNode(String tagName, String nodeValue) {
		this.tagName = tagName;
		this.nodeValue = nodeValue;
	}

	protected ElementNode(Node node) {
		this.tagName = node.getNodeName();
		this.nodeValue = ElementNode.getNodeValue(node);
	}

	// 默认返回根风格节点
	public static ElementNode getInstanceOf() {
		return new ElementNode("root name", "root value");
	}

	public static ElementNode getInstanceOf(Node node) {
		ElementNode elementNode = new ElementNode(node);
		elementNode.addContent();
		return elementNode;
	}

	public Node getNode() {
		return node;
	}

	public void setNode(Node node) {
		this.node = node;
	}

	private void addContent() {
		if (getNodeValue() != null) {
			this.contents.add(getNodeValue());
		}
	}

	public void addContent(ElementNode elementNode) {
		if (elementNode.getNodeValue() != null) {
			this.contents.add(elementNode.getNodeValue());
		}
	}

	public ArrayList<String> getContents() {
		return contents;
	}

	public HashMap<String, String> getAtrr() {
		return atrrMap;
	}

	public String getNodeName() {
		return tagName;
	}

	public String getNodeValue() {
		return nodeValue;
	}

	public static String getNodeValue(Node node) {
		if (node.getNodeType() == Node.TEXT_NODE) {
			String value = node.getNodeValue().trim();
			if (value.length() == 0) {
				return null;
			}
			return value;
		}
		if (node.getNodeType() == Node.ELEMENT_NODE) {
			return nodeToString(node);
		}

		return null;
	}

	public boolean isLeaf() {
		return (this.children.size() == 0);
	}

	public boolean isText() {
		return isText;
	}

	public StyleNode add(StyleNode styleNode) {
		ListIterator<StyleNode> list = this.children.listIterator();
		while (list.hasNext()) {
			StyleNode child = list.next();
			if (child.equals(styleNode)) {
				// 和已有的NodeSet相同，不分裂(分叉) 只增加相同的计数
				child.increaseCount();
				child.addContents(styleNode);
				return child;
			}
		}
		// 内容不相同，分裂出新的NodeSet
		this.children.add(styleNode);
		return styleNode;
	}

	public StyleNode get(StyleNode styleNodeSet) {
		for (StyleNode child : this.children) {
			if (child.equals(styleNodeSet)) {
				return child;
			}
		}

		return null;
	}

	public String toString() {
		return this.getNodeName();
	}

	/*
	 * public short getNodeType() { return node.getNodeType(); }
	 */

	public static String nodeToString(Node node) {
		if (node == null) {
			return "root";
		}
		System.setProperty(DOMImplementationRegistry.PROPERTY,
				"org.apache.xerces.dom.DOMXSImplementationSourceImpl");
		DOMImplementationRegistry registry = null;
		try {
			registry = DOMImplementationRegistry.newInstance();
		} catch (ClassCastException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		DOMImplementationLS impl = (DOMImplementationLS) registry
				.getDOMImplementation("LS");
		LSSerializer lsSerializer = impl.createLSSerializer();
		DOMConfiguration config = lsSerializer.getDomConfig();
		config.setParameter("xml-declaration", false);
		return lsSerializer.writeToString(node);
	}

	public ArrayList<StyleNode> getChildren() {
		return this.children;
	}

	public boolean isImportant() {
		if (getCompositeImportance() > 0 || getContentImportance() > 0) {
			return true;
		}
		return false;
	}

	public void trainNode(Node root) {
		if (!root.hasChildNodes()) {
			return;
		}
		NodeList nodeList = root.getChildNodes();
		Node node = null;
		int i = 0;
		StyleNode styleNode = new StyleNode();
		for (i = 0; i < nodeList.getLength(); i++) {
			node = nodeList.item(i);
			ElementNode elementNode = ElementNode.getInstanceOf(node);
			styleNode.addElementNode(elementNode);
		}
		StyleNode child = this.add(styleNode);
		for (i = 0; i < nodeList.getLength(); i++) {
			child.getElementNode(i).trainNode(nodeList.item(i));
		}
	}

	// 当前元素节点重要性是所属子风格节点重要性的加总，通过所有自风格节点计算当前元素节点的重要性
	public double getSimpleImportance() {
		double sum = 0.0;
		int numOfStyles = 0;
		for (StyleNode child : this.children) {
			numOfStyles += child.getCount();
		}
		for (StyleNode child : this.children) {
			sum += child.getOutImportance(numOfStyles);
		}
		return sum;
	}

	// 元素节点综合重要是元素节点重要性加所属子风格节点内容重要性
	public double getCompositeImportance() {
		double sum = 0.0;
		// 计算所有子风格几点
		for (StyleNode child : this.children) {
			sum += child.getInImportance();
		}
		return (1 - ElementNode.RAMDA) * this.getSimpleImportance()
				+ ElementNode.RAMDA * sum;
	}

	// 当前是叶子元素节点下计算其重要性
	public double getContentImportance() {
		double rv = 0.0;
		String aContent = null;
		if (this.tagName == null || isLeaf() == false) {
			return 0.0;
		}
		if (this.contents.size() == 0) {
			return 0.0;
		}
		if (this.contents.size() == 1) {
			return 1.0;
		}
		for (String content : this.contents) {
			if (content != null) {
				aContent = content;
				break;
			}
		}
		if (aContent == null) {
			return 1.0;
		}
		for (String content : this.contents) {
			if (!aContent.equals(content)) {
				rv = 1.0;
			}
		}
		return rv;
	}

	public void getContent(Node root, StringWriter out) {
		NodeList nodeList = root.getChildNodes();
		int i = 0;
		StyleNode styleNodeSet = new StyleNode();
		Node node = null;
		if (isLeaf() && isText() && isImportant()) {
			out.append(ElementNode.getNodeValue(root));
		}
		for (i = 0; i < nodeList.getLength(); i++) {
			node = nodeList.item(i);
			ElementNode elementNode = ElementNode.getInstanceOf(node);
			styleNodeSet.addElementNode(elementNode);
		}
		if (!root.hasChildNodes()) {
			return;
		}
		StyleNode child = get(styleNodeSet);
		if (child == null) {
			System.err.println(getInformation()
					+ "child is null -- it should not be occured!!");
		}
		for (i = 0; i < nodeList.getLength(); i++) {
			if (child.getElementNode(i) == null) {
				System.err.println("child is null");
			}
			if (nodeList.item(i) == null) {
				System.err.println("nodeList is null");
			}
			child.getElementNode(i).getContent(nodeList.item(i), out);
		}
	}

	public void printChildren() {
		System.out.println(this.getNodeName() + " : node       importance : "
				+ this.getSimpleImportance());
		// System.out.println(this.getNodeValue() +
		// " : compsosite importance : " + this.getCompositeImportance());
		if (this.isLeaf()) {
			System.out.println("    # of contents : " + contents.size());
			System.out.println("    content importance : "
					+ this.getContentImportance());
		}
		for (int i = 0; i < children.size(); i++) {
			children.get(i).print();
		}
	}

	public void printSimpleImportance() {
		if (this.getSimpleImportance() != 0) {
			System.out.println(this.getNodeName() + "  simple importance : "
					+ this.getSimpleImportance());
		}
		for (int i = 0; i < children.size(); i++) {
			children.get(i).printSimpleImportance();
		}
	}

	public void printCompositeImportance() {
		if (this.getCompositeImportance() != 0) {
			System.out.println(this.getNodeName() + "  composite importance : "
					+ this.getCompositeImportance());
		}
		for (int i = 0; i < children.size(); i++) {
			children.get(i).printCompositeImportance();
		}
	}

	public void printContentImportance() {
		System.out.println(this.getNodeName() + " : "
				+ this.getContentImportance());
		if (this.isLeaf() && this.getContentImportance() > 0) {
			for (String content : this.contents) {
				System.out.print("[" + content + "]");
			}
			System.out.println();
		}
		for (StyleNode child : children) {
			child.printContentImportance();
		}
	}

	public void printTree(String sep) {
		System.out.println(sep + "[N] " + getNodeName());
		for (StyleNode styleNodeSet : this.children) {
			styleNodeSet.printTree(sep + " ");
		}
	}

	public String getInformation() {
		StringBuffer strContents = new StringBuffer("\n");
		for (int i = 0; i < contents.size(); i++) {
			strContents.append("[" + contents.get(i) + "]\n");
		}
		return "[info of ElementNode] NodeName:" + this.getNodeName()
				+ " NodeValue:" + this.getNodeValue() + " child.size="
				+ this.children.size() + " contents.size="
				+ this.contents.size() + " contents:" + strContents;
	}

	public void printInformation() {
		System.out.println(getInformation());
		for (int i = 0; i < children.size(); i++) {
			System.out.print(i + "> ");
			children.get(i).printInformation();
		}
	}
}
