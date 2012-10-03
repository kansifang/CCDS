DataArr = GetLine("D:\\Tmp\\PressTest\\data\\user_info.txt","|")
wlHttp.FormData["UserID"] = DataArr[1]
wlHttp.FormData["Password"] = DataArr[2]
wlHttp.Post("http://localhost:8080/ALS6/Frame/PressTest/c4_Logon.jsp")
DataArr2 = GetLine("D:\\Tmp\\PressTest\\data\\business_info.txt","|")
wlHttp.FormData["ObjectType"] = DataArr2[1]
wlHttp.FormData["ObjectNo"] = DataArr2[2]
wlHttp.Post("http://localhost:8080/ALS6/Frame/PressTest/c6_CreditInfo.jsp")
wlHttp.Post("http://localhost:8080/ALS6/Frame/PressTest/c4_SessionOut.jsp")