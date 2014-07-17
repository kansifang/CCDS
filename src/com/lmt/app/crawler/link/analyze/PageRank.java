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
    //穿入参数中每个字符串都以 形式是{"url1 ->url2 ->url3...","url3 ->url4 ->url5..."...} 
    //下面方法没考虑 {"url1 ->url2 ->url3...","url3 ->url1 ->url5..."...} 这样的互链接情况
    public String[] pageRank(String[] s) {
        // height of data
        int theSize = Math.max(4 * s.length/3 + 1, 16);
        // 初始化
        hashedPages = new Hashtable<String,Integer>(theSize);
        String[] pages = new String[s.length]; // theSize
        int[] nLinks = new int[s.length]; // theSize
        rank = new double[s.length];//s中字符串对应的值放到rank 初始化为1
        sortedRank = new String[s.length];//s中字符串对应的值放到sortedRank中 
        String[] dataEntry = new String[s.length];
        // 获取数据
        for (int i = 0; i < s.length; i++) {
            String[] temp = s[i].split(" ");
            pages[i] = temp[0];
            nLinks[i] = temp.length - 1;//入度数
            sortedRank[i] = temp[0];
            rank[i] = 1;//PageRank值
            hashedPages.put(pages[i], i);//给每个URL赋一个索引值
            dataEntry[i] = "";
        }
        int tRow, tCol;
        //初始化矩阵
        for (int i = 0; i < s.length; i++) { 
            String[] temp = s[i].split(" ");
            for (int j = 1; j < temp.length; j++) {
            	//tCol tRow都 表示一个url的索引值 // tCol ---> tRow（n个） 
                tCol = hashedPages.get(temp[0]);  
                tRow = hashedPages.get(temp[j]);
                // assumes no pages link to each other.  
                //else an if-statement is needed to check for i vs. j self-linking
                //tCol链接到了哪些tRow 后面的值表示tCol所有对外链接数分之一，表示可能性，主要是：
                /**
                 * 最初的PageRank算法：
					PR(A)  =  (1-d)  +  d  (PR( Tl) /C(Tl)  + . ..  +  PR(Tn)/C(Tn))
					其中：
					PR(A)  网页 A 的  PageRank  值:
					PR(Ti) 链接到A的网页Ti的  PageRank 值:
					C(Ti) 网页Ti的对外链接数（出度数）
					d 阻尼系数 O<d < l.
					
                 */
                //中计算 Ti
                ////根据 下面的 class BigMatrix..的注释，此处“{”应为 “（”，不过无所谓，也可以认为是注释错误,此处修改为（
                dataEntry[tRow] += "(" + tCol + "," + (1 / (double)nLinks[i]) + ");";
            }
        }
        // 创建矩阵数据
        BigMatrix dataMatrix = new BigMatrix(dataEntry);
        // 排序
        rankFilter(dataMatrix);
        //返回排序后的URL列表
        return(sortedRank);
    }
    private void rankFilter(BigMatrix dataMatrix) {
        String[] tempRank = new String[sortedRank.length];
        Boolean isEqual = true;
        //迭代计算，直到数据收敛（一个字符串数组，每个字符串对应一个值,按这个值从小到大进行排序
        	//每个值对应一个系数
        	//）或者次数达到50次
        for (int i = 0; i < 50; i++) {
            rank = dataMatrix.multiply(rank);
            // 拷贝当前的数组值到临时数组
            for (int j = 0; j < sortedRank.length; j++) {
                tempRank[j] = sortedRank[j];
            }
            //排序
            Arrays.sort(sortedRank, new compareByRank());//sort 按某个值进行比较升序排序
            // 计算是否收敛         
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
//矩阵
class BigMatrix {
    public int nCols, nRows;
    EntryList[] theRows;
	//构造函数采用String的数组作为输入，例如{"(1,1); (4,3); (5,8)", "(2,5); (3,4)","(3,8);(4,5)"}
	//每个字符串能够初始化一行数据。例如，（2，5）表示在第二行的第二列值为5
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

   //乘以1维向量
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
//矩阵的元素元素 指的是 （1,2)这样的字符串
class Entry {
    int col;//元素所在列
    double value;//元素值
    public Entry(String x) {
        String[] temp = x.split(",");
        if (temp[0].compareTo("") != 0) {
            col = Integer.parseInt(temp[0].trim().substring(1));
            value = Double.parseDouble(temp[1].trim().substring(0, temp[1].trim().length() -1));
        }
    }
}
//元素列表，对行进行建模
//这是个链接表，有指向关系，类似于LinkedList而非 ArrayList
class EntryList {
    Entry data;
    EntryList next, tail;
    public EntryList() {
        next = null;
        tail = null;
        data = null;
    }
   //添加数据
    void add(Entry x) {
        if (tail == null) {
            data = x;
            tail = this;
        } else {
            tail.next = new EntryList();//此时tail指向 当前 EntryList，起一个过度作用
            tail.next.data = x;
            tail = tail.next;//此时才指向下一个 层层递进，很妙
        }
    }
}