package com.yy.entity;

import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月2日 上午10:48:56
* 类说明
*/
@Data
public class CustomerDesign {
	private String ID;
	private String userID;
	private String groupID;
	private String design;
	private Date createTime;
	private String positioningBar;
}
