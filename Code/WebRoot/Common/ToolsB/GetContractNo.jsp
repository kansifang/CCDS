<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: ZYWei 2003.8.17
 * Tester:
 *
 * Content: ��ȡ��ˮ��
 * Input Param:
 *			����:	TableName
 *			����:	ColumnName
 			��ʽ��	SerialNoFormate
 * Output param:
 *		  ��ˮ��:	SerialNo
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>��ú�ͬ�źͽ�ݺ�</title>
<%!
	String getArtificialNo(String sOrgId,String sBusinessType,Transaction Sqlca) throws Exception {
		/*��ʽ��4λ������+4λ���+1λҵ������+9+4λ˳���
		  ҵ������ 2 �Թ����� 
				   4 ���� 6501
				   7 �Թ����� 2201
		  */
		String sYear = StringFunction.getToday().substring(0,4);
		String sNoFix = sOrgId+sYear;
		String sNo = sNoFix;
		String sFlag = "8"; //�ѻ��ſ�ʹ��
		//String sFlag = "9"; //�����ſ�ʹ��

		String sSql="select SubTypeCode  from BUSINESS_TYPE where TypeNo='"+sBusinessType+"'";
		String sExchangeType = Sqlca.getString(sSql);
		if (sExchangeType==null) sExchangeType="";
		
		String sMaxNo = "";
		String sSerialNo = "";

		//�жһ�Ʊ
		if (sExchangeType.equals("8315")) {
			sNoFix = "CD"+sOrgId+sYear+"8"+sFlag;
		}
		//����
		else if (sExchangeType.equals("6501")) {
			sNoFix +="4"+sFlag;
		}
		//����
		else if (sExchangeType.equals("2201")) {
			sNoFix +="7"+sFlag;
		}
		//һ�����
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
		/*��ʽ��14��ͬ+2λ˳���*/
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
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
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
	else if (sSerialType.equals("020")) { //��ݺ�
		sSerialNo=getDuebillSerialNo(sArtificialNo,Sqlca);
	}
%>

<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
