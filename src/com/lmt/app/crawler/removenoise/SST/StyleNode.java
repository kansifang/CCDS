package com.lmt.app.crawler.removenoise.SST;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

public class StyleNode {
	private int count;// 当前风格点在网页中出现的次数
	private ArrayList<ElementNode> nodeList = new ArrayList<ElementNode>();

	public StyleNode() {
		this.count = 1;
	}

	public boolean equals(StyleNode obj) {
		if (this.nodeList.size() != obj.nodeList.size()) {
			return false;
		}
		for (int i = 0; i < this.nodeList.size(); i++) {
			if (!this.nodeList.get(i).getNodeName().equals(obj.nodeList.get(i).getNodeName())) {
				return false;
			}
		}
		return true;
	}

	public void addElementNode(ElementNode node) {
		nodeList.add(node);
	}

	public void addContents(StyleNode styleNode) {
		int i = 0;
		//这里面顺序很重要，两个风格节点相同必是所有标签名按顺序一一对应相同
		for (ElementNode elementNode : this.nodeList) {
			elementNode.addContent(styleNode.getElementNode(i++));
		}
	}

	public int getCount(){
		return count;
	}

	public void increaseCount(){
		this.count++;
	}

	public ElementNode getElementNode(int i) {
		if (i > nodeList.size()) {
			return null;
		}
		return nodeList.get(i);
	}

	// numOfStyles 当前风格节点所属元素节点包含的子风格节点总数，即兄弟数
	// 当前风格节点重要性
	public double getEntropyValue(int numOfStyles) {
		if (numOfStyles == 1) {
			return 1.0;
		}
		double ratio = (double) count / numOfStyles;
		return -ratio * Math.log(ratio) / Math.log(numOfStyles);// -ratio*Math.log(numOfStyles)ratio
	}

	// 风格节点综合重要性是所属元素重要性的加总
	public double getNotLeafStyleNodeImportance() {
		double sum = 0.0;
		for (ElementNode elementNode : nodeList) {
			sum += elementNode.getCompositeImportance();
		}
		return sum / nodeList.size();
	}
	//计算风格节点中全是叶子节点的综合重要性
	public double getLeafStyleNodeImportance() {
		boolean isText = true;
		for (ElementNode elementNode : nodeList) {
			if (!elementNode.isLeaf()) {
				isText = false;
				break;
			}
		}
		if (!isText) {
			return 0;
		}
		//出现在网页中总数
		int m = count;
		if (m == 0) {
			return 0;
		}
		HashMap<String, Integer> contentTimesInPage = new HashMap<String, Integer>();
		for (ElementNode elementNode : nodeList) {
			ArrayList<String> contents = elementNode.getContents();
			for (String content : contents) {
				Integer count = contentTimesInPage.get(content);
				if (count == null) {
					contentTimesInPage.put(content, 1);
				} else {
					++count;
					contentTimesInPage.put(content, count);
				}
			}
		}
		double sumHE = 0;
		for (Entry<String, Integer> attEntry : contentTimesInPage.entrySet()) {
			String att = attEntry.getKey();
			for (ElementNode elementNode : nodeList) {
				ArrayList<String> contents = elementNode.getContents();
				double heAtt = 0;
				if (contents.contains(att)) {
					double p = 1 / (double) (attEntry.getValue());
					heAtt = -p * (Math.log(p) / Math.log(m));
				}
				sumHE += heAtt;
			}
		}
		int n = contentTimesInPage.size();//特征数 比如 习近平 李克强就是两个特征
		if (n == 0)
			return 0;
		return (1 - sumHE / n);
	}

	public void printSimpleImportance() {
		for (int i = 0; i < nodeList.size(); i++) {
			nodeList.get(i).printSimpleImportance();
		}
	}

	public void printCompositeImportance() {
		for (int i = 0; i < nodeList.size(); i++) {
			nodeList.get(i).printCompositeImportance();
		}
	}
	
	public void printContentImportance() {
		for (ElementNode node : nodeList) {
			node.printContentImportance();
		}
	}
	private String getInformation() {
		StringBuffer childrenInfo = new StringBuffer();
		for (int i = 0; i < nodeList.size(); i++) {
			childrenInfo.append(nodeList.get(i).getNodeName() + " ");
		}
		return "[elementNodes of StyleNode:] " + " how much elements:"
				+ this.nodeList.size() + " all nodeNames:" + childrenInfo
				+ " how much times in pages:" + count;
	}
	public void printTree(String sep) {
		System.out.println(sep + "[NS] " + nodeList.size());
		for (ElementNode styleNode : nodeList) {
			styleNode.printTree(sep + " ");
		}
	}
	public void printInformation() {
		System.out.println(getInformation());
		for (int i = 0; i < nodeList.size(); i++) {
			nodeList.get(i).printInformation();
		}
	}
	public void printImportance() {
		if (nodeList.size() == 1 && nodeList.get(0).isText()) {
			return;
		}
		System.out.print("# " + count + "[");
		for (int i = 0; i < nodeList.size(); i++) {
			System.out.print(nodeList.get(i).toString() + " ");
		}
		System.out.println("]");

		for (int i = 0; i < nodeList.size(); i++) {
			nodeList.get(i).printImportance();
		}
	}
}