package com.lmt.app.display;
/** 
 * ʱ������ͼ:��ʾ����ʱ���ǩ���� 
 *  
 * �������ܵ㣺 
 *   �� ��ʾ����ʱ���ǩ���� 
 *  
 * 
 *  
 *  
 * */  
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.border.CompoundBorder;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.StandardChartTheme;
import org.jfree.chart.axis.PeriodAxis;
import org.jfree.chart.axis.PeriodAxisLabelInfo;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.time.Day;
import org.jfree.data.time.Month;
import org.jfree.data.time.RegularTimePeriod;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.data.time.Year;
import org.jfree.data.xy.XYDataset;
import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RectangleInsets;
import org.jfree.ui.RefineryUtilities;
//import lw.release.ChartBasePanel;  
@SuppressWarnings("serial")  
public class TimeSeries08 extends ApplicationFrame {  
  
    public TimeSeries08(String title) {  
        super(title);  
        setContentPane(new TimeSeriesPanel());  
    }  
  
    public JPanel createDemoPanel() {  
        return new TimeSeriesPanel();  
    }  
  
    public static void main(String[] arg) {  
        TimeSeries08 timeSeries = new TimeSeries08("��ʾ����ʱ���ǩ����ʾ��");  
        timeSeries.pack();  
        RefineryUtilities.centerFrameOnScreen(timeSeries);  
        timeSeries.setVisible(true);  
    }  
  
    /** 
     * ��ʾ��Demoͼ������� 
     *  
     * ChartBasePanel����Swing������������ӹ�ͬʹ�õģ����ﲻ�ظ����� 
     *  
     * */  
    private class TimeSeriesPanel extends ChartBasePanel {  
        private TimeSeries series;  // �������ʱ��(���ꡢ�¡��ա�ʱ���֡����)����������  
        private ChartPanel chartPanel;    
        private JFreeChart chart = createChart();   // ����һ��JFreeChartʱ������ͼ��  
  
        public TimeSeriesPanel() {  
            super();  
              
            addChart(this.chart);   // ����JFreeChart����JFreeChart�б���  
              
            // ��JFreeChart����ר�õ�ͼ������ChartPanel��  
            this.chartPanel = new ChartPanel(this.chart);  
            this.chartPanel.setPreferredSize(new Dimension(600, 250));  
              
            // ����chartPanel�����߿�  
            CompoundBorder compoundBorder = BorderFactory.createCompoundBorder(  
                    BorderFactory.createEmptyBorder(4, 4,4, 4),  
                    BorderFactory.createEtchedBorder());  
            this.chartPanel.setBorder(compoundBorder);  
              
            // ��chartPanel���뵽��������  
            add(this.chartPanel);  
        }  
  
        /** 
         * ����jfreechartͼ�� 
         * */  
        private JFreeChart createChart() {  
            // ����ͼ�����ݼ���  
            XYDataset xyDataset = createDataset();   
              
            // ���Ӻ���֧��  
            StandardChartTheme standardChartTheme=new StandardChartTheme("CN");     //����������ʽ            
            standardChartTheme.setExtraLargeFont(new Font("����",Font.BOLD,20));    //���ñ�������         
            standardChartTheme.setRegularFont(new Font("SimSun",Font.PLAIN,15));    //����ͼ��������      
            standardChartTheme.setLargeFont(new Font("����",Font.PLAIN,15));      //�������������     
            ChartFactory.setChartTheme(standardChartTheme); //Ӧ��������ʽ      
              
            // ����һ��ʱ������ͼ���JFreeChart  
            JFreeChart jFreeChart = ChartFactory.createTimeSeriesChart(  
                    "����ʱ���ǩ����ʾ��",   // ͼ����  
                    "ʱ��",               // �����ǩ����  
                    "��ֵ",               // �����ǩ����  
                    xyDataset,          // ͼ������ݼ���  
                    true,               // �Ƿ���ʾͼ����ÿ���������е�˵��  
                    false,              // �Ƿ���ʾ������ʾ  
                    false);             // �Ƿ���ʾͼ�������õ�url��������  
          
            // XYPlotͼ����������ö���,��������ͼ���һЩ��ʾ����  
            XYPlot xyPlot = (XYPlot) jFreeChart.getPlot();    
                          
            // �������ݵ�������ߵ���ʾ��ʽ  
            XYItemRenderer r = xyPlot.getRenderer();  
            if (r instanceof XYLineAndShapeRenderer) {  
                XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer) r;  
                renderer.setBaseShapesVisible(true);    // ���ݵ���ʾ���  
                renderer.setBaseShapesFilled(true); // ���ݵ���������  
            }  
              
///////////////////////////////  �¹��ܵ� /////////////////////////////////////////    
            // �Զ����µ�ʱ���ᣬ������ʾ����ʱ���ǩ  
            PeriodAxis periodAxis = new PeriodAxis("ʱ��");   // �Զ���Xʱ����  
            periodAxis.setTimeZone(TimeZone.getDefault());  // ʹ��Ĭ��ʱ��  
            periodAxis.setAutoRangeTimePeriodClass(Day.class); // ���ø�ʱ����Ĭ���Զ�����ʱ�䵥λΪ��  
             
            // ���ò�ͬ�ص�ʱ����ʾ��ʽ  
            PeriodAxisLabelInfo[] arrayOfPeriodAxisLabelInfo = new PeriodAxisLabelInfo[3];  
            arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Day.class, new SimpleDateFormat("d")); // ��һ����ʾ��  
            arrayOfPeriodAxisLabelInfo[1] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MMM"), new RectangleInsets(2.0D, 2.0D, 2.0D, 2.0D), new Font("SansSerif", 1, 10), Color.blue, false, new BasicStroke(0.0F), Color.lightGray); // �ڶ�����ʾ��  
            arrayOfPeriodAxisLabelInfo[2] = new PeriodAxisLabelInfo(Year.class, new SimpleDateFormat("yyyy��")); // ��������ʾ��  
              
            periodAxis.setLabelInfo(arrayOfPeriodAxisLabelInfo); // ����ʱ�����ϵ�ʱ����ʾ��ʽ  
            xyPlot.setDomainAxis(periodAxis);   // ����Xʱ����  
            ChartUtilities.applyCurrentTheme(jFreeChart); // ʹ�õ�ǰ����  
////////////////////////////////////////////////////////////////////////  
              
            return jFreeChart;  
        }  
  
        /** 
         * ����jfreechartͼ�����õ����ݼ��� 
         *  
         * @return 
         */  
        private XYDataset createDataset() {  
  
            // ������������  
            this.series = new TimeSeries("������");      
            setSeriesData(series, 100, new Day(25,10,2012), 18); // ����Ϊʱ�䵥λ����2012��10��25�տ�ʼ���������18���ģ������  
              
            // ���������з���һ�����ݼ�����  
            TimeSeriesCollection dataset = new TimeSeriesCollection();  
            dataset.addSeries(this.series);   
              
            return dataset;  
        }  
  
        /** 
         * �����������,�Զ���λ��ʱ�������ϵ���һ��ʱ��㣬�������ݵ���뵽���������� 
         * 
         * @param series    �������ж��� 
         * @param baseData  ���ɵ�������ݵĻ�׼ֵ 
         * @param regularTime   ������ʱ����(�ꡢ�¡��ա�ʱ���֡����) 
         * @param sampleNum  ���ɵ����ݵ���� 
         */  
        private void setSeriesData(TimeSeries series, double baseData, RegularTimePeriod regularTime, int sampleNum) {  
  
            // �������ģ������  
            double value = baseData;  
            for (int i = 0; i < sampleNum; i++) {  
                series.add(regularTime, value);       
                regularTime = regularTime.next();   //�Զ���λ����һ��ʱ���  
                value *= (1.0D + (Math.random() - 0.495D) / 4.0D);  
            }  
        }  
    }  
      
      
}  
