package com.sohu;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.beans.StringBean;
import org.htmlparser.filters.AndFilter;
import org.htmlparser.filters.HasAttributeFilter;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.tags.Div;
import org.htmlparser.tags.HeadingTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.Transaction;
import com.sohu.bean.NewsBean;

/**
 * 用于对搜狐网站上的新闻进行抓取
 * @author guanminglin <guanminglin@gmail.com>
 */
public class SohuNews {

    private Parser parser = null;   //用于分析网页的分析器。
    private NewsBean bean = new NewsBean();
    private Transaction Sqlca = null;    //数据库连接管理器。
    private PreparedStatement pstmt = null;
    int n=0;//插入数据库条数计数器

    public SohuNews(){
        	ASConfigure asconfigure = ASConfigure.getASConfigure();
        	String sDataSource=null;
        	 String sql = "insert into Batch_Html(newstitle,newsauthor,newscontent,newsurl,newsdate) values(?,?,?,?,?)";
        	try {
        		sDataSource = asconfigure.getConfigure("DataSource");
        		Sqlca = ConnectionManager.getTransaction(sDataSource);
        		pstmt = Sqlca.conn.prepareStatement(sql);
        	} catch (Exception e) {
        		e.printStackTrace();
    			System.out.println("连接数据库失败！连接参数：<br>DataSource:"+ sDataSource);
    		}
    }

    /**
     * 获得一条完整的新闻。
     * @param pageindex 页数，从0开始 newsBean
     * @return
     */
    public ArrayList<NewsBean> getNewsList(String columns,String sfromwhere,int pageindex,int pageSize) {
    	ArrayList<NewsBean> list = new ArrayList<NewsBean>();
        String sSql="select num,"+columns+" from "+
        		"(select row_number()over() as num,"+columns+" "+sfromwhere+")tab "+
        	" where num>"+(pageindex*pageSize)+
        	" and num<"+(pageindex*pageSize+pageSize);
        try {
			ASResultSet rs=Sqlca.getASResultSet(sSql);
			while(rs.next()){
				NewsBean newsBean=new NewsBean();
				newsBean.setNum(rs.getInt("num"));
				newsBean.setNewsTitle(rs.getString("NewsTitle"));
				newsBean.setNewsAuthor(rs.getString("NewsAuthor"));
				newsBean.setNewsContent(rs.getString("NewsContent"));
				newsBean.setNewsDate(rs.getString("NewsDate"));
		        list.add(newsBean);
			}
			rs.getStatement().close();
		    return list;
		} catch (Exception e) {
			System.out.println("查询数据库异常！");
			e.printStackTrace();
		}
        return list;
    }
    /**
     *  设置新闻对象，让新闻对象里有新闻数据
     * @param newsTitle 新闻标题
     * @param newsauthor  新闻作者
     * @param newsContent 新闻内容
     * @param newsDate  新闻日期
     * @param url  新闻链接
     */
    public void setNews(String newsTitle, String newsauthor, String newsContent, String newsDate, String url) {
        bean.setNewsTitle(newsTitle);
        bean.setNewsAuthor(newsauthor);
        bean.setNewsContent(newsContent);
        bean.setNewsDate(newsDate);
        bean.setNewsURL(url);
    }

    /**
     * 将新闻插入到数据库中
     * @param bean
     * @return
     */
    public void saveToDB(NewsBean bean) {
        
        try {
            pstmt.setString(1, bean.getNewsTitle());
            pstmt.setString(2, bean.getNewsAuthor());
            pstmt.setString(3, bean.getNewsContent());
            pstmt.setString(4, bean.getNewsURL());
            pstmt.setString(5, bean.getNewsDate());
            pstmt.addBatch();
            n++;
            if(n>=100){
            	pstmt.executeBatch();
            	n=0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * 获得新闻的标题
     * @param titleFilter
     * @param parser
     * @return
     */
    private String getTitle(NodeFilter titleFilter, Parser parser) {
        String titleName = "";
        try {
            NodeList titleNodeList = (NodeList) parser.parse(titleFilter);
            for (int i = 0; i < titleNodeList.size(); i++) {
                HeadingTag title = (HeadingTag) titleNodeList.elementAt(i);
                titleName = title.getStringText();
            }

        } catch (ParserException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }
        return titleName;
    }

    /**
     * 获得新闻的责任编辑，也就是作者。
     * @param newsauthorFilter
     * @param parser
     * @return
     */
    private String getNewsAuthor(NodeFilter newsauthorFilter, Parser parser) {
        String newsAuthor = "";
        try {
            NodeList authorList = (NodeList) parser.parse(newsauthorFilter);
            for (int i = 0; i < authorList.size(); i++) {
                Node authorSpan = authorList.elementAt(i);
                newsAuthor = authorSpan.toPlainTextString();
            }

        } catch (ParserException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }
        return newsAuthor;

    }

    /*
     * 获得新闻的日期
     */
    private String getNewsDate(NodeFilter dateFilter, Parser parser) {
        String newsDate = null;
        try {
            NodeList dateList = (NodeList) parser.parse(dateFilter);
            for (int i = 0; i < dateList.size(); i++) {
                Node dateTag = dateList.elementAt(i);
                newsDate = dateTag.toPlainTextString();
            }
        } catch (ParserException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }

        return newsDate;
    }

    /**
     * 获取新闻的内容
     * @param newsContentFilter
     * @param parser
     * @return  content 新闻内容
     */
    private String getNewsContent(NodeFilter newsContentFilter, Parser parser) {
        String content = null;
        StringBuilder builder = new StringBuilder();
        try {
            NodeList newsContentList = (NodeList) parser.parse(newsContentFilter);
            for (int i = 0; i < newsContentList.size(); i++) {
                Div newsContenTag = (Div) newsContentList.elementAt(i);
                builder = builder.append(newsContenTag.getStringText());
            }
            content = builder.toString();  //转换为String 类型。
            if (content != null) {
                parser.reset();
                parser = Parser.createParser(content, "gb2312");
                StringBean sb = new StringBean();
                sb.setCollapse(true);
                parser.visitAllNodesWith(sb);
                content = sb.getStrings();
//                String s = "\";} else{ document.getElementById('TurnAD444').innerHTML = \"\";} } showTurnAD444(intTurnAD444); }catch(e){}";
                content = content.replaceAll("\\\".*[a-z].*\\}", "");
                content = content.replace("[我来说两句]", "");
            } else {
               System.out.println("没有得到新闻内容！");
            }

        } catch (ParserException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }

        return content;
    }

    /**
     * 根据提供的URL，获取此URL对应网页所有的纯文本信息，次方法得到的信息不是很纯，
     *常常会得到我们不想要的数据。不过如果你只是想得到某个URL 里的所有纯文本信息，该方法还是很好用的。
     * @param url 提供的URL链接
     * @return RL对应网页的纯文本信息
     * @throws ParserException
     * @deprecated 该方法被 getNewsContent()替代。
     */
    @Deprecated
    public String getText(String url) throws ParserException {
        StringBean sb = new StringBean();

        //设置不需要得到页面所包含的链接信息
        sb.setLinks(false);
        //设置将不间断空格由正规空格所替代
        sb.setReplaceNonBreakingSpaces(true);
        //设置将一序列空格由一个单一空格所代替
        sb.setCollapse(true);
        //传入要解析的URL
        sb.setURL(url);
        //返回解析后的网页纯文本信息
        return sb.getStrings();
    }

    /**
     * 对新闻URL进行解析提取新闻，同时将新闻插入到数据库中。
     * @param url 新闻连接。
     */
    public void parser(String url) {
        try {
            parser = new Parser(url);
            NodeFilter titleFilter = new TagNameFilter("h1");
            NodeFilter contentFilter = new AndFilter(new TagNameFilter("div"), new HasAttributeFilter("id", "contentText"));
            NodeFilter newsdateFilter = new AndFilter(new TagNameFilter("div"), new HasAttributeFilter("class", "time"));
            NodeFilter newsauthorFilter = new AndFilter(new TagNameFilter("span"), new HasAttributeFilter("class", "editer"));
            String newsTitle = getTitle(titleFilter, parser);
            System.out.println(newsTitle); 
            parser.reset();   //记得每次用完parser后，要重置一次parser。要不然就得不到我们想要的内容了。
            
            String newsContent = getNewsContent(contentFilter, parser);
            System.out.println(newsContent);   //输出新闻的内容，查看是否符合要求
            parser.reset();
            
            String newsDate = getNewsDate(newsdateFilter, parser);
            System.out.println(newsDate); 
            parser.reset();
            
            String newsauthor = getNewsAuthor(newsauthorFilter, parser);
            System.out.println(newsauthor); 
            //先设置新闻对象，让新闻对象里有新闻内容。
            setNews(newsTitle, newsauthor, newsContent, newsDate, url);
            //将新闻添加到数据中。
            this.saveToDB(bean);
        } catch (ParserException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public void close(){
    	try{
    		if(pstmt!=null){
				pstmt.executeBatch();
				pstmt.close();
			}
			if(Sqlca != null) {
				Sqlca.conn.commit();
				Sqlca.disConnect();
				Sqlca = null;
			}
		} catch (SQLException ex) {
            Logger.getLogger(SohuNews.class.getName()).log(Level.SEVERE, null, ex);
        }catch (Exception exception3) {
			ARE.getLog().error("Crawler close SQL Error2:", exception3);
		}
    }
    //单个文件测试网页
    public static void main(String[] args) {
      //  SohuNews news = new SohuNews();
      //  news.parser("http://news.sohu.com/20090518/n264012864.shtml");   
    }
}
