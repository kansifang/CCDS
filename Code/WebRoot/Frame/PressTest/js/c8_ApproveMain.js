DataArr = GetLine("D:\\Tmp\\PressTest\\data\\user_info.txt","|")
wlHttp.FormData["UserID"] = DataArr[1]
wlHttp.FormData["Password"] = DataArr[2]
wlHttp.Post("http://localhost:8080/ALS6/Frame/PressTest/c4_Logon.jsp")
DataArr2 = GetLine("D:\\Tmp\\PressTest\\data\\approvetype.txt","|")
wlHttp.FormData["ApproveType"] = DataArr2[1]
wlHttp.Post("http://localhost:8080/ALS6/Frame/PressTest/c8_ApproveMain.jsp")
wlHttp.Post("http://localhost:8080/ALS6/Frame/PressTest/c4_SessionOut.jsp")