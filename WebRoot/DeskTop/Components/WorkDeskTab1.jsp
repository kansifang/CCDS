
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	String sFlag = "0";
	String bForceDeleteTab = "true";
	String bForceAddTab = "true";
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="Tab09.jsp"%>
<%/*~END~*/%>


<script language="JavaScript">
	var bForceRefreshTab = false;
	var bForceDeleteTab = true;
	var bForceAddTab = true;
	var tabstrip = new Array();
	var tabType = new Array();
	var strip_id_increment = -1;
	var hangtableID="tabtd";
	function doTabAction(sArg){
		var sReturn="";
		if(sArg=="WorkTips")
		{
			sReturn="/DeskTop/WorkTips.jsp";
		}
		else if(sArg=="BusinessAlert")
		{
			sReturn="/CreditManage/CreditAlarm/AlarmHandleMain.jsp";
		}
		else if(sArg=="WorkRecordMain")
		{
			sReturn="/DeskTop/WorkRecordMain.jsp";
		}
		else if(sArg=="UserDefine")
		{
			sReturn="/DeskTop/UserDefineMain.jsp";
		}
		//add by lzhang 2011-03-21��������źͻ�����ʾ
		else if(sArg=="BalanceAlert")
		{
			sReturn="/CreditManage/CreditAlarm/AlarmBalanceMain.jsp";
		}
		return sReturn;
	}
	function getIDInArray(tabname){
		for(var i=0;i<tabstrip.length;i++){
			if(tabstrip[i][1]==tabname){
				return tabstrip[i][0];
			}
		}
		return -1;
	}
	function newTab(tabname,url){
		var selectstrip_id_increment=getIDInArray(tabname);
		if(selectstrip_id_increment==-1){
			//���ӵ�����
			addTab(tabname,url);
			selectstrip_id_increment=strip_id_increment;
		}
		tabstrip[selectstrip_id_increment][6]="";//ɾ����־�ÿգ�"del"��ʾɾ��
		//��ȡΪ����tab���»�tabʱӦ�ÿ�ʼ��tab�����
		var beginti=calBiginIndex(selectstrip_id_increment,GbeginTabIndex);
		//�������»�tab
		hc_drawTabToTable_plus_ex(tabstrip,selectstrip_id_increment,beginti,iMaxTabLength,hangtableID);
		myTabAction(hangtableID,selectstrip_id_increment,false,beginti);
		window.focus();
	}
	function addTab(tabname,url){
		var para='';
		if(url.indexOf('?')>=0){
			para='&'+url.substring(url.indexOf('?')+1);
			url=url.substring(0,url.indexOf('?'));
		}
		tabstrip[++strip_id_increment] = new Array(strip_id_increment,
				tabname,
				"AsControl.OpenView('"+url+"','TextToShow="+tabname+para+"&ToInheritObj=y','"+(hangtableID+strip_id_increment)+"')",
				"AsControl.OpenView('"+url+"','TextToShow="+tabname+para+"&ToInheritObj=y','"+(hangtableID+strip_id_increment)+"')","1","1");
	}
	//��һ������ΪTabΨһ��ʶ���ڶ�������ΪTab��ʾ���ƣ�����������ΪTab��OnClick�¼������ĸ�����Ϊoncontextmenu�¼���
	var sMarrow = false;
	var tabname="",url="",para="";
	<%
	String sSql = " select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
			" where CodeNo = 'TabStrip'  and IsInUse = '1' ";
	//add by lzhang 2011/04/12 ���Ӳ鿴��ɫȨ�޿���
	if(CurUser.UserID.equals("9999999")||CurUser.hasRole("062")||CurUser.hasRole("262")||CurUser.hasRole("462")){
		sSql += " order by SortNo ";
	}else{
		sSql += " and ItemNo <> '050'  Order by SortNo ";
	}	
	ASResultSet rs = Sqlca.getASResultSet(sSql);	 
	while(rs.next()){
 %> 
   	tabname="<%=rs.getString("ItemName")%>";
   	url=eval("<%=rs.getString("ItemAttribute")%>");
   	addTab(tabname,url);
 <%
  	}
   	rs.getStatement().close();
	%>
	var initTab = 1;
	var iMaxTabLength = 8;
</script>

<script	language=javascript>
	//��������Ϊ�� tab��������,Ĭ����ʾ�ڼ���,��ʼ��ǩ,�����ʾ��,Ŀ�굥Ԫ��
	hc_drawTabToTable_plus_ex(tabstrip,0,0,iMaxTabLength,hangtableID);
	//�趨Ĭ��ҳ��
	//var iIndex = 0;
	myTabAction(hangtableID,0,false,0);
	window.focus();
</script>


