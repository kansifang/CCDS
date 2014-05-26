<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*,com.lmt.baseapp.Import.impl.*"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*

		 */
	%>
<%
	/*~END~*/
%> 

<%
 	//调用页面传入参数
  		String sType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type")));
 		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
 		String sKey =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OneKey")));
  		String sReportDate =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate")));
  		//FileUpload传入参数
  		String sClearTable =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
  		//FileUpload传入参数
  		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
  		//定义变量：SQL语句、意见详情
  		String sSql = "",sMessage="";
  		ASResultSet rs=null;
  		HashMap<String, String> mmReplace = new HashMap<String, String>();
  		HashMap<String, String> mmAutoSet = new HashMap<String, String>();
  		PreparedStatement ps1 = null,ps2 = null,ps3 = null,ps4 = null;
  		String sImportTableName="Batch_Import";
  		boolean isAutoCommit=false;
 		try {
 		 	isAutoCommit=Sqlca.conn.getAutoCommit();
 		 	Sqlca.conn.setAutoCommit(false);
 		 	Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'");
 		 	//导入文件
 		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,sImportTableName,CurUser,Sqlca);
 		 	efih.action(sConfigNo,sKey);
 	 		//更新配置号和报表日期
 	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
 		 	AfterImport.beforeProcess(sConfigNo, sKey, Sqlca);
 	 		AfterImport.process(sConfigNo, sKey, Sqlca,"归属条线","~s借据明细@归属条线e~");
 	 		String groupBy="case when ~s借据明细@经营类型(新)e~ = '电力' then '电力' "+
 		 			"when ~s借据明细@经营类型(新)e~ ='房地产' then '房地产' "+
 					"when ~s借据明细@经营类型(新)e~ ='钢贸户' then '钢贸户' "+
					"when ~s借据明细@经营类型(新)e~ ='钢铁' then '钢铁' "+
 		 			"when ~s借据明细@经营类型(新)e~ ='化工化肥' then '化工化肥' "+
 		 			"when ~s借据明细@经营类型(新)e~ ='建筑施工' then '建筑施工' "+
 		 			"when ~s借据明细@经营类型(新)e~ ='交通运输' then '交通运输' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '煤炭开采' then '煤炭开采' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '煤炭洗选' then '煤炭洗选' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '农林牧副渔' then '农林牧副渔' "+
 		 			"when ~s借据明细@经营类型(新)e~ like '焦碳%' then '焦碳' "+//焦碳—
 		 			"when ~s借据明细@经营类型(新)e~ like '批发零售%' then '批发零售' "+//批发零售—
 		 			"when ~s借据明细@经营类型(新)e~ like '制造业%' then '制造业' "+//制造业—
 		 			"when ~s借据明细@经营类型(新)e~ = '汽车维修及销售' then '汽车维修及销售' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '燃气生产和供应' then '燃气生产和供应' "+
 					"when ~s借据明细@经营类型(新)e~ = '铁矿开采' then '铁矿开采' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '文化娱乐' then '文化娱乐' "+
 					"when ~s借据明细@经营类型(新)e~ = '信息技术' then '信息技术' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '医药制造' then '医药制造' "+
 					"when ~s借据明细@经营类型(新)e~ = '医院学校' then '医院学校' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '政府平台' then '政府平台' "+
 		 			"when ~s借据明细@经营类型(新)e~ = '住宿餐饮' then '住宿餐饮' "+
 		 			"else '其他' end";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"经营类型(新)",groupBy);
 		 	groupBy="case when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=6  then '1M6]' "+
 		 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=12 then '2M(6-12]' "+
 		 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=36 then '3M(12-36]' "+
 		 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=60 then '4M(36-60]' "+
 		 						"else '5M(60' end,~s借据明细@业务品种e~";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"期限业务品种",groupBy);
 		 	groupBy="case when ~s借据明细@主要担保方式e~ like '保证-%' then '保证' "+
 		 			"when ~s借据明细@主要担保方式e~ like '抵押-%' then '抵押' "+
 		 			"when ~s借据明细@主要担保方式e~ = '信用' then '信用' "+
 		 			"when ~s借据明细@主要担保方式e~ like '%质押-%' then '质押' "+
 		 			"else '其他' end";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"单一担保方式",groupBy);
 		 	//groupBy="case when case when ~s借据明细@主要担保方式e~='软抵押'  then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=6 end then 六个月以下 "+
				//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=12 end then 十二个月以下"+
				//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=36 end then 三十六个月以下"+
				//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=60 end then 六十个月以下"+
				//		"else case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=6 end then 六十个月以上 end,~s借据明细@业务品种e~";
 		 	//AfterImport.process(sConfigNo, sKey, Sqlca,"混合担保方式",groupBy);
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"企业规模","~s借据明细@企业规模e~");
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"业务品种","~s借据明细@业务品种e~");
 		 	groupBy="case when ~s借据明细@国家地区e~ like '%太原市%' then '太原市' "+
 		 			"when ~s借据明细@国家地区e~ like '%吕梁市%' then '吕梁市' "+
 		 			"when ~s借据明细@国家地区e~ like '%晋中市%' then '晋中市' "+
 		 			"when ~s借据明细@国家地区e~ like '%朔州市%' then '朔州市' "+
 		 			"when ~s借据明细@国家地区e~ like '%临汾市%' then '临汾市' "+
 		 			"when ~s借据明细@国家地区e~ like '%长治市%' then '长治市' "+
 		 			"when ~s借据明细@国家地区e~ like '%运城市%' then '运城市' "+
 		 			"when ~s借据明细@国家地区e~ like '%忻州市%' then '忻州市' "+
 		 			"when ~s借据明细@国家地区e~ like '%大同市%' then '大同市' "+
 		 			"when ~s借据明细@国家地区e~ like '%晋城市%' then '晋城市' "+
 		 			"else '其他地区' end";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"地区分类",groupBy);
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"机构分类","~s借据明细@直属行名称e~");
 		 	//AfterImport.process(sConfigNo, sKey, Sqlca,"企业规模(含贴现个经营)","~s借据明细@经营类型(新)e~");
 		 	AfterImport.afterProcess(sConfigNo, sKey, Sqlca);
  		}catch (Exception e) {
 		 	sMessage=e.getMessage(); 	
 		 	out.println("An error occurs : " + e.toString());
 		 	sMessage="false";
 		 	e.printStackTrace();
 		 	Sqlca.conn.rollback();
 		 	throw e;
 		}finally{
 	 		Sqlca.conn.setAutoCommit(isAutoCommit);
 	 	}
 %>
<script language=javascript>
	self.returnValue = "<%=sMessage%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>