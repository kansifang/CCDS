<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:		ljtao	2008/12/08
			Tester:
			Content: �û�������Ȩ����������
			Input Param:
			Output param:
			ObjectType:Special/Normal -- ������Ȩ/һ����Ȩ
			Type:1/2/3 -- ������Ȩ/������Ȩ/֧����Ȩ
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "������Ȩ����"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ȩ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		String sFolder1 = "",sFolder2 = "",sFolder3 = "";
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/
%>
	<%
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������Ȩ����","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

		//������ͼ�ṹ
		//sFolder1 = tviTemp.insertFolder("root","������Ȩ","",1);
		//tviTemp.insertPage(sFolder1,"������Ȩ","",2);
		//tviTemp.insertPage(sFolder1,"������Ȩ","",3);
		//tviTemp.insertPage(sFolder1,"֧����Ȩ","",4);
		
		//sFolder2 = tviTemp.insertFolder("root","һ����Ȩ","",5);
		//tviTemp.insertPage(sFolder3,"������Ȩ","",6);
		//tviTemp.insertPage(sFolder3,"������Ȩ","",7);
		//tviTemp.insertPage(sFolder3,"֧����Ȩ","",8);
		
		sFolder3 = tviTemp.insertFolder("root","��Ȩ","",1);
		tviTemp.insertPage(sFolder3,"������Ȩ","",2);
		tviTemp.insertPage(sFolder3,"����(ֱ��֧��)��Ȩ","",3);
		tviTemp.insertPage(sFolder3,"֧����Ȩ","",4);
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/

	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		//if(sCurItemID=='2'){
		//	OpenComp("UserSpecialList","/Common/Configurator/UserAuthManage/UserSpecialList.jsp","ObjectType=Special&Type=1","right");
		//}
		//if(sCurItemID=='3'){
		//	OpenComp("UserSpecialList","/Common/Configurator/UserAuthManage/UserSpecialList.jsp","ObjectType=Special&Type=2","right");
		//}
		//if(sCurItemID=='4'){
		//	OpenComp("UserSpecialList","/Common/Configurator/UserAuthManage/UserSpecialList.jsp","ObjectType=Special&Type=3","right");
		//}
		if(sCurItemID=='2'){
			OpenComp("UserAuthList","/Common/Configurator/UserAuthManage/UserAuthList.jsp","ObjectType=Normal&Type=1","right");
		}
		if(sCurItemID=='3'){
			OpenComp("UserAuthList","/Common/Configurator/UserAuthManage/UserAuthList.jsp","ObjectType=Normal&Type=2","right");
		}
		if(sCurItemID=='4'){
			OpenComp("UserAuthList","/Common/Configurator/UserAuthManage/UserAuthList.jsp","ObjectType=Normal&Type=3","right");
		}
		setTitle(getCurTVItem().name);
	}

	
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/
%>
	<script language="javascript">
	startMenu();
	expandNode('root');	
	//expandNode("<%//=sFolder1%>");
	//expandNode("<%//=sFolder2%>");
	expandNode("<%=sFolder3%>");
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
