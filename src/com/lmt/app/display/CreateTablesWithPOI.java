package com.lmt.app.display;
import java.awt.Color;
import java.awt.Font;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.text.DecimalFormat;
import java.text.NumberFormat;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.labels.StandardPieSectionLabelGenerator;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
   
  
public class CreateTablesWithPOI {  
    public static void main(String[] args) {  
        String outputFile = "D:\\test.docx";  
        CustomXWPFDocument document = new CustomXWPFDocument(); 
        XWPFParagraph paragraph = null;  
        XWPFTable tableOne = document.createTable();  
        XWPFTableRow tableOneRowOne = tableOne.getRow(0);  
        tableOneRowOne.getCell(0).setText("��1�е�1��");  
        tableOneRowOne.addNewTableCell().setText("��1�е�2��");  
        tableOneRowOne.addNewTableCell().setText("��1�е�3��");  
        tableOneRowOne.addNewTableCell().setText("��1�е�4��");  
        XWPFTableRow tableOneRowTwo = tableOne.createRow();  
        tableOneRowTwo.getCell(0).setText("��2�е�1��");  
        tableOneRowTwo.getCell(1).setText("��2�е�2��");  
        tableOneRowTwo.getCell(2).setText("��2�е�3��");  
        FileOutputStream fOut;  
        try {  
            fOut = new FileOutputStream(outputFile);  
            //�ŵ�һ��ͼ ��״ͼ
            paragraph = document.createParagraph(); //һ������
            ByteArrayInputStream  in = getPieChartImage();  
            String ind = document.addPictureData(in, XWPFDocument.PICTURE_TYPE_JPEG);   
            System.out.println("pic ID=" + ind);  
            document.createPicture(paragraph,document.getAllPictures().size()-1, 200, 200,"    ");   
            // �ŵڶ���ͼ  ��״ͼ
            paragraph = document.createParagraph(); //��һ������
            ind = document.addPictureData(getBarChartImage(), XWPFDocument.PICTURE_TYPE_JPEG);   
            System.out.println("pic ID=" + ind);  
            document.createPicture(paragraph,document.getAllPictures().size()-1, 200, 200,"    ");   
            document.write(fOut);   
            fOut.flush();  
            // �����������ر��ļ�  
            fOut.close();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }   
    }  
    public static ByteArrayInputStream getPieChartImage() {  
        ByteArrayInputStream in = null;  
        DefaultPieDataset pieDataset = new DefaultPieDataset();  
        pieDataset.setValue(" ������ ", 20);  
        pieDataset.setValue(" �Ϻ��� ", 18);  
        pieDataset.setValue(" ���� ", 16);  
        pieDataset.setValue(" ����� ", 15);  
        pieDataset.setValue(" ɽ���� ", 45);  
        JFreeChart chart = ChartFactory.createPieChart3D(" ��ҵ����ͼ ", pieDataset,  
                true, false, false);  
        // ���ñ���������ʽ  
        chart.getTitle().setFont(new Font(" ���� ", Font.BOLD, 20));  
        // ���ñ�״ͼ������������ʽ  
        PiePlot piePlot = (PiePlot) chart.getPlot();  
        piePlot.setLabelFont(new Font(" ���� ", Font.BOLD, 10));  
        // ������ʾ�ٷֱ���ʽ  
        piePlot.setLabelGenerator(new StandardPieSectionLabelGenerator(  
                (" {0}({2}) "), NumberFormat.getNumberInstance(),  
                new DecimalFormat(" 0.00% ")));  
        // ����ͳ��ͼ����  
        piePlot.setBackgroundPaint(Color.white);  
        // ����ͼƬ��ײ�������ʽ  
        chart.getLegend().setItemFont(new Font(" ���� ", Font.BOLD, 10));  
        try {  
            ByteArrayOutputStream out = new ByteArrayOutputStream();  
            ChartUtilities.writeChartAsPNG(out, chart, 400, 300);  
            in  = new ByteArrayInputStream(out.toByteArray());  
        } catch (Exception e) {  
            e.printStackTrace();  
        }   
        return in;  
    }  
    public static ByteArrayInputStream getBarChartImage() {  
        ByteArrayInputStream in = null;  
        DefaultCategoryDataset dataset =new DefaultCategoryDataset();   
        dataset.addValue(100,"Spring��Security","Jan");  
        dataset.addValue(200,"jBPM��4","Jan");  
        dataset.addValue(300,"Ext��JS","Jan");  
        dataset.addValue(400,"JFreeChart","Jan");  
        JFreeChart chart = ChartFactory.createBarChart("chart","num","type",dataset, PlotOrientation.VERTICAL, true, false, false);   
        // ���ñ���������ʽ  
        chart.getTitle().setFont(new Font(" ���� ", Font.BOLD, 20));  
        // ���ñ�״ͼ������������ʽ  
        // ����ͼƬ��ײ�������ʽ  
        chart.getLegend().setItemFont(new Font(" ���� ", Font.BOLD, 10));  
        try { 
            ByteArrayOutputStream out = new ByteArrayOutputStream();  
            ChartUtilities.writeChartAsPNG(out, chart, 400, 300);  
            in  = new ByteArrayInputStream(out.toByteArray());  
        } catch (Exception e) {  
            e.printStackTrace();  
        }   
        return in;  
    }  
}  