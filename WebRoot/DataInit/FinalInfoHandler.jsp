<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.impl.cbhb.impawn.bizlets.datainit.importobj.CopyInfoUtil"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-17
		Tester:
		Describe: �������Ƿ�ǩ��һ���������ύǰ���
		Input Param:
			SerialNo:������ˮ��
		Output Param:
		HistoryLog:zywei 2005/08/01
			
	 */
	%>
<%/*~END~*/%> 


<% 
		//��ȡ������������ˮ��
		//String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
		//����ֵת���ɿ��ַ���
		//if(sSerialNo == null) sSerialNo = "";
		//���������SQL��䡢�������
		String sSql = "",sMessage="true";
		ASResultSet rs=null;
		HashMap<String, String> mmReplace = new HashMap<String, String>();
		HashMap<String, String> mmAutoSet = new HashMap<String, String>();
		PreparedStatement ps1 = null,ps2 = null,ps3 = null,ps4 = null;
		boolean isAutoCommit=false;
		try {
			isAutoCommit=Sqlca.conn.getAutoCommit();
			Sqlca.conn.setAutoCommit(false);
			//1�����±�֤��Ǽǲ���֤����֣������ �������汣֤������ĵ�BailAccountSum
			Sqlca.executeSQL("update" +
						"	(select /*+BYPASS_UJVC*/ "+
						"		BWI.BailCurrency as BailCurrency_BWI,"+
						"		BPT.BailCurrency as BailCurrency_BPT"+
						"		from Bail_WasteBook_Import BWI,Business_PutOut_Temp BPT" +
						"		where BWI.BPPutOutNo =BPT.PutOutNo" +
						"		 and BWI.ImportNo like 'N"+CurUser.UserID+"%000000'"+
						"		 and BPT.ImportNo like 'N"+CurUser.UserID+"%000000'"+
						"		)"+
						" set BailCurrency_BWI=BailCurrency_BPT");
			Sqlca.executeSQL("update" +
					"	(select /*+BYPASS_UJVC*/ "+
					"		BW.BailCurrency as BailCurrency_BW,"+
					"		BPT.BailCurrency as BailCurrency_BPT"+
					"		from Bail_WasteBook BW,Business_PutOut_Temp BPT" +
					"		where BW.BPPutOutNo =BPT.PutOutNo" +
					"		 and BPT.ImportNo like 'N"+CurUser.UserID+"%000000'"+
					"		)"+
					" set BailCurrency_BW=BailCurrency_BPT");
			//2������ѺƷռ����Ϣ���б�֤��ı���
			Sqlca.executeSQL("update" +
					"	(select /*+BYPASS_UJVC*/ "+
					"		GB.Currency as Currency_GB,"+
					" 		BWI.Currency as Currency_BWI"+
					"		from GuarantyValue_Book GB,"+
					"		 (select BailAccountNo as ImpawnID,min(BailCurrency) as Currency " +
					"			from Bail_WasteBook_Import" +
					"			where ImportNo like 'N"+CurUser.UserID+"%000000'"+ 
					"			group by BailAccountNo"+
					"		 ) BWI"+
					" 		where GB.ImpawnID=BWI.ImpawnID"+
					"	)"+
					"  set Currency_GB=Currency_BWI");
			//3�����·ſ�ѺƷ������Ϣ���б�֤��ı���
			Sqlca.executeSQL("update" +
					"	(select /*+BYPASS_UJVC*/ "+
					"		PIRH.Currency as Currency_PIRH, "+
					"		BWI.Currency as Currency_BWI"+
					"		from PutOut_Impawn_Relative_His PIRH,"+
					"	 		(select BPPutOutNo,BailAccountNo,min(BailCurrency) as Currency"+
					"	 			from Bail_WasteBook_Import " +
					"	 			where ImportNo like 'N"+CurUser.UserID+"%000000'"+
					"	 			group by BPPutOutNo,BailAccountNo"+
					"			) BWI" +
					"	where PIRH.BPPutOutNo =BWI.BPPutOutNo"+
					"    and PIRH.ImpawnID=BWI.BailAccountNo"+
					" 	)"+
					" set Currency_PIRH=Currency_BWI");
			Sqlca.executeSQL("merge into PutOut_Impawn_Relative PIR "+
					" using (select BPPutOutNo,BailAccountNo,min(BailCurrency) as Currency"+
					"		from Bail_WasteBook_Import" +
					"		where ImportNo like 'N"+CurUser.UserID+"%000000' group by BPPutOutNo,BailAccountNo) BWI" +
					" on (BWI.BPPutOutNo=PIR.BPPutOutNo and BWI.BailAccountNo =PIR.ImpawnID)"+
					" when matched then update set PIR.Currency=BWI.Currency");
			//4��������Ѻ��֤���ͬ
			sSql = "select BCC.RelativeSerialNo as SerialNo," +
						" BCC.CustomerID as GuarantorID,"+
						" getCustomerName(BCC.CustomerID) as GuarantorName,"+
						" BCC.BeginDate as SignDate," +
						" BCC.BeginDate," +
						" BCC.EndDate,"+
						" BPT.BailRatio,"+
						" BPT.PutOutNo,"+
						" '060' as GuarantyType,"+//��ǩ
						" '020' as ContractType,"+//��߶��
						" '020' as ContractStatus,"+//��ǩ
						" '1' as IsBailGuaranty,"+//��֤����Ѻ��ͬ��־
						" PIR.ImpawnType as GuarantyType,"+//ѺƷ����
						" PIR.ImpawnID as GuarantyRightID,"+//��֤���˺�
						" BPT.BailRatio as AboutRate,"+//��֤�����
						" PIR.Currency as GuarantySubType,"+//��֤�����
						" PIR.InitUsedSum as AboutSum1,"+//��֤����
						" PIR.InitUsedSum as AboutSum2"+//��֤��ծȨ���
						" from Business_PutOut_Temp BPT,PutOut_Impawn_Relative PIR,CL_Info CI,Business_ContractCLInfo BCC"+
						" where BPT.PutOutNo=PIR.BPPutOutNo" +
						" and BPT.ImportNo like 'N"+CurUser.UserID+"%000000'" +
						" and BPT.LineID=CI.LineID" +
						" and CI.ApplySerialNo=BCC.ApplySerialNo" +
						" and BCC.SerialNo=BCC.CreditAggreement" +
						" and BPT.BailRatio>0";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				String sBCSerialNo = DataConvert.toString(rs.getString("SerialNo"));
				double iExist = Sqlca.getDouble("select count(1) from Contract_Relative CR,Guaranty_Contract GC" +
												" where CR.SerialNo='"+sBCSerialNo+"'" +
												" and CR.ObjectType='GuarantyContract'" +
												" and CR.ObjectNo=GC.SerialNo" +
												" and GC.IsBailGuaranty='1'");
				if(iExist==0){
					String sGCSerialNo = DBFunction.getSerialNo("Guaranty_Contract","SerialNo",Sqlca);
					//������ͬ
					mmAutoSet = new HashMap<String, String>();
					mmAutoSet.put("SerialNo",sGCSerialNo);
					ps1 = CopyInfoUtil.copyInfo("insert", rs,"select * from Guaranty_Contract", null, null,null, mmAutoSet, Sqlca, ps1);
					ps1.execute();
					//��ͬ������Ϣ��
					mmAutoSet = new HashMap<String, String>();
					mmAutoSet.put("ObjectType","GuarantyContract");
					mmAutoSet.put("ObjectNo",sGCSerialNo);
					ps2 = CopyInfoUtil.copyInfo("insert", rs,"select * from Contract_Relative", null, null,null, mmAutoSet, Sqlca, ps2);
					ps2.execute();
					//ѺƷ��Ϣ��
					mmReplace = new HashMap<String, String>();
					mmReplace.put("OwnerName","GuarantorName");
					mmReplace.put("OwnerID","GuarantorID");
					String sGuarantyID = DBFunction.getSerialNo("Guaranty_Info", "GuarantyID", Sqlca);//�����������������к�
					mmAutoSet = new HashMap<String, String>();
					mmAutoSet.put("GuarantyID",sGuarantyID);
					ps3 = CopyInfoUtil.copyInfo("insert", rs,"select * from Guaranty_Info", null, null,mmReplace, mmAutoSet, Sqlca, ps3);
					ps3.execute();
					//��ͬ��ѺƷ������Ϣ��
					mmAutoSet = new HashMap<String, String>();
					mmAutoSet.put("ObjectNo",sBCSerialNo);
					mmAutoSet.put("ObjectType","BusinessContract");
					mmAutoSet.put("ContractNo",sGCSerialNo);
					mmAutoSet.put("GuarantyID",sGuarantyID);
					mmAutoSet.put("Channel","init");
					ps4 = CopyInfoUtil.copyInfo("insert", rs,"select * from Guaranty_Relative", null, null,null, mmAutoSet, Sqlca, ps4);
					ps4.execute();
				}
			}
			rs.getStatement().close();
			if(ps1!=null) ps1.close();
			if(ps2!=null) ps2.close();
			if(ps3!=null) ps3.close();
			if(ps4!=null) ps4.close();
			sMessage= "true";
			Sqlca.conn.commit();
	}catch (Exception e) {
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
