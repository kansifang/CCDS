<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:         cjiang    2005-8-2 0:03
		Tester:
		Content:        ���������б�
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][]={ {"TypeID","��������ID"},
					      {"TypeName","��������˵��"},
					      {"CheckerClass","���Ƽ��������"},
					      {"LimitationExpr","�����ж�Script"},
					      {"CompileCheckExpr","�޶�����У��Script"},
					      {"ControlType","���Ʒ�ʽ"},
					      {"ObjectType","���ƶ�������"},
					      {"CrossUsageEnabled","�Ƿ���"},
					      {"LimitationComp","�������������ID"},
					      {"LimitationWizard","����������Wizrd"}
					  };
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sSql="select TypeID , TypeName , CheckerClass , LimitationExpr ,"+
	             " CompileCheckExpr , getItemName('ControlType',ControlType) as ControlType , ObjectType , " +
	             " getItemName('YesNo',CrossUsageEnabled) as CrossUsageEnabled , LimitationComp , LimitationWizard "+
	             " from CL_LIMITATION_TYPE " ;
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="CL_LIMITATION_TYPE";
	doTemp.setKey("TypeID",true);
	doTemp.setAlign("ControlType,ObjectType,CrossUsageEnabled","2");
	doTemp.setHTMLStyle("LimitationExpr","style={width:200px}");
	doTemp.setHTMLStyle("ControlType,CrossUsageEnabled","style={width:60px}");
	doTemp.setVisible("ObjectType",false);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//ASDataWindow dwTemp = new ASDataWindow("EntList",doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath}
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
		OpenPage("/Common/Configurator/CreditLineConfig/LimitationTypeInfo.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sTypeID = getItemValue(0,getRow(),"TypeID");
		
		if (typeof(sTypeID)=="undefined" || sTypeID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sTypeID=getItemValue(0,getRow(),"TypeID");
		if (typeof(sTypeID)=="undefined" || sTypeID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		OpenPage("/Common/Configurator/CreditLineConfig/LimitationTypeInfo.jsp?TypeID="+sTypeID,"_self","");
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sTypeID=getItemValue(0,getRow(),"TypeID");
		if (typeof(sTypeID)=="undefined" || sTypeID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		openObject("TypeID",sTypeID,"001");//ʹ��ObjectViewer����ͼ001��Example��
		/*
		 * [�ο�]
		 * ��ͬ����һ�䣺
		 * OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ComponentName=����鿴��&ObjectType=Example&ObjectNo="+sExampleID+"&ViewID=001","_blank",OpenStyle);
		 */
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
