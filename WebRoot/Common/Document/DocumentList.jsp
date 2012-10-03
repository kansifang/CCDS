<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
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
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ĵ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������                     
	String sObjectNo = "";//--������
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	else							
		sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = 	{                             	
                            	{"DocTitle","�ĵ�����"},
                            	{"AttachmentCount","��������"},                    
                            	{"UserName","�Ǽ���"},
                            	{"OrgName","�Ǽǻ���"},
                            	{"InputTime","�Ǽ�����"},
                            	{"UpdateTime","��������"}
                           	};                           
    	//����SQL���
    String sSql = " SELECT DR.DocNo as DocNo ,DR.ObjectNo as ObjectNo ,DR.ObjectType as ObjectType,DocTitle," + 
				  " getAttachmentSum(DL.DocNo) as AttachmentCount,OrgName,UserID,UserName,InputTime,UpdateTime " +
				  " FROM DOC_LIBRARY DL,DOC_RELATIVE DR" +
				  " WHERE DL.DocNo=DR.DocNo and OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	//���ݶ������ͽ��в�ѯ			  
	if(sObjectType.equals("Other")) //�����ĵ�
		sSql += " AND DR.ObjectType not in ('Customer','CreditApply','ApproveApply','BusinessContract','NPAReformApply','LawcaseInfo','AssetInfo')" ; 
	else
		sSql += " AND DR.ObjectType = '" + sObjectType + "'" ; 
    //���ݶ����Ž��в�ѯ
    if (!sObjectNo.equals(""))
		sSql += " AND DR.ObjectNo='" + sObjectNo + "' ";
    //�����ֱ��֧�й���Ա,ֱ��֧���ĵ�����Ա
	if(CurUser.hasRole("0M2")||CurUser.hasRole("0M3"))
	{
		sSql += " AND OrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	//����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //���ñ�ͷ
    doTemp.setHeader(sHeaders);
    //�ɸ��µı�
    doTemp.UpdateTable = "DOC_LIBRARY";
    //���ùؼ���
	doTemp.setKey("DocNo",true);
	//���ò��ɼ���
    doTemp.setVisible("DocNo,UserID,DocType,ObjectNo,ObjectType",false);
    //���÷��
    doTemp.setCheckFormat("InputTime,UpdateTime","3");
    doTemp.setAlign("AttachmentCount","3");
    doTemp.setAlign("DocTitle,UserName,InputTime,UpdateTime","2"); 
	doTemp.setHTMLStyle("OrgName" ,"style={width:200px} ");
    doTemp.setHTMLStyle("AttachmentCount","style={width:80px}");
    doTemp.setHTMLStyle("DocTitle"," style={width:140px}");
    doTemp.setHTMLStyle("OrgName","style={width:250px}");       
    doTemp.setHTMLStyle("UserName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
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
		{"true","","Button","����","�����ĵ���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","�ĵ�����","�鿴�ĵ�����","viewAndEdit_doc()",sResourcesPath},
		{"true","","Button","��������","�鿴��������","viewAndEdit_attachment()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
		{"false","","Button","��������","���������ĵ���Ϣ","exportFile()",sResourcesPath},
		};
	if(sObjectNo.equals(""))
	{
		sButtons[0][0]="false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Document/DocumentInfo.jsp?UserID="+"<%=CurUser.UserID%>","_self","");
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
		sDocNo=getItemValue(0,getRow(),"DocNo");
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����		     	
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
    		OpenPage("/Common/Document/DocumentInfo.jsp?DocNo="+sDocNo+"&UserID="+sUserID,"_self","");
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
    		popComp("AttachmentList","/Common/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID);
      		reloadSelf();
      	}
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function exportFile()
	{
		//����������Ϣ       
    	OpenPage("/Common/Document/ExportFile.jsp","_self","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
