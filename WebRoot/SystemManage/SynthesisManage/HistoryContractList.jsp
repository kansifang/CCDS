<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hlzhang 2011/10/28
		Tester:
		Describe: ��ͬ��ʷ��¼
		Input Param:
				ObjectType���������ͣ�BusinessContract��
				ObjectNo: ��ͬ��ˮ��
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʷ��ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
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
							{"BCSerialNo","�޸���ˮ��"},
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"BusinessType","ҵ��Ʒ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"ArtificialNo","�ı���ͬ���"},
							{"CustomerName","�ͻ�����"},
							{"SerialNo","��ͬ��ˮ��"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���(Ԫ)"},
							{"RelativeSum","�ѳ��˽��(Ԫ)"},
							{"Balance","���(Ԫ)"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"ManageOrgName","�������"},
							{"UpdateOrgName","���»���"},
							{"UpdateUserName","������Ա"},
						  };

	sSql =	" select BCSerialNo,SerialNo,CustomerID,CustomerName,InterestBalance1,InterestBalance2,"+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" ArtificialNo,BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
			" BusinessSum,Balance,OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,PutOutDate, "+
			" Maturity,ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,getOrgName(UpdateOrgID) as UpdateOrgName,getUserName(UpdateUserID) as UpdateUserName "+
			" from BUSINESS_CONTRACT_BAK "+
			//" where ManageUserID = '"+CurUser.UserID+"' and SerialNo = '"+sObjectNo+"' "+
			" where SerialNo = '"+sObjectNo+"' "+
			" Order by BCSerialNo Desc ";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT_BAK";
    //���ùؼ���
	doTemp.setKey("BCSerialNo",true);
	//���ò��ɼ���
    doTemp.setVisible("InterestBalance1,InterestBalance2,BusinessType,ArtificialNo,BusinessCurrency",false);
    doTemp.setVisible("OccurType,VouchType,ManageOrgID",false);
   	//���ö��뷽ʽ
    //doTemp.setAlign("BusinessSum,Balance","3");
    //�����ֶ�����
    //doTemp.setCheckFormat("BusinessSum,Balance","2");	
	//�����ֶ������������������һ��
	doTemp.setType("BusinessSum,Balance","Number");

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����setEvent
	//dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");

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
			{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()",sResourcesPath},
			{"true","","Button","����","�����б���Ϣ","closeSelf()",sResourcesPath} 
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=��ť����;]~*/%>
	<script language=javascript>
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sBCSerialNo   = getItemValue(0,getRow(),"BCSerialNo");
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBCBusinessType = getItemValue(0,getRow(),"BusinessType");
		
		if(typeof(sBCBusinessType) == "undefined" || sBCBusinessType.length == 0 || sBCBusinessType == "" )
		{
			sBCBusinessType = "1010010";
		}
		
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/HistoryContractInfo.jsp?BCSerialNo="+sBCSerialNo+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo, "_self","");
		}
	}
	
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�ر�;InputParam=��;OutPutParam=��;]~*/
	function closeSelf()
	{
		self.close();  //�رյ�ǰҳ��

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


<%@	include file="/IncludeEnd.jsp"%>