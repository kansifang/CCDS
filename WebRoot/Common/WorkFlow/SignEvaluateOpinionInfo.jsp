<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:  bwang 
	Tester:
	Content: ���õȼ��϶�ǩ�����
	Input Param:
		
	Output param:
	History Log: 
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ��϶�ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	String sSql="";
	ASResultSet rs=null;
	String sCognResult="",sCustomerName="",sModelName="";
	String sAccountMonth="",sEvaluateDate="",sSystemScore="",sSystemResult="",sCustomerID="";
	//��ȡ���������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�õ�ǰ�׶ε��������
	sSql = " select ER.ObjectNo,getCustomerName(ER.ObjectNo) as CustomerName,"+
	   " CognResult,ER.AccountMonth ,"+
	   " EC.ModelName as ModelName,ER.EvaluateDate,ER.EvaluateScore,ER.EvaluateResult"+
	   " from EVALUATE_RECORD ER,EVALUATE_CATALOG EC" + 
       " where ER.ObjectType = '"+sObjectType + "'"+
       " and ER.SerialNo = '"+sObjectNo+"' and ER.ModelNo=EC.ModelNo";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCognResult = rs.getString("CognResult");
		sModelName=rs.getString("ModelName");
		sAccountMonth=rs.getString("AccountMonth");
	 	sEvaluateDate=rs.getString("EvaluateDate");
 		sSystemScore=rs.getString("EvaluateScore");
	 	sSystemResult=rs.getString("EvaluateResult");
	 	sCustomerID=rs.getString("ObjectNo");
	 	sCustomerName=rs.getString("CustomerName");
	 	
	 	if (sModelName==null)sModelName="";
	 	if (sAccountMonth==null)sAccountMonth="";
	 	if (sEvaluateDate==null)sEvaluateDate="";
	 	if (sSystemScore==null)sSystemScore="";
	 	if (sSystemResult==null)sSystemResult="";
	 	if (sCustomerID==null)sCustomerID="";
	 	if (sCustomerName==null)sCustomerName="";
		if(sCognResult ==null) sCognResult=""; 
	 
	}
	
	rs.getStatement().close();
	String sHeaders[][] = { 
							{"AccountMonth","����·�"},
	                        {"ModelName","����ģ��"},
	                        {"SystemScore","ϵͳ�����÷�"},
	                        {"SystemResult","ϵͳ�������"},
	                        {"CustomerName","�ͻ�����"},
	                        {"CognScore","�˹������÷�"},
							{"CognResult","�˹��������"},
							{"PhaseOpinion","����ԭ��˵��"},
							{"InputTime","�˹���������"},
							{"InputOrgName","������λ"},
							{"InputUserName","������"}
			              };                 
		
	//����SQL���
	 sSql = 	" select SerialNo,'' as AccountMonth, PhaseChoice as ModelName,"+//����·�,����ģ��
	 			" SystemScore as SystemScore,SystemResult as SystemResult,"+//ϵͳ�����÷֣�ϵͳ�������
	 			" CognScore as CognScore,CognResult as CognResult,"+//�˹����֣��˹��������
	 			" OpinionNo,PhaseOpinion, CustomerId,CustomerName,"+//����ԭ��˵�����ͻ�����
				" InputOrg,getOrgName(InputOrg) as InputOrgName,ObjectType,ObjectNo, "+
				" InputUser,getUserName(InputUser) as InputUserName, "+
				" InputTime,UpdateUser,UpdateTime "+
				" from FLOW_OPINION " +
				" where SerialNo='"+sSerialNo+"' ";
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders); 
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	//�����ֶ��Ƿ�ɼ�  
	doTemp.setVisible("AccountMonth,SerialNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime,ObjectType,ObjectNo,CustomerId",false);		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("InputOrgName,InputUserName,AccountMonth",false);
	//�˹��϶�����
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	//���ñ�����
	doTemp.setRequired("CognScore,PhaseOpinion",true);
	doTemp.setAlign("SystemScore","3");
	doTemp.setType("CognScore,SystemScore","Number");

	//����������
	doTemp.setDDDWSql("SystemResult,CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	//����ֻ������
	doTemp.setReadOnly("InputOrgName,InputUserName,InputTime,AccountMonth,ModelName,CognResult,SystemScore,SystemResult,CustomerName",true);
	//�༭��ʽΪ��ע��
	doTemp.setEditStyle("PhaseOpinion","3");	
	//��html��ʽ
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:50%;overflow:scroll;font-size:9pt;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	//��������ԭ�����������
	doTemp.setLimit("PhaseOpinion",400);
			
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
		};
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
		sObjectNo = "<%=sObjectNo%>";
		sObjectType = "<%=sObjectType%>";
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0"); 
	}
	
	/*~[Describe=ɾ�����;InputParam=��;OutPutParam=��;]~*/
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
			setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,getRow(),"ModelName","<%=sModelName%>");
			setItemValue(0,getRow(),"EvaluateDate","<%=sEvaluateDate%>");
			setItemValue(0,getRow(),"SystemScore","<%=DataConvert.toDouble(sSystemScore)%>");
			setItemValue(0,getRow(),"SystemResult","<%=sSystemResult%>");	
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");	
		}      
		
			setItemValue(0,getRow(),"CognResult","<%=sCognResult%>");
		
	}
	
		/*~[Describe=���ݷ�ֵ�����������;InputParam=��;OutPutParam=��;]~*/
	function setResult(){		
		//������ֵ�������
		//��Ҫ���ݾ���������е���
		var CognScore = getItemValue(0,getRow(),"CognScore");
		if(CognScore<0){
			alert("�˹��϶��÷ֱ������0��");
			setItemValue(0,getRow(),"CognScore","");
			setItemValue(0,getRow(),"CognResult","");
			setItemFocus(0,getRow(),"CognScore");
			return;
		}
		if (CognScore<60)
			result = "BB";
		else if (CognScore<76)
			result = "BBB";
		else if (CognScore<86)
			result = "A";
		else if (CognScore<95)
			result = "AA";
		else
			result = "AAA";			
		setItemValue(0,getRow(),"CognResult",result);
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