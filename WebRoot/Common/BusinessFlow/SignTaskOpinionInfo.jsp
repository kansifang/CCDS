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
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][]={                       
	                        {"PhaseOpinion","���"},
	                        {"InputOrgName","�Ǽǻ���"}, 
	                        {"InputUserName","�Ǽ���"}, 
	                        {"InputTime","�Ǽ�����"}                      
                        }; 
	//����SQL���
	String sSql = 	"select SerialNo,"+
					"ObjectType,ObjectNo,OpinionNo,PhaseOpinion,"+
					"InputOrg,getOrgName(InputOrg) as InputOrgName,"+
					"InputUser,getUserName(InputUser) as InputUserName,"+
					"InputTime,UpdateUser,UpdateTime"+
					" from FLOW_OPINION" +
					" where SerialNo='"+sSerialNo+"' ";
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders); 
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	//�����ֶ��Ƿ�ɼ�  
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
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
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		
		as_save("myiframe0");
        
        //add by ljtao 2009-09-18 �������ʱ������Ҫ��������Ϣ���µ��������Ӧ�� FLOW_OPINION ���еļ�¼��
		//var sReturnValue = PopPage("/Common/WorkFlow/JSSignOpinionAction.jsp?SerialNo="+"<%//=sSerialNo%>"+"&ObjectNo="+"<%//=sObjectNo%>"+"&ObjectType="+"<%//=sObjectType%>","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//if(typeof(sReturnValue)=="undefined" || sReturnValue == "false")
		//{
		//	alert("������ı�Ҫ��Ϣ���µ�������еĲ���û����ɣ����Գ���������д��������棡");
		//	return;
		//}
		//end add
		
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
	</script>
<%/*~END~*/%>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>