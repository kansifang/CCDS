<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/strip.css">
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sResourcesPath%>/css/treeview.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/jquery.treeview.js'></script>
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ��ҳ��
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/27 ����̨������Ų���ճ�������ʾ�ϡ�
		History Log: syang 2009/12/09 ��дҳ��TAB���ɷ�ʽ��
		History Log: syang 2009/12/16 TAB֧���Զ��幦��
	 */
	%>
<%/*~END~*/%>

<%
	//ȡϵͳ����
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";
%> 
<html>
<head>
<title><%=sImplementationName%></title>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:auto;overflow-x:visible;overflow-y:visible}">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td valign="bottom" class="mytop">
				<%@include file="/MainTop.jsp"%>
			</td>
		</tr> 
	<!--	<tr>
  			<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
		</tr>-->
   	<tr>
			<td valign="top">
			<!-- ����̨���� -->
				<div  valign=middle class="groupboxmaxcontent" style="padding:0;border:0px solid #F00;position:absolute; height:100%;width: 100%; overflow:hidden" id="window1">
 				</div>
			</td>
		</tr>
	</table>
</body>
</html>
<script type="text/javascript">
	//���ɹ���̨Tabҳ
	var tabCompent = null;
	$(document).ready(function(){
		tabCompent = new TabStrip("T001","����̨","tab","#window1");
		tabCompent.setSelectedItem("0");
		tabCompent.setIsCache(true);	 						//�Ƿ񻺴�
//		tabCompent.setIsAddButton(true);	 			//����������ť
		tabCompent.setAddCallback("addNewTabListen(this)");
		tabCompent.setCloseCallback("deleteTabListen(this)");
		//tabCompent.setCanClose(false);
  	<%
		String sSql = "",sSqlTab = "";
		int iCount = 0;
		ASResultSet rs1 = null;
		
		sSqlTab = 	" select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
					" where CodeNo = 'TabStrip'  and IsInUse = '1' "+
					" order by SortNo";
  		String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSqlTab,Sqlca);
		for(int i=0;i<sTabStrip.length;i++){
			if(sTabStrip[i][0] != null&&sTabStrip[i][1] != null&&sTabStrip[i][2] != null){
				out.println("tabCompent.addDataItem('"+i+"',\""+sTabStrip[i][1]+"\",\""+sTabStrip[i][2]+"\",true,false);");
			}
		}
		//�û��Զ��幤��̨
		String custTab = com.amarsoft.app.util.WorkTipTabsManage.genTabScript(CurUser.UserID,Sqlca);
		out.println(custTab);
	%>
		tabCompent.init();
	});

/************************************************************************
 * 
 * ���º���Ϊ����̨TAB���ӻ�ر�ʱ���ص�������������ͬ���������ݿ������
 *
 ***********************************************************************/
	/**
	 *�ص����������һ����Tabѡ��
	 */
	function addNewTabListen(obj){
		if($(obj).data("_treeview") != "1"){
			//1.����˵�DOM����
			var menuHTML = $("#MenuHeaderUl").parent("td").html();
			menuHTML = menuHTML.replace("id=MenuHeaderUl","id=menuTree");					//����ԭ����ID
			menuHTML = menuHTML.replace("class=MenuHeaderUl","class=treeview");		//����ԭ����CSS
			//2.������ͼ����
			var offset = $(obj).offset();
			x = offset.left;			//ȡ����������ť��x����
			y = offset.top;				//ȡ����������ť��y����
			var treeContainer = $('<div id="newTabMenu"></div>');
			treeContainer.css("top",y+10);					//10pxΪtabѡ��հ׵ĸ߶ȣ��˵�������ѡ�����
			treeContainer.css("left",x);
			treeContainer.addClass("treeview-container");
			//3.���������
			treeContainer.append(menuHTML);																				//�������������
			$("#window1").before(treeContainer);																	//�����ͼ����������
			//4.������ͼ
			$("#menuTree").treeview({
				persist: "location",
				collapsed: true,
				unique: false
			});
			//5.��¼�¼���״̬���ٴε��ʱ��������������
			$(obj).data("_treeview","1");
			//6.���¼�
			//6.1 ����Ƴ��󣬲˵���ʧ
			$(obj).mouseout(function(){
				$("#newTabMenu").css("display","none");
			});
			//6.2 �������˵�������
			$("#newTabMenu").hover(function(){
					$("#newTabMenu").css("display","block");
				},function(){
					$("#newTabMenu").css("display","none");
				});
			//6.3.����ͼ�����¼�
			$("#menuTree").children("li").each(function(i){
					workTipTreeBindClick($(this));
			});
		//........................
		}else{
			//���ӻ�ر�Tab��������ť��λ�÷����˱仯����Ҫ���¼���
			var offset = $(obj).offset();
			x = offset.left;													//ȡ����������ť��x����
			y = offset.top;														//ȡ����������ť��y����
			$("#newTabMenu").css("top",y+10);
			$("#newTabMenu").css("left",x);
			$("#newTabMenu").css("display","block");
		}
	}
	/**
   *ҳ��TAB�رջص�����
   */
	function deleteTabListen(obj){
		id = $(obj).attr("id").replace(/^handle_/,"");
		var curUserID = "<%=CurUser.UserID%>";
		var param = "Operate=del";
				param += "&UserID="+curUserID;
				param += "&TabID="+id;
		var b = PopPageAjax("/Common/ToolsB/WorkTipTabsManage.jsp?"+param);
	}

/***********************************************************************************
 * 
 *����ͼ�Ľڵ�󶨵����¼�����һ��ȫ���󶨣����õ��ʱ���Ű����ӽڵ�ĵ����¼�
 *
 **********************************************************************************/
	function workTipTreeBindClick(obj){
		obj.click(function(e){
			liNode = $(this);
			bChild = (liNode.find('ul:first').html() != null);	//ȡ���Ƿ����Ӳ˵�
			if(bChild){														//������ӽڵ㣬������ӽڵ㵥���¼�
				$(this).unbind("click");						//����ڵ����ӽڵ㣬��ǰ�ڵ㵥������Ч
				ulNode = liNode.find('ul:first');
				//Ϊ�ӽڵ�󶨵����¼�
				ulNode.children("li").each(function(){
					workTipTreeBindClick($(this));
				});
			}else{				//����ִ����Ӷ���
				id = liNode.attr("id");
				action = liNode.attr("_action");
				text = liNode.text();
				encodeScript = action.replace(/&/gi,'`');
				if(tabCompent.getItemNumber() < 8 ){
					var curUserID = "<%=CurUser.UserID%>";
					var param = "Operate=add";
							param += "&UserID="+curUserID;
							param += "&TabID="+id;
							param += "&TabName="+text;
							param += "&Script="+encodeScript;
							param += "&Cache=true";
							param += "&Close=true";
					var b = PopPageAjax("/Common/ToolsB/WorkTipTabsManage.jsp?"+param);
					if(b == "true"){
						tabCompent.addItem(id,text,action,true,true,true);
					}
					//��¼��������
				}else{
						alert("����̨ѡ��������ܳ���8��");
				}
		    if (e && e.stopPropagation){
		        e.stopPropagation();
		    }else{
		        window.event.cancelBubble=true;
		    }
				$("#newTabMenu").css("display","none");
			}
			return false;
		});
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
