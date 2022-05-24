package com.yy.entity;

import com.yy.util.DateFormat;
import lombok.Data;

import java.util.Date;

/**
 * @Auther: 韩烁
 * @Data: 2022/3/23 0023 15:19
 * @Description:消息列表
 */
@Data
public class MessageList {
    Integer id;
    Integer chatID;
    String userID;
    String receiverID;
    String content;
    String lastTime;
    Integer count;
    String deleteMessageTime;
    String userName;
    String isHas;
    String cusName;
    public void setLastTime(String lastTime) {
        String createDate1 = lastTime.substring(0,lastTime.trim().lastIndexOf(" "));
        if (createDate1.equals(DateFormat.dateToStr(new Date(),"yyyy-MM-dd"))){
            this.lastTime = lastTime.substring(lastTime.trim().lastIndexOf(" "),lastTime.length()-3);
        }else if (createDate1.equals(DateFormat.getdate())){
            this.lastTime = "昨   天";
        }else {
            this.lastTime = DateFormat.dateToStr(DateFormat.strToDate(createDate1,"yyyy-MM-dd"),"yy/MM/dd");
        }
    }

    public void setLastTimeTrue(String lastTime){
        this.lastTime = lastTime;
    }

    public void setContent(String content) {
        if ( content.indexOf("<img") != -1 ){
            content = "[表情]";
        }
        if (content.indexOf("data:image") != -1){
            content = "[图片]";
        }
        this.content = content;
    }
}
