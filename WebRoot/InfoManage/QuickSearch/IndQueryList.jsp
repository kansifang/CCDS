<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FBkang 2005-08-01
		Tester:
		Content: ���˿ͻ����ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ����˿ͻ����ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���˿ͻ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
										{"CustomerID","�ͻ����"},
										{"FullName","����"},
										{"CertTypeName","֤������"},
										{"CertID","֤������"},
										{"SexName","�Ա�"},
										{"Birthday","��������"},
										{"EduExperienceName","���ѧ��"},
//										{"EduDegreeName","���ѧλ"},										
//										{"SINo","��ᱣ�պ�"},
										{"Staff","�Ƿ���Ա��"},
										{"StaffName","�Ƿ���Ա��"},
										{"BizHouseFlag","�Ƿ��̻�"},
										{"BizHouseFlagName","�Ƿ��̻�"},
										{"GovServiceFlag","�Ƿ�ְ��Ա"},
										{"GovServiceFlagName","�Ƿ�ְ��Ա"},
										{"NationalityName","����"},
										{"NativePlace","������ַ"},
										{"IndRPRType","��������"},                                        //new
										{"IndRPRTypeName","��������"},                                       //new
										{"HousemasterFlagName","�Ƿ���"},                                       //new
										{"PoliticalFaceName","������ò"},
										{"MarriageName","����״��"},         
										{"HealthStatusName","����״��"},                             //new
										{"IncomeSourceName","��Ҫ������Դ"},                            //newPopulationNum
										{"PopulationNum","��ͥ�˿���"},                          //new
										{"IndRate","�»����������(%)"},                          //new
										{"FamilyAdd","��ס��ַ"},
										{"FamilyZIP","��ס��ַ�ʱ�"},
										{"FamilyTel","סլ�绰"},
										{"FamilyStatusName","��ס״��"},
										{"MobileTelephone","�ֻ�����"},
										{"EmailAdd","��������"},
										{"CommAdd","ͨѶ��ַ"},
										{"CommZip","ͨѶ��ַ�ʱ�"},
										{"OccupationName","ְҵ"},
										{"HeadShipName","ְ��"},
										{"PositionName","ְ��"},
										{"FamilyMonthIncome","��ͥ������(Ԫ)"},
										{"YearIncome","����������(Ԫ)"},
								    	{"UnitKindName","��λ������ҵ"},
										{"WorkCorp","��λ����"},
										{"WorkAdd","��λ��ַ"},
										{"WorkZip","��λ��ַ�ʱ�"},
										{"WorkTel","��λ�绰"},
										{"WorkBeginDate","����λ������ʼ��"},
										{"EduRecord","��ҵѧУ(ȡ�����ѧ��)"},
										{"GraduateYear","��ҵ���(ȡ�����ѧ��)"},
										{"CreditLevel","���м������õȼ�"},                         //new
										{"UserName","�Ǽ���"},
										{"OrgName","�Ǽǵ�λ"},
										{"InputDate","�Ǽ�����"},
										{"UpdateDate","��������"}
						   }; 
	
	sSql = 	" select CustomerID,FullName,getItemName('CertType',CertType) as CertTypeName, "+
			" CertID,getItemName('Sex',Sex) as SexName,Birthday, "+
			" getItemName('EducationExperience',EduExperience) as EduExperienceName, "+
			" staff,getItemName('YesNo',Staff) as StaffName,"+
			" BizHouseFlag,getItemName('YesNo',BizHouseFlag) as BizHouseFlagName,"+
			" GovServiceFlag,getItemName('YesNo',GovServiceFlag) as GovServiceFlagName,"+
			" getItemName('Nationality',Nationality) as NationalityName,IndRPRType, "+
			" NativePlace,getItemName('IndRPRType',IndRPRType) as IndRPRTypeName, "+
			" getItemName('YesNo',HousemasterFlag) as HousemasterFlagName ,"+
			" getItemName('HealthStatus',HealthStatus) as HealthStatusName ,"+ 
			" getItemName('IncomeSource',IncomeSource) as IncomeSourceName ,"+     
			" PopulationNum,IndRate,"+
			" getItemName('PoliticalFace',PoliticalFace) as PoliticalFaceName,"+
			" getItemName('Marriage',Marriage) as MarriageName,FamilyAdd,FamilyZIP, "+
			" FamilyTel,getItemName('FamilyStatus',FamilyStatus) as FamilyStatusName, "+
			" MobileTelephone,EmailAdd,CommAdd,CommZip, "+
			" getItemName('Occupation',Occupation) as OccupationName, "+
			" getItemName('HeadShip',HeadShip) as HeadShipName, "+
			" getItemName('TechPost',Position) as PositionName,FamilyMonthIncome, "+
			" YearIncome,getItemName('IndustryType',UnitKind) as UnitKindName , "+
			" WorkCorp,WorkAdd,WorkZip,WorkTel,WorkBeginDate,EduRecord,GraduateYear,CreditLevel, "+
			" getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName, "+
			" InputDate,UpdateDate "+
			" from IND_INFO "+
			" where CustomerID in "+
          	" (select CustomerID from CUSTOMER_BELONG "+
           	" where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%'))";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName,NativePlace,CommAdd","style={width:250px} "); 
    doTemp.setHTMLStyle("EnterpriseName,RegisterAdd,OfficeAdd","style={width:200px}");
    doTemp.setHTMLStyle("EmployeeNumber","style={width:30px}");    
    doTemp.setHTMLStyle("MostBusiness","style={width:250px}");   
    doTemp.setHTMLStyle("OrgName,FamilyAdd,WorkAdd,IncomeSourceName,PositionName","style={width:200px}"); 
       
    doTemp.setCheckFormat("Licensedate,LicenseMaturity,UpdateDate,InputDate,WorkBeginDate","3");	 
	doTemp.setAlign("FamilyMonthIncome,YearIncome","3");		
	doTemp.setVisible("staff,IndRPRType,GovServiceFlag,BizHouseFlag",false);
	//���ɲ�ѯ��
	doTemp.setType("FamilyMonthIncome,YearIncome","Number");
	doTemp.setDDDWSql("staff","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo'");
	doTemp.setDDDWSql("BizHouseFlag","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo'");
	doTemp.setDDDWSql("GovServiceFlag","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo'");
	doTemp.setDDDWSql("IndRPRType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndRPRType'");
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","FullName","");
	doTemp.setFilter(Sqlca,"3","CertID","");
	doTemp.setFilter(Sqlca,"4","staff","");
	doTemp.setFilter(Sqlca,"5","BizHouseFlag","");
	doTemp.setFilter(Sqlca,"6","GovServiceFlag","");		
	doTemp.setFilter(Sqlca,"7","IndRPRType","");
	doTemp.setFilter(Sqlca,"8","CreditLevel","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[1][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------//

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ø��˿ͻ�����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");//�򿪸��˿ͻ���ϸ��Ϣ
		}
	}	
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
