<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ndeng 2005-04-17
			Tester:
			Describe: ֪ͨ�б�
			Input Param:
		
			Output Param:
		
		
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "֪ͨ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������

	//���ҳ�����
	
	//����������
	//String sBelongOrg = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	//out.println(sBelongOrg);
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = { 
					{"BoardNo","������"},
					{"BoardName","��������"},
					{"BoardTitle","�������"},
					{"BoardDesc","��������"},
					{"IsPublish","�Ƿ񷢲�"},
					{"IsNew","�Ƿ���"},
					{"IsEject","�Ƿ񵯳�"},
					{"FileName","�����ļ���"},
					{"ContentType","��������"},
					{"ContentLength","���ݳ���"},
					{"UploadTime","�ϴ�ʱ��"},
					{"DocContent","�ĵ�����"}				
				}; 

	String sSql = " select BoardNo,BoardName,BoardTitle,BoardDesc, "+
		  " getItemName('YesNo',IsPublish) as IsPublish, "+
		    	  " getItemName('YesNo',IsNew) as IsNew, "+
		    	  " getItemName('YesNo',IsEject) as IsEject "+
		    	  " from BOARD_LIST ";

	//����DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    //���ø��µ����ݿ����
	doTemp.UpdateTable = "BOARD_LIST"; 
    //���ùؼ��ֶ�	
	doTemp.setKey("BoardNo",true);
	doTemp.setAlign("IsNew,IsEject,IsPublish","2");
	doTemp.setHTMLStyle("IsNew,IsEject,IsPublish"," style={width:60px} ");
	doTemp.setVisible("BoardNo",false);
	doTemp.setHTMLStyle("BoardTitle"," style={width:300px}");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


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
						{"true","","Button","����","��������","my_add()",sResourcesPath},
						{"true","","Button","����","�鿴����","my_detail()",sResourcesPath},
						{"true","","Button","ɾ��","ɾ������","my_del()",sResourcesPath}						
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

	function my_del()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");	
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}		
	}
	

	function initRow()
	{
		if (getRowCount(0)==0)
		{
		 	as_add("myiframe0");
		}		
	}
	
	/*�������һ��Ҫ  */
	function mySelectRow()
	{		
	}
	
	function my_add()
	{
		OpenPage("/SystemManage/SynthesisManage/BoardInfo.jsp","_self","");	
	}
	
	function my_detail()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");			
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/BoardInfo.jsp?BoardNo="+sBoardNo,"_self","");	
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>


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
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
