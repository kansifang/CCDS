<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: ������Ȩά��
			Input Param:
					OrgID:		������
					RoleID:		��ɫ��
					ObjectNo:	��Ȩ�������к�
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ҵ��Ʒ��ȷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	
	
	//���ҳ�����
	//��Ȩ��
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//���Ʒ�����ţ����Ʒ��������ж������������
	String sAuthorizeMethodSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthorizeMethodSerialNo"));
	//�����������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//Ҫչʾ������--��ά���Ŀ�������
	String sDisplayContent = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DispayContent"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sAuthorizeMethodSerialNo == null) sAuthorizeMethodSerialNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sDisplayContent == null) sDisplayContent = "";
	//1������ʱ���ѡ���ά��
	if(!"".equals(sDisplayContent)&&sDisplayContent.length()>0){
		int iDisplaySum=0;
		sSerialNo=DBFunction.getSerialNo("Config_Info","SerialNo","yyyyMMdd","000000",new java.util.Date(),Sqlca);
		StringBuffer table=new StringBuffer("Config_Info(SerialNo,");
		StringBuffer value=new StringBuffer("Values('"+sSerialNo+"',");
		String []aDispayContents =sDisplayContent.split("~");
		if(aDispayContents.length>1){
	String[] aValue=aDispayContents[0].split(";");
	String[] aText=aDispayContents[1].split(";");
	iDisplaySum=aValue.length;
	for(int i=0;i<iDisplaySum&&iDisplaySum==aText.length;i++){
		if(!"".equals(aValue[i])&&!"".equals(aText[i])){
			table.append("ItemNo"+(i+1)+","+"ItemName"+(i+1)+",");
			value.append("'"+aValue[i]+"','"+aText[i]+"',");
		}
	}
		}
		
		table.append("ItemExistSum,");
		value.append(iDisplaySum+",");
		table.append("Attribute1,");
		value.append("'"+sAuthorizeMethodSerialNo+"',");
		table.append("InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate");
		value.append("'"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"'");
		sSql="insert into "+table.toString()+")"+value.toString()+")";
		Sqlca.executeSQL(sSql);
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		//2�������Ѳ����ά�ȣ�չʾ����
		int iItemExistSum=0;//ά����Ŀ
		int iExtent=0;//��ҳ���г���Ҫչʾ��ά��֮��Ҫչʾ������Ҫ��
		int iBeginIndex=0;//ά�ȿ�ʼչʾ�����±�
		String sHeaders[][]=null;
		String[] aItemNo=null;//�洢ά��ID�������ѯcode_library���õ�����Ҫ��
		StringBuffer sItemValues=new StringBuffer("");
		ASResultSet rs=Sqlca.getASResultSet("select * from Config_Info where SerialNo='"+sSerialNo+"'");
		if(rs.next()){
			iItemExistSum=rs.getInt("ItemExistSum");
			aItemNo =new String[iItemExistSum];
			iExtent=5;//����չʾ5��Ҫ��
			sHeaders =new String[2*iItemExistSum+iExtent][2];
			sHeaders[iBeginIndex][0]="Describe1";
			sHeaders[iBeginIndex++][1]="������������";
			for(int i=0;i<iItemExistSum;i++){
		sHeaders[(iBeginIndex)][0]="ItemValue"+(i+1);
		sHeaders[(iBeginIndex++)][1]=rs.getString("ItemName"+(i+1));
		sHeaders[(iBeginIndex)][0]="ItemValueDes"+(i+1);
		sHeaders[(iBeginIndex++)][1]=rs.getString("ItemName"+(i+1));
		sItemValues.append("ItemValue"+(i+1)+","+"ItemValueDes"+(i+1)+",");//��ά��ֵ��//sItemValues.append("CAST(ItemValue"+(i+1)+" AS VARCHAR(32672)) AS ItemValue"+(i+1)+","+"CAST(ItemValueDes"+(i+1)+" AS VARCHAR(32672)) AS ItemValueDes"+(i+1)+",");//��̬��ѯ�ֶΣ�ά��ֵ�� ʹ��CAST�Ƕ� long varchar �Ƚϰ�ȫ��д��
		aItemNo[i]=rs.getString("ItemNo"+(i+1));//ά�Ⱥţ���Ӧcode_library�е�ItemNo
			}
			sHeaders[(iBeginIndex)][0]="InputDate";
			sHeaders[(iBeginIndex++)][1]="��Ȩ��ʼ����";
			sHeaders[(iBeginIndex)][0]="UpdateDate";
			sHeaders[(iBeginIndex++)][1]="��Ȩ��ֹ����";
			sHeaders[(iBeginIndex)][0]="InputOrgName";
			sHeaders[(iBeginIndex++)][1]="��Ȩ����";
			sHeaders[(iBeginIndex)][0]="InputUserName";
			sHeaders[(iBeginIndex++)][1]="��Ȩ��";
		}
		rs.getStatement().close();
		sSql =  " select SerialNo,Describe1,"+
		  sItemValues.toString()+
		" InputDate,UpdateDate,"+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,"+
		" getOrgName(UpdateOrgID) as UpdateOrgName,getUserName(UpdateUserID) as UpdateUserName"+
		" from Config_Info "+
		" Where SerialNo ='"+sSerialNo+"'";
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable="Config_Info";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName,UpdateOrgName,UpdateUserName",false);
		doTemp.setType("Balance1,Balance2","Number");
		doTemp.setCheckFormat("Balance1,Balance2","2");
		doTemp.setRequired("Describe1",true);
		doTemp.setCheckFormat("InputDate,UpdateDate","3");
		doTemp.setReadOnly("InputOrgName,InputUserName",true);
		
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID,UpdateOrgID,UpdateOrgName,UpdateUserID,UpdateUserName",false);
		doTemp.setEditStyle("Describe1","3");
		doTemp.setHTMLStyle("Describe1"," style={height:100px;width:600px} ");
		doTemp.setDDDWCode("IsInUse","YesNo");
		//����ά��ֵ�����뷽ʽ
		for(int i=0;i<aItemNo.length;i++){
			rs=Sqlca.getASResultSet("select ItemDescribe,RelativeCode from Code_Library where CodeNo='AuthorizeControlType' and ItemNo='"+aItemNo[i]+"'and IsInUse='1'");
			if(rs.next()){
		String sSelectType=rs.getString(1);
		String sParaString=rs.getString(2);
		if(sSelectType==null)sSelectType="01";
		if(sParaString==null)sParaString=" ";
		sParaString = StringFunction.replace(sParaString,"#SerialNo",sSerialNo);
		sParaString = StringFunction.replace(sParaString,"#CurOrg",CurOrg.OrgID);
		sParaString = StringFunction.replace(sParaString,"#CurUser",CurUser.UserID);
		if("01".equals(sSelectType)){//��ѡ�����˵�
			doTemp.setVisible("ItemValue"+(i+1),true);
			doTemp.setRequired("ItemValue"+(i+1),true);
			doTemp.setDDDWSql("ItemValue"+(i+1),sParaString);
			doTemp.setVisible("ItemValueDes"+(i+1),false);
		}else if("02".equals(sSelectType)){//��ѡ�����˵�
			doTemp.setVisible("ItemValue"+(i+1),false);
			doTemp.setReadOnly("ItemValueDes"+(i+1),true);
			doTemp.setRequired("ItemValueDes"+(i+1),true);
			doTemp.setEditStyle("ItemValueDes"+(i+1),"3");
			doTemp.setLimit("ItemValueDes"+(i+1),32672);//����varchar����󳤶ȣ�Ҳ�ǲ�ѯ����������󳤶�
			doTemp.setHTMLStyle("ItemValueDes"+(i+1)," style={height:100px;width:600px} ");
			doTemp.setUnit("ItemValueDes"+(i+1)," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCustomizeOnDialogue(\""+sParaString+"\",\"ItemValue"+(i+1)+"\",\"ItemValueDes"+(i+1)+"\")>");
		}else if("03".equals(sSelectType)){//����ҳ��
			doTemp.setVisible("ItemValue"+(i+1),false);
			doTemp.setReadOnly("ItemValueDes"+(i+1),true);
			doTemp.setRequired("ItemValueDes"+(i+1),true);
			doTemp.setEditStyle("ItemValueDes"+(i+1),"3");
			doTemp.setLimit("ItemValueDes"+(i+1),32672);//����varchar����󳤶ȣ�Ҳ�ǲ�ѯ����������󳤶�
			doTemp.setHTMLStyle("ItemValueDes"+(i+1)," style={height:100px;width:600px} ");
			doTemp.setUnit("ItemValueDes"+(i+1)," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCustomizeOnPage(\""+sParaString+"\",\"ItemValue"+(i+1)+"\",\"ItemValueDes"+(i+1)+"\")>");
		}else if("04".equals(sSelectType)){//���ı���
			doTemp.setVisible("ItemValue"+(i+1),true);
			doTemp.setRequired("ItemValue"+(i+1),true);
			doTemp.setEditStyle("ItemValue"+(i+1),"3");
			doTemp.setLimit("ItemValue"+(i+1),32672);//����varchar����󳤶ȣ�Ҳ�ǲ�ѯ����������󳤶�
			doTemp.setHTMLStyle("ItemValue"+(i+1)," style={height:100px;width:600px} ");
			doTemp.setVisible("ItemValueDes"+(i+1),false);
		}
			}
		}
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����ΪGrid���
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
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
			{"true","","Button","����","������Ϣ","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
	}
	

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/PublicInfo/ConfigList.jsp?ObjectNo=<%=sObjectNo%>"+"&AuthorizeMethodSerialNo=<%=sAuthorizeMethodSerialNo%>","DetailFrame",OpenStyle);
	}
	
	/*~[Describe=ѡ��֧�л���;InputParam=��;OutPutParam=��;]~*/
	function selectFinalOrg()
	{
			
		//setObjectValue("SelectSubOrg",sParaString,"@FinalOrg@0@FinalOrgName@1",0,0,"");
		setObjectValue("SelectAllOrg","","@OrgID@0@FinalOrgName@1",0,0,"");
		
	}
	 /*~[Describe=����ѡ��򣬲��ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]
	 	*���������
		*Selects=Column1(��ʾ����),Column2������ֵ��...@TableName@WhereClause~Column1(��ʾ����),Column2������ֵ��...@TableName@WhereClause
	*/
	function selectCustomizeOnDialogue(ParaString,TypeValue,TypeName)
	{
		
		var sTypeValues="",sTypeNames="";
		ParaString =ParaString.replace(/SPACE/g," ");
		var sReturn = PopPage("/PublicInfo/MultiSelectDialogue.jsp?"+ParaString,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_none_")
		{
			var sTypeInfo = sReturn.split("~");
			if(sTypeInfo.length>1){
				//var aTypeInfo=sTypeInfo[1].match(/;/gi);//����sTypeInfo��";"��ɵ�����
				setItemValue(0,getRow(),TypeValue,sTypeInfo[0]);
				setItemValue(0,getRow(),TypeName,sTypeInfo[1]);					
			}
						
		}
	}
	/*У�����ģ�2���ֽڣ�Ӣ�Ļ���ַ����ĳ���
	var aTypeInfo0=sTypeInfo[0].split(";");
				var aTypeInfo1=sTypeInfo[1].split(";");
				var iLength=0,i=0;
				for(i=0;i<aTypeInfo1.length;i++){
					iLength +=aTypeInfo1[i].length*2+1;
					if(iLength<700){
						continue;
					}else{
						alert(aTypeInfo1[i]+"��֮���������ڳ��������޷�ѡ����������Ȩ���в��䣡");
						break;
					}
				}
				if(i===aTypeInfo1.length){
					setItemValue(0,getRow(),TypeValue,sTypeInfo[0]);
					setItemValue(0,getRow(),TypeName,sTypeInfo[1]);
				}else{
					setItemValue(0,getRow(),TypeValue,sTypeInfo[0].substr(0,sTypeInfo[0].indexOf(aTypeInfo0[i])));
					setItemValue(0,getRow(),TypeName,sTypeInfo[1].substr(0,sTypeInfo[1].indexOf(aTypeInfo1[i])));
				}
	*/
	/*~[Describe=����ѡ��ҳ��ѡ��֧�ֶ�ѡ��;InputParam=��;OutPutParam=��;]
 	*���������
		*#Columns Column1:###@Column2:###...
		*#Table ����
		*#WhereClause ��ѯ���� 
		*#FieldName ����ҳ����� ��ʽ��Column1(����),Column2(����)...
		*#ReturnValue ����ֵ ��ʽ��Column1,Column2...
		*#FilterValue  ��ѯ���� ��ʽ��Column1,Column2...
		*#Compart ����ֵ�ָ���
	*/
	function selectCustomizeOnPage(sParaString,TypeValue,TypeName)
	{
		var sTypeValues="",sTypeNames="";
		sParaString =sParaString.replace(/SPACE/g," ");
		var sReturn=setObjectValue("SelectCustomizeWithMulti",sParaString,"",0,0,"");
		if(typeof(sReturn)!=='undefined'&&sReturn!=='_CLEAR_'){
			var sTypeInfo = sReturn.split(';');
			for(var i=0;i<sTypeInfo.length;i=i+2){
				sTypeValues=sTypeValues+sTypeInfo[i]+";";
			}
			for(i=1;i<sTypeInfo.length;i=i+2){
				sTypeNames = sTypeNames + sTypeInfo[i]+";";
			}
			setItemValue(0,getRow(),TypeValue,sTypeValues);
			setItemValue(0,getRow(),TypeName,sTypeNames);
		}
	}
	//��дcommon.js�еķ���,��ѡ��MultiSelectDialogBefore.jsp��Ϊ�µĵ���ҳ�棬�˵�����֧��ͨ���������� ���⡢����ֵ����ѯ������
	function selectObjectValue(sObjectType,sParaString,sStyle)
	{
		if(typeof(sStyle)=="undefined" || sStyle=="") 
			sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var sObjectNoString = PopPage("/PublicInfo/MultiSelectPageBefore.jsp?SelName="+sObjectType+"&ParaString="+sParaString,"",sStyle);
		return sObjectNoString;
	}	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			bIsInsert = true;
		}
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
    }
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>
//bFreeFormMultiCol=true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
