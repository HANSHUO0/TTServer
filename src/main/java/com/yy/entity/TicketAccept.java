package com.yy.entity;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月5日 下午5:22:02
* 类说明
*/
@Data
public class TicketAccept {

	private String id;
	private String cid;
	private String groupID;
	@JsonProperty("cCusName")
	private String cCusName;
	private String claimDate;
	private String description;
	private String emergency;
	private String progress;
	private String getUserID;
	private String psnName;
	private String isDel;
}
