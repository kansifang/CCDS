<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	String sSortNo; //������
	
    //���ҳ�����	
    //����������	
    String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if (sModelNo == null) sModelNo = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
					{"ModelNo","��������"},
					{"ItemNo","��Ŀ���"},
					{"DisplayNo","��ʾ���"},
					{"ItemName","��Ŀ����"},
					{"ItemAttribute","��Ŀ����"},
					{"ValueMethod","ȡֵ����"},
					{"ValueCode","ȡֵ����"},
					{"ValueType","ֵ����"},
					{"EvaluateMethod","��������"},
					{"Coefficient","ϵ��"},
					{"Remark","��ע"},
			       };  

	sSql = " Select  "+
		"ModelNo,"+
		"ItemNo,"+
		"DisplayNo,"+
		"ItemName,"+
		"ItemAttribute,"+
		"ValueMethod,"+
		"ValueCode,"+
		"ValueType,"+
		"EvaluateMethod,"+
		"Coefficient,"+
		"Remark "+ 
		"From EVALUATE_MODEL";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_MODEL";
	doTemp.setKey("ModelNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("ModelNo",false);
	doTemp.setHTMLStyle("ItemNo,DisplayNo,ValueType,Coefficient"," style={width:60px} ");
	doTemp.setHTMLStyle("ItemName"," style={width:160px} ");
	doTemp.setHTMLStyle("ItemAttribute"," style={width:160px} ");
	doTemp.setHTMLStyle("ValueMethod"," style={width:200px} ");
	doTemp.setHTMLStyle("ValueCode"," style={width:160px} ");
	doTemp.setHTMLStyle("EvaluateMethod"," style={width:200px} ");
	doTemp.setHTMLStyle("Remark"," style={width:160px} ");

	//����С����ʾ״̬,
	doTemp.setAlign("Coefficient","3");
	doTemp.setType("Coefficient","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("Coefficient","2");

	if(sModelNo!=null && !sModelNo.equals("")) 
	{
		doTemp.WhereClause+=" Where ModelNo='"+sModelNo+"' order by DisplayNo";
	}
	
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);
    
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","����","doReturn('N')",sResourcesPath}
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
    var sCurModelNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/EvaluateManage/EvaluateModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo="+sModelNo+"~ItemNo="+sItemNo,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/EvaluateManage/EvaluateModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
