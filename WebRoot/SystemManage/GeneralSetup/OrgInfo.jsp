<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: �������Ϣ����
			Input Param:
	                    OrgID���������
			Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
		
	//����������	
	
	//���ҳ�����	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CurOrgID"));
	if(sOrgID == null) sOrgID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    //�����ϼ�����ѡ��ʽ
    doTemp.setUnit("RelativeOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("RelativeOrgName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	//filter��������
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
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
			{(CurUser.hasRole("099")?"true":"false"),"","Button","����","�����޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","���ص��б����","doReturn()",sResourcesPath}		
			};
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
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
    var sCurOrgID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		//�����ű��������Ƿ����ظ�������
		if(sOrgID!="<%=sOrgID%>"){
			sReturn=RunMethod("PublicMethod","GetColValue","OrgID,ORG_INFO,String@OrgID@"+sOrgID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("������Ļ������ѱ�ʹ�ã�");
				return;
			}
		}
	    sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
	    if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert(getBusinessMessage("901"));//��ѡ�񼶱�
        	return;
        }else
        {
        	if(sOrgLevel != '0')
        	{
        		sRelativeOrgName = getItemValue(0,getRow(),"RelativeOrgName");
			    if (typeof(sRelativeOrgName) == 'undefined' || sRelativeOrgName.length == 0) 
		        {
		        	alert("��ѡ���ϼ�������");
		        	return;
		        }
        	}
        }
	    setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        as_save("myiframe0","");
        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(){
		OpenPage("/SystemManage/GeneralSetup/OrgList.jsp","_self","");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrgName()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0) 
        {
        	alert(getBusinessMessage("900"));//�����������ţ�
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert(getBusinessMessage("901"));//��ѡ�񼶱�
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;		
		setObjectValue("SelectOrg",sParaString,"@RelativeOrgID@0@RelativeOrgName@1",0,0,"");
		
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            bIsInsert = true;
		}
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
