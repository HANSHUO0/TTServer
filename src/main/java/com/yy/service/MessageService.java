package com.yy.service;

import com.yy.entity.Message;
import com.yy.entity.MessageList;
import com.yy.entity.User;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Auther: 韩烁
 * @Data: 2022/3/14 0014 16:12
 * @Description:新消息处理
 */
public interface MessageService {

    List<MessageList> selNewMessage(User user);

    Integer sendMessage(String isHas,String string, String role, String to, String socketId);

    Integer sendPicture(String isHas, String string, String role, String to, String socketId);

    List<Message> selectChatContent(Message message);

    void updateHaveRead(Message message);

    Object deleteMessages(MessageList messageList);


}
