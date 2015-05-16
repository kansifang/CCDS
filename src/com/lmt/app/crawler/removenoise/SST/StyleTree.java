package com.lmt.app.crawler.removenoise.SST;

import java.io.File;
import java.io.StringWriter;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.lmt.app.crawler.parser.ParseUtils;
public class StyleTree {
	private ElementNode eletmentRoot;
	public StyleTree() {
		this.eletmentRoot = ElementNode.getInstanceOf();
	}
	public void train(byte[] htmlContent) {
		this.eletmentRoot.trainNode(ParseUtils.parseDocumentNeko(htmlContent));
	}
	public void train(File file) {
		this.eletmentRoot.trainNode(ParseUtils.parseDocumentNeko(file));
	}
	public void train(String dirName) {
		File dir = new File(dirName);
		if (dir.isDirectory()) {
			File[] children = dir.listFiles();
			for (int i = 0; i < children.length; i++) {
				if (children[i].isFile()) {
					train(children[i]);
				}
			}
		}
	}
	public String getText(Node node) {
		StringWriter out = new StringWriter();
		this.eletmentRoot.getContent(node, out);
		return out.toString();
	}
	public void printTree() {
		this.eletmentRoot.printTree("");
	}
}