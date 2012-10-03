<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	//取系统名称
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";
	    
%>
<html>
<head>
<title><%=sImplementationName%></title>
</head>
<script language=javascript>

    function openFile(sBoardNo)
    {
        popComp("BoardView","/SystemManage/SynthesisManage/BoardView.jsp","BoardNo="+sBoardNo,"","");
    }

    function saveFile(sBoardNo)
    {
        window.open("<%=sWebRootPath%>/SystemManage/BoardManage/BoardView2.jsp?BoardNo="+sBoardNo+"&rand="+randomNumber(),"_blank",OpenStyle);
    }

</script>

<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
	  <td id=mytop class="mytop">
	       	<%@include file="/MainTop.jsp"%>
          </td>
	</tr> 
	<tr>
	  <td valign="top" id="mymiddle" class="mymiddle"></td>
	</tr>
	<tr>
	  <td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
	</tr>
        <tr>
          <td valign="top"  onMouseOver="showlayer(0,this)">
            <table width="100%" border="0" cellpadding="5" height="100%" cellspacing="0">
              <tr>
                <td valign="top" rowspan=2>
                  <div class="groupboxmaxcontent" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                      <tr>
                        <td height="1">
                          <table cols=2 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td nowrap class="groupboxheader">
                              	<font class="groupbox"> &nbsp;&nbsp;我的工作台&nbsp;&nbsp;</font> </td>
                              <td nowrap class="groupboxcorner"><img class="groupboxcornerimg" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" name="Image1"></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td>
                         <div  valign=middle class="groupboxmaxcontent" style="position:absolute; width: 100%;overflow:auto;visibility: inherit" id="window1">
						<%
							String sTableStyle = "valign=middle align=center cellspacing=0 cellpadding=0 border=0 width=95% height=95%";
							String sTabHeadStyle = "";
							String sTabHeadText = "<br>";
							String sTopRight = "";
							String sTabID = "tabtd";
							String sIframeName = "DeskTopTab";
							String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
							String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";
						%>
						<%@include file="/Resources/CodeParts/Tab04.jsp"%>
                          </div>

                        </td>
                      </tr>
                    </table>
                  </div>
                </td>
                <td width=200 height=205>
	                <table border='1' cellspacing='0' cellpadding='0' width='100%' height="100%">
	                   <tr>
	                      <td align="center" nowrap bgcolor= #dcdcdc bordercolorlight='#99999' bordercolordark='#FFFFFF' height="18">我的日历</td>
						</tr>
						<tr>
	                      <td bgcolor= #dcdcdc>
	                      <iframe name="MyCalendar" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在打开页面，请稍候" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
	                      </td>
						</tr>
		            </table>
                </td>
                </tr>

                <tr >
                <td width=200 >
                  <table border='1' cellspacing='0' cellpadding='0' width='100%' height="100%">
                    <tr>
                      <td align="center" nowrap bgcolor= #dcdcdc bordercolorlight='#99999' bordercolordark='#FFFFFF' height="18">总行通知</td>
					</tr>
		            <tr>
		              <td nowrap bgcolor= #dcdcdc bordercolorlight='#dcdcdc' bordercolordark='#dcdcdc' class="pt9song">

				            <table width=97% border=0 align="right" cellpadding=5 height=100%>
				              <tr>
				                    <td class="pt9song">
				                    <font color="#FFFFFF">
				                    <marquee behavior="scroll" DIRECTION="up" width=100% height=100%  scrollamount=2 scrolldelay=80 onMouseOver="this.stop();" onMouseOut="this.start();" bgcolor="#6382BC" style="padding-left:5">
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><!--加空行解决滚动区域的问题-->
				                 <%
				                  String sIsNew = "",sIsEject = "";
				                  ASResultSet rs = null;
				                  rs = Sqlca.getASResultSet("select BoardNo,BoardTitle,IsNew,IsEject from BOARD_LIST where IsPublish = '1' and (ShowToRoles is null or ShowToRoles in (select RoleID from USER_ROLE where UserID='"+CurUser.UserID+"')) order by BoardNo desc");
				                  while(rs.next())
				                  {
				                    sIsNew = DataConvert.toString(rs.getString("IsNew"));
				                    sIsEject = DataConvert.toString(rs.getString("IsEject"));
				                    out.print("<li style='cursor:hand' >");
				                    if(sIsEject.equals("1"))
				                    {
				                        out.print("<span onclick='javascript:openFile(\""+rs.getString(1)+"\")'>"+rs.getString(2)+"</span>");
				                    }
				                    else
				                    {
				                        out.print("<span>"+rs.getString(2)+"</span>");
				                    }
				                    if(sIsNew.equals("1")) out.print("<img src='"+sResourcesPath+"/new.gif' border=0>");
				                    
				                    out.print("<br><br>");
				                  }
				                  rs.getStatement().close();
				                  %>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                </marquee>
				                    </font>
				                  </td>
				                 </tr>
			                </table>
	                 </td>
	                </tr>
	              </table>

               </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
<script language="JavaScript">
	OpenComp("MyCalendar","/DeskTop/MyCalendar.jsp","","MyCalendar","")
	var tabstrip = new Array();
  	<%
		String sSql = "",sSqlTab = "";
		int iCount = 0;
		ASResultSet rs1 = null;
		
		sSqlTab = 	" select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
						" where CodeNo = 'TabStrip'  and IsInUse = '1' ";
		if(!CurUser.hasRole("480")&&!CurUser.hasRole("280")&&!CurUser.hasRole("080"))
		{
			sSqlTab += " and ItemNo<>'020' and ItemNo<>'040'";
		}
	  	String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSqlTab,Sqlca);

		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));
  	%>

  	function doTabAction(sArg)
  	{
  		if(sArg=="WorkTips")
  		{
  			OpenComp("WorkTips","/DeskTop/WorkTips.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="BusinessAlert")
  		{
  			OpenComp("AlarmHandleMain","/CreditManage/CreditAlarm/AlarmHandleMain.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="WorkRecordMain")
  		{
  			OpenComp("WorkRecordMain","/DeskTop/WorkRecordMain.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="UserDefine")
  		{
  			OpenComp("UserDefineMain","/DeskTop/UserDefineMain.jsp","","<%=sIframeName%>","");
  		}
  		  		
		//当日业务情况
    	if(sArg=="BusinessCurrenyDay")
  		{
  			OpenComp("BusinessCurrenyDay","/DeskTop/BusinessCurrenyDay.jsp","","<%=sIframeName%>","");
 	  	}
		//期间业务动态
    	else if(sArg=="BusinessDynamic")
  		{
  			OpenComp("BusinessDynamic","/DeskTop/BusinessDynamic.jsp","","<%=sIframeName%>","");
 	  	}
		//授信集中度（重大客户）
    	else if(sArg=="VipCustomerFrame")
  		{
  			OpenComp("VipCustomerFrame","/DeskTop/VipCustomerFrame.jsp","","<%=sIframeName%>","");
 	  	}
		//表内业务结构
    	else if(sArg=="LoanInq1")
  		{
  			OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","InOutFlag=1","<%=sIframeName%>","");
 	  	}
		//表外业务结构
  		else if(sArg=="LoanInq2")
  		{
  			OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","InOutFlag=2","<%=sIframeName%>","");
  		}
		//资产质量
  		else if(sArg=="LoanQuanlity")
  		{
  			OpenComp("LoanQuanlity","/DeskTop/LoanQuanlity.jsp","InOutFlag=2","<%=sIframeName%>","");
	  	}
  	}

	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.all('<%=sTabID%>'));
	<%=sTabStrip[0][2]%>;
</script>

<%@ include file="/IncludeEnd.jsp"%>