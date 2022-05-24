package com.yy.controller;

import com.yy.dao.CustomerDao;
import com.yy.entity.*;
import com.yy.service.CustomerService;
import com.yy.service.GroupService;
import com.yy.service.MessageService;
import com.yy.service.UserService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

/**
 * @Auther: 韩烁
 * @Data: 2022/2/25 0025 10:47
 * @Description:沟通界面
 */
@Controller
@RequestMapping("pay")
@Scope("prototype")
public class ChatController {

    @Resource
    UserService userService;

    @Resource
    CustomerDao customerDao;

    @Resource
    MessageService messageService;

    @Resource
    CustomerService customerService;

    /**沟通界面进入*/
    @RequestMapping("toin.action")
    public String index(HttpServletRequest request,User user){

        //检索未读新消息
        List<MessageList> messages = messageService.selNewMessage(user);

        //同事、客户检索
        HashMap o = (HashMap) userService.selUserAboutGroup(user);

        if("查询失败".equals(o.get("msg"))) {

        }else {

            if (o.get("DepartmentPeople")!=null)
            request.setAttribute("DepartmentPeople",JSONArray.fromObject(o.get("DepartmentPeople")));

            if (o.get("customerPeopleList")!=null) {
                request.setAttribute("CustomerPeopleList", JSONArray.fromObject(o.get("customerPeopleList")));
            }
            if (o.get("userList")!=null)
            request.setAttribute("FriendsList", JSONArray.fromObject(o.get("userList")));


            request.setAttribute("message", JSONArray.fromObject(messages));
        }

        return "pay/index";
    }

    /**
     * 检索未读新消息数
     * @param user
     * @return
     */
    @RequestMapping("/message.action")
    @ResponseBody
    public Object selUnreadMessages(User user){

        List<MessageList> messages = messageService.selNewMessage(user);

        return messages;
    }

    /**
     * 模糊查询联系人（同事+客户）
     * @param user
     * @return
     */
    @RequestMapping("contacts.action")
    @ResponseBody
    public Object contacts(User user){
        return userService.selUserAboutGroup(user);
    }

    /**
     * 检索 未读消息、聊天内容
     */
    @RequestMapping("selectChatContent.action")
    @ResponseBody
    public Object selectChatContent(Message message){
        List<Message> messageList = messageService.selectChatContent(message);


        return messageList;
    }

    /**
     * 刷新已读
     */
    @RequestMapping("updateHaveRead.action")
    public void updateHaveRead(Message message){
        messageService.updateHaveRead(message);
    }

    /**
     * 删除聊天记录
     */
    @RequestMapping("deleteChatMessage.action")
    @ResponseBody
    public Object deleteMessages(MessageList messageList){
        return messageService.deleteMessages(messageList);
    }

    /**
     * 烟花页面
     */
    @RequestMapping("fireworks.action")
    public String fireworks(){
        return "pay/fireworks";
    }

    //检索同事或客户信息
    @RequestMapping("selectPeopleDetails.action")
    @ResponseBody
    public Object selectPeopleDetails(User user){
        List<CustomerEffective> customers = customerDao.selectCustomerEffective(user);
        return customers;
    }

    @RequestMapping("editCustomerMessage")
    @ResponseBody
    public Object editCustomerMessage(User user){
        return customerService.editCustomerMessage(user);
    }
}
