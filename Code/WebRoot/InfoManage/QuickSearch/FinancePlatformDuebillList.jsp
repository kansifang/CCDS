<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  wangdw 2012/06/13
		Tester:
		Content: ����ƽ̨���̨��
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�
					Flag:
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ƽ̨���̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String sFlag = "";//��ʶ
	String PG_CONTENT_TITLE = "";//--��ͷ
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����
	sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));	//���ҳ�����
	if(sFlag==null) sFlag = "";
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 
							{"SERIALNO","�����ˮ��"},
							{"CUSTOMERNAME","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BUSINESSSUM","��ݽ��"},
							{"BALANCE","������"},
							{"BusinessCurrency","����"},
							{"ACTUALBUSINESSRATE","ִ��������"},
							{"RateFloat","���ʸ���ֵ"},
							{"PutOutDate","�����ʼ��"},
							{"Maturity","��ݵ�����"},
							{"VouchType","��Ҫ������ʽ"},
							{"NormalBalance","�������"},
							{"OverdueBalance","���ڽ��"},
							{"DullBalance","�������"},
							{"BadBalance","���ʽ��"},
							{"PlatformLevel_name","ƽ̨����"},
							{"PlatformLevel","ƽ̨����"},
							{"DealClassify_name","���÷���"},
							{"DealClassify","���÷���"},
							{"LegalPersonNature_name","��������"},
							{"LegalPersonNature","��������"},
							{"PlatformType_name","ƽ̨����"},
							{"PlatformType","ƽ̨����"},
							{"CashCoverDegree_name","�ֽ������ǳ̶�"},
							{"CashCoverDegree","�ֽ������ǳ̶�"},
							{"FinanceCreditType_name","�Ŵ�����"},
							{"FinanceCreditType","�Ŵ�����"}
							}; 					
	sSql =	"select BD.SERIALNO,BD.RelativeSerialNo2,BD.CUSTOMERNAME,getBusinessName(BD.BusinessType) as BusinessTypeName,BD.BUSINESSSUM,BD.BALANCE,"
		    +"getItemName('Currency',BD.BusinessCurrency) as BusinessCurrency,BD.ACTUALBUSINESSRATE,BC.RateFloat,"
		    +"BD.PutOutDate,BD.Maturity,getItemName('VouchType',BC.VouchType) as VouchType,BD.NormalBalance,BD.OverdueBalance,BD.DullBalance,BD.BadBalance,"
			+"getItemName('PlatformLevel',CF.PlatformLevel) as PlatformLevel_name,"
		    +"CF.PlatformLevel,"
		    +"getItemName('DealClassify',CF.DealClassify) as DealClassify_name,"
		    +"CF.DealClassify,"
		    +" getItemName('LegalPersonNature',CF.LegalPersonNature) as LegalPersonNature_name,"
		    +"CF.LegalPersonNature,"
		    +" getItemName('FinancePlatformType',CF.PlatformType) as PlatformType_name,"
		    +"CF.PlatformType,"
		    +" getItemName('CashCoverDegree',CF.CashCoverDegree) as CashCoverDegree_name,"
		    +"CF.CashCoverDegree,"
		    +" getItemName('FinanceCreditType',CF.FinanceCreditType) as FinanceCreditType_name,"
		    +"CF.FinanceCreditType"
		    +" from BUSINESS_DUEBILL as BD,BUSINESS_CONTRACT as BC,CUSTOMER_FINANCEPLATFORM as CF "
		    +"where BD.CUSTOMERID=CF.CUSTOMERID and BD.RelativeSerialNo2 = BC.SerialNo";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("EI.CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	//doTemp.setKey("SerialNo",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	//doTemp.setHTMLStyle("PlatformLevel,DealClassify,LegalPersonNature,PlatformType,FinanceCreditType,CashCoverDegree","style={width:250px} ");  
	//���ö��뷽ʽ
	//doTemp.setAlign("OverDueDays,BusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setVisible("PlatformLevel,DealClassify,LegalPersonNature,PlatformType,CashCoverDegree,FinanceCreditType,RelativeSerialNo2",false);
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BUSINESSSUM,BALANCE,ACTUALBUSINESSRATE,RateFloat,NormalBalance,OverdueBalance,DullBalance,BadBalance","2");
	doTemp.setDDDWSql("PlatformLevel","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'PlatformLevel'");
	doTemp.setDDDWSql("DealClassify","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DealClassify'");
	doTemp.setDDDWSql("LegalPersonNature","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'LegalPersonNature'");
	doTemp.setDDDWSql("PlatformType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FinancePlatformType'");
	doTemp.setDDDWSql("CashCoverDegree","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CashCoverDegree'");
	doTemp.setDDDWSql("FinanceCreditType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FinanceCreditType'");
	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","PlatformLevel","");
	doTemp.setFilter(Sqlca,"2","DealClassify","");
	doTemp.setFilter(Sqlca,"3","LegalPersonNature","");
	doTemp.setFilter(Sqlca,"4","PlatformType","");
	doTemp.setFilter(Sqlca,"5","CashCoverDegree","");
	doTemp.setFilter(Sqlca,"6","FinanceCreditType","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
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
			{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
			{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
 	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"RelativeSerialNo2");	
		
	    sObjectType = "AfterLoan";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
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