<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2010/10/14
		Tester:
		Describe:���ǽ�ݻ�����Ϣ
		Input Param:
			SerialNo:    ��ݱ��
			ObjectNo:	 ��ͬ��ˮ��
		Output Param:

		HistoryLog: pliu 2011.08.12
		            xlyu 2011.10.27
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ݻ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sCustomerID = "",sCustomerName = "";
	String sBusinessType= "";//ҵ��Ʒ��
	double dBusinessSum = 0.0;
	String sMfCustomerID = "";
	String sBusinessCurrency = "";
	String sRelativeOrgSortNo = "100";//�ϼ����������
	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	//���ҳ�����
	String sFinishDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FinishDate"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	if(sFinishDate == null) sFinishDate = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�ú�ͬ��Ϣ
	sSql =  " select CustomerID,CustomerName,BusinessSum,BusinessCurrency,BusinessType,getMfCustomerID(customerID) as MfCustomerID  "+
			" from BUSINESS_CONTRACT  "+
			" where SerialNo ='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		dBusinessSum = rs.getDouble("BusinessSum");
		sBusinessType = rs.getString("BusinessType");
		sMfCustomerID  = rs.getString("MfCustomerID");
		sBusinessCurrency  = rs.getString("BusinessCurrency");
		if(sMfCustomerID==null) sMfCustomerID = "";
	}
	rs.getStatement().close();
	//ȡ�ϼ�����SortNo
	sSql =  " select SortNo "+
			" from ORG_INFO  "+
			" where OrgID ='"+CurOrg.RelativeOrgID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sRelativeOrgSortNo = rs.getString("SortNo");
		if(sRelativeOrgSortNo==null) sRelativeOrgSortNo="100";
	}
	rs.getStatement().close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = null; 
	if(sBusinessType.equals("2010"))//���гжһ�Ʊ
	{ 
		sTempletNo ="MendHPInfo";     
	}else if(sBusinessType.startsWith("2020") || sBusinessType.equals("2050030") || sBusinessType.equals("2050020"))//��������֤����������֤����������֤
    { 
		sTempletNo ="MendLCInfo";
    }else if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040") || sBusinessType.equals("2050040"))//�����Ա����ͷ������Ա��������Ᵽ��
    { 
    	sTempletNo ="MendBHInfo";  
    }else { sTempletNo ="MendDuebillInfo"; }//�����ı���ҵ��
	
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//out.println(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if (!"".equals(sFinishDate) && sBusinessType.equals("2010"))
   	{
		dwTemp.ReadOnly = "1"; 
		
  	}else{
  		dwTemp.ReadOnly = "0";
  	}
 	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//System.out.println("#########source:"+doTemp.SourceSql);
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
		{"true","","Button","����","����","goBack()",sResourcesPath}
		};
	if (!"".equals(sFinishDate) && sBusinessType.equals("2010"))
   	{
		sButtons[0][0]="false";
   	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		
		if(vI_all("myiframe0"))
		{	            
			//¼��������Ч�Լ��
			if (!ValidityCheck()) return;
			if(bIsInsert)
			{
				beforeInsert();
				bIsInsert = false;
			}
				beforeUpdate();
			    as_save("myiframe0",sPostEvents);	
					
		}
	}

	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditPutOut/MendDueBillList.jsp","_self","");
	}
    	
 	

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		ddBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //���ʽ�ݽ��
		if("<%=sBusinessType%>"=="2010")//���гжһ�Ʊ
		{
			setItemValue(0,0,"Balance",ddBusinessSum);
		}
	}
    
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"BusinessType","<%=sBusinessType%>");
			setItemValue(0,0,"MfCustomerID","<%=sMfCustomerID%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"BusinessSum",amarMoney("<%=dBusinessSum%>",2));
			setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");	
			setItemValue(0,0,"RelativeSerialNo2","<%=sObjectNo%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");		
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");	
			bIsInsert = true;
		}
    }
	
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_DUEBILL";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "BD";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
	            //���гжһ�Ʊ�������Ա������������Ա���
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }	  
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		dBusinessSum = "<%=dBusinessSum%>";//��ͬ���
		sObjectNo = "<%=sObjectNo%>";//��ͬ��ˮ��
		ddBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //���ʽ�ݽ��
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--�����ˮ��
		sMaturity = getItemValue(0,getRow(),"Maturity"); //��Ʊ������
		sPutoutDate = getItemValue(0,getRow(),"PutoutDate"); //��Ʊ�ж���
		sBusinessType = "<%=sBusinessType%>";
		sCustomerID =  getItemValue(0,getRow(),"CustomerID");
		if(sBusinessType == "2010")
		{
			dReturn = RunMethod("WorkFlowEngine","DateExcute",sPutoutDate+",5,0");
			if(sMaturity > dReturn)
			{
				alert("�ж������費����6���£�");
				return false;
			}
		}
		dBalance = getItemValue(0,getRow(),"Balance"); //��ȡ���
		if(ddBusinessSum < dBalance)
		{
			if(sBusinessType=="2020" || sBusinessType=="2050030" || sBusinessType=="2050020")//����֤
			{
				alert("����֤�����С�ڿ�֤��");
				return false;
			}else if(sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 || sBusinessType == "2050040")
			{
				alert("�����С�ڱ�����");
				return false;
			}
		}
		//���еĽ�ݽ��ĺͱ���С�ں�ͬ�������������ý����Ϣ
		if(sBusinessType.indexOf("2") == 0)//���еı��ⲹ��ҵ��
		{
		    //��ý�ݽ��֮��
          	sReturn=RunMethod("BusinessManage","GetColSumValue",sObjectNo+","+sSerialNo);
          	if(typeof(sReturn) == "undefined" || sReturn.length==0 || sReturn=="Null" ) sReturn=0;
		    if(parseFloat(dBusinessSum) < (parseFloat(sReturn)+parseFloat(ddBusinessSum)))
		    {
		    	alert("����ҵ����֮����С�ڵ��ں�ͬ��");
		    	return false;
		    }
		    
			//����Ʊ�ݱ��Ψһ��
			sBillNo = getItemValue(0,getRow(),"BillNo");//Ʊ�ݺ�
			sReturn=RunMethod("BusinessManage","CheckBusinessBillNo",sSerialNo+","+sBillNo+","+sCustomerID+","+sObjectNo);
			if(typeof(sReturn) != "undefined" && sReturn.length!=0 && sReturn!="Null")
			{
				alert("Ʊ�ݺ��ظ�,������¼�룡");
		    	return false;
			}
	    }
	    //��ʾ:ҵ�����ʼ��Ӧ�����ڵ��ڽ���
	    if(sPutoutDate > "<%=StringFunction.getToday()%>")
	    {
	    	alert("��ʾ:ҵ�����ʼ��Ӧ���ڵ��ڽ��죡");
	    }
		return true;
	}

	/*~[Describe=�������˻���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectMFOrg()
	{	
		if("<%=sBusinessType%>"=="2050030")//��������֤
		{
			sParaString = "SortNo,100900";
			setObjectValue("SelectBelongWholeOrg",sParaString,"@MFOrgID@0@MFOrgName@1",0,0,"");
		}else{
			if("<%=CurOrg.OrgLevel%>"=="6")//����֧��
			{
				sParaString = "SortNo,<%=sRelativeOrgSortNo%>";
				setObjectValue("SelectBelongWholeOrg",sParaString,"@MFOrgID@0@MFOrgName@1",0,0,"");
			}else{
				sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
				setObjectValue("SelectBelongWholeOrg",sParaString,"@MFOrgID@0@MFOrgName@1",0,0,"");	
			}
		}
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
