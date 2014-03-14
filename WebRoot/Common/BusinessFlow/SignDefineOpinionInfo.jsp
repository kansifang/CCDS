<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
		Author:   CChang 2003.8.25
		Tester:
		Content: ǩ�����
		Input Param:
			TaskNo��������ˮ��
			ObjectNo��������
			ObjectType����������
		Output param:
		History Log: zywei 2005/07/31 �ؼ�ҳ��
		*/
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ǩ�����";
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "",sFlowNo = "",sPhaseNo = "";
	String sCustomerID = "",sCustomerName = "",sBusinessCurrency = "";
	String sBailCurrency = "",sRateFloatType = "",sBusinessType = "";
	String sOccurType = "",sBusinessSum = "",sBusinessSubType = "",sInputOrgID="",sTasksFirstBatch="",sTotalSumFirstBatch="";
	double dBusinessSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0,dTotalSumFirstBatch=0.0;
	double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0 ,dPromisesFeeSum=0.0,dPromisesFeeRatio=0.0 ;
	int iTermYear = 0,iTermMonth = 0,iTermDay = 0,iTasksFirstBatch=0;
	ASResultSet rs = null;
	
	//��ȡ���������������ˮ�š������š���������
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
	<%
		//���ݶ������ͺͶ����Ż�ȡ���̺�
		sSql = 	" select PhaseNo from FLOW_OBJECT "+
		" where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
		sPhaseNo = Sqlca.getString(sSql);
		if(sPhaseNo == null) sPhaseNo = "";
		
		sSql = "select BusinessSum from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
		double dApplyBusinessSum = Sqlca.getDouble(sSql).doubleValue();
			
		//���ݶ������ͺͶ����Ż�ȡ��Ӧ��ҵ����Ϣ
		//--modified by wwhe 2009-09-07 for:չʾ�ϼ��������	
		if(sPhaseNo.equals("3000")){
			sSql = 	" select CustomerID,CustomerName,BusinessCurrency,BusinessSum,PromisesFeeRatio,PromisesFeeSum, "+
			" BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,BusinessType,TermYear, "+
			" TermMonth,TermDay,OccurType,BusinessSubType,InputOrgID "+
			" TasksFirstBatch,TotalSumFirstBatch "+
			" from BUSINESS_APPLY "+
			" where SerialNo = '"+sObjectNo+"' ";
		}else{
			sSql = 	" select BA.CustomerID,BA.CustomerName,BA.BusinessCurrency,FO.BusinessSum,FO.PromisesFeeRatio,FO.PromisesFeeSum, "+
			" FO.BaseRate,FO.RateFloatType,FO.RateFloat,FO.BusinessRate,FO.BailCurrency, "+
			" FO.BailSum,FO.BailRatio,FO.PdgRatio,FO.PdgSum,BA.BusinessType,FO.TermYear, "+
			" FO.TermMonth,FO.TermDay,BA.OccurType,FO.TasksFirstBatch,FO.TotalSumFirstBatch,FO.BusinessSubType,BA.InputOrgID "+
			" from BUSINESS_APPLY BA,FLOW_OPINION FO "+
			" where BA.SerialNo = '"+sObjectNo+"' and FO.ObjectType='CreditApply' and BA.SerialNo = FO.ObjectNo order by FO.OpinionNo DESC";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			sCustomerName = rs.getString("CustomerName");
			sBusinessCurrency = rs.getString("BusinessCurrency");
			dBusinessSum = rs.getDouble("BusinessSum");
			dBaseRate = rs.getDouble("BaseRate");
			sRateFloatType = rs.getString("RateFloatType");
			dRateFloat = rs.getDouble("RateFloat");
			dBusinessRate = rs.getDouble("BusinessRate");
			sBailCurrency = rs.getString("BailCurrency");
			dBailSum = rs.getDouble("BailSum");
			dBailRatio = rs.getDouble("BailRatio");
			dPromisesFeeSum = rs.getDouble("PromisesFeeSum");
			dPromisesFeeRatio = rs.getDouble("PromisesFeeRatio");
			dPdgRatio = rs.getDouble("PdgRatio");
			dPdgSum = rs.getDouble("PdgSum");
			sBusinessType = rs.getString("BusinessType");
			iTermYear = rs.getInt("TermYear");
			iTermMonth = rs.getInt("TermMonth");
			iTermDay = rs.getInt("TermDay");
			sOccurType = rs.getString("OccurType");
			sBusinessSubType = rs.getString("BusinessSubType");//--added by wwhe 2009-06-08
			sInputOrgID = rs.getString("InputOrgID");//--added by wwhe 2009-06-08
			iTasksFirstBatch = rs.getInt("TasksFirstBatch");// --added by ymwu 2012-02-27  ��������ҵ�����
			dTotalSumFirstBatch = rs.getDouble("TotalSumFirstBatch");//--added by ymwu 2012-02-27 ���������
			//����ֵת��Ϊ���ַ���
			if(sCustomerID == null) sCustomerID = "";
			if(sCustomerName == null) sCustomerName = "";
			if(sBusinessCurrency == null) sBusinessCurrency = "";
			if(sRateFloatType == null) sRateFloatType = "";
			if(sBailCurrency == null) sBailCurrency = "";
			if(sBusinessType == null) sBusinessType = "";
			if(sOccurType == null) sOccurType = "";
			if(sBusinessSubType == null) sBusinessSubType = "";//--added by wwhe 2009-06-08
			if(sInputOrgID == null) sInputOrgID = "";//--added by wwhe 2009-06-08
			//ת��������ʾ��ʽ
			if(dBusinessSum > 0)
		sBusinessSum = DataConvert.toMoney(dBusinessSum);
			if(iTasksFirstBatch > 0)
		sTasksFirstBatch = DataConvert.toMoney(iTasksFirstBatch);
			if(dTotalSumFirstBatch > 0)
		sTotalSumFirstBatch = DataConvert.toMoney(dTotalSumFirstBatch);
		}
		rs.getStatement().close();
		
		String sHeaders[][]={                       
		                        {"CustomerID","�ͻ����"},
		                        {"CustomerName","�ͻ�����"},
		                        {"BusinessCurrency","ҵ�����"},
		                        {"BusinessSum","��׼���(Ԫ)"},
		                        {"TermMonth","��׼����"},
		                        {"TermDay","��"},
		                        {"TasksFirstBatch","�״��ÿ�����ҵ�����"},
		                        {"TotalSumFirstBatch","�״��ÿ�����ҵ���ܶ��"},
		                        {"BaseRate","��׼������(%)"},
		                        {"RateFloatType","���ʸ�����ʽ"},
		                        {"RateFloat","��׼���ʸ���ֵ"},
		                        {"BusinessRate","��׼ִ��������(%)"},
		                        {"BailCurrency","��֤�����"},
		                        {"BailSum","��֤����"},
		                        {"BailRatio","��֤�����(%)"},	                        
		                        {"PromisesFeeRatio","��ŵ����(%)"},	                        
		                        {"PromisesFeeSum","��ŵ��"},
		                        {"PdgRatio","��������(��)"},
		                        {"PdgSum","�����ѽ��(Ԫ)"},
		                        {"PhaseOpinion","���"},
		                        {"PhaseOpinion1","�������1"},
		                        {"PhaseOpinion2","�������2"},
		                        {"PhaseOpinion3","�������3"},
		                        {"InputOrgName","�Ǽǻ���"}, 
		                        {"InputUserName","�Ǽ���"}, 
		                        {"InputTime","�Ǽ�����"},
		                        {"BusinessSubType","���ŷ���"}//--added by wwhe 2009-06-08
	                        };                    
		String sHeaders1[][]={                       
		                        {"CustomerID","�ͻ����"},
		                        {"CustomerName","�ͻ�����"},
		                        {"BusinessCurrency","ҵ�����"},
		                        {"BusinessSum","��׼���(Ԫ)"},
		                        {"TermMonth","��׼����"},
		                        {"TermDay","��"},
		                        {"BaseRate","��׼������(%)"},
		                        {"RateFloatType","���ʸ�����ʽ"},
		                        {"RateFloat","��׼���ʸ���ֵ"},
		                        {"BusinessRate","��׼ִ��������(%)"},
		                        {"BailCurrency","��֤�����"},
		                        {"BailSum","��֤����"},
		                        {"BailRatio","��֤�����(%)"},
		                        {"PromisesFeeRatio","��ŵ����(%)"},	                        
		                        {"PromisesFeeSum","��ŵ��"},
		                        {"PdgRatio","��������(��)"},
		                        {"PdgSum","�����ѽ��(Ԫ)"},
		                        {"PhaseOpinion","���"},
		                        {"PhaseOpinion1","�������1"},
		                        {"PhaseOpinion2","�������2"},
		                        {"PhaseOpinion3","�������3"},
		                        {"InputOrgName","�Ǽǻ���"}, 
		                        {"InputUserName","�Ǽ���"}, 
		                        {"InputTime","�Ǽ�����"}                      
	                        }; 	
	    String sHeaders2[][]={                       
		                        {"CustomerID","�ͻ����"},
		                        {"CustomerName","�ͻ�����"},
		                        {"BusinessCurrency","չ�ڱ���"},
		                        {"BusinessSum","��׼չ�ڽ��(Ԫ)"},
		                        {"TermMonth","��׼չ������"},
		                        {"TermDay","��"},
		                        {"BaseRate","��׼������(%)"},
		                        {"RateFloatType","���ʸ�����ʽ"},
		                        {"RateFloat","��׼���ʸ���ֵ"},
		                        {"BusinessRate","��׼չ��ִ��������(%)"},
		                        {"BailCurrency","��֤�����"},
		                        {"BailSum","��֤����(Ԫ)"},
		                        {"BailRatio","��֤�����(%)"},
		                        {"PromisesFeeRatio","��ŵ����(%)"},	                        
		                        {"PromisesFeeSum","��ŵ��"},
		                        {"PdgRatio","��������(��)"},
		                        {"PdgSum","�����ѽ��(Ԫ)"},
		                        {"PhaseOpinion","���"},
		                        {"PhaseOpinion1","�������1"},
		                        {"PhaseOpinion2","�������2"},
		                        {"PhaseOpinion3","�������3"},
		                        {"InputOrgName","�Ǽǻ���"}, 
		                        {"InputUserName","�Ǽ���"}, 
		                        {"InputTime","�Ǽ�����"}                      
	                        }; 	
	    String sHeaders3[][]={                       
		                        {"PhaseOpinion","���"},
		                        {"InputOrgName","�Ǽǻ���"}, 
		                        {"InputUserName","�Ǽ���"}, 
		                        {"InputTime","�Ǽ�����"}                      
	                        };  
		//����SQL���
		sSql = 	" select SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID, "+
		" CustomerName,BusinessSubType,BusinessCurrency,BusinessSum,TermYear,TermMonth, "+
		" TermDay,TasksFirstBatch,TotalSumFirstBatch,BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
		" BailSum,BailRatio,PromisesFeeRatio,PromisesFeeSum,PdgRatio,PdgSum,PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3,InputOrg, "+
		" getOrgName(InputOrg) as InputOrgName,InputUser, "+
		" getUserName(InputUser) as InputUserName,InputTime, "+
		" UpdateUser,UpdateTime "+
		" from FLOW_OPINION " +
		" where SerialNo='"+sSerialNo+"' ";

		//ͨ��SQL��������ASDataObject����doTemp
		ASDataObject doTemp = new ASDataObject(sSql);
		
		//�����б��ͷ	
		if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //�����ʼ�׶κͷ��ز������Ͻ׶�
		{
			doTemp.setHeader(sHeaders3); 
		}else
		{
			if(sOccurType.equals("015"))//��������Ϊչ��
			{
		doTemp.setHeader(sHeaders2); 
			}else
			{
		//ҵ��Ʒ��Ϊ��ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡����˾�Ӫѭ�����������Ѻ���
		//���˱�֤������˵�Ѻ�������Ӫ��������������������������ҵ��ѧ���
		//������ѧ������гжһ�Ʊ���֡�����ס��װ�޴�����˸���������˾�Ӫ���
		//���˵�Ѻѭ���������С�����ô������������Ѻ��������ٽ�����ҵ�÷����
		//������ҵ�÷�����������ٽ���ס���������ס��������뷵��ҵ�񡢸���ί�д���
		//��ִ��������
		if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
		 || sBusinessType.equals("1110080") || sBusinessType.equals("1110090")
		 || sBusinessType.equals("1110100") || sBusinessType.equals("1110110")
		 || sBusinessType.equals("1110120") || sBusinessType.equals("1110130")
		 || sBusinessType.equals("1110140") || sBusinessType.equals("1110150")
		 || sBusinessType.equals("1020010") || sBusinessType.equals("1110160")	 
		 || sBusinessType.equals("2110050") || sBusinessType.equals("1110170")
		 || sBusinessType.equals("1110070") || sBusinessType.equals("1110060")
		 || sBusinessType.equals("1110050") || sBusinessType.equals("1110040")
		 || sBusinessType.equals("1110030") || sBusinessType.equals("1110020")
		 || sBusinessType.equals("1110010") || sBusinessType.equals("2100")
		 || sBusinessType.equals("2110040"))
			doTemp.setHeader(sHeaders1); 
		else //��ִ֮��������
			doTemp.setHeader(sHeaders); 
			}
		}
		
		//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
		doTemp.UpdateTable = "FLOW_OPINION";
		doTemp.setKey("SerialNo,OpinionNo",true);		
		doTemp.setUnit("TermMonth","��");
		doTemp.setUnit("TermDay","��"); 
		doTemp.setVisible("BusinessSubType,TasksFirstBatch,TotalSumFirstBatch",false);
		
		//�����ֶ��Ƿ�ɼ��ͱ�����	
		if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //�����ʼ�׶κͷ��ز������Ͻ׶�
		{
			doTemp.setVisible("CustomerName,BusinessCurrency,BusinessSum,BusinessRate,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum",false);
			doTemp.setRequired("PhaseOpinion",true);
		}else
		{
			if(sOccurType.equals("015"))//��������Ϊչ��
			{
		doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
		doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PhaseOpinion",true);
		doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
			}else
			{
		//ҵ��Ʒ��Ϊ���˸����������ծȯת�������ί�д��������㴢��ת�������ת���
		//ת�����ʽ�����֯���ת�����Ŵ���ת�������������
		if(sBusinessType.equals("2110050") || sBusinessType.equals("2060050")
		 || sBusinessType.equals("2110040") || sBusinessType.equals("2060030")
		 || sBusinessType.equals("2060060") || sBusinessType.equals("2060020")
		 || sBusinessType.equals("2060040") || sBusinessType.equals("2060010"))  
		{
			doTemp.setVisible("BailSum,BailRatio,,PromisesFeeRatio,PromisesFeeSum",false);	
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PdgRatio,PdgSum,PhaseOpinion",true);
			if(sBusinessType.equals("2110050") || sBusinessType.equals("2110040"))
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			else
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
			doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");	
		}
		//ҵ��Ʒ��Ϊ��������֤������ó�ױ����������ࣩ������ó�ױ������������ࣩ���а����̱���
		//�����ŵ��������������������顢���Ᵽ�������������˰������������������֤��
		//���±������ӹ�װ��ҵ����ڱ�����������������������֤�����ý𱣺�����Լ������
		//�����������Ա��������������Ա��������ϱ��������������Ͷ�걣����͸֧�黹������
		//���гжһ�Ʊ�������Ŵ�֤�����м�֤ȯ���е�����Ԥ�����������ά�ޱ�������𳥻�����
		else if(sBusinessType.equals("2050020") || sBusinessType.equals("2030050")
		 || sBusinessType.equals("2040070") || sBusinessType.equals("2040040")
		 || sBusinessType.equals("2080010") || sBusinessType.equals("2090010")
		 || sBusinessType.equals("2080020") || sBusinessType.equals("2050040")
		 || sBusinessType.equals("2030060") || sBusinessType.equals("2030040")
		 || sBusinessType.equals("2020") || sBusinessType.equals("2040060")
		 || sBusinessType.equals("2040100") || sBusinessType.equals("2030010")	 
		 || sBusinessType.equals("2050030") || sBusinessType.equals("2040090")
		 || sBusinessType.equals("2040020") || sBusinessType.equals("2040110")
		 || sBusinessType.equals("2030070") || sBusinessType.equals("2040080")
		 || sBusinessType.equals("2050010") || sBusinessType.equals("2040010")	 
		 || sBusinessType.equals("2030030") || sBusinessType.equals("2010")
		 || sBusinessType.equals("2080030") || sBusinessType.equals("2090020")
		 || sBusinessType.equals("2040030") || sBusinessType.equals("2040050")
		 || sBusinessType.equals("2030020"))  
		{
			doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BailSum,BailRatio,PdgRatio,PdgSum,PhaseOpinion,PromisesFeeRatio,PromisesFeeSum",true);	
			doTemp.setHTMLStyle("BusinessSum"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
			doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}
		//ҵ��Ʒ��Ϊ�������������̡����˷��ݴ��������Ŀ���������Ѵ������������	
		else if(sBusinessType.equals("3030030") || sBusinessType.equals("3030010")
		 || sBusinessType.equals("3030020")) 
		{
			doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BailSum,BailRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}	
		//ҵ��Ʒ��Ϊ���˾�Ӫ���������ѧ�����ҵ��ѧ����
		else if(sBusinessType.equals("1110170") || sBusinessType.equals("1110150")
		 || sBusinessType.equals("1110140"))
		{
			doTemp.setVisible("PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}	
		else if(sBusinessType.equals("2110010"))  //ҵ��Ʒ��Ϊ����ס�����������
		{
			doTemp.setVisible("RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);	
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,BailSum,BailRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}
		else if(sBusinessType.equals("1090010") || sBusinessType.equals("2070"))  //ҵ��Ʒ��Ϊ���ڱ���ί�д���
		{
			doTemp.setVisible("BailSum,BailRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PdgRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
		}
		else //��֮
		{
			if(sBusinessType.equals("3010")){//�ۺ����Ŷ��
				doTemp.setVisible("BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,BaseRate,RateFloatType,RateFloat,PromisesFeeRatio,PromisesFeeSum",false);
				//--added by wwhe 2009-06-08 for:���ŷ���չʾ
				doTemp.setVisible("BusinessSubType,TasksFirstBatch,TotalSumFirstBatch",true);
				doTemp.setRequired("TasksFirstBatch,TotalSumFirstBatch",true);
				doTemp.setDDDWCode("BusinessSubType","CreditLineType");
			}else{
				doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			}
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,PhaseOpinion",true);
			//ҵ��Ʒ��Ϊ��ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡����гжһ�Ʊ���֡����뷵��ҵ��
			//����ס����������ٽ���ס�����������ҵ�÷�����������ٽ�����ҵ�÷����
			//����������Ѻ�������С�����ô�����˵�Ѻѭ��������˾�Ӫѭ�����
			//������Ѻ������˱�֤������˵�Ѻ�������Ӫ�������������������������
			//����ס��װ�޴�����ִ��������
			if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
			 || sBusinessType.equals("1020010")	|| sBusinessType.equals("2100")
			 || sBusinessType.equals("1110010") || sBusinessType.equals("1110020")
			 || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")
			 || sBusinessType.equals("1110050") || sBusinessType.equals("1110060")
			 || sBusinessType.equals("1110070") || sBusinessType.equals("1110080")
			 || sBusinessType.equals("1110090") || sBusinessType.equals("1110100") 
			 || sBusinessType.equals("1110110") || sBusinessType.equals("1110120") 
			 || sBusinessType.equals("1110130") || sBusinessType.equals("1110160"))
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			else//��ִ֮��������
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
		}	
		// added bllou 2011-12-23 ����ó�������಻��ʾ��ŵ���ʼ�����
		if("2050".equals(sBusinessType.substring(0,4)))  
		{
			doTemp.setVisible("PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("PromisesFeeRatio,PromisesFeeSum",false);
		}
			}
		}
		
		doTemp.setVisible("SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID,TermYear,BailCurrency,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
		//���ò��ɸ����ֶ�
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		//��������������
		doTemp.setDDDWCode("BusinessCurrency,BailCurrency","Currency");
		doTemp.setDDDWCode("RateFloatType","RateFloatType");
		//����ֻ������
		doTemp.setReadOnly("CustomerName,BusinessRate,InputOrgName,InputUserName,InputTime,PdgSum",true);
		//�༭��ʽΪ��ע��
		doTemp.setEditStyle("PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3","3");
		//�����ֶθ�ʽ
		doTemp.setType("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum,TasksFirstBatch,TotalSumFirstBatch","Number");
		doTemp.setCheckFormat("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,TotalSumFirstBatch","2");
		doTemp.setAlign("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,TasksFirstBatch,TotalSumFirstBatch","3");	
		doTemp.setType("TermMonth,TermDay","Number");
		doTemp.setCheckFormat("TermMonth,TermDay,TasksFirstBatch","5");
		doTemp.setAlign("TermMonth,TermDay","3");
		//����html��ʽ
		doTemp.setHTMLStyle("PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3"," style={height:100px;width:30%;overflow:scroll;font-size:9pt;} ");
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
		doTemp.appendHTMLStyle("PromisesFeeRatio","onchange=parent.getPromisesFreeRatio()");
		doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��׼�����ʱ�����ڵ���0,С�ڵ���100��\" ");
		//doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʸ���ֵ������ڵ���0,С�ڵ���100��\" ");
		doTemp.setHTMLStyle("TermDay"," onchange=parent.getTermDay() ");
		//--added by wwhe 2010-01-20 for:���������Զ���ȡ��׼����
		if(!sBusinessType.startsWith("2")){
			doTemp.appendHTMLStyle("TermMonth", " onBlur=\"javascript:parent.getApplyRate()\" ");
		}
		doTemp.setReadOnly("BailSum,BusinessCurrency,PromisesFeeSum",true);
		//�����ֶ�չʾλ�� added by wwhe 2009-05-04
		doTemp.setCheckFormat("BaseRate,BusinessRate","16");//--����С�����6λ
		//����ASDataWindow����		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
		dwTemp.Style="2";//freeform��ʽ
		
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
%>
	<%
		//����Ϊ��
			//0.�Ƿ���ʾ
			//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
			//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.��ť����
			//4.˵������
			//5.�¼�
			//6.��ԴͼƬ·��
		String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
		{"false","","Button","��ȷ���鿴/����","��ȷ���鿴/����","reDistribute()",sResourcesPath}
			};
		
		if(sBusinessType.equals("3010")){
			sButtons[2][0] = "true";
		}
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language="javascript">

	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		//���ʸ�����ʽ
		var sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		var sRateFloat = getItemValue(0,getRow(),"RateFloat");
		
		if("<%=sInputOrgID%>"=='02'&& ((sRateFloatType=="0" && sRateFloat<50) || (sRateFloatType=="1" && sRateFloat<0.5)))
		{
			alert("��С��ҵ���ڷ������ĵĸ������ʱ������50%");
		}
	
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//�������������޲���Ϊ0
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		iTermMonth = getItemValue(0,getRow(),"TermMonth");
		iTermDay = getItemValue(0,getRow(),"TermDay");
		
		if("<%=sPhaseNo%>"!="0010"&&"<%=sPhaseNo%>"!="3000"&&"<%=sBusinessType.startsWith("1020")%>"=="false"&&"<%=sBusinessType.startsWith("1130")%>"=="false")//--modified by wwhe 2009-05-04 for������ҵ��У��
		{
			if(dBusinessSum<=0 || (iTermMonth<0 && iTermDay<0))
			{
				alert(getBusinessMessage('679'));//�������������޲���Ϊ0��
				//alert("�������޺��������������0��");
				return;
			}
		}
		
		//--added by wwhe 2009-09-08 for:���Ŷ�ȷ�����ö�Ƚ��=�������У��
		if(!CheckCLSum())
			return;
		
		//--added by wwhe 2009-09-17 for��������Ϣ��������ϢУ��
		if(parseFloat(dBusinessSum)>"<%=dApplyBusinessSum%>"){
			alert("�������ܴ���������");
			return false;
		}
		
		//--added by wwhe 2010-01-12 for:�жһ�Ʊ���޲��ܴ���6����
		if("<%=sBusinessType.startsWith("2010")%>"=="true"){
			if(parseFloat(iTermMonth)>6){
				alert("�жһ�Ʊ���޲��ܴ���6����");
				return false;
			}
		}
		
		
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert(getHtmlMessage("����û��ǩ�������������ɾ�����������"));
	 	}
	 	else if(confirm("��ȷʵҪɾ�������"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("���ɾ���ɹ�!");
	  		}
	   		else
	   		{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
		}
		reloadSelf();
	} 
	
	function getTermDay()
	{
		sBusinessType = "<%=sBusinessType%>";
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 || parseInt(dTermDay) < 0)
	    {
	    	if(!(sBusinessType=="2050030") || !(sBusinessType=="2020"))
	        alert("���㡱����������ڵ���0,С�ڵ���30��");
	        return false;
	    }
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sOpinionNo);
	}
	
	/*~[Describe=����һ���¼�¼;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ���������������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sBusinessCurrency%>");
			setItemValue(0,getRow(),"BusinessSum","<%=sBusinessSum%>");
			setItemValue(0,getRow(),"TermMonth","<%=iTermMonth%>");
			setItemValue(0,getRow(),"TermDay","<%=iTermDay%>");
			setItemValue(0,getRow(),"BaseRate","<%=DataConvert.toMoney(dBaseRate)%>");
			setItemValue(0,getRow(),"RateFloatType","<%=sRateFloatType%>");
			setItemValue(0,getRow(),"RateFloat","<%=DataConvert.toMoney(dRateFloat)%>");
			setItemValue(0,getRow(),"BusinessRate","<%=dBusinessRate%>");
			setItemValue(0,getRow(),"BailCurrency","<%=sBailCurrency%>");
			setItemValue(0,getRow(),"BailRatio","<%=dBailRatio%>");
			setItemValue(0,getRow(),"BailSum",parseFloat("<%=dBailSum%>"));
			setItemValue(0,getRow(),"PromisesFeeSum","<%=dPromisesFeeSum%>");
			setItemValue(0,getRow(),"PromisesFeeRatio",parseFloat("<%=dPromisesFeeRatio%>"));
			setItemValue(0,getRow(),"PdgRatio","<%=dPdgRatio%>");
			setItemValue(0,getRow(),"PdgSum","<%=dPdgSum%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"BusinessSubType","<%=sBusinessSubType%>");//--added by wwhe 2009-06-08 for:չʾ��������ֶ�
			setItemValue(0,getRow(),"TasksFirstBatch","<%=sTasksFirstBatch%>");
			setItemValue(0,getRow(),"TotalSumFirstBatch","<%=sTotalSumFirstBatch%>");
			
		}        
	}
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{		
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");		
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" )
		{					
			if(sRateFloatType=="0")	//�����ٷֱ�
			{	
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:��������
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //ִ��������
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);			
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
		}
	}
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	   // sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(sPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=���ݳ��ںͳ�ŵ�ѱ��������ŵ�ѽ��;InputParam=��;OutPutParam=��;]~*/
	function getPromisesFreeRatio()
	{
	
		dBailSum = getItemValue(0,getRow(),"BailSum");
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0){
			dCKBalance = dBusinessSum - dBailSum ; 
		}
		
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPromisesFeeRatio = getItemValue(0,getRow(),"PromisesFeeRatio");
	        dPromisesFeeRatio = roundOff(dPromisesFeeRatio,2);
	        if(parseFloat(dPromisesFeeRatio) >= 0)
	        {	        
	            dPromisesFeeSum = parseFloat(dCKBalance)*parseFloat(dPromisesFeeRatio)/100;
	            dPromisesFeeSum = roundOff(dPromisesFeeSum,2);
	            setItemValue(0,getRow(),"PromisesFeeSum",dPromisesFeeSum);
	        }
	    }
	}
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
		/*Ĭ���뵱ǰ����һ��
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	    getPromisesFreeRatio();
	    getpdgsum();
	}
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio()
	{
	  //  sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	  //  sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
	        }
	    }
	}
	
	/*~[Describe=������·���   added by wwhe  2009-09-08;InputParam=��;OutPutParam=��;]~*/
	function reDistribute()
	{
		sParentLineID = RunMethod("CreditLine","GetLineIDByApplyNo","<%=sObjectNo%>");
		OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID="+sParentLineID+"&ToInheritObj=y&IsOpinion=y","_blank");
	}
	
	//���Ŷ�ȷ�����ö�Ƚ��=�������    added by wwhe  2009-09-08
	function CheckCLSum(){
		if("<%=sBusinessType%>" == "3010"){
			sObjectNo = getItemValue(0,getRow(),"ObjectNo");
			fUsableSum=RunMethod("BusinessManage","GetUsableSum","<%=sObjectNo%>");
			sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			if(fUsableSum != sBusinessSum){
				alert("�����������Ŷ�ȷ�����ö�Ƚ��ȣ������·������Ŷ�ȣ�");
				return false;
			}
		}
		return true;
	}
	//--added by wwhe 2010-01-20 for:�����Զ�����
	function getApplyRate()
	{
		var sRateType = getItemValue(0, getRow(), "RateType");
		if(sRateType != "010"){
			//ֻ��ҵ�����������ҵĽ��д���
		    var sBusinessCurrency = getItemValue(0, getRow(), "BusinessCurrency");
		    if (sBusinessCurrency != "01")
		        return;
	
		    sTermMonth = getItemValue(0, getRow(), "TermMonth");
		    sBusinessType = getItemValue(0,getRow(),"BusinessType");//--ҵ��Ʒ��
		    if(sTermMonth<=0)
		    {
		    	alert("������Ӧ����0");
		    	return;
		    }
		    if (typeof(sTermMonth) == "undefined" || sTermMonth.length == 0) sTermMonth = 0;
		    sTerm = sTermMonth;
		    if (sTerm > 0) {
		    	var sType = "dialogWidth=20;dialogHeight=15;center:yes;status:no;statusbar:no";
		    	sRate = PopPage("/CreditManage/CreditApply/GetApplyRate.jsp?Term=" + sTerm + "&RateType=010&rand=" + randomNumber(), "", sType);
				if (typeof(sRate) == "undefined" || sRate.length == 0 || sRate == "null")
		            setItemValue(0, getRow(), "BaseRate", "");
		        sPrintRate = sRate;
		        if (sPrintRate == null || sPrintRate == "")
		            sPrintRate = 0;
		        sPrintRate = roundOff(sPrintRate,6);
		        setItemValue(0, getRow(), "BaseRate", sPrintRate);
		        var sRateFloat = getItemValue(0, getRow(), "RateFloat");
		        if (isNaN(sRateFloat) || sRateFloat == "" || typeof(sRateFloat) == "undefined" || sRateFloat == null) {
		            setItemValue(0, getRow(), "BusinessRate", "");
		            setItemValue(0, getRow(), "FineBaseRate", "");
		        }else
		            getBusinessRate('Y');
			}
		}
	}
	
	</script>
<%
	/*~END~*/
%>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>