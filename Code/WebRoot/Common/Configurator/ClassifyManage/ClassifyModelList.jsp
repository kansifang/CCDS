<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ������ģ���б�
		Input Param:
                  
		Output param:
		                
		History Log: xhgao 2009-03-20 �����ؼ�
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
    //���ҳ�����	
    //����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
    if (sModelNo == null)	sModelNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"ModelNo","ģ����"},
			{"GroupNo","����	"},
			{"ConditionNo","�������"},
			{"Status","״̬	"},
			{"NextStatus","����״̬"},
			{"NextAction","��������"},
			};

	sSql = "select "+
			"ModelNo,"+
			"GroupNo,"+
			"ConditionNo,"+
			"Status,"+
			"NextStatus,"+
			"NextAction "+
			"from CLASSIFY_MODEL Where ModelNo = '" +sModelNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("ModelNo,GroupNo,ConditionNo,Status",true);
	doTemp.UpdateTable="CLASSIFY_MODEL";
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("NextAction",false);    	

 	doTemp.setHTMLStyle("ModelNo"," style={width:160px} ");

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
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
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
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","����","doReturn('N')",sResourcesPath}
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
        sReturn=popComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/ClassifyManage/ClassifyModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        sGroupNo = getItemValue(0,getRow(),"GroupNo");
        sConditionNo = getItemValue(0,getRow(),"ConditionNo");
        sStatus = getItemValue(0,getRow(),"Status");
        if(typeof(sGroupNo)=="undefined" || sGroupNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo="+sModelNo+"~GroupNo="+sGroupNo+"~ConditionNo="+sConditionNo+"~Status="+sStatus,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/ClassifyManage/ClassifyModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sGroupNo = getItemValue(0,getRow(),"GroupNo");
        if(typeof(sGroupNo)=="undefined" || sGroupNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
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
