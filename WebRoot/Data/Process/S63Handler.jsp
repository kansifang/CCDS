<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*,com.lmt.baseapp.Import.impl.*"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*

		 */
	%>
<%
	/*~END~*/
%> 

<%
 	//����ҳ�洫�����
  		String sType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type")));
 		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
 		String sKey =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OneKey")));
  		String sReportDate =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate")));
  		//FileUpload�������
  		String sClearTable =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
  		//FileUpload�������
  		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
  		//���������SQL��䡢�������
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
 		 	//�����ļ�
 		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,sImportTableName,CurUser,Sqlca);
 		 	efih.action(sConfigNo,sKey);
 	 		//�������úźͱ�������
 	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
 		 	AfterImport.beforeProcess(sConfigNo, sKey, Sqlca);
 	 		AfterImport.process(sConfigNo, sKey, Sqlca,"��������","~s�����ϸ@��������e~");
 	 		String groupBy="case when ~s�����ϸ@��Ӫ����(��)e~ = '����' then '����' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ ='���ز�' then '���ز�' "+
 					"when ~s�����ϸ@��Ӫ����(��)e~ ='��ó��' then '��ó��' "+
					"when ~s�����ϸ@��Ӫ����(��)e~ ='����' then '����' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ ='��������' then '��������' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ ='����ʩ��' then '����ʩ��' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ ='��ͨ����' then '��ͨ����' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = 'ú̿����' then 'ú̿����' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = 'ú̿ϴѡ' then 'ú̿ϴѡ' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = 'ũ��������' then 'ũ��������' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼%' then '��̼' "+//��̼��
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ like '��������%' then '��������' "+//�������ۡ�
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ like '����ҵ%' then '����ҵ' "+//����ҵ��
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = '����ά�޼�����' then '����ά�޼�����' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = 'ȼ�������͹�Ӧ' then 'ȼ�������͹�Ӧ' "+
 					"when ~s�����ϸ@��Ӫ����(��)e~ = '���󿪲�' then '���󿪲�' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = '�Ļ�����' then '�Ļ�����' "+
 					"when ~s�����ϸ@��Ӫ����(��)e~ = '��Ϣ����' then '��Ϣ����' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = 'ҽҩ����' then 'ҽҩ����' "+
 					"when ~s�����ϸ@��Ӫ����(��)e~ = 'ҽԺѧУ' then 'ҽԺѧУ' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = '����ƽ̨' then '����ƽ̨' "+
 		 			"when ~s�����ϸ@��Ӫ����(��)e~ = 'ס�޲���' then 'ס�޲���' "+
 		 			"else '����' end";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"��Ӫ����(��)",groupBy);
 		 	groupBy="case when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=6  then '1M6]' "+
 		 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=12 then '2M(6-12]' "+
 		 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=36 then '3M(12-36]' "+
 		 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=60 then '4M(36-60]' "+
 		 						"else '5M(60' end,~s�����ϸ@ҵ��Ʒ��e~";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"����ҵ��Ʒ��",groupBy);
 		 	groupBy="case when ~s�����ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
 		 			"when ~s�����ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
 		 			"when ~s�����ϸ@��Ҫ������ʽe~ = '����' then '����' "+
 		 			"when ~s�����ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' then '��Ѻ' "+
 		 			"else '����' end";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"��һ������ʽ",groupBy);
 		 	//groupBy="case when case when ~s�����ϸ@��Ҫ������ʽe~='���Ѻ'  then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=6 end then ���������� "+
				//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=12 end then ʮ����������"+
				//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=36 end then ��ʮ����������"+
				//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=60 end then ��ʮ��������"+
				//		"else case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=6 end then ��ʮ�������� end,~s�����ϸ@ҵ��Ʒ��e~";
 		 	//AfterImport.process(sConfigNo, sKey, Sqlca,"��ϵ�����ʽ",groupBy);
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"��ҵ��ģ","~s�����ϸ@��ҵ��ģe~");
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"ҵ��Ʒ��","~s�����ϸ@ҵ��Ʒ��e~");
 		 	groupBy="case when ~s�����ϸ@���ҵ���e~ like '%̫ԭ��%' then '̫ԭ��' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%˷����%' then '˷����' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%�ٷ���%' then '�ٷ���' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%�˳���%' then '�˳���' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%��ͬ��%' then '��ͬ��' "+
 		 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
 		 			"else '��������' end";
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"��������",groupBy);
 		 	AfterImport.process(sConfigNo, sKey, Sqlca,"��������","~s�����ϸ@ֱ��������e~");
 		 	//AfterImport.process(sConfigNo, sKey, Sqlca,"��ҵ��ģ(�����ָ���Ӫ)","~s�����ϸ@��Ӫ����(��)e~");
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