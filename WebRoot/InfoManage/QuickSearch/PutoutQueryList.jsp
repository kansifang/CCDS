<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: ��ͬ��Ϣ���ٲ�ѯ
			Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ���ͬ��Ϣ���ٲ�ѯ
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�Ŵ���Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	String isPutOutInfoM=CurUser.hasRole("097")?"Yes":"No";//�Ƿ�ſ��޸�Ա���ǵĻ��ſ�ͨ������Ȼ�����޸ĳ�����Ϣ���տ�����Ϣ
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
					{"OperateOrgName","�Ŵ�����"},
					{"PutoutOrgName","�Ŵ�����"},
					{"ContractSerialNo","��ͬ��ˮ��"},
					{"SerialNo","������ˮ��"},
					{"CustomerName","�ͻ�����"},										
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"BusinessSum","���"},
					{"Balance","���"},										
					}; 
	
	sSql =	" select fo.ObjectType,fo.FlowNo,fo.PhaseNo,getOrgName(OperateOrgID) as OperateOrgName,"+
	" getOrgName(getHeaderOrgID(bp.OperateOrgID))||'-'||getOrgName(bp.OperateOrgID) as PutoutOrgName,bp.ContractSerialNo,bp.SerialNo ,"+
	" bp.CustomerName,getBusinessName(bp.BusinessType) as BusinessTypeName,bp.BusinessSum,GetBalanceByPutoutNo(bp.SerialNo) as Balance,bp.ExchangeType"+
	" from business_putout bp,flow_object fo"+
	" where fo.ObjectType='PutOutApply' "+
	" and fo.PhaseNo='1000'"+
	" and fo.ObjectNo=bp.SerialNo"+
	" and "+(isPutOutInfoM.equals("Yes")?"1=1":"bp.OperateOrgID in (select BelongOrgID from ORG_Belong where OrgID = '"+CurOrg.OrgID+"')")+
	" order by bp.SerialNo desc";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("bp.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("bp.SerialNo",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,BusinessRate,Balance","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,BailRatio","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,RateFloat,BusinessRate,Balance,TermMonth,BailRatio","Number");
	doTemp.setCheckFormat("BusinessRate","16");
	
	doTemp.setVisible("OperateOrgName,ObjectType,FlowNo,PhaseNo,ExchangeType",false);
	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","OperateOrgName","");		
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewTab()",sResourcesPath},
			{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
			{"false","","Button","��ӡ����׼��֤","��ӡ����׼��֤","print()",sResourcesPath}
		};
		if(isPutOutInfoM.equals("Yes")){
			sButtons[2][0]="true";
		}
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sIsPOM="<%=isPutOutInfoM%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		if (sIsPOM == "Yes") {
			sParamString += "&ViewID=000"
		}else{
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//��ó������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//added by bllou 2012-03-27 �ſ��޸�Ա�����޸��Ѿ������������ĳ�����Ϣ
	/*~[Describe=��ӡ����֪ͨ��;InputParam=��;OutPutParam=��;]~*/
	function print(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		var sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sReturn = PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?ObjectNo="+sObjectNo+"&ContractSerialNo="+sContractSerialNo,"","");	
	}
	

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
