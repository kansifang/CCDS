	function selectOrgID(){
		var sOrgInfo = PopPage("/FixStat/SelectOrgID.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(typeof(sOrgInfo)!="undefined"){
			if(sOrgInfo=="_NONE_"){
				document.item.OrgID.value = "";
				document.item.OrgName.value = "ÇëÑ¡Ôñ»ú¹¹";
			}else if(sOrgInfo!=""){
				var sInfoDetail = sOrgInfo.split('@');
				document.item.OrgID.value=sInfoDetail[0];
				document.item.OrgName.value=sInfoDetail[1];
			}
		}
	}

	function selectDate()
	{
			sDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=22;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sDate)!="undefined")
			{
				document.item.InputDate.value=sDate;
			}
	}

	function selectMonth()
	{
			sMonth = PopPage("/FixStat/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=12;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sMonth)!="undefined")
			{
				document.item.InputDate.value=sMonth;
			}
	}

	function selectQuarter()
	{
			sQuarter = PopPage("/FixStat/SelectQuarter.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sQuarter)!="undefined")
			{
				document.item.InputDate.value=sQuarter;
			}
	}
	
	function SelectHalfYear(){
			sHalfYear = PopPage("/FixStat/SelectHalfYear.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sHalfYear)!="undefined")
			{
				document.item.InputDate.value=sHalfYear;
			}
	}
	
	function selectYear()
	{
			sYear = PopPage("/FixStat/SelectYearEnd.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sYear)!="undefined")
			{
				document.item.InputDate.value=sYear;
			}
	}
