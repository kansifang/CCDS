<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ���񱨱�ģ���б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���񱨱�ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if (sModelNo == null) 	sModelNo = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"ModelNo","ģ�ͱ��"},
			{"RowNo","�б��"},
			{"RowName","������"},
			{"RowSubject","��Ӧ��Ŀ"},
			{"RowSubjectName","��Ӧ��Ŀ"},
			{"DisplayOrder","��ʾ����"},
			{"RowAttribute","������"},
			{"Col1Def","��1����"},
			{"Col2Def","��2����"},
			{"Col3Def","��3����"},
			{"Col4Def","��4����"},
			{"StandardValue","��׼ֵ"},
			{"DeleteFlag","ɾ����־"},
		};

	sSql = "Select "+
			"RM.ModelNo,"+
			"RM.RowNo,"+
			"RM.RowName,"+
			"RM.RowSubject,"+
			"FI.ItemName as RowSubjectName,"+
			"RM.DisplayOrder,"+
			"RM.RowAttribute,"+
			"RM.Col1Def,"+
			"RM.Col2Def,"+
			"RM.Col3Def,"+
			"RM.Col4Def,"+
			"RM.StandardValue,"+
			"RM.DeleteFlag "+
			" From REPORT_MODEL RM,FINANCE_ITEM FI"+
			" Where RM.RowSubject = FI.ItemNo and RM.ModelNo = '"+sModelNo+"' Order by 2";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_MODEL";
	doTemp.setKey("ModelNo,RowNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("ModelNo,RowSubject,Col3Def,Col4Def,DeleteFlag",false);
	doTemp.setHTMLStyle("ModelNo,RowNo,RowSubject,DisplayOrder,StandardValue,DeleteFlag"," style={width:60px} ");
	doTemp.setHTMLStyle("RowName"," style={width:200px} ");
	doTemp.setHTMLStyle("RowAttribute,Col1Def,Col2Def,Col3Def,Col4Def"," style={width:250px} ");
	doTemp.appendHTMLStyle("Col1Def,Col2Def,Col3Def,Col4Def","style=cursor:hand onDBLClick=\"parent.myDBLClick(this)\"");
	//doTemp.appendHTMLStyle("RowSubjectName","style=cursor:hand onDBLClick=\"parent.SelectSubject()\"");
	
	doTemp.setReadOnly("RowSubjectName",true);
	doTemp.setUpdateable("RowSubjectName",false);
	
	//��ѯ
 	doTemp.setColumnAttribute("ModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����/���¹�ʽ����","��ʽ�����Ľ�������/���µ�formulaexp�ֶ���","genExplain()",sResourcesPath}
		};
    %> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurModelNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/ReportManage/ReportModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
        as_save("myiframe0","");
        
	}

    function myDBLClick(myobj)
    {
        editObjectValueWithScriptEditorForAFS(myobj,'<%=sModelNo%>');
    }

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        sRowNo = getItemValue(0,getRow(),"RowNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo="+sModelNo+"~RowNo="+sRowNo,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/ReportManage/ReportModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sRowNo = getItemValue(0,getRow(),"RowNo");
        if(typeof(sRowNo)=="undefined" || sRowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function genExplain()
	{
		var sReturn = RunMethod("Configurator","GenFinStmtExplain","<%=sModelNo%>");
		if(typeof(sReturn)!="undefined" && sReturn=="succeeded"){
			alert("�ѽ���ʽ�����Ľ�������/���µ�formulaexp1��formulaexp2�ֶ��С�");
		}else{
			alert(sReturn);
		}
	}

	function SelectSubject()
	{		
		setObjectValue("SelectAllSubject","","@RowSubject@0@RowSubjectName@1",0,0,"");			
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
