<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ��ҵ� 2005-08-17
			Tester:
			Describe:�ĵ���Ϣ�б�
			Input Param:
	       		    ObjectNo: ������
	       		    ObjectType: ��������           		
	        Output Param:

			HistoryLog:zywei 2005/09/03 �ؼ����
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ĵ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//���ҳ�����
	
	//����������
	String sObjectType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = 	{ 
						{"DocNo","�ĵ���"},
                            	{"DocTitle","�ĵ�����"},
                            	{"AttachmentCount","��������"},   
                            	{"DocAttribute","�ĵ����"},  
                            	{"UserName","�Ǽ���"},
                            	{"OrgName","�Ǽǻ���"},
                            	{"InputTime","�Ǽ�����"},
                            	{"UpdateTime","��������"}
                           	};                           
    	//����SQL���
    String sSql = " SELECT DR.DocNo as DocNo ,DR.ObjectNo as ObjectNo ,DR.ObjectType as ObjectType,"+
    			  " DocTitle," + 
		  " getAttachmentSum(DL.DocNo) as AttachmentCount,"+
    			  " getItemName('DocumentKind',DocAttribute) as DocAttribute,"+
		  " OrgName,UserID,UserName,InputTime,UpdateTime " +
		  " FROM DOC_LIBRARY DL,DOC_RELATIVE DR" +
		  " WHERE DL.DocNo=DR.DocNo "+
		  " AND DR.ObjectType = '" + sObjectType + "'"+
		  " AND DR.ObjectNo='" + sObjectNo + "' ";
	//����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //���ñ�ͷ
    doTemp.setHeader(sHeaders);
    //�ɸ��µı�
    doTemp.UpdateTable = "DOC_LIBRARY";
    //���ùؼ���
	doTemp.setKey("DocNo",true);
	//���ò��ɼ���
    doTemp.setVisible("UserID,DocType,ObjectNo,ObjectType",false);
    //���÷��
    doTemp.setAlign("AttachmentCount","3");
    doTemp.setHTMLStyle("AttachmentCount","style={width:80px}");
    doTemp.setHTMLStyle("DocTitle"," style={width:140px}");
    doTemp.setHTMLStyle("UserName,OrgName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
    //���ɲ�ѯ��
	doTemp.setColumnAttribute("DocTypeName,DocTitle","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����setEvent
	dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","150");
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
			{"true","","Button","����","�����ĵ���Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","�ĵ�����","�鿴�ĵ�����","viewAndEdit_doc()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
			{"false","","Button","��������","���������ĵ���Ϣ","exportFile()",sResourcesPath},
			};
		if(sObjectNo.equals(""))
		{
			sButtons[0][0]="false";
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
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Document/DocumentInfo.jsp?UserID="+"<%=CurUser.UserID%>","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	
		sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{ 
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
				as_del('myiframe0');
				as_save('myiframe0') //�������ɾ������Ҫ���ô����             
				reloadSelf();
			} 
		}else 
		{
			alert(getHtmlMessage('3'));
			return;
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_doc()
	{
		var sDocNo=getItemValue(0,getRow(),"DocNo");
		var sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����		     	
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
    		OpenPage("/Document/DocumentInfo.jsp?DocNo="+sDocNo+"&UserID="+sUserID,"_self","");
        }
	}
	
	/*~[Describe=�鿴���޸ĸ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_attachment()
	{    
    	sDocNo=getItemValue(0,getRow(),"DocNo");
    	sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	     
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{        
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;         
    	}
    	else
    	{
    		popComp("AttachmentList","/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID);
      		reloadSelf();
      	}
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function exportFile()
	{
		//����������Ϣ       
    	OpenPage("/Document/ExportFile.jsp","_self","");
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
			var sDocNo = getItemValue(0,getRow(),"DocNo");
			var sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("AttachmentList","/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID,"DetailFrame","");
	
		}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>
<%
	/*~END~*/
%>


<%@	include file="/IncludeEnd.jsp"%>
