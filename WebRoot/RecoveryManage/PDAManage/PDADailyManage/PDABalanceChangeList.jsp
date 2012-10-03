<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.16
		Tester:
		Content: ��ծ�ʲ����䶯̨��
		���䶯���ͣ�����ͳ��ۣ�BalanceChangeType
		�ʲ������ʲ����y=�ʲ����е�����a-�䶯���б䶯���b.
		���ʽ�����b>0;otherwise b<0.
		Input Param:
			        ObjectNo�������ţ���ծ�ʲ���ˮ�ţ�
			        ObjectType���������ͣ�ASSET_INFO��						
		Output param:
		
		History Log: zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = " ��ծ�ʲ����䶯̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";

	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";	
	
	//��ȡҳ�����	
	
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
							{"ChangeTypeName","�䶯����"},	
							{"ChangeStyle","�䶯����"},	
							{"ChangeStyleName","�䶯����"},	
							{"ChangeSum","�䶯���(Ԫ)"},	
							{"InputUserName","�Ǽ���"}, 
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						}; 
	//�ӱ䶯���л�ȡ�䶯��¼
	sSql = 	" select ASSET_BALANCE.SerialNo,"+
			" ASSET_BALANCE.ObjectType,"+
			" ASSET_BALANCE.ObjectNo,"+			
			" ASSET_INFO.AssetName,"+
			" ASSET_BALANCE.ChangeDate,"+
			" ASSET_BALANCE.ChangeType,"+
			" getItemName('BalanceChangeType',trim(ASSET_BALANCE.ChangeType)) as ChangeTypeName,"+
			" ASSET_BALANCE.ChangeStyle,"+
			" getItemName('BalanceChangeStyle',trim(ASSET_BALANCE.ChangeStyle)) as ChangeStyleName,"+
			" ASSET_BALANCE.ChangeSum,"+
			" getUserName(ASSET_BALANCE.InputUserID) as InputUserName," + 
			" getOrgName(ASSET_BALANCE.InputOrgID) as InputOrgName," + 
			" ASSET_BALANCE.InputDate"+				
			" from ASSET_BALANCE,ASSET_INFO " +
			" where ASSET_BALANCE.ObjectNo = '"+sObjectNo+"' "+
			" and ASSET_BALANCE.ObjectType = '"+sObjectType+"' "+
			" and ASSET_INFO.SerialNo = ASSET_BALANCE.ObjectNo "+
			" order by ASSET_BALANCE.InputDate desc ";
			//��Ӧ��ObjectType��ĳ���ʲ������䶯��¼��
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_BALANCE";	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,ChangeType,ChangeStyle",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("ChangeDate,InputDate","style={width:70px} ");  
	doTemp.setHTMLStyle("ChangeTypeName,ChangeStyleName","style={width:60px} ");  
	doTemp.setHTMLStyle("ChangeSum,InputUserName","style={width:80px} ");  
	doTemp.setHTMLStyle("InputOrgName","style={width:120px} ");  
	doTemp.setHTMLStyle("AssetName","style={width:100px} ");  
	doTemp.setHTMLStyle("InputUserName"," style={width:80px} ");
		
	doTemp.setCheckFormat("ChangeSum","2");		
	//���ö��뷽ʽ
	doTemp.setAlign("ChangeSum","3");
	doTemp.setType("ChangeSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("ChangeSum","2");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeInfo.jsp","right","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;			
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			// ����ͬʱ�޸ĵ�ծ�ʲ������
			var NewValue = "0"; //�õ��޸�֮���ֵ.	ɾ���൱�ڱ䶯�����ԭ����Ϊ0
			var OldValue = getItemValue(0,getRow(),"ChangeSum");  //�õ�ԭ����ֵ	
			if (OldValue == "") OldValue = "0";

			var TempValue = parseFloat(NewValue)-parseFloat(OldValue);//������Ҫ�䶯��ֵ.
			var sChangeType = getItemValue(0,getRow(),"ChangeType");  //�õ��䶯����	

			//�޸ĵ�ծ�ʲ���ĵ�ծ���.
			var sObjectNo = "<%=sObjectNo%>";//��ծ�ʲ����
			var sReturn = PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeAction.jsp?SerialNo="+sObjectNo+"&Interval_Value="+TempValue+"&ChangeType="+sChangeType,"","");

			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sChangeType = getItemValue(0,getRow(),"ChangeType");  //�õ��䶯����	
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeInfo.jsp?SerialNo="+sSerialNo+"&ChangeType="+sChangeType,"right","");
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