package com.lmt.app.display;
/** 
 * 时间序列图:显示多重时间标签文字 
 *  
 * 新增功能点： 
 *   ① 显示多重时间标签文字 
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
        TimeSeries08 timeSeries = new TimeSeries08("显示多重时间标签文字示例");  
        timeSeries.pack();  
        RefineryUtilities.centerFrameOnScreen(timeSeries);  
        timeSeries.setVisible(true);  
    }  
  
    /** 
     * 显示该Demo图表的容器 
     *  
     * ChartBasePanel类是Swing框架下所有例子共同使用的，这里不重复贴出 
     *  
     * */  
    private class TimeSeriesPanel extends ChartBasePanel {  
        private TimeSeries series;  // 间隔定长时间(如年、月、日、时、分、秒等)的数据序列  
        private ChartPanel chartPanel;    
        private JFreeChart chart = createChart();   // 创建一个JFreeChart时间序列图表  
  
        public TimeSeriesPanel() {  
            super();  
              
            addChart(this.chart);   // 将此JFreeChart加入JFreeChart列表中  
              
            // 将JFreeChart放在专用的图表容器ChartPanel中  
            this.chartPanel = new ChartPanel(this.chart);  
            this.chartPanel.setPreferredSize(new Dimension(600, 250));  
              
            // 设置chartPanel容器边框  
            CompoundBorder compoundBorder = BorderFactory.createCompoundBorder(  
                    BorderFactory.createEmptyBorder(4, 4,4, 4),  
                    BorderFactory.createEtchedBorder());  
            this.chartPanel.setBorder(compoundBorder);  
              
            // 将chartPanel加入到本容器中  
            add(this.chartPanel);  
        }  
  
        /** 
         * 创建jfreechart图表 
         * */  
        private JFreeChart createChart() {  
            // 生成图表数据集合  
            XYDataset xyDataset = createDataset();   
              
            // 增加汉字支持  
            StandardChartTheme standardChartTheme=new StandardChartTheme("CN");     //创建主题样式            
            standardChartTheme.setExtraLargeFont(new Font("隶书",Font.BOLD,20));    //设置标题字体         
            standardChartTheme.setRegularFont(new Font("SimSun",Font.PLAIN,15));    //设置图例的字体      
            standardChartTheme.setLargeFont(new Font("宋体",Font.PLAIN,15));      //设置轴向的字体     
            ChartFactory.setChartTheme(standardChartTheme); //应用主题样式      
              
            // 创建一个时间序列图表的JFreeChart  
            JFreeChart jFreeChart = ChartFactory.createTimeSeriesChart(  
                    "多重时间标签文字示例",   // 图表名  
                    "时间",               // 横轴标签文字  
                    "数值",               // 纵轴标签文字  
                    xyDataset,          // 图表的数据集合  
                    true,               // 是否显示图表中每条数据序列的说明  
                    false,              // 是否显示工具提示  
                    false);             // 是否显示图表中设置的url网络连接  
          
            // XYPlot图表区域的设置对象,用来设置图表的一些显示属性  
            XYPlot xyPlot = (XYPlot) jFreeChart.getPlot();    
                          
            // 设置数据点和序列线的显示格式  
            XYItemRenderer r = xyPlot.getRenderer();  
            if (r instanceof XYLineAndShapeRenderer) {  
                XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer) r;  
                renderer.setBaseShapesVisible(true);    // 数据点显示外框  
                renderer.setBaseShapesFilled(true); // 数据点外框内填充  
            }  
              
///////////////////////////////  新功能点 /////////////////////////////////////////    
            // 自定义新的时间轴，用于显示多重时间标签  
            PeriodAxis periodAxis = new PeriodAxis("时间");   // 自定义X时间轴  
            periodAxis.setTimeZone(TimeZone.getDefault());  // 使用默认时区  
            periodAxis.setAutoRangeTimePeriodClass(Day.class); // 设置该时间轴默认自动增长时间单位为天  
             
            // 设置不同重的时间显示格式  
            PeriodAxisLabelInfo[] arrayOfPeriodAxisLabelInfo = new PeriodAxisLabelInfo[3];  
            arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Day.class, new SimpleDateFormat("d")); // 第一行显示天  
            arrayOfPeriodAxisLabelInfo[1] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MMM"), new RectangleInsets(2.0D, 2.0D, 2.0D, 2.0D), new Font("SansSerif", 1, 10), Color.blue, false, new BasicStroke(0.0F), Color.lightGray); // 第二行显示月  
            arrayOfPeriodAxisLabelInfo[2] = new PeriodAxisLabelInfo(Year.class, new SimpleDateFormat("yyyy年")); // 第三行显示年  
              
            periodAxis.setLabelInfo(arrayOfPeriodAxisLabelInfo); // 设置时间轴上的时间显示格式  
            xyPlot.setDomainAxis(periodAxis);   // 设置X时间轴  
            ChartUtilities.applyCurrentTheme(jFreeChart); // 使用当前主题  
////////////////////////////////////////////////////////////////////////  
              
            return jFreeChart;  
        }  
  
        /** 
         * 创建jfreechart图表所用的数据集合 
         *  
         * @return 
         */  
        private XYDataset createDataset() {  
  
            // 生成数据序列  
            this.series = new TimeSeries("序列线");      
            setSeriesData(series, 100, new Day(25,10,2012), 18); // 以月为时间单位，从2012年10月25日开始，随机产生18天的模拟数据  
              
            // 将数据序列放在一个数据集合中  
            TimeSeriesCollection dataset = new TimeSeriesCollection();  
            dataset.addSeries(this.series);   
              
            return dataset;  
        }  
  
        /** 
         * 随机生成数据,自动定位到时间序列上的下一个时间点，将新数据点加入到数据序列中 
         * 
         * @param series    数据序列对象 
         * @param baseData  生成的随机数据的基准值 
         * @param regularTime   定长的时间间隔(年、月、日、时、分、秒等) 
         * @param sampleNum  生成的数据点个数 
         */  
        private void setSeriesData(TimeSeries series, double baseData, RegularTimePeriod regularTime, int sampleNum) {  
  
            // 生成随机模拟数据  
            double value = baseData;  
            for (int i = 0; i < sampleNum; i++) {  
                series.add(regularTime, value);       
                regularTime = regularTime.next();   //自动定位到下一个时间点  
                value *= (1.0D + (Math.random() - 0.495D) / 4.0D);  
            }  
        }  
    }  
      
      
}  
