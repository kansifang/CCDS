<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.upload.*,java.io.File,java.util.Date"%>
<%@page import="com.amarsoft.impl.cbhb.impawn.bizlets.datainit.impawn.ImpawnInitialize,
com.amarsoft.impl.cbhb.impawn.bizlets.datainit.putout.PutOutInitialize,
com.amarsoft.impl.cbhb.impawn.bizlets.datainit.bail.BailInitialize,
com.amarsoft.impl.cbhb.impawn.bizlets.datainit.batchno.BatchNoInitialize"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
<%
	/*
				Author:   bllou 2012/08/23
				Tester: 
				Content: �ϴ��ĵ�
				Input Param:
				Output param:
				History Log:
																															
		 */
%>
<%
	/*~END~*/
%>

<%//������ز����õ������ļ���ʵ��·��
	
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
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
		//�õ�����·�����ļ���
		String sFileSavePath="/ImpawnManage/DataInit/ExcelFiles/";
		String sSaveFileRealPath = StringFunction.replace(request.getRealPath(""),"\\","/")+sFileSavePath+sdfTemp.format(dateNow)+"/";//���嵽����ϴ��ļ�
		File dFile = new File(sSaveFileRealPath);
		if(!dFile.exists())
		{
			dFile.mkdirs();
			System.out.println("�������渽���ļ�·��[" + sSaveFileRealPath + "]�����ɹ�����");
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
			throw new Exception("û���ϴ���Ч�ļ���");
		}
		try {
			isAutoCommit=Sqlca.conn.getAutoCommit();
			Sqlca.conn.setAutoCommit(false);
			//�����ļ�
			if(sItemID.equals("2")){//����ʼ��
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
			}else if(sItemID.equals("3")){//Ʊ�ݶ�Ӧ���κų�ʼ��
				if("true".equals(sClearTable)){
					Sqlca.executeSQL("truncate table Business_PutOut_Batch_Import");
				}
				String sNImportNo=DBFunction.getSerialNo("Business_PutOut_Batch_Import","ImportNo","'O"+CurUser.UserID+"'yyyyMMddhhmm","000000",new Date(),Sqlca);
				Sqlca.executeSQL("update Business_PutOut_Batch_Import set ImportNo='"+sNImportNo+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
				BatchNoInitialize efih=new BatchNoInitialize(Sqlca,aFiles,CurUser);
				efih.handle();
			}else if(sItemID.equals("4")){//Ʊ�ݱ�֤����Ϣ��ʼ��
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
			}else if(sItemID.equals("5")){//��ȳ�ʼ��
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
	    alert("�ļ��ϴ����ɹ�������");
	}else if("<%=reString%>" == "FileNotFound"){
		alert("�����ļ�ʱ���ļ��Ҳ���������ʧ�ܣ�");
	}if("<%=reString%>" == "Exception"){
		alert("�����ļ�ʱ�쳣������ʧ�ܣ�");
	}
	self.top.reloadSelf();
    //self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>