package com.yy.entity;


import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月23日 下午4:26:29
* 类说明
*/
@Data
public class Ticket {

	private Integer curPage;
	private Integer pageSize;
	private String id;
	private String userID;
	private String groupID;
	private String cid;
	private String type;
	@JsonProperty("cCusName")
	private String cCusName;
	private String address;
	@JsonProperty("cContact")
	private String cContact;
	private String appointmentDate;
	private String cusVIP;
	private String dep;
	private String emergency;
	private String endDate;
	private String failureDate;
	private String faultType;
	private String inSources;
	private String phone;
	private String position;
	private String processing;
	private String product;
	private String registerPeople;
	private String serialNumber;
	private String states;
	private String description;
	private Integer progress;
	
	private String legalPerson;
	private String legalPersonName;
	private String sendPerson;
	private String sendDate;
	private String claimDate;
	private String finishDate;
	private String processing2;
	private String wages;
	private String otherMes;
	
	private String assignee;
	private String assigneeName;
	private String acceptanceDate;
	private String processing3;
	private String errorReason;
	private String solve;
	private String casePerson;
	private String casePersonName;
	private String caseDate;
	private Integer integral;
	
	private String accessPeople;
	private String accessPeopleName;
	private String accessDate;
	private String overview;
	private String feedback;
	
	private String chooseDate;
	private String test1;
	private String test2;
	
	private String operationPeople;
	private String message;
}
