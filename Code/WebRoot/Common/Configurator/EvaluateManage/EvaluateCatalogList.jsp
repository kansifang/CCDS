<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ����ģ��Ŀ¼�б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ģ��Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������

	//����������	
	String sType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if(sType == null) sType = "";
	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
					{"ModelNo","��������"},
					{"ModelName","����������"},
					{"ModelType","���������"},
					{"ModelDescribe","����������"},
					{"TransformMethod","ת������"},
					{"Remark","��ע"},
			       };  

	sSql = 	" Select ModelNo,ModelName,getItemName('EvaluateModelType',ModelType) as ModelType,"+
			" TransformMethod,ModelDescribe,Remark "+ 
			" From EVALUATE_CATALOG ";
	//ģ�����Ͳμ�����EvaluateModelType
	if(sType.equals("Classify")) //�ʲ����շ���
		//sSql += " Where ModelNo = 'Classify1' ";
		sSql += " Where ModelType = '020' ";
	if(sType.equals("Risk")) //���ն�����
		//sSql += " Where ModelNo = 'RiskEvaluate' ";	
		sSql += " Where ModelType = '030' ";	
	if(sType.equals("CreditLine")) //����ۺ����Ŷ�Ȳο�
		//sSql += " Where ModelNo = 'CreditLine' ";
		sSql += " Where ModelType = '080' ";
	if(sType.equals("CreditLevel")) //���õȼ�����	(��˾�ͻ��͸���)
		//sSql += " Where (ModelNo like '0%' or ModelNo like '5%') ";	
		sSql += " Where (ModelType ='010' or ModelType = '015' or ModelType = '017') ";//added by bllou ��һ��ͬҵ	
	sSql += " order by ModelType,ModelNo ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_CATALOG";
	doTemp.setKey("ModelNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("ModelNo"," style={width:120px} ");
	doTemp.setHTMLStyle("ModelName"," style={width:200px} ");
	doTemp.setHTMLStyle("TransformMethod,"," style={width:600px} ");
	doTemp.setHTMLStyle("ModelDescribe,Remark"," style={width:200px} ");
	doTemp.setVisible("ModelDescribe,Remark",false);
	
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//��ѯ
 	doTemp.setColumnAttribute("ModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelEvaluateModel(#ModelNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//added by bllou 2012-09-20 ������ģ����ʾϸ��
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","150");
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
		{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ģ���б�","�鿴/�޸�ģ���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
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
        sReturn=popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/EvaluateManage/EvaluateCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        //openObject("EvaluateCatalogView",sModelNo,"001");
        popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","ModelNo="+sModelNo);
        
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        popComp("EvaluateModelList","/Common/Configurator/EvaluateManage/EvaluateModelList.jsp","ModelNo="+sModelNo,"");
        
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('50'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
		function mySelectRow()
		{
			var sModelNo = getItemValue(0,getRow(),"ModelNo");
			if("<%=Sqlca.getString("select RelativeCode from Code_Library where CodeNo='OperateModelNos' and ItemNo='010' and IsInUse='1'")%>".indexOf(sModelNo)>0){
				document.getElementById("ListHorizontalBar").parentNode.style.display="";
				document.getElementById("ListDetailAreaTD").parentNode.style.display="";
				OpenComp("EvaluateScoreConfigList","/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","ModelNo="+sModelNo+"&CodeNo=CreditLevelToTotalScore","DetailFrame","");
			}else{
				document.getElementById("ListHorizontalBar").parentNode.style.display="none";
				document.getElementById("ListDetailAreaTD").parentNode.style.display="none";
			}
		  	//OpenPage("/ImpawnManage/ShowInfoManage/ImpawnRightDocList.jsp?IMASerialno="+sIMASerialno+"&ImpawnID="+sImpawnID,"DetailFrame","");
		}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
