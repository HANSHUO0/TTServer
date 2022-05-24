package com.yy.entity;



import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月30日 下午4:14:36
* 类说明
*/
@Data
public class TicketProgress {

	private String id;
	private String groupID;
	private String ticketID;
	private String userID;
	private String userName;
	private String processing2;
	private Integer progress;
	private String getUserID;
	private String getUserName;
	private String sendDate;
	private String claimDate;
	private String finishDate;
	private String wages;
	private String otherMes;
	private String isDel;
}
