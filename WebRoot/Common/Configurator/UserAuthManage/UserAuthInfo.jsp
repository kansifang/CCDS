<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:	ljtao 2008/12/08
			Tester:
			Content: ������Ȩ��Ϣ
			Input Param:
			SerialNo����ˮ��
			sObjectType:Special/Normal -- ������Ȩ/һ����Ȩ
			sAuthorType:1/2/3 -- ������Ȩ/������Ȩ/֧����Ȩ
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
		String PG_TITLE = "������Ȩ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//���ҳ�����	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sAuthorType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAuthorType == null) sAuthorType = "";
	//�������
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = {     
						{"SerialNo","��ˮ��"},
			                    {"BusinessKind","ҵ������"},
			                    {"BusinessTypeName","ҵ��Ʒ��"},
			                    {"VouchType","��Ҫ������ʽ"},
			                    {"EvaluateRate","���õȼ�"},
			                    {"MathMark","����"},
			                    {"DoorSum","�����޶�(Ԫ)"},
			                    {"FinalOrgName","�������"},
			                    {"FinalRole","������Ա"},
			                    {"InputOrgName","�Ǽǻ���"},
			                    {"InputUserName","�Ǽ���"},
			                    {"InputDate","�Ǽ�����"},	
			                    {"UpdateDate","��������"}
			         }; 
		sSql = " select SerialNo,ObjectType,AuthorType,BusinessKind,BusinessType,getBusinessName(BusinessType) as BusinessTypeName, " +
			   " VouchType,EvaluateRate,MathMark,DoorSum, " +
			   " FinalOrg,getOrgName(FinalOrg) as FinalOrgName,FinalRole, " +//Attribute1,Attribute2,
			   " InputOrgID,getOrgName(InputOrgID) as InputOrgName, "+
			   " InputUserID,getUserName(InputUserID) as InputUserName,InputDate,UpdateDate "+
			   " from USER_AUTHORIZATION "+
		       " where ObjectType= '"+sObjectType+"' and SerialNo = '"+sSerialNo+"' ";

		//ͨ��sql�������ݴ������		
		ASDataObject doTemp = new ASDataObject(sSql);
		//���ñ�ͷ		
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "USER_AUTHORIZATION"; 
		//���ùؼ���		
		doTemp.setKey("SerialNo",true);
		//���ñ�������
		doTemp.setRequired("MathMark,BusinessKind,DoorSum,FinalRole",true);//,Attribute1,Attribute2
		//�����Ƿ�ɼ�����
		doTemp.setVisible("SerialNo,ObjectType,AuthorType,InputOrgID,InputUserID,FinalOrg,BusinessType",false);
		doTemp.setVisible("VouchType,EvaluateRate",false);//��ʱ����
		//if(sAuthorType.equals("1"))
			//doTemp.setVisible("FinalOrgName",false);
		//else
			//doTemp.setRequired("FinalOrgName",true);
		//������ʾ�ĳ���
		doTemp.setHTMLStyle("InputDate,UpdateDate"," style={width:80px}");
		doTemp.setType("DoorSum","Number");
		doTemp.setCheckFormat("DoorSum","2");
		//�������������Ʋ��ɸ���
		doTemp.setUpdateable("FinalOrgName,InputOrgName,MathMarkName,InputUserName,BusinessTypeName",false);
		//��������������Ϊֻ�����ӵ����Ի�����ѡ��	
		doTemp.setReadOnly("FinalOrgName,InputOrgName,InputUserName,InputDate,UpdateDate,BusinessTypeName",true);	
		
		if(sAuthorType.equals("1"))
			doTemp.setDDDWSql("FinalRole","select RoleID,RoleName from ROLE_INFO where RoleAttribute='0' and RoleStatus='1' order by RoleID ");
		else if(sAuthorType.equals("2"))
			doTemp.setDDDWSql("FinalRole","select RoleID,RoleName from ROLE_INFO where RoleAttribute='2' and RoleStatus='1' order by RoleID ");
		else
			doTemp.setDDDWSql("FinalRole","select RoleID,RoleName from ROLE_INFO where RoleAttribute='4' and RoleStatus='1' order by RoleID ");
			
		doTemp.setDDDWSql("BusinessKind","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'BusinessKind' and IsInUse='1'");
		doTemp.setDDDWCode("MathMark","MathMark");
		doTemp.setDDDWCode("VouchType","VouchType2");
		//doTemp.setDDDWCode("Attribute1","HaveNot");
		//doTemp.setDDDWCode("Attribute2","HaveNot");
		doTemp.setUnit("FinalOrgName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectFinalOrg()>");
		doTemp.setUnit("BusinessTypeName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.SelectAllBusinessType()>");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		sBusinessKind = getItemValue(0,getRow(),"BusinessKind");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(sBusinessKind=="20" || sBusinessKind=="90")
		{
			if (typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("��ҵ�����͡�ѡ����ˣ���ҵ��Ʒ�֡����");
				return;
			}
		}
		else 
		{
			if (typeof(sBusinessType)!="undefined" && sBusinessType.length!=0)
			{
				alert("��ҵ�����͡�ѡ��˾�����ţ���ҵ��Ʒ�֡������");
				setItemValue(0,getRow(),"BusinessTypeName","");		
				setItemValue(0,getRow(),"BusinessType","");		
				return;
			}
		}
	
		sFinalOrg = getItemValue(0,getRow(),"FinalOrg");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			initSerialNo();//��ʼ����ˮ���ֶ�		
		setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");		
		as_save("myiframe0");		
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/UserAuthManage/UserAuthList.jsp?ObjectType=<%=sObjectType%>&Type=<%=sAuthorType%>","_self","");
	}
	
	/*~[Describe=ѡ��֧�л���;InputParam=��;OutPutParam=��;]~*/
	function selectFinalOrg()
	{
		if("<%=sAuthorType%>" == "2")	//����
			sParaString = "OrgLevel,3";
		else if("<%=sAuthorType%>" == "3")	//֧��
			sParaString = "OrgLevel,6";
		else
			sParaString = "OrgLevel,0";
			
		setObjectValue("SelectSubOrg",sParaString,"@FinalOrg@0@FinalOrgName@1",0,0,"");
		//setObjectValue("SelectAllOrg","","@FinalOrg@0@FinalOrgName@1",0,0,"");
		
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>
								
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"AuthorType","<%=sAuthorType%>");
			if("<%=sAuthorType%>" == "1")
				setItemValue(0,getRow(),"FinalOrg","9999");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");				
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "USER_AUTHORIZATION";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	function SelectAllBusinessType()
	{
		setObjectValue("SelectAllBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
