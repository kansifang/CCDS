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
  //把Excel中列序号转化为字母表示 1为A....
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
		//toReplaceS就是获取 ~sXXXX@xxxe~ configContent是XXXX@xxx
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
  //把s中以sStart开始sEnd结尾的字符串，用配置表中 ItemDescribe（真正的数据库字段）代替
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
  //把s中以#last1year，#last2year..等根据date计算上年末，上两年末..的字符串替换成真正的上年末，上两年末
  public static String replaceWithRealDate(String s,String date) throws Exception{
	while(s.indexOf("#last")!=-1&&s.indexOf("yearend")!=-1){//当包括下面的占位符时，越细致的占位符越先替换，所以放前面
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
   * groupBy="QZ'A'QZ" +//前面加前缀 A
 				"complementstring(trim(replace(" +
 					"case when ~s表外明细@保证金比例(%)e~>=1 then char(~s表外明细@保证金比例(%)e~)" +
 					"else '0'||char(~s表外明细@保证金比例(%)e~) end" +
 					",'.000000','%')),'0',4,'Before')" +//////////0表示在内容前面补0 4表示整个字符的长度
 				"LJF" +//表示各字段之间的连接符 在Sql中 group by 中处理为, select中处理为@ 
 				"QZNumber:0:4:BeforeQZQZ'A'QZ~s表外明细@主要担保方式e~";//
   * @param groupBy
   * @return
   * @throws Exception
   */
  public static String[] replaceWithRealSql(String groupBy) throws Exception{
	  String groupbyClause="",groupbyColumn="";
	  //修理group by 中的分组字段
	  groupbyClause=groupBy.replaceAll("LJF~",",").replaceAll("LJF@",",").replaceAll("QZ(.+?)QZ","");
	  groupbyClause=("".equals(groupbyClause)?"":","+groupbyClause);
	  //修理select中的分组字段
	  groupbyColumn=groupBy;
	  StringBuffer sb=new StringBuffer("");
	  Pattern pattern=Pattern.compile("QZ(.+?)QZ",Pattern.CASE_INSENSITIVE);//用非贪婪模式
	  Matcher matcher=pattern.matcher(groupBy);
	  while(matcher.find()){
		String QZContent=matcher.group(1);
		if(QZContent.startsWith("Number")){
			String []gsa=QZContent.split(":");
			//获取形如 XXXLJFQZNumber:0:1:BeforeQZXXXXX 中 QZNumber:0:1:BeforeQZ之前的 XXX
			//注意下面的start(0)是匹配的QZ。。。QZ第一个Q的位置
			String groupBypart=groupBy.substring(0,matcher.start(0)).replaceAll("QZ(.+?)QZ","").replaceAll("LJF~",",").replaceAll("LJF@",",");
			if(groupBypart.length()>0){
				groupBypart="partition by "+groupBypart.substring(0,groupBypart.lastIndexOf(","));
			}
			QZContent="complementstring(trim(char(row_number()over("+groupBypart+"))),'"+gsa[1]+"',"+gsa[2]+",'"+gsa[3]+"')";
		}
		matcher.appendReplacement(sb,QZContent+"||");//把匹配到的内容replace为什么
	  }
	  matcher.appendTail(sb);
	  if(!"".equals(sb.toString())){
		groupbyColumn=sb.toString();
	  }
	  groupbyColumn=groupbyColumn.replaceAll("LJF~","||'~'||");//分组字段之间的连接符，查询值里面用用~代替---~用于中计
	  groupbyColumn=groupbyColumn.replaceAll("LJF@","||'@'||");//分组字段之间的连接符，查询值里面用用@代替---@用于小计
	  groupbyColumn=("".equals(groupbyColumn)?"":groupbyColumn+",");
	  return new String[]{groupbyColumn,groupbyClause};
  }
}