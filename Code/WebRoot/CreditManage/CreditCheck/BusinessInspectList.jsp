<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �������б�
		Input Param:
			InspectType��  �������� 
				010     ������;��鱨��
	            010010  δ���
	            010020  �����
	            020     �����鱨��
	            020010  δ���
	            020020  �����
		Output Param:
			SerialNo:��ˮ��
			ObjectType:��������
			ObjectNo��������
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//����������
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
    if(sInspectType == null) sInspectType="020010";
    String sOrgFlag = Sqlca.getString("select OrgFlag from Org_Info where orgid = '"+CurOrg.OrgID+"'");
    if(sOrgFlag ==null) sOrgFlag = "";
    boolean bIsCheckUser = false;
    if (CurUser.hasRole("040") || CurUser.hasRole("240")|| CurUser.hasRole("000")){
    	bIsCheckUser = true;
    }
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = null;
  	//�״μ�鱨���б�
  	if(sInspectType.equals("010010") || sInspectType.equals("010020"))
  	{
	  	String sHeaders1[][] = {
								{"CustomerName","�ͻ�����"},
								{"BusinessTypeName","ҵ��Ʒ��"},
								{"BCSerialNo","��ͬ��ˮ��"},
								{"Currency","����"},
								{"BusinessSum","��ͬ���"},
								{"PutOutDate","��ͬ��Ч����"},
								{"InspectType","�������"},
								{"UpDateDate","��������"},
								{"InputUser","�����"},
								{"InputOrg","��������"},
								};

	  	String sSql1 =  " select II.SerialNo as SerialNo,II.ObjectNo as ObjectNo,II.ObjectType as ObjectType,"+
						" BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
						" getBusinessName(BusinessType) as BusinessTypeName,"+
						" getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			            " BC.BusinessType as BusinessType ,"+
			            " BC.SerialNo as BCSerialNo,"+
			            " BC.BusinessSum as BusinessSum,BC.PutOutDate,"+
						" getItemName('InspectType',II.InspectType) as InspectType,"+
						" II.UpdateDate as UpdateDate,"+
						" getUserName(II.InputUserID) as InputUser,"+
						" getOrgName(II.InputOrgId) as InputOrg"+
						" from INSPECT_INFO II,BUSINESS_CONTRACT BC "+
						" where II.ObjectType='BusinessContract' "+
		                " and II.InspectType like '010%' "+
		                " and II.ObjectNo=BC.SerialNo ";
		if(bIsCheckUser){
			sSql1 += " and II.InputOrgId in(select OrgId from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
		}
		else{
			sSql1 += " and II.InputUserID='"+CurUser.UserID+"'";
		}                
	    String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if(sInspectType.equals("010010"))
		{
			if(sDBName.startsWith("INFORMIX"))
				sSql1=sSql1+" and (II.FinishDate = '' or II.FinishDate is null) order by II.UpDateDate desc";
			else if(sDBName.startsWith("ORACLE"))
				sSql1=sSql1+" and (II.FinishDate = ' ' or II.FinishDate is null) order by II.UpDateDate desc";
			else if(sDBName.startsWith("DB2"))
				sSql1=sSql1+" and (II.FinishDate = '' or II.FinishDate is null) order by II.UpDateDate desc";
		}
		else
		{
			if(sDBName.startsWith("INFORMIX"))
				sSql1=sSql1+" and II.FinishDate <> '' and II.FinishDate is not null order by II.FinishDate desc";
			else if(sDBName.startsWith("ORACLE"))
				sSql1=sSql1+" and II.FinishDate <> ' ' and II.FinishDate is not null order by II.FinishDate desc";
			else if(sDBName.startsWith("DB2"))
				sSql1=sSql1+" and II.FinishDate <> '' and II.FinishDate is not null order by II.FinishDate desc";
		}
		//��SQL������ɴ������
		doTemp = new ASDataObject(sSql1);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "INSPECT_INFO";
		//���ùؼ���
		doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
		doTemp.setHeader(sHeaders1);
		//���ò��ɼ���
		doTemp.setVisible("SerialNo,ObjectNo,BusinessType,ObjectType,InspectType,CustomerID",false);
		doTemp.setUpdateable("BusinessTypeName,BusinessType,BusinessSum,CustomerName",false);
		doTemp.setAlign("BusinessSum,Balance","3");
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.setCheckFormat("BusinessSum,Balance","2");
		
		doTemp.setColumnAttribute("BCSerialNo,CustomerName,BusinessSum,InputUser,InputOrg","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	  	//����html��ʽ
	  	//doTemp.setHTMLStyle("UpdateDate,BusinessSum"," style={width:80px} ");
	  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
	  	doTemp.setHTMLStyle("ObjectNo,CustomerName,BusinessTypeName"," style={width:120px} ");
 	}
  	//�����鱨���б�
  	else if(sInspectType.equals("020010") || sInspectType.equals("020020") || sInspectType.equals("040010") || sInspectType.equals("040020"))
  	{
    	String sHeaders2[][] = {
								{"CustomerName","�ͻ�����"},
								{"ObjectNo","�ͻ����"},
								{"InspectType","�������"},
								{"UpdateDate","��������"},
								{"InputUserName","�����"},
								{"InputOrgName","��������"}							
							  };
		String sSql2 = "";
		if(sInspectType.equals("020010") || sInspectType.equals("020020")){
		  	sSql2 =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
							" getItemName('InspectType',InspectType) as InspectType,"+
				            " UpdateDate,InputUserID,InputOrgID,"+
				            " getUserName(InputUserID) as InputUserName,"+
				            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
							" from INSPECT_INFO"+
							" where ObjectType='Customer' "+
			                " and InspectType  like '020%' ";
		}else if(sInspectType.equals("040010") || sInspectType.equals("040020")){
		  	sSql2 =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
							" getItemName('InspectType',InspectType) as InspectType,"+
				            " UpdateDate,InputUserID,InputOrgID,"+
				            " getUserName(InputUserID) as InputUserName,"+
				            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
							" from INSPECT_INFO"+
							" where ObjectType='Customer' "+
			                " and InspectType  like '040%' ";
		}
		if(bIsCheckUser || ((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410"))){
			sSql2 += " and InputOrgId in(select OrgId from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
		}
		else if(!((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410")) || sInspectType.equals("040010")){
				sSql2 += " and InputUserID='"+CurUser.UserID+"'";
		}
		
		if(sInspectType.equals("020010") || sInspectType.equals("040010"))
		{
			sSql2=sSql2+" and (FinishDate = '' or FinishDate is null) order by UpDateDate desc";
		}
		else
		{
			sSql2=sSql2+" and FinishDate is not null order by FinishDate desc";
		}
		//��SQL������ɴ������
		doTemp = new ASDataObject(sSql2);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "INSPECT_INFO";
		//���ùؼ���
		doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
		doTemp.setHeader(sHeaders2);
		//���ò��ɼ���
		doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,ReportType",false);
		doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
		
		//����html��ʽ
		doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
		doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
		doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
		doTemp.setCheckFormat("UpdateDate","3");
		
		doTemp.setColumnAttribute("ObjectNo,CustomerName,UpdateDate,InputUserName,InputOrgName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

  	}
  	else if(sInspectType.equals("030010") || sInspectType.equals("030020"))
  	{
    	String sHeaders2[][] = {
								{"CustomerName","�ͻ�����"},
								{"ObjectNo","�ͻ����"},
								{"InspectType","�������"},
								{"UpdateDate","��������"},
								{"InputUserName","�����"},
								{"InputOrgName","��������"}							
							  };

	  	String sSql2 =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
						" getItemName('InspectType',InspectType) as InspectType,"+
			            " UpdateDate,InputUserID,InputOrgID,"+
			            " getUserName(InputUserID) as InputUserName,"+
			            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
						" from INSPECT_INFO"+
						" where ObjectType='CustomerRisk' "+
		                " and InspectType  like '030%' "+
		                " and InputUserID='"+CurUser.UserID+"'";
		                
		//��SQL������ɴ������
		doTemp = new ASDataObject(sSql2);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "INSPECT_INFO";
		//���ùؼ���
		doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
		doTemp.setHeader(sHeaders2);
		//���ò��ɼ���
		doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,ReportType",false);
		doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
		
		//����html��ʽ
		doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
		doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
		doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
		doTemp.setCheckFormat("UpdateDate","3");
		
		doTemp.setColumnAttribute("ObjectNo,CustomerName,UpdateDate,InputUserName,InputOrgName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

  	}  	
  	
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.setPageSize(16);
  	dwTemp.Style="1";      //����ΪGrid���
  	dwTemp.ReadOnly = "1"; //����Ϊֻ��
  
  
  	Vector vTemp = dwTemp.genHTMLDataWindow("");
  	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","��������","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ñ���","deleteRecord()",sResourcesPath},
		{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������Ϣ","viewCustomer()",sResourcesPath},
		{"false","","Button","ҵ���嵥","�鿴ҵ���嵥","viewBusiness()",sResourcesPath},
		{"false","","Button","���","��ɱ���","finished()",sResourcesPath},
		{"false","","Button","����","������д����","ReEdit()",sResourcesPath}
		};
		
		if((sInspectType.equals("010010") || sInspectType.equals("020010") || sInspectType.equals("040010")) )
		{
			sButtons[5][0] = "true";
		}
		
		if(sInspectType.equals("010020") || sInspectType.equals("020020") || sInspectType.equals("040020"))
		{
		    sButtons[0][0] = "false";
		    sButtons[2][0] = "false";
		    sButtons[6][0] = "true";
		}
		
		if(sInspectType.equals("030020") || sInspectType.equals("030010")){
			sButtons[0][0] = "false";
		    sButtons[4][0] = "false";
		}	
		if(bIsCheckUser){
			sButtons[6][0] = "false";
		}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sInspectType = "<%=sInspectType%>";
		if(sInspectType == '010010')
		{
			//ѡ�����ĺ�ͬ��Ϣ
			var sParaString = "ManageUserID" + "," + "<%=CurUser.UserID%>";
			sReturn = selectObjectValue("SelectInspectContract",sParaString,"",0,0);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") 
				return;
			sReturn = sReturn.split("@");
			//�õ���ͬ���
			sContractNo=sReturn[0];
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sContractNo+"&InspectType="+sInspectType,"","");
			sCompID = "PurposeInspectTab";
			sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sContractNo+"&ObjectType=BusinessContract";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		else if(sInspectType == '020010')
		{
			sParaString = "UserID" + "," + "<%=CurUser.UserID%>" + "," +"ToDay" + "," + "<%=StringFunction.getToday()%>";
			sReturn = selectObjectValue("SelectInspectCustomer",sParaString,"",0,0);
			//alert(sReturn);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
			sReturn = sReturn.split("@");			
			//�õ��ͻ�������Ϣ
			sCustomerID=sReturn[0];
			dReturn = RunMethod("CustomerManage","IsSamllEnt",sCustomerID);
			if(dReturn == 1){
				alert("�˿ͻ��Ǳ����϶���΢С��ҵ�ͻ�������΢С��ҵ�����鱨�棡");
			}else{
				//������в��¼
				sReportType = PopPage("/CreditManage/CreditCheck/SelectReportType.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
				if(sReportType=="" || sReportType=="_CANCEL_" || sReportType=="_CLEAR_" || sReportType=="_NONE_" || typeof(sReportType)=="undefined") 
					return;
				else{
					sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType+"&ReportType="+sReportType,"","");
					sCompID = "InspectTab";
					sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
					sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=Customer&ReportType="+sReportType;
					OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				}
			}		
		}else if(sInspectType == '040010'){
			sToDay = "<%=StringFunction.getToday()%>";
			sParaString = "UserID" + "," + "<%=CurUser.UserID%>" + "," +"ToDay" + "," + "<%=StringFunction.getToday()%>";
			sReturn = selectObjectValue("SelectSmallEntCustomer",sParaString,"",0,0);
			//alert(sReturn);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
			sReturn = sReturn.split("@");			
			//�õ��ͻ�������Ϣ
			sCustomerID=sReturn[0];
			dReturn = RunMethod("CustomerManage","HasCheckFrequency",sCustomerID);
			if(dReturn == 0){
				PopPage("/CreditManage/CreditCheck/AddCheckFrequencyAction.jsp?ObjectNo="+sCustomerID+"&CheckFrequency="+"90","","");
				sReturnValue=RunMethod("CustomerManage","FinishCheckFre",sCustomerID+","+sToDay);
			}	
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType,"","");
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=Customer";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);		
		}
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			sInspectType = "<%=sInspectType%>";
			if(sInspectType=="020010" || sInspectType=="020020" || sInspectType=="040010" || sInspectType=="040020"){
				sReturnValue = RunMethod("CustomerManage","DeleteInspectAction",sCustomerID);
			}	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			
		}	
		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sInspectType = "<%=sInspectType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sReportType = getItemValue(0,getRow(),"ReportType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			if(sInspectType == '010010' || sInspectType == '010020')
			{
				sCompID = "PurposeInspectTab";
				sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;

				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else if(sInspectType == '020010' || sInspectType == '020020')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ReportType="+sReportType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
			else if(sInspectType == '030010')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
			else if(sInspectType == '040010' || sInspectType == '040020')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}

  /*~[Describe=���;InputParam=��;OutPutParam=��;]~*/
	function finished()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sInspectType = "<%=sInspectType%>";
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('650')))//���������ɸñ�����
		{
			sReturn=PopPage("/CreditManage/CreditCheck/FinishInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&InspectType="+sInspectType,"","");
			
			if(sReturn=="Inspectunfinish")
			{
				alert(getBusinessMessage('651'));//�ô����鱨���޷���ɣ�������ɷ��շ��࣡
				return;
			}
			if(sReturn=="finished")
			{
				if(sInspectType == '020010' || sInspectType == '020020' || sInspectType == '040010' || sInspectType == '040020' )
				{
					sReturnValue = RunMethod("CustomerManage","FinishInspectAction",sObjectNo);
				}	
				alert(getBusinessMessage('653'));//�ñ�������ɣ�
				reloadSelf();
			}
		}
		
	}
	 
    /*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		var sCustomerID;
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020" || "<%=sInspectType%>"=="040010" || "<%=sInspectType%>"=="040020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		else if("<%=sInspectType%>"=="030010")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
    /*~[Describe=�鿴ҵ���嵥;InputParam=��;OutPutParam=��;]~*/
	function viewBusiness()
	{
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020" || "<%=sInspectType%>"=="040010" || "<%=sInspectType%>"=="040020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"","","");
		}
	}
	
	function ReEdit()
	{
	    sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sInspectType = "<%=sInspectType%>";
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('654')))//��ȷ��Ҫ���ظñ�����
		{
			sReturn=PopPage("/CreditManage/CreditCheck/ReEditInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&InspectType="+sInspectType,"","");
			reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>