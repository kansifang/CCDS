<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: �������ʲ����������ͬ�б�RelativeContractList.jsp
		Input Param:				
			    SerialNo����ծ�ʲ����
		Output param:
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����õ��ʲ�������ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
		
	//����������		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//�ʲ���ˮ��
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 									
							{"AssetName","�ʲ�����"},
							{"ContractSerialNo","��ͬ��ˮ��"},						
							{"CustomerName","�ͻ�����"},
							{"BusinessCurrencyname","��ͬ����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","��ͬ���"},
							{"IndebtSum","��ծ���(Ԫ)"},	
							{"Principal","���뱾��(Ԫ)"},	
							{"IndebtInterest","����Ϣ(Ԫ)"},	
							{"OutdebtInterest","����Ϣ(Ԫ)"}, 
							{"OtherInterest","����(Ԫ)"}
						}; 
						
	//�ӵ�ծ�ʲ�������Ϣ��ASSET_CONTRACT��ѡ��������ĺ�ͬ���������Ϣ
	sSql =  " select AI.SerialNo as SerialNo,"+		
			" AI.AssetName as AssetName,"+
			" AC.ContractSerialNo as ContractSerialNo,"+			
			" BC.CustomerName as CustomerName,"+
			" getItemName('Currency', BC.BusinessCurrency)  as  BusinessCurrencyname,"+
			" BC.BusinessSum as BusinessSum,"+
			" BC.Balance as Balance,"+
			" AC.IndebtSum as IndebtSum,"+
			" AC.Principal as Principal,"+
			" AC.IndebtInterest as IndebtInterest,"+
			" AC.OutdebtInterest as OutdebtInterest,"+
			" AC.OtherInterest  as OtherInterest"+
			" from ASSET_CONTRACT AC,BUSINESS_CONTRACT BC,ASSET_INFO AI" +
			" where AC.SerialNo = AI.SerialNo "+
			" and BC.SerialNo = AC.ContractSerialNo  "+
			" and AI.SerialNo = '"+sSerialNo+"' "+
			" order by AC.ContractSerialNo desc";

	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_CONTRACT";
	
	//���ùؼ���
	doTemp.setKey("SerialNo,ContractSerialNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("SerialNo",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("SerialNo,ContractSerialNo,AssetName","style={width:100px} ");  
	doTemp.setHTMLStyle("IndebtSum,Principal,IndebtInterest,IndebtInterest,OutdebtInterest,OtherInterest,BusinessCurrencyname,AssetNo","style={width:80px} ");  
	
	//���ö��뷽ʽ
	doTemp.setAlign("IndebtSum,Principal,IndebtInterest,OutdebtInterest,,BusinessSum,Balance,OtherInterest","3");
	doTemp.setType("IndebtSum,Principal,IndebtInterest,OutdebtInterest,,BusinessSum,Balance,OtherInterest","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("IndebtSum,Principal,IndebtInterest,OutdebtInterest,,BusinessSum,Balance,OtherInterest","2");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	//��������¼�
	
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
		{"true","","Button","����","����һ����ͬ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ͬ����","�쿴��ͬ����","my_Contract()",sResourcesPath}	,
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}		
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
		var sRelativeContractNo = "";	
		//��ȡ��ծ�ʲ������ĺ�ͬ��ˮ��	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_")  
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}		
		if(sRelativeContractNo == "" || typeof(sRelativeContractNo) == "undefined") return;
		{	
			sSerialNo = "<%=sSerialNo%>";			
			popComp("PDARelativeContractInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sRelativeContractNo+"~SerialNo="+sSerialNo);
			reloadSelf();
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sContractSerialNo) == "undefined" || sContractSerialNo.length == 0)
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
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sContractSerialNo) == "undefined" || sContractSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��	
			return;		
		}
		
		popComp("PDARelativeContractInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sContractSerialNo+"~SerialNo="+sSerialNo);
	}	
	
	/*~[Describe=�鿴��ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Contract()
	{  
		//��ú�ͬ��ˮ��
		var sContractNo = getItemValue(0,getRow(),"ContractSerialNo");  //��ͬ��ˮ�Ż������
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sObjectType = "AfterLoan";
		sObjectNo = sContractNo;				
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
