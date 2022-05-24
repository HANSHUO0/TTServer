package com.yy.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月27日 上午8:56:07
* 类说明
*/
@Data
public class TicketBehavior {

	private String id;
	private String groupID;
	private String ticketID;
	private String firstPeople;
	private Integer behavior;
	private String secondPeople;
	private String message;
	private Date createTime;
	
	private String time;
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
		setTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(createTime));
	}
}
