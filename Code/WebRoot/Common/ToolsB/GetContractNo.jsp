<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: ZYWei 2003.8.17
 * Tester:
 *
 * Content: 获取流水号
 * Input Param:
 *			表名:	TableName
 *			列名:	ColumnName
 			格式：	SerialNoFormate
 * Output param:
 *		  流水号:	SerialNo
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获得合同号和借据号</title>
<%!
	String getArtificialNo(String sOrgId,String sBusinessType,Transaction Sqlca) throws Exception {
		/*格式：4位机构号+4位年份+1位业务属性+9+4位顺序号
		  业务属性 2 对公贷款 
				   4 贴现 6501
				   7 对公按揭 2201
		  */
		String sYear = StringFunction.getToday().substring(0,4);
		String sNoFix = sOrgId+sYear;
		String sNo = sNoFix;
		String sFlag = "8"; //脱机放款使用
		//String sFlag = "9"; //正常放款使用

		String sSql="select SubTypeCode  from BUSINESS_TYPE where TypeNo='"+sBusinessType+"'";
		String sExchangeType = Sqlca.getString(sSql);
		if (sExchangeType==null) sExchangeType="";
		
		String sMaxNo = "";
		String sSerialNo = "";

		//承兑汇票
		if (sExchangeType.equals("8315")) {
			sNoFix = "CD"+sOrgId+sYear+"8"+sFlag;
		}
		//贴现
		else if (sExchangeType.equals("6501")) {
			sNoFix +="4"+sFlag;
		}
		//按揭
		else if (sExchangeType.equals("2201")) {
			sNoFix +="7"+sFlag;
		}
		//一般贷款
		else {
			sNoFix +="2"+sFlag;
		}

		Sqlca.executeSQL("exec FindContractNo '"+sNoFix+"','"+sOrgId+"','"+sYear+"'");
		sSql="select min(CurrentNo) from OBJECT_NO where FixNo='"+sNoFix+"'";
		sMaxNo = Sqlca.getString(sSql);
		Sqlca.executeSQL("delete from OBJECT_NO where FixNo='"+sNoFix+"' and CurrentNo="+sMaxNo+"");
		sSerialNo = ""+(10000+Integer.parseInt(sMaxNo));
		sNo = sNoFix + sSerialNo.substring(1,5);	
		return sNo;
	}

	String getDuebillSerialNo(String sArtificialNo,Transaction Sqlca) throws Exception {
		/*格式：14合同+2位顺序号*/
		String sNoFix = sArtificialNo;
		String sNo = sNoFix;
		String sSql="select max(DuebillSerialNo) from BUSINESS_PUTOUT where substring(DuebillSerialNo,1,14)='"+sNoFix+"' and len(DuebillSerialNo)=16";
		String sMaxNo = Sqlca.getString(sSql);
		String sSubNo;
		int iSubNo = 101;
		if (sMaxNo != null) {
			sSubNo = "1" + sMaxNo.substring(14,16);
			iSubNo = Integer.parseInt(sSubNo)+1;
		}

		String sExistNo;
		do {
			sSubNo = ""+iSubNo;
			sNo = sNoFix + sSubNo.substring(1,3);
			sSql = "select SerialNo from BUSINESS_DUEBILL where SerialNo='"+sNo+"'";
			sExistNo = Sqlca.getString(sSql);
			iSubNo ++;
		} while (sExistNo!=null);
		return sNo;
	}
%>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	String	sBusinessType = DataConvert.toRealString(iPostChange,(String)request.getParameter("BusinessType"));
	String	sOrgID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgID"));
	String	sArtificialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ArtificialNo"));
	if (sArtificialNo == null) sArtificialNo = "";
	String	sSerialType = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialType"));
	String	sSerialNo = sArtificialNo;

	if (sSerialType == null) {
		if (sOrgID == null)
			sOrgID = CurOrg.OrgID;
		String sOrgIDPart = "";
		if (sArtificialNo.length() == 14) {
			sOrgIDPart = sArtificialNo.substring(0,4);
		}
		if (sArtificialNo.length() == 16) {
			sOrgIDPart = sArtificialNo.substring(2,6);
		}
		if (!sOrgID.equals(sOrgIDPart))
			sSerialNo=getArtificialNo(sOrgID,sBusinessType,Sqlca);
	}
	else if (sSerialType.equals("020")) { //借据号
		sSerialNo=getDuebillSerialNo(sArtificialNo,Sqlca);
	}
%>

<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
