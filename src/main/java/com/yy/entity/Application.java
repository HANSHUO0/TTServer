package com.yy.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2021年2月24日 下午4:02:40
* 类说明
*/
@Data
public class Application {

	private String id;
	private String groupID;
	private String applicationName;
	private String applicationPhone;
	private Integer state;
	private Date createTime;
	
	private String time;
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
		setTime(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(createTime));
	}
}
