package tests.w3cNodeTest;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class DomParseService {

	public List<Book> getBooks(InputStream inputStream) throws Exception {

		List<Book> list = new ArrayList<Book>();

		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

		DocumentBuilder builder = factory.newDocumentBuilder();

		Document document = builder.parse(inputStream);

		Element element = document.getDocumentElement();

		NodeList bookNodes = element.getElementsByTagName("book");

		for (int i = 0; i < bookNodes.getLength(); i++) {

			Element bookElement = (Element) bookNodes.item(i);

			Book book = new Book();

			book.setId(Integer.parseInt(bookElement.getAttribute("id")));
			//获取所有孩子节点，只是第一层节点，不包括孙子节点
			NodeList childNodes = bookElement.getChildNodes();
			// System.out.println("*****"+childNodes.getLength());
			for (int j = 0; j < childNodes.getLength(); j++) {
				Node child=childNodes.item(j);
				System.out.println("*****"+child.getNodeName());
				if (child.getNodeType() == Node.ELEMENT_NODE) {
					if ("name".equals(child.getNodeName())) {
						book.setName(child.getFirstChild().getNodeValue());
					} else if ("price".equals(child.getNodeName())) {
						book.setPrice(Float.parseFloat(child.getFirstChild().getNodeValue()));

					}

				}

			}// end for j

			list.add(book);

		}// end for i

		return list;

	}

}
