package com.yy.entity;


import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月6日 下午1:47:04
* 类说明
*/
@Data
public class TicketAccepts {

	private String id;
	private String ticketID;
	private String groupID;	
	private String assignee;
	private String userName;
	private String acceptanceDate;
	private String progress;
	private String processing3;
	private String errorReason;
	private String solve;
	private String casePerson;
	private String caseDate;
	private Integer integral;
}
