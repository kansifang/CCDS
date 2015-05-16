package tests.w3cNodeTest;

import java.io.InputStream;
import java.util.List;

import junit.framework.TestCase;

public class ParseTest extends TestCase{

	public void testDom() throws Exception{
		InputStream input = this.getClass().getClassLoader().getResourceAsStream("tests/w3cNodeTest/book.xml");//类路径第一个包tests前不要加/
		DomParseService dom = new DomParseService();
		List<Book> books = dom.getBooks(input);
		for(Book book : books){
			System.out.println(book.toString());
		}
	}

}
