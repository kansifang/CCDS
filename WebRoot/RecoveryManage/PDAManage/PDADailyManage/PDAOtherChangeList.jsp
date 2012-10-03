<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: ��ծ�ʲ������䶯��Ϣ
		Input Param:
			        ObjectNo��������
			        ObjectType����������						
		Output param:
		
		History Log: zywei 2005/09/06 �ؼ����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = " ��ծ�ʲ������䶯��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sComponentName == null) sComponentName = "";
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�䶯��ˮ��"},
							{"ObjectType","��������"},
							{"ObjectNo","�ʲ���ˮ��"},							
							{"AssetName","�ʲ�����"},
							{"ChangeDate","�䶯����"},
							{"ChangeType","�䶯����"},	
							{"ChangeContent","�䶯����"},	
							{"InputUserName","�Ǽ���"}, 
							{"InputOrgName","�Ǽǻ���"}
						}; 
	//�������䶯���л�ȡ�䶯��¼
	sSql =  " select OI.SerialNo,"+
			" OI.ObjectType,"+
			" OI.ObjectNo,"+			
			" AI.AssetName,"+
			" OI.ChangeDate,"+
			" OI.ChangeType,"+
			" OI.ChangeContent,"+				
			" getOrgName(OI.InputOrgID) as InputOrgName," + 
			" getUserName(OI.InputUserID) as InputUserName" + 
			" from OTHERCHANGE_INFO OI,ASSET_INFO AI" +
			" where  OI.ObjectType = '"+sObjectType+"' "+
			" and OI.ObjectNo = '"+sObjectNo+"' "+
			" and OI.ObjectNo = AI.serialNo "+
			" order by OI.ChangeDate desc";
			//��Ӧ��ObjectType��ĳ���ʲ��ı䶯��¼��
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "OTHERCHANGE_INFO";	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("ChangeDate,ChangeType","style={width:80px} ");  
	doTemp.setHTMLStyle("SerialNo,ChangeContent,AssetName","style={width:100px} ");  
	doTemp.setHTMLStyle("InputUserName,InputOrgName"," style={width:80px} ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	
	//����HTMLDataWindow
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
		{"true","","Button","����","�����䶯��¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�䶯��¼����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���䶯��¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAOtherChangeInfo.jsp","right","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;			
		}else
		{
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;	
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAOtherChangeInfo.jsp?SerialNo="+sSerialNo,"right","");
		}
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>	

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
