<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.impl.jsbank_als.CheckGuarantyEnterpriseLimit,com.lmt.app.lending.bizlets.*"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%> 
<%!/**
		 * 
		 * @param CreditAggreement
		 * @return
		 * @throws Exception
		 */
		private static boolean getRight(Transaction Sqlca,String CreditAggreement) throws Exception{
			boolean bFlag = false;
			String sSql = "";
			ASResultSet rs = null;
			String sIndustryType1 = "";//����ͻ�����
			try{
				sSql =  " select IndustryType1 from ENT_INFO  where CustomerID in " +
						"( select CustomerID from BUSINESS_CONTRACT  where SerialNo = '"+CreditAggreement+"') ";
				System.out.println("sSql    "+sSql);
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sIndustryType1 = rs.getString("IndustryType1");
				}
				rs.getStatement().close();
				if(sIndustryType1 == null) sIndustryType1 = "";
		
				//�ж�����ͻ������Ƿ�Ϊ����ͨ
				if(sIndustryType1.equals("8")){
					bFlag = true;
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return bFlag;
		}%>
<%
	//��ȡ����
		String sApplyType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType")));
		String sOrgID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID")));
		String sCustomerType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType")));
		String sCreditAggreement = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CreditAggreement")));
		String sBusinessSubType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSubType")));
		String sIsJGT = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsJGT")));
		String sManageDepartFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageDepartFlag")));
		//�������
		String sSql = "",sPhaseOpinion = "",sMessage="true",sCustomerID="",sBusinessType = "";
		String sFlowNo = "";
		
		//�ж��Ƿ�Ϊ֧��Ȩ�� 2011-5-4
		if(sIsJGT.equals("1")&&getRight(Sqlca,sCreditAggreement)&&sApplyType.equals("DependentApply")){
	//����֧��Ȩ��
	sFlowNo= "CreditNormalFlow3";
		}else if(sOrgID.equals("14")){
		if(sApplyType.equals("PutOutApply")){
			sFlowNo = "MicroPutOutFlow";
		}else{
			sFlowNo = "CreditMicroFlow";
		}
		}else if("001002".equals(sManageDepartFlag)&&!sApplyType.equals("CreditLineApply")){//��С����(���˶��)
		sFlowNo= "CreditNormalFlow";
		}else if(sOrgID.equals("20")){//��ͻ���ҵ������(ȫ����)
	sFlowNo= "CreditNormalFlow0";
		}else if(sCustomerType.equals("03")){
		sFlowNo= "CreditRetailFlow";
		}else if(sOrgID.equals("01")&&sCreditAggreement.trim().equals("")&&sApplyType.equals("DependentApply")){//����Ӫҵ��
		sFlowNo= "CreditNormalFlow";
		}else if(sCreditAggreement.trim().equals("")&&sApplyType.equals("DependentApply")){//����ҵ���ر����ţ�
		sFlowNo= "CreditNormalFlow1";
		}else{
	sFlowNo = DataConvert.toString(Sqlca.getString("select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo = '"+sApplyType+"'"));
		}
%>

<script language=javascript>
	self.returnValue = "<%=sFlowNo%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>
