<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: SLLIU 2005-01-15
*	Tester:
*	Describe: �ʲ������Ϣ;
*	Input Param:
*		ObjectType���������ͣ���ȫ�GuarantyInfo������ʲ���AssetInfo��											
*		ObjectNo���ʲ����
*	Output Param:     
*        	
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʲ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  
	  
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";		
	

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
   	String sHeaders[][] = {
					{"SerialNo","��ˮ��"},
					{"WardDate","���ʱ��"},
					{"WardContent","�������"},
					{"OperateUserName","�����"},
					{"OperateOrgName","�������������"},				
					{"InputUserName","�Ǽ���"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputDate","�Ǽ�����"}
			       };  

	String sSql = 	" select  SerialNo,"+
					" WardDate,"+
					" WardContent,"+
					" getUserName(OperateUserID) as OperateUserName," +	
					" getOrgName(OperateOrgID) as OperateOrgName," +	
					" getUserName(InputUserID) as InputUserName," +	
					" getOrgName(InputOrgID) as InputOrgName," +																																																							
					" InputDate " +	
					" from ASSETWARD_INFO " +
					" where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' "+
					" order by InputDate desc";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "ASSETWARD_INFO";

	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo",false);
    
    //����ѡ��˫�����п�
	doTemp.setHTMLStyle("WardContent"," style={width:200px} ");
	doTemp.setHTMLStyle("OperateUserName,InputUserName,WardDate"," style={width:80px} ");
	doTemp.setHTMLStyle("OperateOrgName,InputOrgName"," style={width:120px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);  //��������ҳ

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
			{"true","","Button","����","������Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����Ϣ","deleteRecord()",sResourcesPath}			
		};		
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------		
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardInfo.jsp?SerialNo="+sSerialNo,"_self","");
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
