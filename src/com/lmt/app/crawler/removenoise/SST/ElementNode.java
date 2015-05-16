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
	//存储 元素节点 如 <a> 叶子节点（textNode） 如 国务院总理
	private ArrayList<String> contents = new ArrayList<String>();
	// 衰减因子，越大，节点重要性越大，反之，后代，即所属之风格节点越重要
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
		//标签节点，本身作为字符串返回
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
				// 和已有的styleNode相同，不分裂(分叉) 只增加相同的计数
				child.increaseCount();
				//只把要加的风格节点中元素节点的内容增加到已存在的风格节点对应的元素节点里面
				child.addContents(styleNode);
				return child;
			}
		}
		// 内容不相同，分裂出新的styleNode
		this.children.add(styleNode);
		return styleNode;
	}

	public StyleNode get(StyleNode styleNode) {
		for (StyleNode child : this.children) {
			if (child.equals(styleNode)) {
				return child;
			}
		}
		return null;
	}
	/**
	 * 返回节点名称
	 */
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
		System.setProperty(DOMImplementationRegistry.PROPERTY,"org.apache.xerces.dom.DOMXSImplementationSourceImpl");
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
		DOMImplementationLS impl = (DOMImplementationLS) registry.getDOMImplementation("LS");
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
	//总体思想是：传入参数节点root的第一层子节点包装成元素节点，然后归入风格节点挂到当前元素下，
	//然后下一层子节点继续包装挂到上一层元素节点下
	public void trainNode(Node root) {
		if (!root.hasChildNodes()) {
			return;
		}
		//所有子节点，可不包括孙子节点
		NodeList nodeList = root.getChildNodes();
		Node node = null;
		int i = 0;
		StyleNode styleNode = new StyleNode();
		//1、把传入参数节点的子节点当成元素节点合并成风格节点，挂到当前元素节点下
		for (i = 0; i < nodeList.getLength(); i++) {
			node = nodeList.item(i);
			ElementNode elementNode = ElementNode.getInstanceOf(node);
			styleNode.addElementNode(elementNode);
		}
		StyleNode child = this.add(styleNode);
		//然后，子节点再当成元素节点合并成风格节点，加入到第一层元素节点中去，即递归往下进行
		//注意 元素节点的顺序和元html标签节点的顺序是一致的
		for (i = 0; i <nodeList.getLength(); i++){
			child.getElementNode(i).trainNode(nodeList.item(i));
		}
	}
	// 当前元素节点重要性是所属子风格节点重要性的加总，通过所有自风格节点计算当前元素节点的重要性
	private double getSimpleImportance() {
		double sum = 0.0;
		int numOfStyles = 0;
		for (StyleNode child : this.children) {
			numOfStyles += child.getCount();
		}
		for (StyleNode child : this.children) {
			sum += child.getEntropyValue(numOfStyles);
		}
		return sum;
	}

	// 元素节点综合重要是元素节点重要性加所属子风格节点内容重要性
	public double getCompositeImportance() {
		double sum = 0.0;
		// 计算所有子风格几点
		for (StyleNode child : this.children) {
			sum += child.getNotLeafStyleNodeImportance();
		}
		return (1 - ElementNode.RAMDA) * this.getSimpleImportance()
				+ ElementNode.RAMDA * sum;
	}

	//给节点一个重要程度值 
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
	
	//以下内容测试用
	/**
	 * 获取当前元素下的风格节点中与 root下的标签节点形成的风格节点相同的内容
	 * @param root
	 * @param out
	 */
	public void getContent(Node root, StringWriter out) {
		NodeList nodeList = root.getChildNodes();
		Node node = null;
		if (isLeaf() && isText() && isImportant()) {
			out.append(ElementNode.getNodeValue(root));
		}
		//先把传入参数节点转化成风格节点
		StyleNode styleNode = new StyleNode();
		for (int i = 0; i < nodeList.getLength(); i++) {
			node = nodeList.item(i);
			ElementNode elementNode = ElementNode.getInstanceOf(node);
			styleNode.addElementNode(elementNode);
		}
		if (!root.hasChildNodes()) {
			return;
		}
		//看看当前元素节点有没有这个风格节点
		StyleNode child = get(styleNode);
		if (child == null) {
			System.err.println(getInformation()
					+ "child is null -- it should not be occured!!");
		}
		//有的话，递归一直往下取直到获得叶子节点的值
		for (int i = 0; i < nodeList.getLength(); i++) {
			if (child.getElementNode(i) == null) {
				System.err.println("there is no elementNode in styleNode");
			}
			if (nodeList.item(i) == null) {
				System.err.println("nodeList is null");
			}
			child.getElementNode(i).getContent(nodeList.item(i), out);
		}
	}

	public void printSimpleImportance() {
		if (this.getSimpleImportance() != 0) {
			System.out.println(this.getNodeName() + "  simple importance :"+ this.getSimpleImportance());
		}
		for (int i = 0; i < children.size(); i++) {
			children.get(i).printSimpleImportance();
		}
	}

	public void printCompositeImportance() {
		if (this.getCompositeImportance() != 0) {
			System.out.println(this.getNodeName() + "  composite importance : "+ this.getCompositeImportance());
		}
		for (int i = 0; i < children.size(); i++) {
			children.get(i).printCompositeImportance();
		}
	}

	public void printContentImportance() {
		System.out.println(this.getNodeName() + " : "+ this.getContentImportance());
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
		for (StyleNode styleNode : this.children) {
			styleNode.printTree(sep + " ");
		}
	}
	public void printInformation() {
		System.out.println(getInformation());
		for (int i = 0; i < children.size(); i++) {
			System.out.print(i + "> ");
			children.get(i).printInformation();
		}
	}
	public void printImportance() {
		System.out.println("["+this.getNodeName()+"]:" );
		if (this.isLeaf()) {
			System.out.println("    size of contents : " + contents.size());
			System.out.println(" node   content importance : "+ this.getContentImportance());
		}else{
			System.out.println( " node   composite : "+ this.getCompositeImportance());
		}
		for (int i = 0; i < children.size(); i++) {
			children.get(i).printImportance();
		}
	}
	private String getInformation() {
		StringBuffer strContents = new StringBuffer("\n");
		for (int i = 0; i < contents.size(); i++) {
			strContents.append("[" + contents.get(i) + "]\n");
		}
		return "[info of ElementNode] NodeName:" + this.getNodeName()
				+ " NodeValue:" + this.getNodeValue() + " child.size="
				+ this.children.size() + " contents.size="
				+ this.contents.size() + " contents:" + strContents;
	}
}