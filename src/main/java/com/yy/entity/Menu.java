package com.yy.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Data;

@Data
public class Menu {

	private Integer id;
	private String title;
	private String url;
	private String icon;
	private Integer parentId;
	
	
	private Date createTime;
		
	private String time;
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
		setTime(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(createTime));
	}
}
