<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
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
	History Log: lpzhang �������õȼ������϶���Ϣ 2009-8-25 
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//�������
	String sSql = "",sFlowNo = "",sPhaseNo = "";
	String sCustomerID = "",sCustomerName = "",sBusinessCurrency = "";
	String sBailCurrency = "",sRateFloatType = "",sBusinessType = "";
	String sOccurType = "",sBusinessSum = "",sPdgSum="", sBailSum ="";
	double dBusinessSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0;
	double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0;
	int iTermYear = 0,iTermMonth = 0,iTermDay = 0,dOldTermMonth = 0,dOldTermDay = 0;
	String sCustomerType ="",sEvaluateSerialNo="",sApplyType="";
	//���õȼ���Ϣ
	String sEvaluateResult="",sCognResult="",sModelNo="",sTransformMethod ="",sModelDescribe="",Sql1="",sSmallEntFlag="";
	double dCognScore =0.0,dEvaluateScore=0.0;
	ASResultSet rs = null,rs1 = null;
	
	//��ȡ���������������ˮ�š������š���������
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
  <%	
	//���ݶ������ͺͶ����Ż�ȡ��Ӧ��ҵ����Ϣ
	sSql = 	" select CustomerID,CustomerName,BusinessCurrency,BusinessSum, "+
			" BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,BusinessType,TermYear, "+
			" TermMonth,TermDay,OccurType,ApplyType "+
			" from BUSINESS_APPLY "+
			" where SerialNo = '"+sObjectNo+"' ";
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
		dPdgRatio = rs.getDouble("PdgRatio");
		dPdgSum = rs.getDouble("PdgSum");
		sBusinessType = rs.getString("BusinessType");
		iTermYear = rs.getInt("TermYear");
		iTermMonth = rs.getInt("TermMonth");
		iTermDay = rs.getInt("TermDay");
		sOccurType = rs.getString("OccurType");
		sApplyType = rs.getString("ApplyType");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		if(sRateFloatType == null) sRateFloatType = "";
		if(sBailCurrency == null) sBailCurrency = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		//ת��������ʾ��ʽ
		if(dBusinessSum > 0)
			sBusinessSum = DataConvert.toMoney(dBusinessSum);
		if(dBailSum > 0)
			sBailSum = DataConvert.toMoney(dBailSum);
		if(dPdgSum > 0)
			sPdgSum = DataConvert.toMoney(dPdgSum);						
	}
	rs.getStatement().close();
	
	
	//ȡ�ÿͻ����õȼ�������Ϣ add by lpzhang 2009-8-24
	sSql = "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"'";
	sCustomerType = Sqlca.getString(sSql);
	if(sCustomerType == null) sCustomerType="";
	
	if( ("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") && sObjectType.equals("CreditApply"))
	{
		String sCustomerFlag="";
		if(sCustomerType.startsWith("03"))
		{
			sCustomerFlag = "IND_INFO";
			sModelNo = Sqlca.getString("select CreditBelong from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'");
			
		}else{
			sCustomerFlag = "ENT_INFO";
			sSql ="select CreditBelong,SmallEntFlag from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sModelNo = rs.getString("CreditBelong");
				sSmallEntFlag  = rs.getString("SmallEntFlag");
				
				if(sModelNo == null) sModelNo ="";
				if(sSmallEntFlag == null) sSmallEntFlag ="";
			}
			rs.getStatement().close();
		}
		
		if (sModelNo != null  && !sModelNo.equals("")) 
		{
			Sql1 = "select TransformMethod,ModelDescribe from EVALUATE_CATALOG where ModelNo = '"+sModelNo+"'";
			rs1 = Sqlca.getASResultSet2(Sql1);
			if(rs1.next())
			{
				sTransformMethod = rs1.getString("TransformMethod");
				sModelDescribe = rs1.getString("ModelDescribe");
				if(sTransformMethod == null) sTransformMethod ="";
				if(sModelDescribe == null) sModelDescribe ="";
			}
			rs1.getStatement().close();
		}
		
	}
	//ȡչ��ԭ��ͬ���޺�����
	if(sOccurType.equals("015")){
		sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT "+
			" where SerialNo = (select relativeserialno2 from BUSINESS_DUEBILL "+
			" where SerialNo=(select ObjectNo from APPLY_RELATIVE  where ObjectType = 'BusinessDueBill' "+ 
			" and SerialNo = '"+sObjectNo+"'))";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			dOldTermMonth = rs.getInt("TermMonth");
			dOldTermDay = rs.getInt("TermDay");
		}
		rs.getStatement().close();
	}
	String sHeaders[][]={                       
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"BusinessCurrency","ҵ�����"},
	                        {"BusinessSum","�������"},
	                        {"TermMonth","����"},
	                        {"TermDay","��"},
	                        {"BaseRate","��׼������(%)"},
	                        {"RateFloatType","���ʸ�����ʽ"},
	                        {"RateFloat","���ʸ���ֵ"},
	                        {"BusinessRate","ִ��������(��)"},
	                        {"BailCurrency","��֤�����"},
	                        {"BailRatio","��֤�����(%)"},	
	                       	{"BailSum","��֤����"},                         
	                        {"PdgRatio","��������(��)"},
	                        {"PdgSum","�����ѽ��(Ԫ)"},
	                        {"SystemScore","ϵͳ�����÷�"},
	                        {"SystemResult","ϵͳ�������"},
	                        {"CognScore","�˹������÷�"},
	                        {"CognResult","�˹��������"},
	                        {"PhaseChoice","����������"},
	                        {"PhaseOpinion","���˵��"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        };                    
	String sHeaders1[][]={                       
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"BusinessCurrency","ҵ�����"},
	                        {"BusinessSum","�������"},
	                        {"TermMonth","����"},
	                        {"TermDay","��"},
	                        {"BaseRate","��׼������(%)"},
	                        {"RateFloatType","���ʸ�����ʽ"},
	                        {"RateFloat","���ʸ���ֵ"},
	                        {"BusinessRate","ִ��������(��)"},
	                        {"BailCurrency","��֤�����"},
	                        {"BailRatio","��֤�����(%)"},	                        
	                        {"BailSum","��֤����"},	                        
	                        {"PdgRatio","��������(��)"},
	                        {"PdgSum","�����ѽ��(Ԫ)"},
	                        {"SystemScore","ϵͳ�����÷�"},
	                        {"SystemResult","ϵͳ�������"},
	                        {"CognScore","�˹������÷�"},
	                        {"CognResult","�˹��������"},
	                        {"PhaseChoice","����������"},
	                        {"PhaseOpinion","���˵��"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        }; 	
    String sHeaders2[][]={                       
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"BusinessCurrency","չ�ڱ���"},
	                        {"BusinessSum","չ�ڽ��"},
	                        {"TermMonth","չ������"},
	                        {"TermDay","��"},
	                        {"BaseRate","��׼������(%)"},
	                        {"RateFloatType","���ʸ�����ʽ"},
	                        {"RateFloat","���ʸ���ֵ"},
	                        {"BusinessRate","չ��ִ��������(��)"},
	                        {"BailCurrency","��֤�����"},
	                        {"BailRatio","��֤�����(%)"},		                        
	                        {"BailSum","��֤����"},                        
	                        {"PdgRatio","��������(��)"},
	                        {"PdgSum","�����ѽ��(Ԫ)"},
	                        {"SystemScore","ϵͳ�����÷�"},
	                        {"SystemResult","ϵͳ�������"},
	                        {"CognScore","�˹������÷�"},
	                        {"CognResult","�˹��������"},
	                        {"PhaseChoice","����������"},
	                        {"PhaseOpinion","���˵��"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        }; 	
    String sHeaders3[][]={                       
				    		{"PhaseChoice","������"},
				            {"PhaseOpinion","���˵��"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        };  
	//����SQL���
	sSql = 	" select SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID, "+
			" CustomerName,BusinessCurrency,BusinessSum,TermYear,TermMonth, "+
			" TermDay,BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailRatio,BailSum,PdgRatio,PdgSum,"+
			" SystemScore as SystemScore,SystemResult as SystemResult,"+//ϵͳ�����÷֣�ϵͳ�������
 			" CognScore as CognScore,CognResult as CognResult,"+//�˹����֣��˹��������
			" PhaseChoice,PhaseOpinion,InputOrg, "+
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
			doTemp.setHeader(sHeaders); 
		}
	}
	
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	doTemp.setUnit("TermMonth","��");
	doTemp.setUnit("TermDay","��");
	doTemp.setReadOnly("BaseRate,BusinessCurrency,BailCurrency,RateFloatType,CustomerName,BusinessRate,InputOrgName,InputUserName,InputTime",true);
	doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
	doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
	doTemp.setHTMLStyle("BusinessSum"," onchange=parent.getBailPdgSum() ");
	
	//�����ֶ��Ƿ�ɼ��ͱ�����	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //�����ʼ�׶κͷ��ز������Ͻ׶�
	{
		doTemp.setVisible("CustomerName,BusinessCurrency,BusinessSum,BusinessRate,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum",false);
		doTemp.setHeader("PhaseChoice","�������");
		doTemp.setRequired("PhaseOpinion",true);
	}else
	{
		if(sOccurType.equals("015"))//��������Ϊչ��
		{
			doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PhaseOpinion",true);
	//		doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
		}else
		{
			if(sPhaseNo.equals("0020"))
			{
				doTemp.setHeader("BusinessSum","������");
				doTemp.setHeader("PhaseChoice","�������");
			}
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum,PhaseChoice,PhaseOpinion",true);
			//��������֤����������֤,���Ᵽ��,
			if(sBusinessType.equals("2050020") || sBusinessType.equals("2050030")|| sBusinessType.equals("2050010")
												|| sBusinessType.equals("2050040")){
				doTemp.setVisible("TermMonth",false);
				doTemp.setRequired("TermMonth",false);
			}
			//�������Ա���,�����Ա���,�������,��������֤,���Ᵽ��
			if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040")|| sBusinessType.equals("2050010") 
												|| sBusinessType.equals("2050030") || sBusinessType.equals("2050040")
												|| sBusinessType.equals("2050020")){
				doTemp.setVisible("TermDay",false);
				doTemp.setRequired("TermDay",false);
			}
			//����ס�����������
			if("1110027".equals(sBusinessType)){
				doTemp.setVisible("RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setRequired("RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setReadOnly("BusinessSum,TermMonth,TermDay",true);
			}
			//���гжһ�Ʊ,��������֤,�����Ա���,�������Ա���,����ó������,�����ŵ,����
			if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040") || sBusinessType.startsWith("2050")
												|| sBusinessType.startsWith("2080") || sBusinessType.startsWith("2090") 
												|| sBusinessType.equals("2010") || sBusinessType.equals("2020") ){
				doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setRequired("BaseRate,RateFloatType,RateFloat,BusinessRate",false);										
			}
			//1110010
			/*if(sBusinessType.startsWith("1010") || sBusinessType.startsWith("1020") || sBusinessType.startsWith("1030")
												|| sBusinessType.startsWith("1040") || sBusinessType.startsWith("1050") 
												|| sBusinessType.equals("1056") || sBusinessType.equals("1054")
												|| sBusinessType.equals("1060") || sBusinessType.startsWith("1080")
												|| sBusinessType.startsWith("1090") || sBusinessType.startsWith("1100")
												|| (sBusinessType.startsWith("1110") && !(sBusinessType.equals("1110070")))
												|| sBusinessType.startsWith("1140")
												|| sBusinessType.startsWith("2060") || sBusinessType.equals("2070") 
												|| sBusinessType.equals("2100") || (sBusinessType.startsWith("1150")&& !sBusinessType.equals("1150020") )){
				doTemp.setVisible("BailSum,BailRatio",false);
				doTemp.setRequired("BailSum,BailRatio",false);								
			}
			*/
			//���ڱ���
			if("1090010".equals(sBusinessType)){
				doTemp.setVisible("PdgSum",false);
				doTemp.setRequired("PdgSum",false);
			}
			
			//
			/*if(!(sBusinessType.equals("2010") || sBusinessType.equals("2020") || sBusinessType.startsWith("2030")
											  || sBusinessType.startsWith("2040") || sBusinessType.startsWith("2050") 
											  || sBusinessType.startsWith("2060") || sBusinessType.equals("2070")
											  || sBusinessType.startsWith("2080") || sBusinessType.startsWith("2090")
											  || sBusinessType.equals("2110040") || sBusinessType.equals("2110050")
											  )){
				doTemp.setVisible("PdgSum,PdgRatio",false);
				doTemp.setRequired("PdgSum,PdgRatio",false);							
			}
			*/
			if(sBusinessType.startsWith("30"))//�ۺ����Ŷ��
				doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);//BusinessRate,BaseRate,RateFloatType,RateFloat
				doTemp.setRequired("BailSum,BailRatio,PdgRatio,PdgSum",false);
		}
	}

	doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
	
	//������������ʱ�����ʾ��
	doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",false);
	if(("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply"))
	{
		doTemp.setReadOnly("SystemScore,SystemResult,CognResult",true);
		if(!(sBusinessType.equals("1056") || sBusinessType.equals("1054")) && !sSmallEntFlag.equals("1") && !sCustomerType.startsWith("03"))
			doTemp.setRequired("CognScore,CognResult,SystemScore,SystemResult",true);
		doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",true);
		//�˹��϶�����
		doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
		doTemp.setAlign("SystemScore,CognScore","3");
		doTemp.setType("SystemScore,CognScore","Number");
	}

	//ͬҵ���ʱ��ֻ��ʾ���Ŷ�ȼ����޵� 2009-12-23 lpzhang
	if(sBusinessType.equals("3015"))
	{
		doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",false);
		doTemp.setReadOnly("RateFloatType",false);
	}
	
	//�����ۺ�����/��˾�ۺ����Ŷ�ȣ�����ʾ 2010/06/22 xhyong
	if(sBusinessType.equals("3040")||sBusinessType.equals("3060")||sBusinessType.equals("3010"))
	{
		doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
		doTemp.setRequired("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
	}
	//��Ա���ҵ�������ѽ��Ϊ���޸�
	if(sBusinessType.startsWith("2030")||sBusinessType.startsWith("2040"))
	{
		doTemp.setReadOnly("PdgSum",false);
	}else{
		doTemp.setReadOnly("PdgSum",true);
	}
	doTemp.setVisible("SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID,TermYear,BailCurrency,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	//��������������
	doTemp.setDDDWCode("BusinessCurrency,BailCurrency","Currency");
	doTemp.setDDDWCode("RateFloatType","RateFloatType");
	doTemp.setDDDWCode("PhaseChoice","PhaseChoice");
	//�༭��ʽΪ��ע��
	doTemp.setEditStyle("PhaseOpinion","3");
	//�������
	doTemp.setRequired("PhaseChoice",true);
	//�����ֶθ�ʽ
	doTemp.setType("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","Number");
	doTemp.setCheckFormat("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","2");
	doTemp.setAlign("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","3");	
	
	doTemp.setType("TermMonth,TermDay","Number");
	doTemp.setCheckFormat("TermMonth,TermDay","5");
	doTemp.setAlign("TermMonth,TermDay","3");
	//����html��ʽ
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:30%;overflow:scroll;font-size:9pt;} ");
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��׼�����ʱ�����ڵ���0,С�ڵ���100��\" ");
	//doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʸ���ֵ������ڵ���0,С�ڵ���100��\" ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("TermDay"," onchange=parent.getTermDay() ");	
	doTemp.setReadOnly("BailSum",true);
	//������ʾС��λ��Ϊ6λ
	doTemp.setCheckFormat("BusinessRate","16");
	//�Զ���ȡ�������ͺ�����ֵ
	if(!sBusinessType.startsWith("3")){
		doTemp.appendHTMLStyle("TermMonth,TermDay","onBlur=\"javascript:parent.getBaseRateType()\" ");
	}
	if((sFlowNo.equals("EntCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1) || (sFlowNo.equals("IndCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1))
	{
		doTemp.setReadOnly("PhaseChoice",true);
	}
	
	//����ASDataWindow����		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform��ʽ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"false","","Button","��ȡ��������","��ȡ��������","getEvaluate()",sResourcesPath},
			{"false","","Button","�������","�������","OpinionSummary()",sResourcesPath},
		};

	if( ("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") && 
		sObjectType.equals("CreditApply"))
		{
			sButtons[2][0] = "true";
		}
	
	if((sFlowNo.equals("EntCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1) || (sFlowNo.equals("IndCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1))
	{
		sButtons[3][0] = "true";
	}
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language="javascript">
	var iCount = 0;
	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		//֧������С���鳤�����غ��д�������Ρ��к��д�������βŽ���˼�顣lpzhang
		sPhaseNo = "<%=sPhaseNo%>";
		sFlowNo = "<%=sFlowNo%>";
		
		if((sFlowNo == "CreditFlow03" && sPhaseNo =="0270") || 
		   (sFlowNo == "EntCreditFlowTJ01" || sFlowNo == "IndCreditFlowTJ01")&& (sPhaseNo =="0050" || sPhaseNo =="0170" || sPhaseNo =="0300"))
		{
			if (!ValidityCheck()) return;
		}
		//���³�/���³����к����г��Ž���˼�飡
		/*
		if((sFlowNo == "EntCreditFlowTJ01" || sFlowNo == "IndCreditFlowTJ01")&& (sPhaseNo =="0060" || sPhaseNo =="0180" || sPhaseNo =="0310")){
			if(!ValidityCheck1()) return;
		}
		*/
		//�������������޲���Ϊ0
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		iTermMonth = getItemValue(0,getRow(),"TermMonth");
		iTermDay = getItemValue(0,getRow(),"TermDay");
		sBusinessType ="<%=sBusinessType%>";
		if(sBusinessType!="2050020" && sBusinessType !="2050030" && sBusinessType!="2050010"  && sBusinessType.substring(0,4)!="2030" && sBusinessType.substring(0,4)!="2040" )
		{
			if("<%=sPhaseNo%>"!="0010"&&"<%=sPhaseNo%>"!="3000")
			{
				if(dBusinessSum<=0 || iTermMonth+iTermDay<=0)
				{
					alert(getBusinessMessage('679'));//�������������޲���Ϊ0��
					//alert("�������޺��������������0��");
					return;
				}
			}
		}
		
		var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			var sTaskNo = "<%=sSerialNo%>";
			var sReturn = RunMethod("WorkFlowEngine","CheckOpinionInfo",sTaskNo);
			if(!(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null" || sReturn == "null" || sReturn == "NULL")){
				alert("�˱�ҵ����ǩ���������ˢ��ҳ����ǩ�������");
				return;
			}
			initOpinionNo();
		}
		
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	//������С����ߴ�����Ա�Ƿ��ύ���
	function ValidityCheck()
	{
		sSerialNo = "<%=sSerialNo%>";
		sPhaseNo = "<%=sPhaseNo%>";
		sObjectType = "<%=sObjectType%>";
		sObjectNo = "<%=sObjectNo%>";
		sPhaseChoice = getItemValue(0,getRow(),"PhaseChoice");
		
		sNoSubmitUser=RunMethod("WorkFlowEngine","GetNoTaskSubmit",sSerialNo+","+sObjectType+","+sObjectNo);
	
		if(typeof(sNoSubmitUser)!="undefined" && sNoSubmitUser.length!=0) {
			sNoSubmitUser = sNoSubmitUser.substr(1,sNoSubmitUser.length);
			alert("�Բ��𣬸�����ҵ����С���Ա��"+sNoSubmitUser+"��δ�ύ��������ǩ�������");
			return false;
		}
		//ȡ���Ͻ׶κ�
		sSuperPhaseNo = RunMethod("WorkFlowEngine","GetSuperPhaseNo",sPhaseNo+","+sObjectType+","+sObjectNo);
		//�Ͻ׶�ͬ������
		dAgreeNum=RunMethod("WorkFlowEngine","GetAgreeNum",sSuperPhaseNo+","+sObjectType+","+sObjectNo);
		//�Ͻ׶ηַ�����
		dDispenseTotalNum=RunMethod("WorkFlowEngine","GetDispenseTotalNum",sSuperPhaseNo+","+sObjectType+","+sObjectNo);
		if(parseFloat(dAgreeNum)/parseFloat(dDispenseTotalNum) < 2/3) {  //��ͬ��
			if(sPhaseChoice == "01")
			{
				alert("������Ա��ͬ��˱�ҵ�����룬������ǩ��ͬ�⡱��");
				getASObject(0,0,"PhaseChoice").focus();
				return false;
			}
		}
		return true;
	}
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function OpinionSummary()
	{
		sFlowNo="<%=sFlowNo%>";
		sPhaseNo="<%=sPhaseNo%>";
		sObjectNo = "<%=sObjectNo%>";
		sCompID = "OpinionSummaryList";
		sCompURL = "/Common/WorkFlow/OpinionSummaryList.jsp";
		sReturn = popComp(sCompID,sCompURL,"FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
			if(sReturn=="��ͬ��")
			{	
				setItemValue(0,getRow(),"PhaseChoice","02");
				setItemDisabled(0,0,"PhaseChoice",true);
      			getASObject(0,0,"PhaseChoice").style.background ="#efefef";
			}else if(sReturn=="ͬ��"){
				setItemValue(0,getRow(),"PhaseChoice","01");
      			setItemDisabled(0,0,"PhaseChoice",false);
	  		    getASObject(0,0,"PhaseChoice").style.background ="WHITE";
			}
			
		}
	}
	
	//���³�/���³����к����г� ���ǰһ�׶ε����
	function ValidityCheck1(){
		sPhaseChoice = getItemValue(0,getRow(),"PhaseChoice");
		sPhaseNo = "<%=sPhaseNo%>";
		sObjectType = "<%=sObjectType%>";
		sObjectNo = "<%=sObjectNo%>";
		sReturn = RunMethod("WorkFlowEngine","GetAgreement",sPhaseNo+","+sObjectType+","+sObjectNo);
		if(sPhaseChoice == "01" && sReturn !="01"){
			alert("����᲻ͬ��˱�ҵ�����룬������ǩ��ͬ�⡱��");
			getASObject(0,0,"PhaseChoice").focus();
			return false;
		}
		return true;
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
	
	/*~[Describe=��ȡ����������Ϣ;InputParam=��;OutPutParam=��;]~*/
    function getEvaluate()
    {
    	EvaluateResult = PopPage("/Common/WorkFlow/getEvaluateResult.jsp?rand="+randomNumber()+"&CustomerID=<%=sCustomerID%>","","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
    	
    	if(typeof(EvaluateResult) == "undefined" || EvaluateResult == "")
	 	{
	   		alert("�ÿͻ�û���κ����õȼ�������¼�����Ƚ������õȼ�������");
	   		return;
	 	}else
	 	{
	    	EvaluateResultMember = EvaluateResult.split('@');
			dEvaluateScore = EvaluateResultMember[0];
			sEvaluateResult = EvaluateResultMember[1];
			dCognScore = EvaluateResultMember[2];
			sCognResult = EvaluateResultMember[3];
	   
	 		setItemValue(0,getRow(),"SystemScore",roundOff(dEvaluateScore,2));
	 		setItemValue(0,getRow(),"SystemResult",sEvaluateResult);
	 		setItemValue(0,getRow(),"CognScore",roundOff(dCognScore,2));
	 		setItemValue(0,getRow(),"CognResult",sCognResult);
	 	}
	 	
	} 
	
	function getTermDay()
	{
		sBusinessType = "<%=sBusinessType%>";
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 || parseInt(dTermDay) < 0)
	    {
	    	if(!(sBusinessType=="2050030") || !(sBusinessType=="2020"))
	        alert("���㡱����������ڵ���0,С�ڵ���30��");
	    }
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
		var sOpinionNo ="";						
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if((typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0 || sOpinionNo== 'Null' || sOpinionNo== 'null') )
		{
			alert("�뽵��IE�������ȫ���ã�");
			return;
		}
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
			setItemValue(0,getRow(),"BailSum","<%=sBailSum%>");
			setItemValue(0,getRow(),"PdgRatio","<%=dPdgRatio%>");
			setItemValue(0,getRow(),"PdgSum","<%=sPdgSum%>");
			
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
		}        
	}
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		if("<%=sObjectType%>" == "ReinforceContract")
		{
			return;
		}
	
		//ҵ������
		sBusinessType = "<%=sBusinessType%>";
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
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
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}
	}
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//��ȡ�����ѱ���
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	
	/*~[Describe=���ݷ�ֵ�����������;InputParam=��;OutPutParam=��;]~*/
	function setResult(){		
		//������ֵ�������
		//��Ҫ���ݾ���������е���
		var CognScore = getItemValue(0,getRow(),"CognScore");
		if(CognScore<0 || CognScore>100){
			alert("����������0��100֮�䣡");
			setItemValue(0,getRow(),"CognScore","");
			setItemValue(0,getRow(),"CognResult","");
			setItemFocus(0,getRow(),"CognScore");
			return;
		}
		sModelDescribe = "<%=sModelDescribe%>";
		if(typeof(sModelDescribe) != "undefined" && sModelDescribe != "") 
		{			
			var my_array = new Array();
			var str_array = new Array();
			my_array = sModelDescribe.split(",");
			for(var i=0;i<my_array.length;i++)
			{ 
				str_array = my_array[i].split("&");
				if(checkResult(str_array[0],str_array[1],CognScore))
				{
					result = str_array[2];
					setItemValue(0,getRow(),"CognResult",result);
					return;
				}
			}
			
		}else
		{
			alert("����ģ�����ô�������ϵ����Ա��");
		}			

	}
	//�������õȼ��������Խ��
	function checkResult(sSign,dNum,dCognScore)
	{
		if(sSign == "=")
		{
			if(dCognScore == dNum)
				return true;
			else
				return false;
		}else if(sSign == ">")
		{
			if(dCognScore > dNum)
				return true;
			else
				return false;
		}else if(sSign == ">=")
		{
			if(dCognScore >= dNum)
				return true;
			else
				return false;
		}else if(sSign == "<")
		{
			if(dCognScore < dNum)
				return true;
			else
				return false;
		}else if(sSign == "<=")
		{
			if(dCognScore <= dNum)
				return true;
			else
				return false;
		}else if(sSign == "<>")
		{
			if(dCognScore != dNum)
				return true;
			else
				return false;
		}else 
			return false;
		
	}
	
	function getBailPdgSum(){
		getpdgsum();
		getBailSum();
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	   // sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType="<%=sBusinessType%>";
	    if(parseFloat(dBusinessSum) >= 0 && sBusinessType.substring(0,4)!="2040" && sBusinessType.substring(0,4)!="2030")
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
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
   		dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	dBailRatio = getItemValue(0,getRow(),"BailRatio"); //��ȡ��֤�����
	        if(parseFloat(dBailRatio) >= 0)
	        {	
	        	dBailRatio = roundOff(dBailRatio,2);	        	
	        	sBusinessType = "<%=sBusinessType%>";
		        sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		        sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		        ddBailSum = 0.00;
		        dERateRatio = 1.00;
		        if(typeof(sBailCurrency) == "undefined" || sBailCurrency == "" ){
		        	sBailCurrency = "01";
		        }
		        if(sBusinessCurrency == sBailCurrency){
		           	dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
		        }
	 			else{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
	            	dBailSum = parseFloat(dBusinessSum*dERateRatio)*parseFloat(dBailRatio)/100;
	            }		        
           		dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }	    
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
	
	//�Զ���ȡ�������� 
	function getBaseRateType(){
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
		 sBaseRateID = "";
		 if(sBusinessCurrency=='01')//�����
		 {
			 if("<%=sOccurType%>" == "015"){
			 	if(typeof(dTermDay) == "undefined" && dTermDay == "" ){
			 		dTermDay = 0;
			 	}
			 	dTermDay = dTermDay + <%=dOldTermDay%>;
			 	if(dTermDay/30 >1){
			 		dTermMonth = dTermMonth + 2;
			 	}
			 	else if(dTermDay>0){
			 		dTermMonth = dTermMonth + 1;
			 	}
			 	dTermMonth = dTermMonth + <%=dOldTermMonth%>;
			 }else if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			 {
			 	dTermMonth = dTermMonth+1; 
			 }
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		 }else{//���
		 	if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//��ҹ
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//һ��
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//����
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//һ����
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//������
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//������
			 }else{
			 	sBaseRateID = "20070";//ʮ������
			 }
		 }
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 //sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		 sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
	     if(typeof(sReturn) != "undefined" && sReturn != ""){
	     	setItemValue(0,0,"BaseRate",sReturn);
	     } 	    
		getBusinessRate("M");
	}	
	
	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
	</script>
<%/*~END~*/%>


<script language=javascript>	
	AsOne.AsInit();
	init();
//bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>