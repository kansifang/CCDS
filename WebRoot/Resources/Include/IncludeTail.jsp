<%
        if(CurPage!=null){
            String sDefaultTVItemID = DataConvert.toRealString(iPostChange,CurPage.getParameter("DefaultTVItemID"));
            String sDefaultTVItemName = DataConvert.toRealString(iPostChange,CurPage.getParameter("DefaultTVItemName"));
            if(sDefaultTVItemID!=null && !sDefaultTVItemID.equals("")){
                %>
                <script>selectItem('<%=sDefaultTVItemID%>');</script>
                <%
            }else if(sDefaultTVItemName!=null && !sDefaultTVItemName.equals("")){
                %>
                <script>selectItemByName('<%=sDefaultTVItemName%>');</script>
                <%
                	}
                        }

                    }
                    catch(Exception e)
                    {
                    	if(SqlcaRepository!=null) SqlcaRepository.conn.rollback();
                    	if(Sqlca!=null) Sqlca.conn.rollback();

                        e.printStackTrace();
                        ARE.getLog().error(e.getMessage(),e);
                        throw e;
                    }
                    finally
                    {
                        java.util.Date dEndTime = new java.util.Date();
                        double iTimeConsuming = (dEndTime.getTime()-dBeginTime.getTime())/1000.0;
                        session.setAttribute("LastRunEndTime",sdf.format(dEndTime));

                        if(sDebugMode!=null && sDebugMode.equals("1"))
                        	ARE.getLog().debug("[JSP]"+sdf.format(dBeginTime)+" : "+iTimeConsuming+" ["+CurUser.UserID+"]["+sCurJspName+"]");

                        if(SqlcaRepository!=null)
                        {
                            if(sRunTimeDebugMode!=null && sRunTimeDebugMode.equals("1"))
                            {
                                SqlcaRepository.conn.commit();
                		        sdf.applyPattern("yyyyMMdd HHmm:ss.SSS");
                                SqlcaRepository.executeSQLWithoutLog("insert into user_runtime(SessionID,BeginTime,UserId,JspName,EndTime,TimeConsuming) "+
                                    " values('"+session.getId()+"','"+sdf.format(dBeginTime)+"','"+CurUser.UserID+"','"+sCurJspName+"','"+sdf.format(dEndTime)+"',"+iTimeConsuming+")");
                                SqlcaRepository.conn.commit();
                            }
                        }
                        if(SqlcaRepository == Sqlca)
                        {
                            Sqlca.conn.commit();
                            Sqlca.disConnect();
                            Sqlca = null;
                            SqlcaRepository = null;
                        }else
                        {
                            if(Sqlca!=null)
                            {
                                Sqlca.conn.commit();
                                Sqlca.disConnect();
                                Sqlca = null;
                            }
                            if(SqlcaRepository!=null)
                            {
                                SqlcaRepository.conn.commit();
                                SqlcaRepository.disConnect();
                                SqlcaRepository = null;
                            }
                        }
                    }
                %>