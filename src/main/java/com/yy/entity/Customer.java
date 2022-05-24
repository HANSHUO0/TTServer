package com.yy.entity;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月1日 下午6:19:45
* 类说明
*/
@Data
public class Customer {
	
	private String groupName;
	private String id;
	private String groupID;
	@JsonProperty("cCusCode")
	private String cCusCode;
	@JsonProperty("cCusName")
	private String cCusName;
	@JsonProperty("cCusAddName")
	private String cCusAddName;
	@JsonProperty("cSupUnit")
	private String cSupUnit;
	@JsonProperty("cCCCode")
	private String cCCCode;
	@JsonProperty("cCusVIP")
	private String cCusVIP;
	@JsonProperty("cPsnCode")
	private String cPsnCode;
	@JsonProperty("cInfoSource")
	private String cInfoSource;
	@JsonProperty("cCusPhone")
	private String cCusPhone;
	@JsonProperty("cDepCode")
	private String cDepCode;
	@JsonProperty("cCusAddress")
	private String cCusAddress;
	@JsonProperty("cStatus")
	private String cStatus;
	@JsonProperty("cTrade")
	private String cTrade;
	@JsonProperty("cMemo")
	private String cMemo;
	@JsonProperty("cCusFax")
	private String cCusFax;
	@JsonProperty("dCapital")
	private String dCapital;
	@JsonProperty("cCusBussinse")
	private String cCusBussinse;
	@JsonProperty("dCusSale")
	private String dCusSale;
	@JsonProperty("iStaffCount")
	private String iStaffCount;
	@JsonProperty("cCusHomePage")
	private String cCusHomePage;
	@JsonProperty("cDCCode")
	private String cDCCode;
	@JsonProperty("cMail")
	private String cMail;
}
