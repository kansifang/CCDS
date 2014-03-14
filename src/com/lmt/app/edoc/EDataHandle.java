package com.lmt.app.edoc;

import java.text.DecimalFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.xpath.XPath;

import com.lmt.app.cms.explain.ASMethod;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * �����ĵ�ʵ���� ��ǩ������
 * 
 * @author fmwu
 * 
 */
public class EDataHandle {
	/**
	 * �õ�����Document
	 * 
	 * @return
	 * @throws Exception
	 */
	public static Document getData(Document def, Map map, Transaction Sqlca) throws Exception {
		// ��ʼ������ֵ
		String xpath_parm = "/edoc/def/parmlist/parm";
		List list_parm = XPath.selectNodes(def, xpath_parm);
		for (Iterator i = list_parm.iterator(); i.hasNext();) {
			Element el_tag = (Element) i.next();
			String parmName = el_tag.getAttributeValue("name");
			String sDataSrc = el_tag.getAttributeValue("datasrc");
			// ��������ֵ����ȡֵ
			if ("input".equals(sDataSrc)) {
				String sValue = (String) map.get(parmName);
				el_tag.setText(sValue);
			}
		}

		for (Iterator i = list_parm.iterator(); i.hasNext();) {
			Element el_tag = (Element) i.next();
			String sDataSrc = el_tag.getAttributeValue("datasrc");
			String sType = el_tag.getAttributeValue("type");
			String sValue = el_tag.getTextTrim();

			// ����sql����ȡֵ
			if ("sql".equals(sDataSrc)) {
				// sqlȡֵ
				String sSql = el_tag.getAttributeValue("sql");
				// System.out.println("sSql"+sSql);
				sSql = replaceStr(sSql, list_parm);
				// ʵ�ʵ�sqlֵ
				el_tag.setAttribute("sql", sSql);
				sValue = getSqlValue(sSql, Sqlca);
			} else if ("method".equals(sDataSrc)) {
				// ����ȡֵ
				String sClass = el_tag.getAttributeValue("class");
				String sMethod = el_tag.getAttributeValue("method");
				String sArgs = el_tag.getAttributeValue("args");
				sArgs = replaceStr(sArgs, list_parm);
				// ʵ�ʵ�argsֵ
				el_tag.setAttribute("args", sArgs);
				ASMethod method = new ASMethod(sClass, sMethod, Sqlca);
				Any anyValue = method.execute(sArgs);
				sValue = anyValue.toStringValue();
			}

			// �������ݲ�Ϊ��
			if (!"".equals(sValue)) {
				// �������ݽ���ֵת��
				if ("E".equals(sType)) {
					// Сд���
					String fmt = "##,##0.00";
					DecimalFormat numberFormat = new DecimalFormat(fmt);
					sValue = numberFormat.format(Double.parseDouble(sValue));
				} else if ("M".equals(sType)) {
					// ��д���
					sValue = StringFunction.numberToChinese(Double.parseDouble(sValue));
				}
			}
			el_tag.setText(sValue);
		}

		Element el_data = (Element) XPath.selectSingleNode(def, "/edoc/data");
		Element el_parent = el_data.getParentElement();
		el_data.detach();
		el_data = new Element("data");

		// ��ͨ��ǩ����
		String xpath = "/edoc/def/taglist/tag";
		List list = XPath.selectNodes(def, xpath);

		// ȡ�ñ���
		Element el_def = (Element) XPath.selectSingleNode(def, "/edoc/def/taglist");
		String sDefaultTable = el_def.getAttributeValue("table");
		String sDefaultWhere = el_def.getAttributeValue("where");
		sDefaultWhere = replaceStr(sDefaultWhere, list_parm);
		// System.out.println("sWhere=[" + sDefaultWhere + "]");

		Element el_taglist = new Element("taglist");
		el_taglist.setAttribute("remark", "�����б�");
		el_data.addContent(el_taglist);
		// ��ֵ���ݴ���
		for (Iterator i = list.iterator(); i.hasNext();) {
			Element el_tag_def = (Element) i.next();
			// ����Ԫ��
			Element el_tag = (Element) el_tag_def.clone();
			el_taglist.addContent(el_tag);
			String sType = el_tag.getAttributeValue("type");
			String sDataSrc = el_tag.getAttributeValue("datasrc");
			String sValue = "";

			// ��������Դ����ȡֵ
			if ("col".equals(sDataSrc)) {
				// �ֶ�ȡֵ
				String sColumn = el_tag.getAttributeValue("column");
				//ʵ�ʵ�columnֵ
				sColumn = replaceStr(sColumn, list_parm);
				String sTable = el_tag.getAttributeValue("table");
				if (sTable == null || "".equals(sTable))
					sTable = sDefaultTable;
				// ʵ�ʵ�tableֵ
				el_tag.setAttribute("table", sTable);
				String sWhere = el_tag.getAttributeValue("where");
				if (sWhere == null || "".equals(sWhere))
					sWhere = sDefaultWhere;
				else
					sWhere = replaceStr(sWhere, list_parm);
				// ʵ�ʵ�whereֵ
				el_tag.setAttribute("where", sWhere);
				sValue = getColValue(sColumn, sTable, sWhere, Sqlca);
			} else if ("sql".equals(sDataSrc)) {
				// sqlȡֵ
				String sSql = el_tag.getAttributeValue("sql");
				sSql = replaceStr(sSql, list_parm);
				// ʵ�ʵ�sqlֵ
				el_tag.setAttribute("sql", sSql);
				sValue = getSqlValue(sSql, Sqlca);
			} else if ("method".equals(sDataSrc)) {
				// ����ȡֵ
				String sClass = el_tag.getAttributeValue("class");
				String sMethod = el_tag.getAttributeValue("method");
				String sArgs = el_tag.getAttributeValue("args");
				sArgs = replaceStr(sArgs, list_parm);
				// ʵ�ʵ�argsֵ
				el_tag.setAttribute("args", sArgs);
				ASMethod method = new ASMethod(sClass, sMethod, Sqlca);
				Any anyValue = method.execute(sArgs);
				sValue = anyValue.toStringValue();
			}

			// �������ݲ�Ϊ��
			if (!"".equals(sValue)) {
				// �������ݽ���ֵת��
				if ("E".equals(sType)) {
					// Сд���
					String fmt = "##,##0.00";
					DecimalFormat numberFormat = new DecimalFormat(fmt);
					sValue = numberFormat.format(Double.parseDouble(sValue));
				} else if ("M".equals(sType)) {
					// ��д���
					sValue = StringFunction.numberToChinese(Double.parseDouble(sValue));
				}
			}else {
				String sShowNull = el_tag.getAttributeValue("shownull");
				if ("false".equals(sShowNull)) {
					el_tag.setText("");
				}
			}

			// ����ʵ��ֵ
			String sText = el_tag.getTextTrim();
			if ("fix".equals(sDataSrc)) {
				sValue = sText;
			} else {
				// ���粻�ǹ̶�ȡֵ������ֵ
				if (!"".equals(sText)) {
					//�滻�Ա���
					sValue = StringFunction.replace(sText, "#value#", sValue);
				}
			}

			if (!"".equals(sText)) {
				//�滻����
				sValue = replaceStr(sValue, list_parm);
			}

			// ���������Ǵ��룬���ݴ������ȡֵ
			if ("C".equals(sType)) {
				String sId = el_tag.getAttributeValue("id");
				String sName = el_tag.getAttributeValue("name");
				Element tag = getItemTag(sName, sValue, def);
				if (tag != null) {
					el_tag.detach();
					el_tag = (Element) tag.clone();
					el_taglist.addContent(el_tag);
					el_tag.setAttribute("id", sId);
					el_tag.setAttribute("name", sName);
					el_tag.setAttribute("type", sType);
					el_tag.setAttribute("datasrc", sDataSrc);

					//������֧�ֲ���
					sText=el_tag.getTextTrim();
					sText = replaceStr(sText, list_parm);
					el_tag.setText(sText);

					List list_tag_wp = tag.getChildren("wp");
					// �����ڵ�ÿ�����ݴ���
					for (Iterator i_tag_wp = list_tag_wp.iterator(); i_tag_wp.hasNext();) {
						Element tag_wp= (Element) i_tag_wp.next();
						Element el_tag_wp = (Element) tag_wp.clone();
						el_tag.addContent(el_tag_wp);
						sText=el_tag_wp.getTextTrim();
						sText = replaceStr(sText, list_parm);
						el_tag_wp.setText(sText);
					}
				}
			}else {
				//������֧�ֲ���
				String sLength = el_tag.getAttributeValue("length");
				if (sLength != null && !"".equals(sLength)) {
					int iLen = Integer.parseInt(sLength);
					sValue = specifyLengthRightFill(sValue,iLen,"-");
				}
				el_tag.setText(sValue);
			}

			// �ж������Ƿ���ڻس�
			if (sValue.indexOf("\n") != -1) {
				el_tag.setAttribute("existwp", "true");
				el_tag.setText("");
				String[] aStr = sValue.split("\n");
				for (int i1 = 0; i1 < aStr.length; i1++) {
					Element el_tag_wp = new Element("wp");
					el_tag_wp.setText(aStr[i1]);
					el_tag.addContent(el_tag_wp);
				}
			}
		}

		// ����ǩ����
		String xpath_tbl = "/edoc/def/tablelist/table";
		List list_tbl = XPath.selectNodes(def, xpath_tbl);
		// �����
		Element el_tablelist = new Element("tablelist");
		el_tablelist.setAttribute("remark", "����б�");
		el_data.addContent(el_tablelist);

		// ���ѭ��
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_table = (Element) i.next();
			Element el_table_data = new Element("table");
			el_table_data.setAttribute("name", el_table.getAttributeValue("name"));

			el_tablelist.addContent(el_table_data);

			// ��ȡ����
			String sTable = el_table.getAttributeValue("table");
			sTable = replaceStr(sTable, list_parm);
			el_table_data.setAttribute("table", sTable);

			// �滻Where��������
			String sWhere = el_table.getAttributeValue("where");
			sWhere = replaceStr(sWhere, list_parm);
			el_table_data.setAttribute("where", sWhere);

			// ��ȡ�ֶμ���
			String sCols = el_table.getAttributeValue("cols");
			el_table_data.setAttribute("cols", sCols);

			String sSql = "select " + sCols + " from " + sTable + " where " + sWhere;
			// System.out.println("SQL[" + sSql + "]");
			// ��ȡ�����
			ASResultSet rs = Sqlca.getASResultSet(sSql);
			boolean isExsitData = false;
			while (rs.next()) {
				isExsitData = true;
				List list_table_tag = el_table.getChildren();
				Element el_table_datalist = new Element("datalist");
				el_table_data.addContent(el_table_datalist);

				// ÿ�����ݴ���
				for (Iterator i_tag = list_table_tag.iterator(); i_tag.hasNext();) {
					Element el_tag_src = (Element) i_tag.next();
					// ����Ԫ��
					Element el_tag = (Element) el_tag_src.clone();
					el_table_datalist.addContent(el_tag);

					String sType = el_tag.getAttributeValue("type");
					String sDataSrc = el_tag.getAttributeValue("datasrc");
					String sValue = "";

					// ��������Դ����ȡֵ
					if ("col".equals(sDataSrc)) {
						// �ֶ�ȡֵ
						String sColumn = el_tag.getAttributeValue("column");
						//ʵ�ʵ�columnֵ
						sColumn = replaceStr(sColumn, list_parm);
						sValue = rs.getString(sColumn);
						if (sValue==null)
							sValue = "";
					}

					// �������ݲ�Ϊ��
					if (!"".equals(sValue)) {
						// �������ݽ���ֵת��
						if ("E".equals(sType)) {
							// Сд���
							String fmt = "##,##0.00";
							DecimalFormat numberFormat = new DecimalFormat(fmt);
							sValue = numberFormat.format(Double.parseDouble(sValue));
						} else if ("M".equals(sType)) {
							// ��д���
							sValue = StringFunction.numberToChinese(Double.parseDouble(sValue));
						}
					}

					// ����ʵ��ֵ
					String sText = el_tag.getTextTrim();
					if ("fix".equals(sDataSrc)) {
						sValue = sText;
					} else {
						// ���粻�ǹ̶�ȡֵ������ֵ
						if (!"".equals(sText)) {
							sValue = StringFunction.replace(sText, "#value#", sValue);
						}
					}

					// ���������Ǵ��룬���ݴ������ȡֵ
					if ("C".equals(sType)) {
						String sId = el_tag.getAttributeValue("id");
						String sName = el_tag.getAttributeValue("name");
						Element tag = getItemTag(sName, sValue, def);
						if (tag != null) {
							el_tag.detach();
							el_tag = (Element) tag.clone();
							el_table_datalist.addContent(el_tag);
							el_tag.setAttribute("id", sId);
							el_tag.setAttribute("name", sName);
							el_tag.setAttribute("type", sType);
							el_tag.setAttribute("datasrc", sDataSrc);

							// ������֧�ֲ���
							sText=el_tag.getTextTrim();
							sText = replaceStr(sText, list_parm);
							el_tag.setText(sText);

							List list_tag_wp = tag.getChildren("wp");
							// �����ڵ�ÿ�����ݴ���
							for (Iterator i_tag_wp = list_tag_wp.iterator(); i_tag_wp.hasNext();) {
								Element tag_wp= (Element) i_tag_wp.next();
								Element el_tag_wp = (Element) tag_wp.clone();
								el_tag.addContent(el_tag_wp);
								sText=el_tag_wp.getTextTrim();
								sText = replaceStr(sText, list_parm);
								el_tag_wp.setText(sText);
							}
						}
					}else {
						el_tag.setText(sValue);
					}

					// �ж������Ƿ���ڻس�
					if (sValue.indexOf("\n") != -1) {
						el_tag.setAttribute("existwp", "true");
						el_tag.setText("");
						String[] aStr = sValue.split("\n");
						for (int i1 = 0; i1 < aStr.length; i1++) {
							Element el_tag_wp = new Element("wp");
							el_tag_wp.setText(aStr[i1]);
							el_tag.addContent(el_tag_wp);
						}
					}
				}
			}
			if (!isExsitData) {
				List list_table_tag = el_table.getChildren();
				Element el_table_datalist = new Element("datalist");
				el_table_data.addContent(el_table_datalist);

				// ÿ�����ݴ���
				for (Iterator i_tag = list_table_tag.iterator(); i_tag.hasNext();) {
					Element el_tag = (Element) i_tag.next();
					Element el_tag_data = (Element) el_tag.clone();
					el_tag_data.setText("");
					el_table_datalist.addContent(el_tag_data);
				}
			}
		}
		el_parent.addContent(el_data);
		return def;
	}

	/**
	 * ���ݴ����itemno��ȡitemname,������Դ��Document
	 * 
	 * @param codono
	 *            �������ƣ�һ��ָ��ǩ����
	 * @param itemno
	 *            ������
	 * @param data
	 *            ����������Դ�ĵ�
	 * @return ��Ŀ����
	 * 
	 * @throws JDOMException
	 */
	private static Element getItemTag(String codono, String itemno, Document data) throws JDOMException {
		String xpath = "/edoc/code/codelist/code[@codeno='" + codono + "']/codeitem[@itemno='" + itemno + "']/tag";
		Element e = (Element) XPath.selectSingleNode(data, xpath);
		return e;
	}

	/**
	 * ����key��ȡ��ͬĳ���ֶε�ֵ
	 */
	private static String getColValue(String sCol, String sTable, String sWhere, Transaction Sqlca) throws Exception {
		String sSql = "Select " + sCol + " from " + sTable + " where " + sWhere + "";
		return getSqlValue(sSql, Sqlca);
	}

	/**
	 * ��ȡSQL�еĵ�ֵ
	 * @param sSql 
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	private static String getSqlValue(String sSql, Transaction Sqlca) throws Exception {
		// System.out.println("SQL[" + sSql + "]");
		String value = Sqlca.getString(sSql);
		if (value == null)
			value = "";
		return value;
	}

	/**
	 * �Ҳ�λ �ַ�sdata�Ҳ��ַ�sFillchar��ʹsdata�ĳ��ȴﵽlen��
	 */
	private static String specifyLengthRightFill(String sdata, int len, String sFillchar) {
		int j = len - sdata.getBytes().length;
		for (int k = 1; k <= j; k++)
			sdata = sdata + sFillchar;

		if (j < 0)
			sdata = new String(sdata.getBytes(), 0, len);
		return sdata;
	}

	/**
	 * �滻����ֵ
	 */
	private static String replaceStr(String sStr, List list) throws Exception {
		for (Iterator i_tag = list.iterator(); i_tag.hasNext();) {
			Element el_tag = (Element) i_tag.next();
			sStr = StringFunction.replace(sStr, "#" + el_tag.getAttributeValue("name"), el_tag.getTextTrim());
		}
		return sStr;
	}
}
