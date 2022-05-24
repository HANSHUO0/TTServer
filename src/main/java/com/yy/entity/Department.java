package com.yy.entity;

import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月9日 下午4:42:14
* 类说明
*/
@Data
public class Department {

	private String id;
	private String groupID;
	private String listData;
	private String showData;
	private String revokeDate;
	private Date createDate;
}
