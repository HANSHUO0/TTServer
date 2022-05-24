package com.yy.entity;
/**
* @author 陈籽伟
* @version 创建时间：2020年12月15日 下午5:51:11
* 类说明
*/

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class CustomerAssociation {

	private String ID;
	private String groupID;
	@JsonProperty("cCusCode")
	private String cCusCode;
	@JsonProperty("cCompanyName")
	private String cCompanyName;
	@JsonProperty("cAssociation")
	private String cAssociation;
	private Date createTime;
}
