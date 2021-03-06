package com.yy.config;

import com.yy.service.MessageService;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.ContextLoader;

import javax.annotation.Resource;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @ServerEndpoint 注解是一个类层次的注解，它的功能主要是将目前的类定义成一个websocket服务器端,
 *                 注解的值将被用于监听用户连接的终端访问URL地址,客户端可以通过这个URL来连接到WebSocket服务器端
 */
@RestController
@ServerEndpoint(value = "/webSocketOneToOne/{param}")
public class WebSocketOneToOne {

    private MessageService messageService = (MessageService)ApplicationHelper.getBean("messageServiceImpl");


    //静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;
    //实现服务端与客户端通信的话，可以使用Map来存放，其中Key为用户标识
    private static ConcurrentHashMap<String,WebSocketOneToOne> connections = new ConcurrentHashMap<>();
    //与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;
    //用户标识
    private String role;
    //会话标识
    private String socketId;

    /**
     * 连接建立成功调用的方法
     *
     * @param session
     *            可选的参数。session为与某个客户端的连接会话，需要通过它来给客户端发送数据
     */
    @OnOpen
    public void onOpen(@PathParam("param") String param, Session session) {
        this.session = session;
        String[] arr = param.split(",");
        this.role = arr[0];             //用户标识  2
        this.socketId = arr[1];         //会话标识  123
        connections.put(role,this);     //添加到map中
        addOnlineCount();               // 在线数加
        System.out.println("有新连接加入！新用户："+role+",当前在线人数为" + getOnlineCount());
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose() {
        connections.remove(role);  // 从map中移除
        subOnlineCount();          // 在线数 减
        System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param message
     *            客户端发送过来的消息
     * @param session
     *            可选的参数
     */
    @OnMessage
    public synchronized void onMessage(String message, Session session) {
        this.session = session;
        // System.out.println("来自客户端的消息:" + message);
        JSONObject json=JSONObject.fromObject(message);
        String string = null;  //需要发送的信息
        String to = null;      //发送对象的用户标识
        String isHas = null;  //是否有会话主表
        String type = null;  //图片为 1
        if (json.has("isHas")){
            isHas = (String) json.get("isHas");
        }
        if(json.has("message")){
            string = (String) json.get("message");
            // System.out.println(string);
        }
        if(json.has("role")){
            to = (String) json.get("role");
        }
        if (json.has("type")){
            type = "1";
        }
        Integer num = 0;
        try {
            if (null == type || !type.equals("1")) {
                num = messageService.sendMessage(isHas, string, role, to, socketId);
            }else {
                num = messageService.sendPicture(isHas,string,role,to,socketId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (num == 1) {
            send(string, role, to, socketId);
        }
    }

    /**
     * 发生错误时调用
     *
     * @param session
     * @param error
     */
    @OnError
    public void onError(Session session, Throwable error) {
        System.out.println("发生错误");
        error.printStackTrace();
    }


    //发送给指定角色
    public void send(String msg,String from,String to,String socketId){
        try {
            //to发给指定用户
            WebSocketOneToOne con = connections.get(to);
            if(con!=null){
                if(socketId==con.socketId||con.socketId.equals(socketId)){
                    con.session.getBasicRemote().sendText(from+"说"+msg);
                }

            }
            /*//from具体用户发送
            WebSocketOneToOne confrom = connections.get(from);
            if(confrom!=null){
                if(socketId==confrom.socketId||confrom.socketId.equals(socketId)){
                    confrom.session.getBasicRemote().sendText(from+"说："+msg);
                }

            }*/
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
        WebSocketOneToOne.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
        WebSocketOneToOne.onlineCount--;
    }
}
