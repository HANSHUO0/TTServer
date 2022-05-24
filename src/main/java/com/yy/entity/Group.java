package com.yy.entity;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月27日 下午2:52:44
* 类说明
*/
@Data
public class Group {

	private String ID;
	private String CreateUserID;
	private String cGroupPhone;
	private String cGroupAdmin;
	private String cGroupAddress;
	private String cGroupPeople;
	private Integer IsDel;
	private String cGroupImg;
	private String cGroupCode;
	private String cGroupName;
	private String createDate;
}
