package com.yy.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.yy.util.DateFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @Auther: 韩烁
 * @Data: 2022/3/14 0014 16:04
 * @Description:
 */
@Data
public class Message implements Serializable {
    private static final long serialVersionUID = 1L;
    Integer ID;
    Integer chatID;
    String chatPeopleID;
    String userID;
    String receiverID;
    String userName;
    String cSendCode;
    String iNewType;
    String CreateDate;
    String theSpecificTime;
    String news;
    String isDel;
    Integer count;

    public void setCreateDate(String createDate) {
        this.theSpecificTime = DateFormat.dateToStr(DateFormat.strToDate(createDate,"yyyy-MM-dd HH:mm"),"yyyy/MM/dd HH:mm");
        String createDate1 = createDate.substring(0,createDate.trim().lastIndexOf(" "));
        if (createDate1.equals(DateFormat.dateToStr(new Date(),"yyyy-MM-dd"))){
            CreateDate = createDate.substring(createDate.trim().lastIndexOf(" "),createDate.length()-3);
        }else if (createDate1.equals(DateFormat.getdate())){
            CreateDate = "昨天";
        }else {
            CreateDate = DateFormat.dateToStr(DateFormat.strToDate(createDate1,"yyyy-MM-dd"),"yy/MM/dd");
        }
    }

    public void setCreateDateTrue(String createDate){
        this.CreateDate = createDate;
    }
}
