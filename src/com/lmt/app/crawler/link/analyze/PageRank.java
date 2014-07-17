package com.lmt.app.crawler.link.analyze;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Hashtable;

public class PageRank {
    private double[] rank;
    Hashtable<String,Integer> hashedPages;
    String[] sortedRank;
    public PageRank() {
    }
    //���������ÿ���ַ������� ��ʽ��{"url1 ->url2 ->url3...","url3 ->url4 ->url5..."...} 
    //���淽��û���� {"url1 ->url2 ->url3...","url3 ->url1 ->url5..."...} �����Ļ��������
    public String[] pageRank(String[] s) {
        // height of data
        int theSize = Math.max(4 * s.length/3 + 1, 16);
        // ��ʼ��
        hashedPages = new Hashtable<String,Integer>(theSize);
        String[] pages = new String[s.length]; // theSize
        int[] nLinks = new int[s.length]; // theSize
        rank = new double[s.length];//s���ַ�����Ӧ��ֵ�ŵ�rank ��ʼ��Ϊ1
        sortedRank = new String[s.length];//s���ַ�����Ӧ��ֵ�ŵ�sortedRank�� 
        String[] dataEntry = new String[s.length];
        // ��ȡ����
        for (int i = 0; i < s.length; i++) {
            String[] temp = s[i].split(" ");
            pages[i] = temp[0];
            nLinks[i] = temp.length - 1;//�����
            sortedRank[i] = temp[0];
            rank[i] = 1;//PageRankֵ
            hashedPages.put(pages[i], i);//��ÿ��URL��һ������ֵ
            dataEntry[i] = "";
        }
        int tRow, tCol;
        //��ʼ������
        for (int i = 0; i < s.length; i++) { 
            String[] temp = s[i].split(" ");
            for (int j = 1; j < temp.length; j++) {
            	//tCol tRow�� ��ʾһ��url������ֵ // tCol ---> tRow��n���� 
                tCol = hashedPages.get(temp[0]);  
                tRow = hashedPages.get(temp[j]);
                // assumes no pages link to each other.  
                //else an if-statement is needed to check for i vs. j self-linking
                //tCol���ӵ�����ЩtRow �����ֵ��ʾtCol���ж�����������֮һ����ʾ�����ԣ���Ҫ�ǣ�
                /**
                 * �����PageRank�㷨��
					PR(A)  =  (1-d)  +  d  (PR( Tl) /C(Tl)  + . ..  +  PR(Tn)/C(Tn))
					���У�
					PR(A)  ��ҳ A ��  PageRank  ֵ:
					PR(Ti) ���ӵ�A����ҳTi��  PageRank ֵ:
					C(Ti) ��ҳTi�Ķ�������������������
					d ����ϵ�� O<d < l.
					
                 */
                //�м��� Ti
                ////���� ����� class BigMatrix..��ע�ͣ��˴���{��ӦΪ ����������������ν��Ҳ������Ϊ��ע�ʹ���,�˴��޸�Ϊ��
                dataEntry[tRow] += "(" + tCol + "," + (1 / (double)nLinks[i]) + ");";
            }
        }
        // ������������
        BigMatrix dataMatrix = new BigMatrix(dataEntry);
        // ����
        rankFilter(dataMatrix);
        //����������URL�б�
        return(sortedRank);
    }
    private void rankFilter(BigMatrix dataMatrix) {
        String[] tempRank = new String[sortedRank.length];
        Boolean isEqual = true;
        //�������㣬ֱ������������һ���ַ������飬ÿ���ַ�����Ӧһ��ֵ,�����ֵ��С�����������
        	//ÿ��ֵ��Ӧһ��ϵ��
        	//�����ߴ����ﵽ50��
        for (int i = 0; i < 50; i++) {
            rank = dataMatrix.multiply(rank);
            // ������ǰ������ֵ����ʱ����
            for (int j = 0; j < sortedRank.length; j++) {
                tempRank[j] = sortedRank[j];
            }
            //����
            Arrays.sort(sortedRank, new compareByRank());//sort ��ĳ��ֵ���бȽ���������
            // �����Ƿ�����         
            for (int j = 0; j < sortedRank.length; j++) {
                if (sortedRank[j].compareTo(tempRank[j]) != 0) {
                    isEqual = false;
                    break;
                }
            }
            
            if (isEqual == true) {
                break;
            } else {
                isEqual = true;
            }
        }
    }
    class compareByRank implements Comparator<String> {
        public int compare(String a, String b) {
            int indexA = hashedPages.get(a);
            int indexB = hashedPages.get(b);
            if (rank[indexA] == rank[indexB]) {
                return(0);
            } else if (rank[indexA] > rank[indexB]) {
                return(-1);
            } else {
                return(1);
            }
        }
     }
}
//����
class BigMatrix {
    public int nCols, nRows;
    EntryList[] theRows;
	//���캯������String��������Ϊ���룬����{"(1,1); (4,3); (5,8)", "(2,5); (3,4)","(3,8);(4,5)"}
	//ÿ���ַ����ܹ���ʼ��һ�����ݡ����磬��2��5����ʾ�ڵڶ��еĵڶ���ֵΪ5
    public BigMatrix(String[] x) {
        nRows = x.length;
        nCols = 0;
        theRows = new EntryList[nRows];
        for (int i = 0; i < nRows; i++) {
           theRows[i] = new EntryList();
           if (x[i] != null) {
               String[] tempArr = x[i].split(";");
               if (tempArr[0] != null) {
                   for (int j = 0; j < tempArr.length; j++) {
                       Entry entry = new Entry(tempArr[j]);
                       theRows[i].add(entry);
                       if (nCols <= entry.col) {
                           nCols = entry.col + 1;
                       }
                   }
               }
           }
        }
    }

   //����1ά����
    public double[] multiply(double[] x) {
        double[] result = new double[nRows];
        int count;
        for (int i = 0; i < nRows; i++) {
            EntryList temp = theRows[i];
            count = 0;
            while ((temp != null) && (temp.data != null)) {
                result[i]+= (temp.data.value * x[temp.data.col]);
                temp = temp.next;
                count++;
            }
        }
        return(result);
    }
}
//�����Ԫ��Ԫ�� ָ���� ��1,2)�������ַ���
class Entry {
    int col;//Ԫ��������
    double value;//Ԫ��ֵ
    public Entry(String x) {
        String[] temp = x.split(",");
        if (temp[0].compareTo("") != 0) {
            col = Integer.parseInt(temp[0].trim().substring(1));
            value = Double.parseDouble(temp[1].trim().substring(0, temp[1].trim().length() -1));
        }
    }
}
//Ԫ���б����н��н�ģ
//���Ǹ����ӱ���ָ���ϵ��������LinkedList���� ArrayList
class EntryList {
    Entry data;
    EntryList next, tail;
    public EntryList() {
        next = null;
        tail = null;
        data = null;
    }
   //�������
    void add(Entry x) {
        if (tail == null) {
            data = x;
            tail = this;
        } else {
            tail.next = new EntryList();//��ʱtailָ�� ��ǰ EntryList����һ����������
            tail.next.data = x;
            tail = tail.next;//��ʱ��ָ����һ�� ���ݽ�������
        }
    }
}