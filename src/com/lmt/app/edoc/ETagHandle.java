package com.lmt.app.edoc;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.xpath.XPath;

/**
 * �����ĵ�ʵ���� ��ǩ������
 * 
 * @author fmwu
 * 
 */
public class ETagHandle {

	// private static String TAG_REGEX = "\\{\\$([^\\{\\}][^\\}]*)\\}";
	// Ѱ�ұ�ǩ������ʽ
	private static String TAG_REGEX = "\\��\\��([^\\��\\��][^\\��\\��]*)\\��\\��";

	//private static String IMAGE_REGEX = "\\��\\��\\��([^\\��\\��][^\\��\\��]*)\\��\\��\\��";

	/**
	 * ��ȡElement����Ϊname�ĵ�һ����Element
	 * 
	 * @param element
	 * @param name
	 * @return ���������ĸ�Element
	 * @throws JDOMException
	 * @throws IOException
	 */
	private static Element getFirstParent(Element element, String name) throws JDOMException, IOException {
		Element parent = element;
		while (parent != null) {
			if (parent.getQualifiedName().equalsIgnoreCase(name)) {
				return parent;
			}
			// System.out.println("node.name:" + parent.getQualifiedName());
			parent = parent.getParentElement();
		}
		return parent;
	}

	/**
	 * ��ȡ�ַ����еı�ǩ���֣���ǩ��ʽ����TAG���� ��������ڱ�ǩ���򷵻ؿ�ֵ�����򷵻ر�ǩ����
	 * 
	 * @param str
	 * @return ��ǩ����
	 */
	private static String getTag(String str) {
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(str);
		String sTag = null;
		if (m.find()) {
			sTag = m.group(1);
		}
		return sTag;
	}

	/**
	 * �ж��ַ����е��Ƿ��б�ǩ����ǩ��ʽ����TAG���� ������ڱ�ǩ����true,�����򷵻�false
	 * 
	 * @param str
	 * @return ��ǩ����
	 */
	private static boolean isExistTag(String str) {
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(str);
		return m.find();
	}

	/**
	 * �ж��ַ����е��Ƿ����ض���ǩ����ǩ��ʽ����TAG���� ������ڱ�ǩ����true,�����򷵻�false
	 * 
	 * @param str
	 * @return ��ǩ����
	 */
	private static boolean isExistTag(String str, String tagName) {
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(str);
		String sTag = null;
		if (m.find()) {
			sTag = m.group(1);
		}
		if (tagName != null)
			return tagName.equals(sTag);
		else
			return false;
	}

	/**
	 * �������ĵ���ʽ����͵����ĵ����ݶ����ǩ���
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String checkTag(Document doc, Document data) throws JDOMException, IOException {
		// ���е��ı����򣬶�Ӧ�������еĶ����ǩ
		String xpath_wt = "/w:wordDocument/w:body/wx:sect//w:p/w:r/w:t";
		// ����е��ı����򣬶�Ӧ���ڱ���еı�ǩ
		String xpath_tbl_wt = "/w:wordDocument/w:body/wx:sect//w:tbl/w:tr//w:t";
		List list_wt = XPath.selectNodes(doc, xpath_wt);
		List list_tbl_wt = XPath.selectNodes(doc, xpath_tbl_wt);
		// �޳�����е��ı���Ԫ
		list_wt.removeAll(list_tbl_wt);

		boolean passFlag = true;
		StringBuffer sb = new StringBuffer("");
		sb.append("<taglist tabname=\"\" remark=\"��ֵ��ǩ\">\n");

		// ���б�ǩѭ��
		for (Iterator i = list_wt.iterator(); i.hasNext();) {
			Element el = (Element) i.next();
			String sTag = getTag(el.getTextTrim());
			if (sTag != null) {
				Element el_data = (Element) XPath.selectSingleNode(data, "/edoc/def/taglist/tag[@name='" + sTag + "']");
				if (el_data == null) {
					passFlag = false;
					sb.append("    ");
					sb.append("<tag name=" + sTag + "> �����ڣ�������>\n");
				}
			}
		}
		if (passFlag) {
			sb.append("    ");
			sb.append("<sucess>��ֵ��ǩ����ͨ�����ĵ�ģ�������б�ǩ�������ݶ��壡</>\n");
		}
		sb.append("</taglist>\n");

		// �������б���ǩ
		String xpath_tbl = "/w:wordDocument/w:body/wx:sect//w:tbl";
		List list_tbl = XPath.selectNodes(doc, xpath_tbl);

		int iTable = 0;
		passFlag = true;
		sb.append("<tablelist remark=\"����ǩ\">\n");
		// ���б��ѭ��������������Ƿ��б�ǩ�ֶ�
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_tbl = (Element) i.next();
			iTable++;
			List list2 = XPath.selectNodes(el_tbl, "//w:tbl[" + iTable + "]/w:tr//w:t");
			sb.append("    ");
			sb.append("<table id=\"" + iTable + "\" tabname=\"\"\n");
			for (Iterator i1 = list2.iterator(); i1.hasNext();) {
				Element el = (Element) i1.next();
				String sTag = getTag(el.getTextTrim());
				if (sTag != null) {
					Element el_data = (Element) XPath.selectSingleNode(data, "/edoc/def/tablelist/table/tag[@name='" + sTag + "']");
					if (el_data == null) {
						sb.append("    ");
						sb.append("<tag name=" + sTag + "> �����ڣ�������</>\n");
					}
				}
			}
			if (passFlag) {
				sb.append("    ");
				sb.append("    ");
				sb.append("<sucess>����б�ǩ����ͨ�����ĵ�ģ�������б���ǩ�������ݶ��壡</>\n");
			}
			sb.append("    ");
			sb.append("</table>\n");
		}
		sb.append("</tablelist>\n");
		return sb.toString();
	}

	/**
	 * ��ȡ�����ĵ���ʽ����ı�ǩ�б�
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String getTagList(Document doc) throws JDOMException, IOException {
		// ���е��ı����򣬶�Ӧ�������еĶ����ǩ
		String xpath_wt = "/w:wordDocument/w:body/wx:sect//w:p/w:r/w:t";
		// ����е��ı����򣬶�Ӧ���ڱ���еı�ǩ
		String xpath_tbl_wt = "/w:wordDocument/w:body/wx:sect//w:tbl/w:tr//w:t";
		List list_wt = XPath.selectNodes(doc, xpath_wt);
		List list_tbl_wt = XPath.selectNodes(doc, xpath_tbl_wt);
		// �޳�����е��ı���Ԫ
		list_wt.removeAll(list_tbl_wt);

		StringBuffer sb = new StringBuffer("");
		int iCount = 0;
		sb.append("<taglist remark=\"��ֵ��ǩ�б�\" table=\"\" where=\"\">\n");

		// ���б�ǩѭ��
		for (Iterator i = list_wt.iterator(); i.hasNext();) {
			Element el = (Element) i.next();
			String sTag = getTag(el.getTextTrim());
			if (sTag != null) {
				iCount++;
				sb.append("    ");
				sb.append("<tag");
				sb.append(" id=\"" + iCount + "\"");
				sb.append(" name=\"" + sTag + "\"");
				sb.append(" type=\"S\"");
				sb.append(" datasrc=\"\"");
				sb.append(" column=\"\"");
				sb.append(">");
				sb.append("</tag>\n");
			}
		}
		sb.append("</taglist>\n");

		// �������б���ǩ
		String xpath_tbl = "/w:wordDocument/w:body/wx:sect//w:tbl";
		List list_tbl = XPath.selectNodes(doc, xpath_tbl);

		int iTable = 0;
		sb.append("<tablelist remark=\"����ǩ\">\n");
		// ���б��ѭ��������������Ƿ��б�ǩ�ֶ�
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_tbl = (Element) i.next();
			iTable++;
			iCount = 0;
			List list2 = XPath.selectNodes(el_tbl, "//w:tbl[" + iTable + "]/w:tr//w:t");
			sb.append("    ");
			sb.append("<table id=\"" + iTable + "\" name=\"�������\" tabname=\"\" cols=\"\" where=\"\">\n");
			for (Iterator i1 = list2.iterator(); i1.hasNext();) {
				Element el = (Element) i1.next();
				String sTag = getTag(el.getTextTrim());
				if (sTag != null) {
					iCount++;
					sb.append("    ");
					sb.append("    ");
					sb.append("<tag");
					sb.append(" id=\"" + (iTable * 100 + iCount) + "\"");
					sb.append(" name=\"" + sTag + "\"");
					sb.append(" type=\"S\"");
					sb.append(" datasrc=\"col\"");
					sb.append(" column=\"\"");
					sb.append(">");
					sb.append("</tag>\n");
				}
			}
			sb.append("    ");
			sb.append("</table>\n");
		}
		sb.append("</tablelist>\n");
		return sb.toString();
	}

	/**
	 * ��ȡ�����ĵ����ݶ���ı�ǩ�б�
	 * 
	 * @param def
	 *            �����ĵ����ݶ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String getDefTagList(Document def) throws JDOMException, IOException {
		StringBuffer sb = new StringBuffer("");
		// ��ͨ��ǩ����
		String xpath = "/edoc/def/taglist/tag";
		// ����ǩ����
		String xpath_tbl = "/edoc/def/tablelist/table";
		List list = XPath.selectNodes(def, xpath);
		List list_tbl = XPath.selectNodes(def, xpath_tbl);

		sb.append("<taglist table=\"\">\n");
		for (Iterator i = list.iterator(); i.hasNext();) {
			Element el_tag = (Element) i.next();
			sb.append("    ");
			sb.append("<tag");
			sb.append(" name=\"" + el_tag.getAttributeValue("name") + "\"");
			sb.append(" type=\"" + el_tag.getAttributeValue("type") + "\"");
			sb.append(" col=\"" + el_tag.getAttributeValue("col") + "\"");
			sb.append(">");
			sb.append(el_tag.getValue());
			sb.append("</tag>\n");
		}
		sb.append("<taglist>\n");

		sb.append("<tablelist>\n");
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_table = (Element) i.next();
			sb.append("    ");
			sb.append("<table");
			sb.append(" name=\"" + el_table.getAttributeValue("name") + "\"");
			sb.append(">");
			sb.append("\n");

			List list_table_tag = el_table.getChildren();
			for (Iterator i_tag = list_table_tag.iterator(); i_tag.hasNext();) {
				Element el_tag = (Element) i_tag.next();
				sb.append("    ");
				sb.append("    ");
				sb.append("<tag");
				sb.append(" name=\"" + el_tag.getAttributeValue("name") + "\"");
				sb.append(" type=\"" + el_tag.getAttributeValue("type") + "\"");
				sb.append(">");
				sb.append("</tag>\n");
			}
			sb.append("    ");
			sb.append("</table>\n");
		}
		sb.append("</tablelist>\n");
		return sb.toString();
	}

	/**
	 * ��data���ݶ����滻�ĵ������еĵ�ֵ��ǩ(���������е�����)
	 * 
	 * @param doc
	 *            �ĵ�����
	 * @param data
	 *            ���ݶ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceSimpleTag(Document doc, Document data) throws JDOMException, IOException {
		// ��ֵw:t�ı���ǩ
		String xpath_doc_wt = "/w:wordDocument/w:body/wx:sect//w:p/w:r/w:t";
		// �����w:t�ı���ǩ
		String xpath_doc_tbl_wt = "/w:wordDocument/w:body/wx:sect//w:tbl/w:tr//w:t";

		List list_doc = XPath.selectNodes(doc, xpath_doc_wt);
		List list_doc_temp = XPath.selectNodes(doc, xpath_doc_wt);

		// �޳�����е�w:t�ı�����
		list_doc.removeAll(XPath.selectNodes(doc, xpath_doc_tbl_wt));
		list_doc_temp.removeAll(XPath.selectNodes(doc, xpath_doc_tbl_wt));

		// �޳������ڱ�ǩ��w:t�ı�����
		for (Iterator i = list_doc_temp.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			if (!isExistTag(el_wt.getTextTrim())) {
				list_doc.remove(el_wt);
			}
		}

		// ��ֵ����
		String xpath_data = "/edoc/data/taglist/tag";
		// �����ֵ����ѭ������
		List list_data = XPath.selectNodes(data, xpath_data);
		replaceGroupTag(list_doc, list_data, data);
	}
	/**
	 * ��data���ݶ����滻�ĵ������еĵ�ֵ��ǩ(���������е�����)
	 * 
	 * @param doc
	 *            �ĵ�����
	 * @param data
	 *            ���ݶ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	/*
	static void replaceImageTag(Document doc, Document data) throws JDOMException, IOException {
		// ��ֵw:t�ı���ǩ
		String xpath_doc_wt = "/w:wordDocument/w:body/wx:sect//w:p/w:r/w:pict/w:binData";//�����"//"��ʾ����
		// �����w:t�ı���ǩ
		String xpath_doc_tbl_wt = "/w:wordDocument/w:body/wx:sect//w:tbl/w:tr//w:t";

		List list_doc = XPath.selectNodes(doc, xpath_doc_wt);
		List list_doc_temp = XPath.selectNodes(doc, xpath_doc_wt);

		// �޳�����е�w:t�ı�����
		list_doc.removeAll(XPath.selectNodes(doc, xpath_doc_tbl_wt));
		list_doc_temp.removeAll(XPath.selectNodes(doc, xpath_doc_tbl_wt));

		// �޳������ڱ�ǩ��w:t�ı�����
		for (Iterator i = list_doc_temp.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			if (!isExistTag(el_wt.getTextTrim())) {
				list_doc.remove(el_wt);
			}
		}
		// ��ֵ����
		String xpath_data = "/edoc/data/taglist/tag";
		// �����ֵ����ѭ������
		List list_data = XPath.selectNodes(data, xpath_data);
		replaceGroupTag(list_doc, list_data, data);
	}
	*/
	/**
	 * ����һ�������滻һ���ǩ
	 * 
	 * @param list_doc
	 *            ���滻�ı�ǩ
	 * @param list_data
	 *            ���滻������
	 * @param data
	 *            �ĵ����ݣ��������������
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceGroupTag(List list_doc, List list_data, Document data) throws JDOMException, IOException {
		int pictindex=0;
		// �����ݽ���ѭ������
		for (Iterator i = list_data.iterator(); i.hasNext();) {
			Element el_data = (Element) i.next();
			String tagName = el_data.getAttributeValue("name");
			String value = el_data.getText();
			String isExistwp = el_data.getAttributeValue("existwp");
			// �������ݽ��������ǩ�ı�����
			for (Iterator i1 = list_doc.iterator(); i1.hasNext();) {
				Element el_wt = (Element) i1.next();
				String text = el_wt.getTextTrim();
				// �����Ǹñ�ǩ������д���
				if (isExistTag(text, tagName)) {
					//�����ͼ�α��
					if(tagName.contains("ͼ")){//����ͼ����״ͼ ����ͼ�ȣ�Ҫ����<w:pict><w:bindData></w:bindData></w:pict>
						Element el_wr = getFirstParent(el_wt, "w:r");//<w:r><w:t>����AA����</w:t></w:r>
						el_wt.detach();//�����Ԫ�ظ�Ԫ���������������
						Namespace nsw=Namespace.getNamespace("w", "http://schemas.microsoft.com/office/word/2003/wordml");
						Element el_wp=new Element("pict",nsw);
						//������������Ԫ��
						Element el_wbd=new Element("binData",nsw);
						el_wbd.setAttribute("name","wordml://0300000"+(++pictindex)+".png",nsw);
						el_wbd.setAttribute("space","preserve");
						el_wbd.setText(value);
						el_wp.addContent(el_wbd);
						Namespace nsv=Namespace.getNamespace("v", "urn:schemas-microsoft-com:vml");
						Namespace nso=Namespace.getNamespace("o", "urn:schemas-microsoft-com:office:office");
						Element el_vs=new Element("shape",nsv);
						el_vs.setAttribute("id",""+tagName);
						el_vs.setAttribute("spid","_x0000_i1028",nso);
						el_vs.setAttribute("type","_x0000_t75");
						el_vs.setAttribute("style","width:6in;height:247.75pt;visibility:visible;mso-wrap-style:square");
						Element el_vi=new Element("imagedata",nsv);
						el_vi.setAttribute("src","wordml://0300000"+pictindex+".png");
						el_vi.setAttribute("title","",nso);
						el_vs.addContent(el_vi);
						
						el_wp.addContent(el_vs);
						
						el_wr.addContent(el_wp);
						continue;
					}
					// ���������Ƕ���  ��Ŀǰ��û�������������---�߼���:���ڱ�Ǩ A���ж������ݣ���������ĵ��� ���Ӷ���p:r:t,���ɶ�������
					if ("true".equals(isExistwp)) {
						// �õ��ж���
						// System.out.println("replaceGroupTag:����["+text+"]["+tagName+"]");
						Element el_wp = getFirstParent(el_wt, "w:p");
						// ��ȡ��ǰ����ĸ�����
						Element parent = el_wp.getParentElement();//����������w:p���Ǹ�Ԫ�ؽڵ�
						int iPos = parent.indexOf(el_wp);
						// ������ԭʼ���б�ǩ����
						Element el_wp_copy = (Element) el_wp.clone();
						el_wp.detach();
						List list_wp = el_data.getChildren("wp");//��ȡ�����ĵ��� ��� wp
						for (Iterator i2 = list_wp.iterator(); i2.hasNext();) {
							// �����ж���
							el_wp = (Element) el_wp_copy.clone();
							// �������
							parent.addContent(iPos++, el_wp);
							// �����ж���
							Element el_wp_data = (Element) i2.next();
							String wp_value = el_wp_data.getText();
							replaceElementWp(el_wp, tagName, wp_value);
						}
					} else {
						el_wt.setText(relpaceTag(text, tagName, value));
					}
				}
			}
		}
	}

	/**
	 * ����TagNme�����ݶ����滻�ĵ���(w:p)�����е��ı�(w:t)��ǩ����ֵ�滻
	 * 
	 * @param el_wp
	 *            �ĵ��ж���
	 * @param tagName
	 *            ��ǩ����
	 * @param value
	 *            �滻ֵ
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceElementWp(Element el_wp, String tagName, String value) throws JDOMException, IOException {
		List list_wt = XPath.selectNodes(el_wp, "//w:p/w:r/w:t");
		for (Iterator i = list_wt.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			String text = el_wt.getTextTrim();
			if (isExistTag(text, tagName)) {
				el_wt.setText(relpaceTag(text, tagName, value));
			}
		}
	}

	/**
	 * ��data���ݶ����滻�ĵ������еı���ǩ(��ֵ)
	 * 
	 * @param doc
	 *            �ĵ�����
	 * @param data
	 *            ���ݶ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceTableTag(Document doc, Document data) throws JDOMException, IOException {
		String xpath_doc = "/w:wordDocument/w:body/wx:sect//w:tbl/w:tr//w:t";

		List list_doc = XPath.selectNodes(doc, xpath_doc);
		List list_doc_temp = XPath.selectNodes(doc, xpath_doc);

		// �޳������ڱ�ǩ��w:t�ı�����
		for (Iterator i = list_doc_temp.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			if (!isExistTag(el_wt.getTextTrim())) {
				list_doc.remove(el_wt);
			}
		}

		String xpath_data = "/edoc/data/tablelist/table";
		List list_data_tbl = XPath.selectNodes(data, xpath_data);

		// ���ѭ��[����]
		for (Iterator i = list_data_tbl.iterator(); i.hasNext();) {
			Element el_tbl_data = (Element) i.next();
			// �õ����������
			List list_datalist = el_tbl_data.getChildren("datalist");
			// ��ȡ�������
			String tblName = el_tbl_data.getAttributeValue("name");
			// �õ�������еĵ�һ��Tag[����]
			String xpath = "/edoc/data/tablelist/table[@name='" + tblName + "']/datalist/tag";
			Element el_data_tag = (Element) XPath.selectSingleNode(data, xpath);
			String tagName = el_data_tag.getAttributeValue("name");
			// System.out.println("replaceTableTag��[" + tblName + "] First Tag["
			// + tagName + "] Size[" + list_datalist.size() + "]");

			// ����Tag���ֻ�ȡ�ĵ���Tag��ǩ
			Element el_doc_tag = null;
			for (Iterator i1 = list_doc.iterator(); i1.hasNext();) {
				Element el_wt = (Element) i1.next();
				// ����Tag���ֲ����ĵ���Tag��ǩ
				if (isExistTag(el_wt.getTextTrim(), tagName)) {
					el_doc_tag = el_wt;
					break;
				}
			}

			// �ĵ��ж���
			Element el_doc_tr = null;
			// �������ĵ����Ҳ�����Ӧ�ı�ǩ���������һ������滻
			if (el_doc_tag == null)
				continue;
			else {
				// �õ��ĵ����ж���
				el_doc_tr = getFirstParent(el_doc_tag, "w:tr");
			}

			// ��ȡ�ĵ��ж���ĸ�����
			Element el_doc_tr_parent = el_doc_tr.getParentElement();
			int iPos = el_doc_tr_parent.indexOf(el_doc_tr);
			// ������ԭʼ���б�ǩ����
			Element el_doc_tr_copy = (Element) el_doc_tr.clone();
			el_doc_tr.detach();

			// ���ݱ����ѭ��
			for (Iterator i1 = list_datalist.iterator(); i1.hasNext();) {
				// ���Ʊ��ж���
				el_doc_tr = (Element) el_doc_tr_copy.clone();
				// �������ж���
				el_doc_tr_parent.addContent(iPos++, el_doc_tr);

				// ��ȡ���������
				Element el_data_tr = (Element) i1.next();
				List list_data_tr = el_data_tr.getChildren("tag");
				List list_doc_tr = XPath.selectNodes(el_doc_tr, "//w:tr//w:t");
				replaceGroupTag(list_doc_tr, list_data_tr, data);
			}
		}
	}

	/**
	 * ���ַ����кͱ�ǩ���ֶ�Ӧ�ı�ǩ�滻Ϊ��Ӧֵ
	 * 
	 * @param src
	 *            ԭʼ��
	 * @param tagName
	 *            ��ǩ����
	 * @param value
	 *            ��ǩ�滻ֵ
	 * @return �滻����ַ���
	 */
	private static String relpaceTag(String src, String tagName, String value) {
		StringBuffer sb = new StringBuffer();
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(src);
		while (m.find()) {
			String v = m.group(1);
			if (value != null && tagName.equals(v)) {
				m.appendReplacement(sb, value);
			}
		}
		m.appendTail(sb);
		return sb.toString();
	}
}
