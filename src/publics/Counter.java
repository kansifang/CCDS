package publics;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
    	/*������ʽ
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
    	  String S="QZ'A'QZxxxxxQZ'bb'QZ";
    	  Pattern pattern = Pattern.compile("QZ(.+?)QZ",Pattern.CASE_INSENSITIVE);//��+?��̰��ģʽ������ƥ���һ��QZ�����һ��QZ
		  Matcher matcher = pattern.matcher(S);
		  StringBuffer sb=new StringBuffer("");
		  while (matcher.find()) {
				matcher.appendReplacement(sb,matcher.group(1)+"||");
		  }
		  System.out.println(sb.toString());
    }
}