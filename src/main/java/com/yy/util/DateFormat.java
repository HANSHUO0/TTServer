package com.yy.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * @Auther: 韩烁
 * @Data: 2022/3/15 0015 14:52
 * @Description:时间转换工具类
 */
public class DateFormat {



    //字符串转换为日期
    public static Date strToDate(String strDate,String format) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        Date date = null;
        try {
            date = dateFormat.parse(strDate);
        } catch (ParseException e) {
            System.out.println(e.getMessage());
        }
        return date;
    }

    //日期转换为字符串
    public static String dateToStr(Date date,String format) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        String strDate = dateFormat.format(date);
        return strDate;
    }

    //计算日期
    public static String beforeOrAfterNumberDay(Date date, int day) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.add(Calendar.DAY_OF_YEAR, day);
        return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
    }
    //昨天日期获取
    public static String getdate() {
        long nowDate = System.currentTimeMillis();
        return beforeOrAfterNumberDay(new Date(nowDate), -1);
    }

}
