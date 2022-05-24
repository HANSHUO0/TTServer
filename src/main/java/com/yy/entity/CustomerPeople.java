package com.yy.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.Date;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月16日 上午10:11:09
* 类说明
*/
@Data
public class CustomerPeople {

	private String ID;
	@JsonProperty("groupID")
	private String groupID;
	@JsonProperty("cCusCode")
	private String cCusCode;
	@JsonProperty("cName")
	private String cName;
	@JsonProperty("cDep")
	private String cDep;
	@JsonProperty("cPost")
	private String cPost;
	@JsonProperty("cClub")
	private String cClub;
	@JsonProperty("cPhone")
	private String cPhone;
	@JsonProperty("cMoblePhone")
	private String cMoblePhone;
	@JsonProperty("cQQ")
	private String cQQ;
	@JsonProperty("cMoblePhone2")
	private String cMoblePhone2;
	@JsonProperty("cZR")
	private String cZR;
	@JsonProperty("cBridthday")
	private String cBridthday;
	@JsonProperty("cAge")
	private String cAge;
	@JsonProperty("cSex")
	private String cSex;
	@JsonProperty("cLike")
	private String cLike;
	@JsonProperty("cMove")
	private String cMove;
	@JsonProperty("cFriend")
	private String cFriend;
	@JsonProperty("cEmail")
	private String cEmail;
	@JsonProperty("cState")
 	private String cState;
	private Date createTime;
}
