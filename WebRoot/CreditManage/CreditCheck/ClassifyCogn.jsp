<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lpzhang2010-6-3 
		Tester:
		Describe: 
		Input Param:
			SerialNo��������ˮ��
			
				
		Output Param:			

				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����϶���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������:��ʾģ����
	String sTempletNo = "";
		
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TaskNo"));
	String sRightType =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	String sCustomerID =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sObjectNo =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerType == null) sCustomerType = "";
	if(sTaskNo == null) sTaskNo = "";
	if(sRightType == null) sRightType = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sObjectNo == null) sObjectNo = "";
	System.out.println("sTaskNo������"+sTaskNo+"sSerialNo:"+sSerialNo);
	String sBusinessType = "";
	String sOccurType = "";
	String sClassifyLevel1 = "";//�ͻ�������ֽ��
	ASResultSet rs = null;
	String sSql = "select BusinessType,OccurType from business_contract where serialno = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBusinessType = rs.getString("BusinessType");
		sOccurType = rs.getString("OccurType");
	}
	rs.getStatement().close();
	sSql = "select ClassifyLevel from CLASSIFY_RECORD where serialno = '"+sSerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sClassifyLevel1 = rs.getString("ClassifyLevel");
	}
	rs.getStatement().close();
	
	if(sBusinessType == null) sBusinessType = "";	
	if(sOccurType == null) sOccurType = "";
	if(sClassifyLevel1 == null) sClassifyLevel1 = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	sTempletNo = "ClassifyCogn";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sCustomerType.startsWith("03")){
		doTemp.setVisible("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID4,classifyCondition1,ResultUserID5,classifyCondition2",false);
		doTemp.setDDDWSql("ResultUserName1,ClassifyLevel,ClassifyLevel2,Result1","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno in('01','02','03','04','05') and isinuse ='1' ");
		doTemp.setRequired("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID4,classifyCondition1,ResultUserID5,classifyCondition2",false);
	}else{
		doTemp.setDDDWSql("ClassifyLevel,ClassifyLevel2,Result1","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno not in('01','02','03','04','05') and isinuse ='1' ");
		doTemp.setDDDWSql("ResultUserName1","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno in('01','02','03','04','05') and isinuse ='1' ");
	}
	
	if(sBusinessType.startsWith("1")){
		doTemp.setVisible("ResultUserID4,classifyCondition1",false);
		doTemp.setRequired("ResultUserID4,classifyCondition1",false);
	}
	else if(sBusinessType.startsWith("2")){
		doTemp.setVisible("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID5,classifyCondition2",false);
		doTemp.setRequired("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID5,classifyCondition2",false);
	}			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	System.out.println(doTemp.SourceSql);
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
			
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	function saveRecord(sPostEvents)
	{
		
		if (!ValidityCheck()) return;
		
		as_save("myiframe0",classifyOpinion());		
	}
	
	//ǩ�����
	function classifyOpinion()
	{
		var iOpinion="";
		sTaskNo= "<%=sTaskNo%>";
		sSerialNo= "<%=sSerialNo%>";
		sRemark = getItemValue(0,getRow(),"Remark");
		sRemark2 = getItemValue(0,getRow(),"Remark2");
		iOpinion = RunMethod("�弶����","�Ƿ��Ѿ�ǩ�����",sTaskNo);
		if(iOpinion>0)
		{
			RunMethod("�弶����","����ǩ�����",sRemark+","+sRemark2+","+sTaskNo);
		}else{
			var sTableName = "FLOW_OPINION";//����
			var sColumnName = "OpinionNo";//�ֶ���
			var sPrefix = "";//��ǰ׺
								
			//ʹ��GetSerialNo.jsp����ռһ����ˮ��
			var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			//����ˮ�������Ӧ�ֶ�
			RunMethod("�弶����","�����弶�������",sTaskNo+","+sOpinionNo+","+sSerialNo+",ClassifyApply,<%=CurUser.UserID%>,<%=CurOrg.OrgID%>,"+sRemark+","+sRemark2);
		}
		
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}
	
	function ValidityCheck()
	{	
		sResult4 = getItemValue(0,0,"Result4");	
		sResult1 = getItemValue(0,0,"Result1");		
		sResult3 = getItemValue(0,0,"Result3");
		sResultOpinion3 = getItemValue(0,0,"ResultOpinion3");
		sResultUserName1 = getItemValue(0,0,"ResultUserName1");
		sClassifyLevel = getItemValue(0,0,"ClassifyLevel");
		sClassifyLevel2 = getItemValue(0,0,"ClassifyLevel2");
		sResultUserID2 = getItemValue(0,0,"ResultUserID2");//�Ƿ�Ϊ��ϵ�˴���
		sResult5 = getItemValue(0,0,"Result5");//�Ƿ�ΪŲ�ô���
		sResultUserID3 = getItemValue(0,0,"ResultUserID3");//�Ƿ�ΪŲ�ô���
		sResultUserID4 = getItemValue(0,0,"ResultUserID4");//�Ƿ���ڱ�������ҵ����
		sResultUserID5 = getItemValue(0,0,"ResultUserID5");//�Ƿ�Ϊչ�ڴ���
		if(sResult4 == "1"){
			if(typeof(sResultUserName1)=="undefined" || sResultUserName1.length==0 || sResultUserName1 == ""){
				alert("ǣͷ�з���������!");
				return false; 
			}	
		}else{
			if(!(typeof(sResultUserName1)=="undefined" || sResultUserName1.length==0 || sResultUserName1 == ""))
			{
				alert("���ѡ����ǡ��񡱣���ǣͷ�з�������Ӧ�ò���ѡ��!");
				return false;
			}	
		}
		
		if(sResult3=="01" || sResult3=="02"){
			if(typeof(sResultOpinion3)=="undefined" || sResultOpinion3.length==0)
			{
				alert("�����Ƿ�Ϊ�̶��ʲ����ڽ�������Ŀ���Ϊ���ǡ�ʱ�򣬡��̶��ʲ����ڽ�������Ŀ�������˵����Ϊ���䣡");
				return false;
			}
			if(sResult3=="02"){
				if(sClassifyLevel <"0203" ){
					alert("�����Ƿ�Ϊ�̶��ʲ����ڽ�������Ŀ���Ϊ �������ش����ڴ�������ء�����߷����϶�Ϊ����ע3��");
					return false;
				}
			}
		}
		if(sClassifyLevel.substring(0,2) < sResultUserName1 )
		{
			alert("���������ܸ���ǣͷ�з�������");
			return false;
		}
		if(sResultUserID2=="03" && sClassifyLevel<"0202")
		{
			alert("��ϵ�˴��������������һ������߷����϶�Ϊ����ע2����");
			return false;
		}
		if(sResult5=="1" && sClassifyLevel<"0203")
		{
			alert("��Ų�ô����߷����϶�Ϊ����ע3����");
			return false;
		}
		
		if(sResult5=="01" && sClassifyLevel<"0203")
		{
			alert("��Ų�ô����߷����϶�Ϊ����ע3����");
			return false;
		}
		if(sResultUserID3=="05" && sClassifyLevel<"0301")
		{
			alert("�ǣ������δ���ڣ�����߷����϶�Ϊ���μ�1����");
			return false;
		}
		if(sResultUserID3=="06" && (sClassifyLevel<"0400" || sClassifyLevel<"04") )
		{
			alert("�ǣ�����������ڣ�����߷����϶�Ϊ�����ɡ���");
			return false;
		}
		if(sResultUserID3=="07" && sClassifyLevel<"0201" )
		{
			alert("�ǣ��̻�׷�ӣ�����߷����϶�Ϊ����ע1����");
			return false;
		}
		if(sResultUserID4=="08" && sClassifyLevel<"0203" )
		{
			alert("�Ǳ�������ҵ���30�����ڣ�����߷����϶�Ϊ����ע3����");
			return false;
		}
		if(sResultUserID4=="09" && sClassifyLevel<"0302" )
		{
			alert("�Ǳ�������ҵ���31-90�����ڣ�����߷����϶�Ϊ���μ�2����");
			return false;
		}
		if(sResultUserID4=="10" &&(sClassifyLevel<"0400" || sClassifyLevel<"04"))
		{
			alert("�Ǳ�������ҵ���90�����ϣ�����߷����϶�Ϊ�����ɡ���");
			return false;
		}
		
		if(sResultUserID5=="11" &&  sClassifyLevel<"0202")
		{
			alert("��չ�ڣ�δ���ڣ�����߷����϶�Ϊ����ע2����");
			return false;
		}
		if(sResultUserID5=="12" &&  sClassifyLevel<"0203")
		{
			alert("��չ�ڣ������ڣ�����߷����϶�Ϊ����ע3����");
			return false;
		}
		/*
		if(sResult1 > sClassifyLevel){
			alert("�����������������ø��ڡ����ֽ����");
			return false;
		}*/
	
		if("<%=sOccurType%>"=="020" )//������ʽΪ���»���
		{
			if("<%=sCustomerType%>".indexOf("01") == 0)//��˾�ͻ�
			{
				if(sClassifyLevel<"0201"||sClassifyLevel2<"0201")
				{
					alert("������ʽΪ�����»��ɡ�������ҵ��,�����������������ø��ڡ���ע1��");
		    	   
			    }
		    }
		}
		if("<%=sOccurType%>"=="030" )//������ʽΪ�ʲ�����
		{
			if("<%=sCustomerType%>".indexOf("01") == 0)//��˾�ͻ�
			{
				if(sClassifyLevel<"0301"||sClassifyLevel2<"0301")
				{
					alert("������ʽΪ�����顱������ҵ��,�����������������ø��ڡ��μ�1��");
				}
		    	    
		    }
		}
		return true;
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if ("<%=sClassifyLevel1%>"=="")//���û���ҵ���Ӧ��¼���������ֶ�Ĭ��ֵ
		{
			if("<%=sOccurType%>"=="010" || "<%=sOccurType%>"=="065")//������ʽΪ������������������
			{
				if("<%=sCustomerType%>"=="03")//����
			    {
					setItemValue(0,0,"ClassifyLevel","01");//����
				    setItemValue(0,0,"ClassifyLevel2","01");
			    }else if("<%=sCustomerType%>".indexOf("01") == 0){//��˾
				    setItemValue(0,0,"ClassifyLevel","0102");//����2
				    setItemValue(0,0,"ClassifyLevel2","0102");
			    }
		    }
		    if("<%=sOccurType%>"=="030" )//������ʽΪ�ʲ�����
		    {
		    	sReturn = RunMethod("BusinessManage","GetClassifyResult","NPAReformApply,<%=sObjectNo%>");
			    if (!(typeof(sReturn)=="undefined" || sReturn.length==0))
			    {	
			    	var sReturn1 = sReturn.split("@");
				    setItemValue(0,0,"ClassifyLevel",sReturn1[0]);
				    setItemValue(0,0,"ClassifyLevel2",sReturn1[1]);
			    }
		    }
		   if("<%=sOccurType%>"=="020" )//������ʽΪ���»���
		   {
			   sReturn = RunMethod("BusinessManage","GetClassifyResult","BusinessContract,<%=sObjectNo%>");//���Ϊ����ô���أ�
			   if (!(typeof(sReturn)=="undefined" || sReturn.length==0))
			   {	
				   var sReturn1 = sReturn.split("@");
				   setItemValue(0,0,"ClassifyLevel",sReturn1[0]);
				   setItemValue(0,0,"ClassifyLevel2",sReturn1[1]);
			   }
		    }
		}
    }
	

	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	//bFreeFormMultiCol=true;
	
	my_load(2,0,'myiframe0');
	if("<%=sRightType%>"==""){
		 setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
        setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
        setItemValue(0,0,"UserIDName","<%=CurUser.UserName%>");
        setItemValue(0,0,"OrgIDName","<%=CurOrg.OrgName%>"); 
        }
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	
	
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

