<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cyyu 2009-03-23
			Tester:
			Content: ���˵������б�
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
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
	//����������
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
			{"CodeNo","������"},
			{"ItemNo","��Ŀ���"},
			{"ItemName","��Ŀ����"},
			{"SortNo","�����"},
			{"IsInUse","�Ƿ����"},
			{"ItemDescribe","��Ŀ����"},
			{"ItemAttribute","��Ŀ����"},
			{"RelativeCode","��������"},
			{"InputUserName","������"},
			{"InputUser","������"},
			{"InputOrgName","�������"},
			{"InputOrg","�������"},
			{"InputTime","����ʱ��"},
			{"UpdateUserName","������"},
			{"UpdateUser","������"},
			{"UpdateTime","����ʱ��"}
	       };  

	sSql = 	" select ItemNo,ItemName,SortNo,getItemName('IsInUse',IsInUse) as IsInUse," +
	" ItemDescribe,ItemAttribute,RelativeCode," +
	" getUserName(InputUser) as InputUserName,InputUser," + 
	" getOrgName(InputOrg) as InputOrgName,InputOrg," +
	" getUserName(UpdateUser) as UpdateUserName,UpdateUser," +
	" InputTime,UpdateTime " +
	" from CODE_LIBRARY where CodeNo='MainMenu' order by ItemNo";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("ItemNo",true);
	doTemp.setHeader(sHeaders);
	
	//�����б���ʾ
	doTemp.setHTMLStyle("ItemNo,SortNo"," style={width:80px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:60px} ");
	doTemp.setHTMLStyle("ItemDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:120px} ");
 	doTemp.setAlign("IsInUse","2");
	doTemp.setVisible("CodeNo,InputUser,InputOrg,UpdateUser,InputUserName,InputOrgName,UpdateUserName",false);    	

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//��ѯ
 	doTemp.setFilter(Sqlca,"1","ItemNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","ItemName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
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
			{"true","","Button","����","���ø�����¼","stratRecord()",sResourcesPath},
			{"true","","Button","ͣ��","ͣ�ø�����¼","stopRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
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
    var sCurFunctionID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        OpenPage("/Common/Configurator/MainMenuManage/MainMenuInfo.jsp","_self","");    
        ReloadSelf();
	}
	
	/*~[Describe=���ü�¼;InputParam=��;OutPutParam=��;]~*/
	function stratRecord()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
		sIsInUse = getItemValue(0,getRow(),"IsInUse");
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("��ȷ�����øò˵�����"))
		{	
			sFlag = "1";
            sReturn = RunMethod("Configurator","ChangeState",sItemNo+","+sIsInUse+","+sFlag);
			if(sReturn == "false")
			{
				alert("���øò˵���ʧ�ܣ�");
			}
			else if(sReturn == "1")
			{
				alert("����Ŀ�Ѿ�������״̬������Ҫ�����ã�");
			}
			else if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
			    alert("����Ŀ�ѳɹ����ã�");
			    reloadSelf(); 
			}
		}
	}

	/*~[Describe=ͣ�ü�¼;InputParam=��;OutPutParam=��;]~*/
	function stopRecord()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
		sIsInUse = getItemValue(0,getRow(),"IsInUse");
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("��ȷ��ͣ�øò˵�����"))
		{
			sFlag = "2";
            sReturn = RunMethod("Configurator","ChangeState",sItemNo+","+sIsInUse+","+sFlag);
			if(sReturn == "false")
			{
				alert("ͣ�øò˵���ʧ�ܣ�");
			}
			else if(sReturn == "2")
			{
				alert("����Ŀ�Ѿ���ͣ��״̬������Ҫ��ͣ�ã�");
			}
			else if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
			    alert("����Ŀ�ѳɹ�ͣ�ã�");
			    reloadSelf(); 
			}
		}
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        OpenPage("/Common/Configurator/MainMenuManage/MainMenuInfo.jsp?ItemNo="+sItemNo,"_self",""); 
        //�޸����ݺ�ˢ���б�
    	ReloadSelf();
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
