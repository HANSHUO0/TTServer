package com.yy.dao;

import com.yy.entity.Chat;
import com.yy.entity.Message;
import com.yy.entity.MessageList;
import com.yy.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Auther: 韩烁
 * @Data: 2022/3/14 0014 16:26
 * @Description:新消息
 */
public interface MessageDao {

    List<MessageList> selNewMessage(User user);

    Integer addMessage(Message message);

    List<Message> selectChatContent(Message message);

    void updateHaveRead(Message message);

    Integer addChat(Chat chat);

    Integer addChatPeople(MessageList messageList);

    Integer deleteMessages(MessageList messageList);

    Integer selectChatID(Chat chat);
}
