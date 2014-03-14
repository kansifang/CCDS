<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-26
			Tester:
			Content: ��������Ϣ���ٲ�ѯ
			Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ���������Ϣ���ٲ�ѯ
		          
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
		String PG_TITLE = "���Ѻ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sComponentName = "";//--����������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//�����ͷ�ļ�
	String sHeaders[][] =	{ 							
						{"customername","�����"},
						{"SerialNo","��ͬ��ˮ��"},
						{"businesssum","��ͬ���"},
						{"balance","��ͬ���"},
						{"putoutdate","������"},
						{"maturity","������"},
						{"maturity","������"},
						{"businesstypename","ҵ��Ʒ��"},
						{"OwnerName","Ȩ��������"},
						{"GuarantyID","�����Ѻ����"},
						{"GuarantyName","�����Ѻ������"},
						{"GuarantyType","�����Ѻ������"},
						{"GuarantyTypeName","�����Ѻ������"},
						{"OwnerType","Ȩ��������"},
						{"EvalCurrencyName","�����Ѻ����������"},
						{"EvalNetValue","�����Ѻ��������ֵ"},
						{"GuarantyCurrencyName","�����Ѻ���϶�����"},
						{"ConfirmValue","�����Ѻ���϶���ֵ"},
						{"InputOrgID","�Ǽǻ���"},
						{"InputOrgIDName","�Ǽǻ���"},
						{"GuarantyRightID","Ȩ֤��"}
					}; 
	
	sSql =	
	"`select  bc.customername,bc.SerialNo,bc.businesssum,bc.balance,bc.putoutdate,bc.maturity,getbusinessname(bc.businesstype) as businesstypename,"+
	" gi.InputOrgID,getOrgName(gi.InputOrgID) as InputOrgIDName, "+
	" gi.GuarantyID,gi.GuarantyName,gi.GuarantyType,getItemName('GuarantyList',gi.GuarantyType) as GuarantyTypeName,gi.GuarantyRightID,gi.OwnerName, " +
	" getItemName('SecurityType',gi.OwnerType) as OwnerType," +
	" getItemName('Currency',gi.EvalCurrency) as EvalCurrencyName,gi.EvalNetValue,"+
	" getItemName('Currency',gi.GuarantyCurrency) as GuarantyCurrencyName,gi.ConfirmValue" +
	" from GUARANTY_INFO gi,guaranty_relative gr ,business_contract bc "+
	" where gi.InputOrgID in  (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') "+
	" and gr.objecttype in ('BusinessContract','ReinforceContract') "+
	" and gi.guarantyid=gr.guarantyid and gr.objectno=bc.serialno and bc.Flag9 = '1' ";

	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("gi.GuarantyID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_INFO";	
	//���ùؼ���
	doTemp.setKey("GuarantyID",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("OwnerName","style={width:250px} ");  
	//���ò��ɼ���
	doTemp.setVisible("GuarantyType,InputOrgID",false);		
	//���ö��뷽ʽ
	doTemp.setAlign("EvalNetValue,ConfirmValue","3");
	doTemp.setType("businesssum,balance,EvalNetValue,ConfirmValue","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("businesssum,balance,EvalNetValue,ConfirmValue","2");	
	//����������
	doTemp.setDDDWSql("GuarantyType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GuarantyList' and ItemNo not like '030%' and length(ItemNo) > 3");

	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","GuarantyName","");
	//doTemp.setFilter(Sqlca,"2","GuarantyType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","EvalNetValue","");
	doTemp.setFilter(Sqlca,"4","GuarantyID","");
	doTemp.setFilter(Sqlca,"5","InputOrgIDName","");
	doTemp.setFilter(Sqlca,"6","SerialNo","");
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
		};
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

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�������ˮ��
		sGuarantyID    =getItemValue(0,getRow(),"GuarantyID");	
		sGuarantyType=getItemValue(0,getRow(),"GuarantyType");
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
		    popComp("GuarantyThingQueryInfo","/InfoManage/QuickSearch/GuarantyThingQueryInfo.jsp","GuarantyType="+sGuarantyType+"&GuarantyID="+sGuarantyID,"","");
		}			 
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
