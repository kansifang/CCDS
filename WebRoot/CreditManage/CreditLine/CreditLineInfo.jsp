<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: ��Ȼ�����Ϣҳ��
		Input Param:
		Output param:
		History Log: 
			zywei 2007/10/11 ���οͻ�ѡ����
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineID"));
	if(sLineID==null) sLineID="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		
	//������ʾ����				
	String[][] sHeaders = {											
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"LineSum1","��Ƚ��"},
					{"Currency","����"},					
					{"LineEffDate","��Ч��"},
					{"BeginDate","��ʼ��"},
					{"EndDate","������"},			
					{"PutOutDeadLine","���ʹ���������"},				
					{"MaturityDeadLine","�������ҵ����ٵ�������"},				
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�����"},
					{"UpdateTime","��������"}															
					};
	String sSql = 	" select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName, "+
					" LineSum1,Currency,LineEffDate,BeginDate,EndDate,LineEffFlag,PutOutDeadLine, "+
					" MaturityDeadLine,FreezeFlag,GetOrgName(InputOrg) as InputOrgName,InputOrg, "+
					" InputUser,GetUserName(InputUser) as InputUserName,InputTime,UpdateTime "+
					" from CL_INFO "+
					" Where LineID = '"+sLineID+"' and (ParentLineID ='' or ParentLineID is null)";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("LineEffFlag","EffStatus");
	
	//���ò��ɼ�����
	doTemp.setVisible("LineID,CLTypeID,CLTypeName,BCSerialNo,LineEffFlag,FreezeFlag,InputUser,InputOrg,LineEffDate,PutOutDeadLine,MaturityDeadLine",false);
	//����ֻ������
	doTemp.setReadOnly("LineID,CLTypeID,CLTypeName,CustomerID,CustomerName,InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//���ñ�����
	doTemp.setRequired("LineID,CLTypeName,CustomerName,LineSum1,Currency,BeginDate,EndDate",true);
	//���ò��ɸ�������
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setType("LineSum1","Number");
	doTemp.setCheckFormat("PutOutDeadLine,LineEffDate,BeginDate,EndDate,MaturityDeadLine","3");	
	doTemp.setHTMLStyle("InputUserName,InputTime,UpdateTime"," style={width:80px;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	//doTemp.setUnit("CustomerName","<input type=button value=\"...\" onClick=parent.selectCustomer()>");
	
	//���ö�Ƚ�Ԫ����Χ
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ƚ�Ԫ��������ڵ���0��\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.AddCLContractInfo(#BCSerialNo,#CustomerID,#CustomerName,#LineSum1,#Currency,#BeginDate,#EndDate,#PutOutDeadLine,#MaturityDeadLine,#LineEffDate,#InputUser)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.AddCLContractInfo(#BCSerialNo,#CustomerID,#CustomerName,#LineSum1,#Currency,#BeginDate,#EndDate,#PutOutDeadLine,#MaturityDeadLine,#LineEffDate,#InputUser)");
		
	//����HTMLDataWindow
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
		};
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
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}	
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sCurDate);
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		setObjectValue("SelectOwner","","@CustomerID@0@CustomerName@1",0,0,"");
	}
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//У����Ч���Ƿ����ڵ�ǰ����	
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����	
		sLineEffDate = getItemValue(0,getRow(),"LineEffDate");//��Ч��
		sInputTime = getItemValue(0,getRow(),"InputTime");//�Ǽ�����
		if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
		{			
			if(sLineEffDate < sToday  && sInputTime == sToday)
			{		    
				alert(getBusinessMessage('409'));//��Ч�ձ������ڻ���ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		
		//������Ч�ա���ʼ�պ͵�����֮���ҵ���߼���ϵ
		sBeginDate = getItemValue(0,getRow(),"BeginDate");//��ʼ��			
		sEndDate = getItemValue(0,getRow(),"EndDate");//������	
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{			
			if(sBeginDate < sToday  && sInputTime == sToday)
			{		    
				alert(getBusinessMessage('410'));//��ʼ�ձ������ڻ���ڵ�ǰ���ڣ�
				return false;		    
			}
						
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('172'));//�����ձ���������ʼ�գ�
					return false;		    
				}
				
				if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
				{
					if(sEndDate <= sLineEffDate)
					{		    
						alert(getBusinessMessage('411'));//�����ձ���������Ч�գ�
						return false;		    
					}
				}
			}	
		}
						
		return true;
	}

	/*~[Describe=�����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function setCLType()
	{			
		setObjectValue("SelectCLType","","@CLTypeID@0@CLTypeName@1",0,0,"");		
	}
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
