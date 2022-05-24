package com.yy.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月28日 上午8:53:23
* 类说明
*/
@Data
public class UserGroup {

	private String ID;
	private String UserID;
	private String GroupID;
	private Integer MenuID;
	private String AddData;
	private String Menuids;

	private Date CreateDate;
	
	private String time;
	public void setCreateTime(Date createTime) {
		this.CreateDate = createTime;
		setTime(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(createTime));
	}
}
