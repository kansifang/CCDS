package com.lmt.baseapp.util;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.frameapp.sql.Transaction;

public class StringUtils
{
  public static String replace(String s, String s1, String s2)
  {
    for (int i = s.indexOf(s1, 0); i != -1; i = s.indexOf(s1, i + s2.length()))
    {
      s = s.substring(0, i) + s2 + s.substring(i + s1.length());
    }
    return s;
  }

  public static String getSeparate(String s, String s1, int i) {
    int k = 0;
    int l = 0;
    s = s + s1;
    int j;
    while ((j = s.indexOf(s1, k)) >= 0) {
      l++; if (l == i) {
        return s.substring(k, j).trim();
      }
      k = j + 1;
    }
    return "";
  }

  public static int getSeparateSum(String s, String s1) {
    int i = 0;
    int j=0;
    for (; (i = s.indexOf(s1, i) + 1) > 0; j++);
    return j + 1;
  }

  public static String[] toStringArray(String s, String s1)
  {
    String[] as = null;
    int i = getSeparateSum(s, s1);
    if (i > 0) {
      as = new String[i];
      for (int j = 1; j <= i; j++) {
        as[(j - 1)] = getSeparate(s, s1, j);
      }
    }

    return as;
  }

  public static int[] parseStrArray2Int(String[] s)
  {
    int i = s.length;
    int[] i1 = new int[i];
    for (int j = 0; j < i; j++) {
      if ((s[j] == null) || (s[j].length() == 0))
        i1[j] = 0;
      else {
        i1[j] = Integer.parseInt(s[j]);
      }
    }
    return i1;
  }

  public static String[] parseIntArray2Str(int[] is)
  {
    String[] as = new String[is.length];
    for (int i = 0; i < is.length; i++) {
      as[i] = String.valueOf(is[i]);
    }
    return as;
  }

  public static int getMaxFromIntArray(int[] ai)
  {
    int i = 0;
    for (int j = 0; j < ai.length; j++) {
      if (i < ai[j]) {
        i = ai[j];
      }
    }
    return i;
  }

  public static String getStringValue(String s, String s1, String s2, int chartset) {
    if ((s == null) || (s.length() == 0)) {
      return s2.trim();
    }
    return convertCodeset(s1.trim(), chartset);
  }

  public static String getStringValue(String s, String s1, String s2)
  {
    return getStringValue(s, s1, s2, -1);
  }

  public static String getStringValue(String s, String s2, int chartset) {
    return getStringValue(s, s, s2, chartset);
  }

  public static String getStringValue(String s, String s2)
  {
    return getStringValue(s, s2, -1);
  }

  public static String parseExcelColIndex(String sIndex)
  {
    return parseExcelColIndex(Integer.parseInt(sIndex));
  }
  //��Excel�������ת��Ϊ��ĸ��ʾ 1ΪA....
  public static String parseExcelColIndex(int iIndex)
  {
    String sExcelCol = "";
    if (iIndex > 0) {
      String[][] sCharacter = { { "1", "a" }, { "2", "b" }, { "3", "c" }, { "4", "d" }, { "5", "e" }, { "6", "f" }, { "7", "g" }, { "8", "h" }, { "9", "i" }, { "10", "j" }, { "11", "k" }, { "12", "l" }, { "13", "m" }, { "14", "n" }, { "15", "o" }, { "16", "p" }, { "17", "q" }, { "18", "r" }, { "19", "s" }, { "20", "t" }, { "21", "u" }, { "22", "v" }, { "23", "w" }, { "24", "x" }, { "25", "y" }, { "26", "z" } };

      if (iIndex > 26) {
        sExcelCol = sCharacter[(iIndex / 26 - 1)][1] + sCharacter[(iIndex % 26 - 1)][1];
      }
      else {
        sExcelCol = sCharacter[(iIndex - 1)][1];
      }
    }
    return sExcelCol;
  }
  private static String[]getToReplace(String s,String sStart,String sEnd){
	  	int ss=s.indexOf(sStart);
		int se=s.indexOf(sEnd);
		String toReplaceS="";
		//toReplaceS���ǻ�ȡ ~sXXXX@xxxe~ configContent��XXXX@xxx
		if(se+sEnd.length()>s.length()){
			toReplaceS=s.substring(ss,s.length());
		}else{
			try{
				toReplaceS=s.substring(ss, se+sEnd.length());
			}catch(Exception e){
				System.out.println(s);
				System.out.println("ss="+ss+"&&se="+se+"&&sEnd="+sEnd);
			}
		}
		String configContent=s.substring(ss+sStart.length(), se);
		return new String[]{configContent,toReplaceS};
  }
  public static String getOrgName(String sOrgID, Connection conn, String version) throws Exception{
    String sSql = "";
    if (version.equalsIgnoreCase("2005")) {
      sSql = "select OrgName from Org_INFO where SortNo = '" + sOrgID.trim() + "'";
    }
    else {
      sSql = "SELECT OrgName FROM ORG_INFO WHERE OrgID = '" + sOrgID.trim() + "'";
    }

    ResultSet rs = conn.createStatement().executeQuery(sSql);
    String sOrgName = "";
    if (rs.next()) {
      sOrgName = rs.getString("OrgName");
    }
    rs.getStatement().close();
    return sOrgName;
  }

  public static String convertCodeset(String s, int i){
    if (s == null) {
      return s;
    }
    String s1 = s;
    try {
      switch (i) {
      case 2:
        s1 = new String(s.getBytes("ISO8859-1"), "gb2312");
        break;
      case 0:
        s1 = new String(s.getBytes("GBK"), "ISO8859-1");
        break;
      case 1:
        s1 = new String(s.getBytes("ISO8859-1"), "GBK");
        break;
      default:
        s1 = s;
      }
    }
    catch (UnsupportedEncodingException e) {
      return s1;
    }
    return s1;
  }
  //��s����sStart��ʼsEnd��β���ַ����������ñ��� ItemDescribe�����������ݿ��ֶΣ�����
  public static String replaceWithConfig(String s,Transaction Sqlca) throws Exception
  {
    while(s.indexOf("~s")!=-1&&s.indexOf("e~")!=-1){
		String[]cc=getToReplace(s,"~s","e~");
		String[] configContentA=cc[0].split("@");
		String sConfig="select ItemDescribe from Code_Library CL "+
						"where Attribute1='"+configContentA[1].trim()+"' "+
						"and IsInUse='1' "+
						"and (CL.CodeNo='"+configContentA[0]+"' or "+
							"exists(select 1 from Code_Catalog CC "+
								"where CC.CodeNo=CL.CodeNo "+
								"and CC.CodeName='"+configContentA[0].trim()+"')"+
							")";
		String sReplaceS=Sqlca.getString(sConfig);
		s =StringFunction.replace(s, cc[1], sReplaceS);
	};
    return s;
  }
  //��s����#last1year��#last2year..�ȸ���date��������ĩ��������ĩ..���ַ����滻������������ĩ��������ĩ
  public static String replaceWithRealDate(String s,String date) throws Exception{
	while(s.indexOf("#last")!=-1&&s.indexOf("yearend")!=-1){//�����������ռλ��ʱ��Խϸ�µ�ռλ��Խ���滻�����Է�ǰ��
    	String[]cc=getToReplace(s,"#last","yearend");
		int i=Integer.valueOf(cc[0]);
		String sRealDate=StringFunction.getRelativeAccountMonth(date.substring(0, 4)+"/12","year",-i);
		s =StringFunction.replace(s, cc[1], sRealDate);
	};
    while(s.indexOf("#last")!=-1&&s.indexOf("year")!=-1){
    	String[]cc=getToReplace(s,"#last","year");
		int i=Integer.valueOf(cc[0]);
		String sRealDate=StringFunction.getRelativeAccountMonth(date,"year",-i);
		s =StringFunction.replace(s, cc[1], sRealDate);
	};
	
	while(s.indexOf("#last")!=-1&&s.indexOf("month")!=-1){
    	String[]cc=getToReplace(s,"#last","month");
		int i=Integer.valueOf(cc[0]);
		String sRealDate=StringFunction.getRelativeAccountMonth(date,"month",-i);
		s =StringFunction.replace(s, cc[1], sRealDate);
	};
    return s;
  }
  /**
   * groupBy="QZ'A'QZ" +//ǰ���ǰ׺ A
 				"complementstring(trim(replace(" +
 					"case when ~s������ϸ@��֤�����(%)e~>=1 then char(~s������ϸ@��֤�����(%)e~)" +
 					"else '0'||char(~s������ϸ@��֤�����(%)e~) end" +
 					",'.000000','%')),'0',4,'Before')" +//////////0��ʾ������ǰ�油0 4��ʾ�����ַ��ĳ���
 				"LJF" +//��ʾ���ֶ�֮������ӷ� ��Sql�� group by �д���Ϊ, select�д���Ϊ@ 
 				"QZNumber:0:4:BeforeQZQZ'A'QZ~s������ϸ@��Ҫ������ʽe~";//
   * @param groupBy
   * @return
   * @throws Exception
   */
  public static String[] replaceWithRealSql(String groupBy) throws Exception{
	  String groupbyClause="",groupbyColumn="";
	  //����group by �еķ����ֶ�
	  groupbyClause=groupBy.replaceAll("LJF~",",").replaceAll("LJF@",",").replaceAll("QZ(.+?)QZ","");
	  groupbyClause=("".equals(groupbyClause)?"":","+groupbyClause);
	  //����select�еķ����ֶ�
	  groupbyColumn=groupBy;
	  StringBuffer sb=new StringBuffer("");
	  Pattern pattern=Pattern.compile("QZ(.+?)QZ",Pattern.CASE_INSENSITIVE);//�÷�̰��ģʽ
	  Matcher matcher=pattern.matcher(groupBy);
	  while(matcher.find()){
		String QZContent=matcher.group(1);
		if(QZContent.startsWith("Number")){
			String []gsa=QZContent.split(":");
			//��ȡ���� XXXLJFQZNumber:0:1:BeforeQZXXXXX �� QZNumber:0:1:BeforeQZ֮ǰ�� XXX
			//ע�������start(0)��ƥ���QZ������QZ��һ��Q��λ��
			String groupBypart=groupBy.substring(0,matcher.start(0)).replaceAll("QZ(.+?)QZ","").replaceAll("LJF~",",").replaceAll("LJF@",",");
			if(groupBypart.length()>0){
				groupBypart="partition by "+groupBypart.substring(0,groupBypart.lastIndexOf(","));
			}
			QZContent="complementstring(trim(char(row_number()over("+groupBypart+"))),'"+gsa[1]+"',"+gsa[2]+",'"+gsa[3]+"')";
		}
		matcher.appendReplacement(sb,QZContent+"||");//��ƥ�䵽������replaceΪʲô
	  }
	  matcher.appendTail(sb);
	  if(!"".equals(sb.toString())){
		groupbyColumn=sb.toString();
	  }
	  groupbyColumn=groupbyColumn.replaceAll("LJF~","||'~'||");//�����ֶ�֮������ӷ�����ѯֵ��������~����---~�����м�
	  groupbyColumn=groupbyColumn.replaceAll("LJF@","||'@'||");//�����ֶ�֮������ӷ�����ѯֵ��������@����---@����С��
	  groupbyColumn=("".equals(groupbyColumn)?"":groupbyColumn+",");
	  return new String[]{groupbyColumn,groupbyClause};
  }
}