<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: ��ծ�ʲ���ֵ������¼
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
	String PG_TITLE = " ��ծ�ʲ���ֵ������¼"; // ��������ڱ��� <title> PG_TITLE </title>
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
										{"SerialNo","������¼��ˮ��"},
										{"ObjectType","��������"},
										{"ObjectNo","�ʲ���ˮ��"},										
										{"AssetName","�ʲ�����"},
										{"EvaluateReportNo","����������"},	
										{"EvaluateDate","��������"},	
										{"EvaluateSum","�����г��۸�(Ԫ)"},	
										{"EvaluateOrgID","��������"}, 
										{"EvaluateMethod","��������"},
										{"EvaluateMethodName","��������"}
									}; 
	//�ӵ�ծ�ʲ���ֵ������EVALUATE_INFO��ѡ�����ʲ��ļ�ֵ������¼
	sSql =  " select EI.SerialNo,"+
			" EI.ObjectType,"+
			" EI.ObjectNo,"+			
			" AI.AssetName, "+
			" EI.EvaluateReportNo,"+
			" EI.EvaluateDate,"+				
			" EI.EvaluateSum,"+
			" EI.EvaluateOrgID," +	
			" EI.EvaluateMethod," +	
			" getItemName('EvaluateMethod',EI.EvaluateMethod) as EvaluateMethodName"+
			" from EVALUATE_INFO EI, ASSET_INFO AI" +
			" where EI.ObjectType='"+sObjectType+"' "+
			" and EI.ObjectNo='"+sObjectNo+"' "+
			" and EI.ObjectNo=AI.SerialNo "+
			" order by EI.EvaluateDate desc";
			//��Ӧ��ObjectType��ĳ���ʲ��ļ�ֵ������¼��
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_INFO";	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,EvaluateMethod",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("SerialNo,ObjectNo,EvaluateDate","style={width:80px} ");  
	doTemp.setHTMLStyle("AssetName,EvaluateReportNo,EvaluateSum","style={width:100px} ");  
	doTemp.setHTMLStyle("EvaluateOrgID,EvaluateMethod"," style={width:80px} ");
	doTemp.setCheckFormat("EvaluateSum","2");	
	
	//���ö��뷽ʽ
	doTemp.setAlign("EvaluateSum","3");
	doTemp.setType("EvaluateSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("EvaluateSum","2");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
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
		{"true","","Button","����","������ֵ������¼","newRecord()",sResourcesPath},
		{"true","","Button","����","��ֵ������¼����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������¼","deleteRecord()",sResourcesPath}
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp","right","");
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
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp?SerialNo="+sSerialNo,"right","");
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
