<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.12
		Tester:
		Content: ��ծ�ʲ�����̨��AppDisposingList.jsp
		Input Param:								
				ObjectType���������ͣ�ASSET_INFO��
				ObjectNo�������ţ��ʲ���ˮ�ţ�        
		Output param:

		History Log: zywei 2005/09/07 �ؼ����		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�����̨���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
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
							{"ObjectType","��������"},
							{"ObjectNo","�ʲ����"},							
							{"AssetName","�ʲ�����"},
							{"SerialNo","������ˮ��"},
							{"AgreementNo","����Э���"},
							{"BargainDate","��������"},
							{"DispositionType","���÷�ʽ"},
							{"DispositionTypeName","���÷�ʽ"},
							{"DispositionSum","��������(Ԫ)"},
							{"DispositionCharge","���÷���(Ԫ)"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						};
						
	//�ӵ�ծ�ʲ�������Ϣ��ASSET_DISPOSITON��ѡ��������Ϣ��¼
	sSql =  " select ASSET_DISPOSITION.ObjectType as ObjectType,"+
			" ASSET_DISPOSITION.ObjectNo as ObjectNo,"+
			" ASSET_DISPOSITION.SerialNo as SerialNo,"+			
			" ASSET_INFO.AssetName as AssetName,"+
			" ASSET_DISPOSITION.BargainDate as BargainDate,"+
			" ASSET_DISPOSITION.AgreementNo as AgreementNo,"+
			" ASSET_DISPOSITION.DispositionType as DispositionType,"+
			" getItemName('DispositionType',trim(ASSET_DISPOSITION.DispositionType)) as DispositionTypeName,"+
			" ASSET_DISPOSITION.DispositionSum as DispositionSum,"+
			" ASSET_DISPOSITION.DispositionCharge as DispositionCharge,"+
			" getUserName(ASSET_DISPOSITION.InputUserID) as InputUserName, " +	
			" getOrgName(ASSET_DISPOSITION.InputOrgID) as InputOrgName ,"+			
			" ASSET_DISPOSITION.InputDate as InputDate"+
			" from ASSET_DISPOSITION,ASSET_INFO" +
			" where ASSET_DISPOSITION.ObjectType = '"+sObjectType+"' "+
			" and ASSET_INFO.SerialNo = '"+sObjectNo+"' "+
			" and ASSET_DISPOSITION.ObjectNo = '"+sObjectNo+"' "+
			" and (ASSET_DISPOSITION.DispositionType <> '01')  "+
			" order by ASSET_DISPOSITION.InputDate desc ";  //���ⵥ������.
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_DISPOSITION";	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	
	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,DispositionType,SerialNo,AgreementNo",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("DispositionSum,DispositionCharge,InputDate,InputUserName,BargainDate,DispositionTypeName","style={width:80px} ");  
	doTemp.setHTMLStyle("AgreementNo,AssetName"," style={width:100px} ");
	doTemp.setUpdateable("DispositionTypeName",false); 
	//���ö��뷽ʽ
	doTemp.setAlign("DispositionSum,DispositionCharge","3");
	doTemp.setType("DispositionSum,DispositionCharge","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("DispositionSum,DispositionCharge","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
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
			{"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","����","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"true","","Button","�����������","�����������","my_Statistics()",sResourcesPath}	
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
		var sDispositionInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sDispositionInfo) != "undefined" && sDispositionInfo.length != 0)
		{			
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp?DispositionType="+sDispositionInfo+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
		} 		
	}

	/*~[Describe=��ծ�ʲ������ս����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Statistics()
	{
		var sObjectNo="<%=sObjectNo%>";//�ʲ����к�
		//type=1 ��ζ�Ŵ�AppDisposingList��ִ�д����սᲢ�һ��ܡ�
		//type=2 ��ζ�Ŵ�PDADisposalEndList�в쿴���ܡ�
		//type=3 ��ζ�Ŵ�PDADisposalBookList�в쿴���ܡ�
        sReturn=popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sObjectNo+"~Type=3","dialogWidth:720px;dialogheight:580px","");
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
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//����ʲ�������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sDispositionType = getItemValue(0,getRow(),"DispositionType");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp?SerialNo="+sSerialNo+"&DispositionType="+sDispositionType+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
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