<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-9
		Tester:
		Describe: ������ͬ��Ϣ����Ч�ģ���һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:			
			SerialNo��������ͬ��	
			GuarantyType��������ʽ		
		Output Param:

		HistoryLog:
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "һ�㵣����ͬ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������	
	String sTempletFilter = "";//��������
	String sSql = "";
	
	//����������
	
	//���ҳ�������������ͬ���
    String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	if(sSerialNo == null) sSerialNo = "";
	if(sGuarantyType == null) sGuarantyType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//��������
	sTempletFilter = " (ColAttribute like '%BC%' ) ";
	    
	//���ݵ�������ȡ����ʾģ���
	sSql="select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='"+sGuarantyType+"'";
	String sTempletNo = Sqlca.getString(sSql);

	//ͨ����ʾģ��͹�����������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//����ֻ������
	doTemp.setReadOnly("GuarantorName,CertType,CertID,LoanCardNo",true);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		if(!ValidityCheck()) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	function ValidityCheck()
	{		
		ssTempletNo	= "<%=sTempletNo%>";
		sCommonDate = getItemValue(0,getRow(),"CommonDate");
		sSignDate = getItemValue(0,getRow(),"SignDate");
		sBeginDate = getItemValue(0,getRow(),"BeginDate");			
		sEndDate = getItemValue(0,getRow(),"EndDate");
			
		if(ssTempletNo=="Guaranty011" || ssTempletNo=="Guaranty050" || ssTempletNo=="Guaranty060" || ssTempletNo=="Guaranty070" )
		{
			//�����������ڵ��߼�
			if (typeof(sSignDate)!="undefined" && sSignDate.length > 0)
			{
				if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
				{	
					if (typeof(sEndDate)!="undefined" && sEndDate.length > 0)
					{
						if(!(( sSignDate <= sBeginDate ) && (sBeginDate <= sEndDate)))
						{		    
							alert("��ͬǩ����Ӧ��С�ڵ��ں�ͬ��Ч�գ����Һ�ͬ��Ч��Ӧ��С�ڵ��ں�ͬ������!");
							return false;		    
						}
					}
				}
			}
		}else if(ssTempletNo=="Guaranty012" || ssTempletNo=="Guaranty013" )
		{
			//�����������ڵ��߼�
			if (typeof(sSignDate)!="undefined" && sSignDate.length > 0)
			{
				if (typeof(sCommonDate)!="undefined" && sCommonDate.length > 0)
				{
					if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
					{	
						if (typeof(sEndDate)!="undefined" && sEndDate.length > 0)
						{
							if(!(( sSignDate <= sCommonDate ) && ( sCommonDate <= sBeginDate ) && (sBeginDate <= sEndDate)))
							{	
								if(ssTempletNo=="Guaranty012")
								{	    
									alert("��ͬǩ����Ӧ��С�ڵ��ڱ��ս����գ����ս�����Ӧ��С�ڵ��ڱ�����Ч�գ�������Ч��Ӧ��С�ڵ��ڱ��յ�����!");
									return false;
								}else		    
								{
									alert("��ͬǩ����Ӧ��С�ڵ��ڱ���ǩ���գ�����ǩ����Ӧ��С�ڵ��ڱ�����Ч�գ�������Ч��Ӧ��С�ڵ��ڱ���������!");
									return false;
								}
							}
						}
					}
				}
			}
		}
		return true;
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAssure/ValidAssureList1.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
