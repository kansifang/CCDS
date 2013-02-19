<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  author:  --ygao 2007-1-17
  Tester:
               
 */
 %>
<%/*~END~*/%>
<%     
    //定义变量
    String sReturn = "succeed";
	String sEvaluateSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EvaluateSerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sEvaluateSerialNo == null) sEvaluateSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";

	//复制evaluate_record信息
	//Sqlca.executeSQL("delete from WLS_VERSION where version = '" + sVersion + "' and ItemNo <> '000'");
	String sSerialNo=DBFunction.getSerialNo("EVALUATE_RECORD", "SerialNo",Sqlca);
	Sqlca.executeSQL("insert into Evaluate_Record("+
						"OBJECTTYPE,"+
						"OBJECTNO,"+
						"SERIALNO,"+
						"ACCOUNTMONTH,"+
						"MODELNO,"+
						"EVALUATEDATE,"+
						"EVALUATESCORE,"+
						"EVALUATERESULT,"+
						"ORGID,"+
						"USERID,"+
						"COGNDATE,"+
						"COGNSCORE,"+
						"COGNRESULT,"+
						"COGNORGID,"+
						"COGNUSERID,"+
						"REMARK,"+
						"COGNREASON,"+
						"COGNRESULT2,"+
						"COGNUSERNAME2,"+
						"COGNREASON2,"+
						"COGNRESULT3,"+
						"COGNUSERNAME3,"+
						"COGNREASON3,"+
						"COGNUSERID3,"+
						"COGNUSERID2,"+
						"EVALUATELEVEL,"+
						"FINISHDATE2,"+
						"FINISHDATE3,"+
						"FINISHDATE,"+
						"COGNRESULT4,"+
						"COGNUSERNAME4,"+
						"COGNREASON4,"+
						"FINISHDATE4,"+
						"COGNUSERID4,"+
						"EVALUATEFIRSTRESULT,"+
						"EVALUATEYESNO"+
					")"+
					"select "+
						"OBJECTTYPE,"+
						sObjectNo+","+
						sSerialNo+","+
						"ACCOUNTMONTH,"+
						"MODELNO,"+
						"EVALUATEDATE,"+
						"EVALUATESCORE,"+
						"EVALUATERESULT,"+
						CurUser.OrgID+","+
						CurUser.UserID+","+
						"COGNDATE,"+
						"COGNSCORE,"+
						"COGNRESULT,"+
						"COGNORGID,"+
						"COGNUSERID,"+
						"REMARK,"+
						"COGNREASON,"+
						"COGNRESULT2,"+
						"COGNUSERNAME2,"+
						"COGNREASON2,"+
						"COGNRESULT3,"+
						"COGNUSERNAME3,"+
						"COGNREASON3,"+
						"COGNUSERID3,"+
						"COGNUSERID2,"+
						"EVALUATELEVEL,"+
						"FINISHDATE2,"+
						"FINISHDATE3,"+
						"FINISHDATE,"+
						"COGNRESULT4,"+
						"COGNUSERNAME4,"+
						"COGNREASON4,"+
						"FINISHDATE4,"+
						"COGNUSERID4,"+
						"EVALUATEFIRSTRESULT,"+
						"EVALUATEYESNO"+
					" from Evaluate_Record "+
					" where SerialNo = '"+sEvaluateSerialNo+"'");
	//复制evaluate_data信息
	Sqlca.executeSQL("insert into Evaluate_Data("+
						"OBJECTTYPE,"+
						"OBJECTNO,"+
						"SERIALNO,"+
						"ITEMNO,"+
						"ITEMVALUE,"+
						"EVALUATESCORE"+
					")"+
					"select "+
						"OBJECTTYPE,"+
						sObjectNo+","+
						sSerialNo+","+
						"ITEMNO,"+
						"ITEMVALUE,"+
						"EVALUATESCORE"+
					" from Evaluate_Data "+
					" where SerialNo = '"+sEvaluateSerialNo+"'");
 %>
<script language=javascript>
	self.returnValue="<%=sReturn%>";
	self.close();
		
</script>


<%@ include file="/IncludeEnd.jsp"%>