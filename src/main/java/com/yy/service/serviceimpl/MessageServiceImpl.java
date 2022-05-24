package com.yy.service.serviceimpl;

import com.yy.dao.MessageDao;
import com.yy.entity.Chat;
import com.yy.entity.Message;
import com.yy.entity.MessageList;
import com.yy.entity.User;
import com.yy.service.MessageService;
import com.yy.util.DateFormat;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * @Auther: 韩烁
 * @Data: 2022/3/14 0014 16:14
 * @Description:新消息
 */
@Service
public class MessageServiceImpl implements MessageService {

    @Resource
    MessageDao messageDao;

    /**
     * 新消息检索
     * @param user
     * @return
     */
    @Override
    public List<MessageList> selNewMessage(User user) {

        return messageDao.selNewMessage(user);
    }


    /**
     * 发送消息
     * @param string 消息
     * @param role 发送人
     * @param to 接收人
     * @param socketId 会话ID
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public Integer sendMessage(String isHas, String string, String role, String to, String socketId) {
        MessageList messageList = null;
        Chat chat = null;
        Message message = new Message();
        Integer ID = 0;
        if (!("1".equals(isHas))){
            chat = new Chat();
            chat.setUserID(role);
            chat.setReceiverID(to);
             ID = messageDao.selectChatID(chat);
            if ("".equals(ID) || null==ID) {
                Integer integer = messageDao.addChat(chat);
                messageList = new MessageList();
                messageList.setChatID(chat.getId());
                messageList.setUserID(role);
                messageList.setReceiverID(to);
                messageList.setContent(string);
                messageList.setCount(1);
                messageList.setLastTimeTrue(DateFormat.dateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                messageList.setIsHas("1");
                Integer num = messageDao.addChatPeople(messageList);
                message.setCount(1);
            }else {
                chat.setId(ID);
            }
        }
        if (chat != null) {
            message.setChatID(chat.getId());
        }else {
            message.setChatID(null);
        }
        message.setNews(string);
        message.setUserID(role);
        message.setCSendCode(socketId);
        message.setReceiverID(to);
        message.setINewType("1");
        message.setIsDel("0");
        if (messageList != null) {
            message.setCreateDateTrue(messageList.getLastTime());
        }else {
            message.setCreateDateTrue(DateFormat.dateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
        }
        // message.setCreateDate(DateFormat.dateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));

        Integer integer = messageDao.addMessage(message);
        // System.out.println(integer);
        return integer;
    }

    //发送图片
    @Override
    public Integer sendPicture(String isHas, String string, String role, String to, String socketId) {
        MessageList messageList = null;
        Chat chat = null;
        Message message = new Message();
        Integer ID = 0;
        if (!("1".equals(isHas))){
            chat = new Chat();
            chat.setUserID(role);
            chat.setReceiverID(to);
            ID = messageDao.selectChatID(chat);
            if ("".equals(ID) || null==ID) {
                Integer integer = messageDao.addChat(chat);
                messageList = new MessageList();
                messageList.setChatID(chat.getId());
                messageList.setUserID(role);
                messageList.setReceiverID(to);
                messageList.setContent(string);
                messageList.setCount(1);
                messageList.setLastTimeTrue(DateFormat.dateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
                messageList.setIsHas("1");
                Integer num = messageDao.addChatPeople(messageList);
                message.setCount(1);
            }else {
                chat.setId(ID);
            }
        }
        if (chat != null) {
            message.setChatID(chat.getId());
        }else {
            message.setChatID(null);
        }
        message.setNews(string);
        message.setUserID(role);
        message.setCSendCode(socketId);
        message.setReceiverID(to);
        message.setINewType("1");
        message.setIsDel("0");
        if (messageList != null) {
            message.setCreateDateTrue(messageList.getLastTime());
        }else {
            message.setCreateDateTrue(DateFormat.dateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
        }

        Integer integer = messageDao.addMessage(message);
        // System.out.println(integer);
        return integer;
    }

    /**
     * 查询 未读消息、聊天记录
     * @param message
     * @return
     */
    @Override
    public List<Message> selectChatContent(Message message) {
        List<Message>messageList = messageDao.selectChatContent(message);
        return messageList;
    }

    /**
     * 刷新已读
     * @param message
     */
    @Override
    public void updateHaveRead(Message message) {
        messageDao.updateHaveRead(message);
    }

    /**
     * 删除聊天记录
     * @param messageList
     * @return
     */
    @Override
    public Object deleteMessages(MessageList messageList) {
        HashMap<Object, Object> map=new HashMap<>();;
        Integer num = messageDao.deleteMessages(messageList);
        if (num == 1){
            map.put("msg","删除成功");
            map.put("code","1");
        }else {
            map.put("msg","删除失败");
            map.put("code","0");
        }

        return map;
    }


}
