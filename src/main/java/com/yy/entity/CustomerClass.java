package com.yy.entity;

import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月7日 下午6:04:16
* 类说明
*/
@Data
public class CustomerClass {

	private String ID;
	private String selectID;
	private String groupID;
	private String listData;
	private Date createTime;
}
