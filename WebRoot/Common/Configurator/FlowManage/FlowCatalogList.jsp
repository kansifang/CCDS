<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ����ģ���б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	
	//����������	
	
	//���ҳ�����	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"FlowNo","���̱��"},
			{"FlowName","��������"},
			{"FlowType","��������"},
			{"FlowDescribe","��������"},
			{"InitPhase","��ʼ�׶�"},
			{"AAEnabled","�Ƿ������Ȩ����"},
			{"AAPolicy","��Ȩ����"}
		};

	sSql =  " select FlowNo,FlowName,getItemName('ApplyType',FlowType) as FlowType, "+
			" FlowDescribe,getPhaseName(FlowNo,InitPhase) as InitPhase, "+
			" getItemName('YesNo',AAEnabled) as AAEnabled, "+
			" getPolicyName(AAPolicy) as AAPolicy "+
			" from FLOW_CATALOG where 1=1 and FlowNo not in ('SMEConFlow','SMECreditFlow')";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FlowNo,FlowName"," style={width:150px} ");
	doTemp.setHTMLStyle("FlowType,InitPhase"," style={width:150px} ");	
	doTemp.setHTMLStyle("FlowDescribe"," style={width:260px} ");
	doTemp.setAlign("FlowType,AAEnabled","2");

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//��ѯ
 	doTemp.setColumnAttribute("FlowNo,FlowName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelFlowModel(#FlowNo)");
	
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����ģ���б�","�鿴/�޸�����ģ���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","ҵ��������Ϣ","�鿴��ѡ���̵�ҵ����Ϣ","viewInfo()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","");        
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/FlowManage/FlowCatalogList.jsp","_self","");    
                }
            }
        }
        reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        //openObject("FlowCatalogView",sFlowNo,"001");
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0010","");
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        //popComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo="+sFlowNo,"");
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0020","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('49'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	 /*~[Describe=�鿴��ѡ���̵�ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewInfo()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		var sFlowType;		
        if(sFlowNo == "CreditFlow")//����������������
        	sFlowType = "01";
        if(sFlowNo == "ApproveFlow")//�������������������
        	sFlowType = "02";
        if(sFlowNo == "PutOutFlow")//ҵ�������������
        	sFlowType = "03";
        popComp("FlowFindList","/SystemManage/GeneralSetup/FlowFindList.jsp","FlowType="+sFlowType,"");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
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
