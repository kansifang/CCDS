<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.upload.*,java.io.File,java.util.Date"%>
<%@page import="com.amarsoft.impl.cbhb.impawn.bizlets.datainit.impawn.ImpawnInitialize,
com.amarsoft.impl.cbhb.impawn.bizlets.datainit.putout.PutOutInitialize,
com.amarsoft.impl.cbhb.impawn.bizlets.datainit.bail.BailInitialize,
com.amarsoft.impl.cbhb.impawn.bizlets.datainit.batchno.BatchNoInitialize"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
<%
	/*
				Author:   bllou 2012/08/23
				Tester: 
				Content: 上传文档
				Input Param:
				Output param:
				History Log:
																															
		 */
%>
<%
	/*~END~*/
%>

<%//根据相关参数得到保存文件的实际路径
	
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
<%
		boolean isAutoCommit=false;
		java.util.Date dateNow = new java.util.Date();
		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd-hh-mm-ss");
		AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
		myAmarsoftUpload.initialize(pageContext);
		myAmarsoftUpload.upload();

		String sItemID = (String) myAmarsoftUpload.getRequest().getParameter("ItemID");
		String sClearTable = (String) myAmarsoftUpload.getRequest().getParameter("ClearTable");
		String reString ="OK";
		//得到不带路径的文件名
		String sFileSavePath="/ImpawnManage/DataInit/ExcelFiles/";
		String sSaveFileRealPath = StringFunction.replace(request.getRealPath(""),"\\","/")+sFileSavePath+sdfTemp.format(dateNow)+"/";//具体到秒存上传文件
		File dFile = new File(sSaveFileRealPath);
		if(!dFile.exists())
		{
			dFile.mkdirs();
			System.out.println("！！保存附件文件路径[" + sSaveFileRealPath + "]创建成功！！");
		}
		Files files=myAmarsoftUpload.getFiles();
		int iFC=files.getCount();
		String [] aFiles=null;
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<iFC;i++){
			String sFileName=files.getFile(i).getFileName();
			if(!"".equals(sFileName)){
				files.getFile(i).saveAs(sSaveFileRealPath+sFileName);
				sb.append(sSaveFileRealPath+sFileName).append(";");
			}
		}
		if(sb.lastIndexOf(";")==sb.length()-1){
			sb.deleteCharAt(sb.length()-1);
			aFiles=sb.toString().split(";");
		}
		if(aFiles==null){
			throw new Exception("没有上传有效文件！");
		}
		try {
			isAutoCommit=Sqlca.conn.getAutoCommit();
			Sqlca.conn.setAutoCommit(false);
			//解析文件
			if(sItemID.equals("2")){//入库初始化
				if("true".equals(sClearTable)){
					Sqlca.executeSQL("truncate table Impawn_Total_Import ");
//					Sqlca.executeSQL("truncate table ImpawnManage_Apply");
//					Sqlca.executeSQL("truncate table ImpawnPackage_Info_His");
//					Sqlca.executeSQL("truncate table ImpawnPackage_Info");
//					Sqlca.executeSQL("truncate table ImpawnDetail_Info_His");
//					Sqlca.executeSQL("truncate table ImpawnDetail_Info");
//					Sqlca.executeSQL("truncate table ImpawnRightDoc_List_His");
//					Sqlca.executeSQL("truncate table ImpawnRightDoc_List");
				}
				String sNImportNo=DBFunction.getSerialNo("Impawn_Total_Import","ImportNo","'O"+CurUser.UserID+"'yyyyMMddhhmm","000000",new Date(),Sqlca);
				Sqlca.executeSQL("update Impawn_Total_Import set ImportNo='"+sNImportNo+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
				ImpawnInitialize efih=new ImpawnInitialize(Sqlca,aFiles,CurUser);
				efih.handle();
			}else if(sItemID.equals("3")){//票据对应批次号初始化
				if("true".equals(sClearTable)){
					Sqlca.executeSQL("truncate table Business_PutOut_Batch_Import");
				}
				String sNImportNo=DBFunction.getSerialNo("Business_PutOut_Batch_Import","ImportNo","'O"+CurUser.UserID+"'yyyyMMddhhmm","000000",new Date(),Sqlca);
				Sqlca.executeSQL("update Business_PutOut_Batch_Import set ImportNo='"+sNImportNo+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
				BatchNoInitialize efih=new BatchNoInitialize(Sqlca,aFiles,CurUser);
				efih.handle();
			}else if(sItemID.equals("4")){//票据保证金信息初始化
				if("true".equals(sClearTable)){
					Sqlca.executeSQL("truncate table Bail_WasteBook_Import ");
					//Sqlca.executeSQL("truncate table Bail_WasteBook ");
					//Sqlca.executeSQL("truncate table GuarantyValue_Book ");
					//Sqlca.executeSQL("truncate table PutOut_Impawn_Relative_His ");
					//Sqlca.executeSQL("truncate table PutOut_Impawn_Relative ");
				}
				String sNImportNo=DBFunction.getSerialNo("Bail_WasteBook_Import","ImportNo","'O"+CurUser.UserID+"'yyyyMMddhhmm","000000",new Date(),Sqlca);
				Sqlca.executeSQL("update Bail_WasteBook_Import set ImportNo='"+sNImportNo+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
				BailInitialize efih=new BailInitialize(Sqlca,aFiles,CurUser);
				efih.handle();
			}else if(sItemID.equals("5")){//额度初始化
				if("true".equals(sClearTable)){
					Sqlca.executeSQL("truncate table Business_PutOut_Import ");
					Sqlca.executeSQL("truncate table Business_PutOut_Temp ");
 					//Sqlca.executeSQL("truncate table Business_PutOut ");
				}
				String sNImportNo=DBFunction.getSerialNo("Business_PutOut_Import","ImportNo","'O"+CurUser.UserID+"'yyyyMMddhhmm","000000",new Date(),Sqlca);
				Sqlca.executeSQL("update Business_PutOut_Import set ImportNo='"+sNImportNo+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
				Sqlca.executeSQL("update Business_PutOut_Temp set ImportNo='"+sNImportNo+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
				PutOutInitialize efih=new PutOutInitialize(Sqlca,aFiles,CurUser);
				efih.handle();
			}
			Sqlca.conn.commit();
		}catch (Exception e) {
			out.println("An error occurs : " + e.toString());
			e.printStackTrace();
			reString="Exception";
			Sqlca.conn.rollback();
			throw e;
		}finally{
			myAmarsoftUpload = null;
			Sqlca.conn.setAutoCommit(isAutoCommit);
		}
%>
<script language=javascript>
	try{hideMessage();}catch(e) {}
	if("<%=reString%>" == "OK"){
	    alert("文件上传并成功解析！");
	}else if("<%=reString%>" == "FileNotFound"){
		alert("解析文件时，文件找不到，解析失败！");
	}if("<%=reString%>" == "Exception"){
		alert("解析文件时异常，解析失败！");
	}
	self.top.reloadSelf();
    //self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>