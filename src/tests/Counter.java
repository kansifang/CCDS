package tests;

import java.util.regex.Pattern;

import com.lmt.baseapp.Import.base.ExcelBigHandler;
import com.lmt.baseapp.util.StringFunction;

public class Counter {

 

    public volatile static int count = 0;

 

    public static void inc() {

 

        //�����ӳ�1���룬ʹ�ý������

        try {

            Thread.sleep(1);

        } catch (InterruptedException e) {

        }

 

        count++;

    }

 

    public static void main(String[] args) {
    	/*
        //ͬʱ����1000���̣߳�ȥ����i++���㣬����ʵ�ʽ��
        for (int i = 0; i < 1000; i++) {
            new Thread(new Runnable() {
                public void run() {
                    Counter.inc();
                }

            }).start();

        }
        //����ÿ�����е�ֵ���п��ܲ�ͬ,����Ϊ1000
        //System.out.println("���н��:Counter.count=" + Counter.count);
         */
    	//ȥ��HTML���
    	/*
    	Pattern  pattern=Pattern . compile("<.+?>",  Pattern.DOTALL) ;
    	Matcher matcher=pattern.matcher("<a href=\"index.html\">��ҳ</a>");
    	//String  string  =  matcher . replaceAll(" ") ;
    	//System.out.println(string);
    	if(matcher.find()){
    		System. out . println(matcher . group( 0 ));
    	}
    	*/
    	/*�������ʽ
    	Pattern pattern1 = Pattern.compile("(another) (test)");
        StringBuffer sb = new StringBuffer();
        String candidateString = "This is another test.";
        String replacement = "$1 AAA $2";
        Matcher m = pattern1.matcher(candidateString);
        m.find();
        m.appendReplacement(sb, replacement);
        String msg = sb.toString();
        System.out.println(msg);
        */
    	  //System.out.println("2014/04".compareTo("2014/06"));
    	/*
    	  String S="QZ'A'QZxxxxxQZ'bb'QZ";
    	  Pattern pattern = Pattern.compile("QZ(.+?)QZ",Pattern.CASE_INSENSITIVE);//��+?��̰��ģʽ������ƥ���һ��QZ�����һ��QZ
		  Matcher matcher = pattern.matcher(S);
		  StringBuffer sb=new StringBuffer("");
		  while (matcher.find()) {
				matcher.appendReplacement(sb,matcher.group(1)+"||");
		  }
		  System.out.println(sb.toString());
		  */
    	/*
    	String[] AAttachmentNos={"AA","BB"};
    	String sAttachmentNos=StringFunction.toArrayString(AAttachmentNos,"','");
    	System.out.println(sAttachmentNos);
    	*/
    	/*
    	String url="http://finance.www.ap2p.se1arch.finance.com/xxx/jj";
    	if(url.matches("([a-zA-z]+://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./%&=]*)?")
    			&&url.matches("^(?!.*?app)(?!.*?search)(?!.*?tool).*finance.*$")){
    		System.out.println(1);
    	}else{
    		System.out.println(2);
    	}
    	System.out.println("aaaa1111bbbb".matches(".*\\d+.*"));
    	System.out.println(Pattern.matches(".*finance.*", "http://finance.ifeng.com/"));
    	*/
    	//ת��ZΪ26 ��AΪ1��
        System.out.println("1="+ExcelBigHandler.getLetterFromNumber(200));
        System.out.println("A="+ExcelBigHandler.getNumberFromLetter("200"));
        
    }
}