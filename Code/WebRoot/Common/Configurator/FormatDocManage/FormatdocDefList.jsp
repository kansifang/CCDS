<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fhuang 2007-01-04
		Tester:
		Content: ��ʽ�����涨���б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID"));
	if(sDocID == null) sDocID = "";
	//����������	
	
	//���ҳ�����	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"DocID","������"},
			{"DirID","�ڵ���"},
			{"DirName","�ڵ�����"},
			{"JspFileName","JSP�ļ�"},
		};

	sSql =  " select DocID,DirID,"+
			" DirName,JspFileName "+
			" from FormatDoc_Def where 1=1";
	if (!sDocID.equals(""))
	{
		sSql += " and DocID='"+sDocID+"'";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Def";
	doTemp.setKey("DocID,DirID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID,DirID"," style={width:50px} ");
	doTemp.setHTMLStyle("DirName,JspFileName"," style={width:180px} ");


	//��ѯ
 	doTemp.setColumnAttribute("DocID,DirID,DirName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	doTemp.OrderClause = "Order by DocID,DirID asc";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
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
        sReturn=popComp("FormatdocDefInfo","/Common/Configurator/FormatDocManage/FormatdocDefInfo.jsp","DocID=<%=sDocID%>","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/FormatDocManage/FormatdocDefList.jsp","_self","");    
                }
            }
        }
        
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sDocID = getItemValue(0,getRow(),"DocID");
        sDirID = getItemValue(0,getRow(),"DirID");
        if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        //openObject("FlowCatalogView",sFlowNo,"001");
        popComp("FormatdocDefInfo","/Common/Configurator/FormatDocManage/FormatdocDefInfo.jsp","DocID="+sDocID+"~"+"DirID="+sDirID,"");
        
        
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sDocID = getItemValue(0,getRow(),"DocID");
		sDirID = getItemValue(0,getRow(),"DirID");
        if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('68'))) 
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
