
<tr height=1 >
				<td id="FilterButtonTd">
				<span id="ShowFilterButton">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr><td>
				<img class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="FilterIconPlus" onClick="showHideFilterArea()">
				<img class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="FilterIconMinus" onClick="showHideFilterArea()">
				</td><td><a href="javascript:showHideFilterArea();"> &nbsp;��ѯ����</a></td></tr></table>
				</span>
				</td>
</tr>
<tr height=1 >
				<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
				<input type=hidden name=CompClientID value="<%=CurComp.ClientID%>">
				<input type=hidden name=PageClientID value="<%=CurPage.ClientID%>">
				<input type=hidden name=DWCurPage value="0">
				<input type=hidden name=DWCurRow value="0">
				<td colspan=2 id="ListCriteriaTd" class="ListCriteriaTd">
				<span id="FilterArea">
				<!--��ѯ��-->
				<%
				String sFilterHTML = (String)CurPage.getAttribute("FilterHTML");

				if(sFilterHTML!=null && !sFilterHTML.equals(""))
				{
					%>
						<table align=center border="1" bordercolorlight='#99999' bordercolordark='#FFFFFF' width="100%" height="100%" cellspacing="0" cellpadding="3">
						<tr>
						<td class="FilterHeaderTd">
						<a href="javascript:submitFilterForm('DOFilter')">[��ѯ]</a>
						<a href="javascript:clearFilterForm('DOFilter')">[���]</a>
						<a href="javascript:resetFilterForm('DOFilter')">[�ָ�]</a>
						<a href="javascript:hideFilterArea()">[ȡ��]</a>
						&nbsp;&nbsp;&nbsp;&nbsp; <span class="DOFilterHint">�������ѯ���������������ѯ����</span>
						</td>
						</tr>
						<tr>
						<td>
						<% 
						//�����ѯ������4�����ϣ�DOFilterOperatorSelect��ÿ����ѯ�����г���1�Σ�����ʾ��ֱ������ modifyby sxwang 20090219
						int iOccurTimes = StringFunction.getOccurTimes(sFilterHTML,"DOFilterOperatorSelect");
						if(iOccurTimes >= 4)
						{
						%>
						<div style="overflow:auto;width:100%;height:120">
							<table>
							<%=sFilterHTML%>
							</table>
						</div>
						<%}else
						  {
						%>
						<table>
						<%=sFilterHTML%>
						</table>
						<%
						  }
						%>
						</td>
						</tr>
						<tr>
						<td class="FilterSubmitTd" >
						<input type=submit value="��ѯ">
						<input type=button onclick="clearFilterForm('DOFilter')" value="���">
						<input type=button onclick="resetFilterForm('DOFilter')" value="�ָ�">
						<input type=button onclick="hideFilterArea()" value="ȡ��">
						</td>
						</tr>
						</table>
					<%
				}
				%>
				</span>
				</td>
				</form>
</tr>
<script>
	var bFilterAreaShowStatus=false;
	<%
	if(sFilterHTML==null || sFilterHTML.equals("")){
	%>
		showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
	<%
	}else{
		%>
		hideFilterArea();
		bFilterAreaShowStatus = false;	
		<%
	}
	%>
	//Ĭ����ʾfilter������ѯ���Ժ�������ʾ
	<%
	    if(!doTemp.haveReceivedFilterCriteria()) {
	%>
		showFilterArea();
	<%
		}	
	%>
	function showHideFilterArea(){
		if(!bFilterAreaShowStatus){
			showFilterArea();
		}else{
			hideFilterArea();
		}
	}
	function showFilterArea()
	{
		//showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","show");
		bFilterAreaShowStatus = true;
		showHideObjects("FilterIconPlus","hide");
		showHideObjects("FilterIconMinus","show");
	}
	function hideFilterArea(){
		//showHideObjects("ShowFilterButton","show");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
		showHideObjects("FilterIconPlus","show");
		showHideObjects("FilterIconMinus","hide");
	}


</script>

