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
	History Log: zywei 2005/07/31 �ؼ�ҳ��
					lpzhang �������õȼ������϶���Ϣ 2009-8-25 
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
	//��ȡ���������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sApplyType == null) sApplyType = "";
	System.out.println("sCustomerID:"+sCustomerID);
	String Sql="",sCustomerType="",Sql1="";
	String sEvaluateSerialNo="",sEvaluateResult="",sCognResult="",sModelNo="",sTransformMethod ="",sModelDescribe="",sSmallEntFlag="";
	//�������õȼ���������
	String sIsInuse="";//�Ƿ�ͣ�ò��пͻ���������
	String sNewEvaluateSerialNo = "";
	String sNewEvaluateResult = "" ;
	String sNewCognResult = "";
	String sNewModelNo = "";
	String sSModelNo = "";
	String sNewTransformMethod = "";
	String sNewModelDescribe  = "";
	double dNewEvaluateScore = 0.0;
	double dNewCognScore = 0.0;
	double dEvaluateScore=0.0,dCognScore=0.0;
	ASResultSet rs = null, rs1 = null;
	//String[][] sEvluateArr = new String[8][]; 
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	
	//ȡ�ÿͻ����õȼ�������Ϣ add by lpzhang 2009-8-24
	Sql = "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"'";
	sCustomerType = Sqlca.getString(Sql);
	if(sCustomerType == null) sCustomerType="";
	
	//¼�빫˾�Ϳͻ������˿ͻ���ͬҵ�ͻ���Ϣʱ�жϣ��Ƿ�ͣ�ò��пͻ����õȼ�������
	sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if (sIsInuse== null) sIsInuse="" ;
	//����ͬҵ���ţ��Ƕ������
	if( ("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply") && !(sBusinessType.equals("1056") || sBusinessType.equals("1054")))
	{
		Sql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
		       " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
		rs = Sqlca.getASResultSet(Sql);
		if(rs.next())
		{
			sEvaluateSerialNo = rs.getString("SerialNo");
			dEvaluateScore    = rs.getDouble("EvaluateScore");
			sEvaluateResult   = rs.getString("EvaluateResult");
			dCognScore        = rs.getDouble("CognScore");
			sCognResult       = rs.getString("CognResult");
			
			if(sEvaluateSerialNo == null) sEvaluateSerialNo ="";
			if(sEvaluateResult == null) sEvaluateResult ="";
			if(sCognResult == null) sCognResult ="";
		}
		rs.getStatement().close();
		
		if(sIsInuse.equals("2"))
		{
			Sql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='NewEvaluate' "+
		          " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
			rs = Sqlca.getASResultSet(Sql);
			if(rs.next())
			{
				sNewEvaluateSerialNo = rs.getString("SerialNo");
				dNewEvaluateScore    = rs.getDouble("EvaluateScore");
				sNewEvaluateResult   = rs.getString("EvaluateResult");
				dNewCognScore        = rs.getDouble("CognScore");
				sNewCognResult       = rs.getString("CognResult");
				
				if(sNewEvaluateSerialNo == null) sNewEvaluateSerialNo ="";
				if(sNewEvaluateResult == null) sNewEvaluateResult ="";
				if(sNewCognResult == null) sNewCognResult ="";
			}
			rs.getStatement().close();		
		}
		
		String sCustomerFlag="";
		if(sCustomerType.startsWith("03"))
		{
			sCustomerFlag = "IND_INFO";
			sModelNo = Sqlca.getString("select CreditBelong from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'");
			
			if(sModelNo == null) sModelNo ="";
			sNewModelNo = Sqlca.getString("select NewCreditBelong from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'");			
			if(sNewModelNo == null) sNewModelNo ="";
		}else{
			sCustomerFlag = "ENT_INFO";
			Sql ="select CreditBelong,NewCreditBelong,SmallEntFlag from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(Sql);
			if(rs.next())
			{
				sModelNo = rs.getString("CreditBelong");
				sSmallEntFlag  = rs.getString("SmallEntFlag");
				
				if(sModelNo == null) sModelNo ="";
				if(sSmallEntFlag == null) sSmallEntFlag ="";
				sNewModelNo = rs.getString("NewCreditBelong");
				if(sNewModelNo == null) sNewModelNo ="";
			}
			rs.getStatement().close();
		}
		
		System.out.println("sModelNo:::"+sModelNo);
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
		
		if(sNewModelNo != null && !sNewModelNo.equals("") && sIsInuse.equals("2"))
		{
			Sql1 = " select TransformMethod,ModelDescribe from EVALUATE_CATALOG where ModelNo = '"+sNewModelNo+"' ";
			rs1 = Sqlca.getASResultSet2(Sql1);
			if(rs1.next())
			{
				sNewTransformMethod = rs1.getString("TransformMethod");
				sNewModelDescribe = rs1.getString("ModelDescribe");
				if(sNewTransformMethod == null) sNewTransformMethod ="";
				if(sNewModelDescribe == null) sNewModelDescribe ="";	
			}
			rs1.getStatement().close();
		}
	
	}
	
	String sHeaders[][]={   
							{"SystemScore","ϵͳ�����÷�"},
				            {"SystemResult","ϵͳ�������"},
				            {"CognScore","�˹������÷�"},
				            {"CognResult","�˹��������"},
							{"NewSystemScore","����ϵͳ�����÷�"},
				            {"NewSystemResult","����ϵͳ�������"},
				            {"NewCognScore","�����˹������÷�"},
				            {"NewCognResult","�����˹��������"},				            
				            {"PhaseChoice","�������"},
	                        {"PhaseOpinion","���˵��"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        };                    
		
	//����SQL���
	String sSql = 	" select SerialNo,OpinionNo,"+
					" SystemScore,SystemResult,CognScore,CognResult,NewSystemScore,NewSystemResult,NewCognScore,NewCognResult,PhaseChoice,PhaseOpinion,"+
					" InputOrg,getOrgName(InputOrg) as InputOrgName, "+
					" InputUser,getUserName(InputUser) as InputUserName, "+
					" InputTime,UpdateUser,UpdateTime "+
					" from FLOW_OPINION " +
					" where SerialNo='"+sSerialNo+"' ";
	//out.println(sSql);
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders); 
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);	
	//�������
	doTemp.setRequired("PhaseChoice",true);
	doTemp.setDDDWCode("PhaseChoice","PhaseChoice");
	//�����ֶ��Ƿ�ɼ�  
	doTemp.setVisible("SerialNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	//���ñ�����
	doTemp.setRequired("PhaseOpinion",true);
	//����ֻ������
	doTemp.setReadOnly("InputOrgName,InputUserName,InputTime",true);
	//�༭��ʽΪ��ע��
	doTemp.setEditStyle("PhaseOpinion","3");	
	//��html��ʽ
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:50%;overflow:scroll;font-size:9pt;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
		
	//������������ʱ�����ʾ��
	doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",false);
	//��������ģ��
	doTemp.setVisible("NewSystemScore,NewCognScore,NewSystemResult,NewCognResult",false);	
	if(("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply") )
	{
		//��������ģ��
		if(sIsInuse.equals("2"))
		{
			doTemp.setReadOnly("NewSystemScore,NewSystemResult,NewCognResult",true);
			if(!(sBusinessType.equals("1056") || sBusinessType.equals("1054")) && !sSmallEntFlag.equals("1") && !sCustomerType.startsWith("03"))	
				doTemp.setRequired("NewSystemScore,NewCognScore,NewSystemResult,NewCognResult",true);
			doTemp.setVisible("NewSystemScore,NewCognScore,NewSystemResult,NewCognResult",true);
			doTemp.setHTMLStyle("NewCognScore","onChange=\"javascript:parent.setNewResult()\"	");
			doTemp.setAlign("NewSystemScore,NewCognScore","3");
			doTemp.setType("NewSystemScore,NewCognScore","Number");
		}
		doTemp.setReadOnly("SystemScore,SystemResult,CognResult",true);
		if(!(sBusinessType.equals("1056") || sBusinessType.equals("1054")) && !sSmallEntFlag.equals("1") && !sCustomerType.startsWith("03"))	
			doTemp.setRequired("SystemScore,CognScore,SystemResult,CognResult",true); 
		doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",true);
		
		//�˹��϶�����
		doTemp.setHTMLStyle("CognScore","onChange=\"javascript:parent.setResult()\"	");
		doTemp.setAlign("SystemScore,CognScore","3");
		doTemp.setType("SystemScore,CognScore","Number");
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
			};
			
	if(("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply"))
			{
				sButtons[2][0] = "true";
			}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language="javascript">

	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
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
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert("����û��ǩ�������������ɾ�����������");
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
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
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
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
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
		/*~[Describe=���ݷ�ֵ���㲢���������;InputParam=��;OutPutParam=��;]~*/
			function setNewResult(){		
		//������ֵ�������
		//��Ҫ���ݾ���������е���
		var NewCognScore = getItemValue(0,getRow(),"NewCognScore");
		if(NewCognScore<0 || NewCognScore>100){
			alert("����������0��100֮�䣡");
			setItemValue(0,getRow(),"NewCognScore","");
			setItemValue(0,getRow(),"NewCognResult","");
			setItemFocus(0,getRow(),"NewCognScore");
			return;
		}
		sModelDescribe = "<%=sNewModelDescribe%>";
		if(typeof(sModelDescribe) != "undefined" && sModelDescribe != "") 
		{			
			var my_array = new Array();
			var str_array = new Array();
			my_array = sModelDescribe.split(",");
			for(var i=0;i<my_array.length;i++)
			{ 
				str_array = my_array[i].split("&");
				if(checkResult(str_array[0],str_array[1],NewCognScore))
				{
					result = str_array[2];
					setItemValue(0,getRow(),"NewCognResult",result);
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
	
	/*~[Describe=��ȡ����������Ϣ;InputParam=��;OutPutParam=��;]~*/
    function getEvaluate()
    {
    	sEvaluateSerialNo = "<%=sEvaluateSerialNo%>";
   		dEvaluateScore    = "<%=dEvaluateScore%>";
	   	sEvaluateResult   = "<%=sEvaluateResult%>";
	   	dCognScore        = "<%=dCognScore%>";
	   	sCognResult       = "<%=sCognResult%>";
	    
	    if(!isNotNull(sEvaluateSerialNo))
	 	{
	   		alert("�ÿͻ�û���κ����õȼ�������¼�����Ƚ������õȼ�������");
	   		return;
	 	}else
	 	{
	 		setItemValue(0,getRow(),"SystemScore",dEvaluateScore);
	 		setItemValue(0,getRow(),"SystemResult",sEvaluateResult);
	 		setItemValue(0,getRow(),"CognScore",dCognScore);
	 		setItemValue(0,getRow(),"CognResult",sCognResult);
	 	}
	 	if("<%=sIsInuse%>" == "2")
	 	{
	 		sNewEvaluateSerialNo = "<%=sNewEvaluateSerialNo%>";
   			dNewEvaluateScore    = "<%=dNewEvaluateScore%>";
	   		sNewEvaluateResult   = "<%=sNewEvaluateResult%>";
	   		dNewCognScore        = "<%=dNewCognScore%>";
	   		sNewCognResult       = "<%=sNewCognResult%>";
	   		
	   		if(!isNotNull(sNewEvaluateSerialNo))
	   		{
	   			alert("�ÿͻ�û�в������õȼ�������¼�����Ƚ����������õȼ�������");
	   			return;
	   		}else
	   		{
	   			setItemValue(0,getRow(),"NewSystemScore",dNewEvaluateScore);
	 			setItemValue(0,getRow(),"NewSystemResult",sNewEvaluateResult);
	 			setItemValue(0,getRow(),"NewCognScore",dNewCognScore);
	 			setItemValue(0,getRow(),"NewCognResult",sNewCognResult);
	   		}	 	
	 	}
	 	
	} 
	
	</script>
<%/*~END~*/%>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>