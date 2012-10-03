<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2010/02/01
*	Tester:
*	Describe: �����������б�;
*	Input Param:
*		CustomerID��--��ǰ�ͻ����
*		SerialNo:	--������Ϣ��ˮ��
*		EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
*	Output Param:     
*        
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//���ҳ�����
	
	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","��������ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"AssessFormTypeName","������"},
							{"AssessLevel","�������õȼ�"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						   };
	
	String sSql = 	" Select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName, " +
					" AssessFormType,getItemName('AssessFormType',AssessFormType) as AssessFormTypeName,getItemName('AssessLevel',AssessLevel) as AssessLevel, "+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName, " +
					" InputUserID,getUserName(InputUserID) as InputUserName, " +
					" InputDate  " +
					" from ASSESSFORM_INFO " +
					" Where ObjectNo = '"+sCustomerID+"'"+
					" and ObjectType='Customer' ";	  

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,AssessFormType,ObjectNo,ObjectType,InputOrgID,InputUserID",false);
	if("0501".equals(sCustomerType))
	{
		doTemp.setVisible("AssessLevel",false);
	}
	doTemp.UpdateTable = "ASSESSFORM_INFO";
	//����
	doTemp.setAlign("InputDate,CustomerName,AssessLevel","2");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("InputOrgName,InputUserName,InputDate"," style={width:80px} ");
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
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
		{"true","","Button","����","�����ͻ�������Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ�������Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ�������Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","��ӡ","��ӡ","my_Print()",sResourcesPath},
		};
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
		var sCustomerType= "<%=sCustomerType%>";
		var sAssessFormType="";
		if(sCustomerType == "03" )//���˿ͻ�
		{
			//�����Ի�ѡ���
			var sReturn = PopPage("/Common/Evaluate/AssessFormTypeChoice.jsp?ShowFlag=010","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				sReturn = sReturn.split("@");
				sAssessFormType = sReturn[0];
			}else
			{
				return;
			}
		}
		OpenPage("/Common/Evaluate/AssessformInfo.jsp?AssessFormType="+sAssessFormType+"&EditRight=01","_self","");	
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{	
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='01';
		else
			sEditRight='02';  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAssessFormType = getItemValue(0,getRow(),"AssessFormType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/Common/Evaluate/AssessformInfo.jsp?SerialNo="+sSerialNo+"&AssessFormType="+sAssessFormType+"&EditRight="+sEditRight,"_self","");
		}
	}
	
	/*~[Describe=��ӡ;InputParam=��;OutPutParam=��;]~*/
	function my_Print()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sAssessFormType = getItemValue(0,getRow(),"AssessFormType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��  	
		}else
		{
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false") //δ���ɳ���֪ͨ��
			{
				//���ɳ���֪ͨ��	
				PopPage("/FormatDoc/Evaluate/"+sAssessFormType+".jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			OpenPage("/FormatDoc/POPreviewFile.jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
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

<%@include file="/IncludeEnd.jsp"%>
