package com.yy.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月15日 下午5:46:05
* 类说明
*/
@Data
public class CustomerAddress {

	private String ID;
	private String groupID;
	@JsonProperty("cCusCode")
	private String cCusCode;
	@JsonProperty("cSupUnit")
	private String cSupUnit;
	@JsonProperty("cCusAddress")
	private String cCusAddress;
	private String isDefault;
	private Date createTime;
}
