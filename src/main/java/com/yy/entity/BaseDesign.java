package com.yy.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2020年8月25日 上午10:42:53
* 类说明
*/
@Data
public class BaseDesign {

	private Integer cid;
	
	private String ID;
	
	private String DesignName;
	
	private String PageTitle;
	
	private String TableName;
	
	private String Controller;
	
	private String ViewName;
	
	private String Design;
	
	private Integer IsDel;
	
	private String CreateUserID;
	
	private String UserName;
	
	private String ModifyUserID;
	
	private String PositioningBar;
	
	private Date CreateDate; 
	
	private String Time;
	
	public void setCreateDate(Date CreateDate) {
		this.CreateDate = CreateDate;
		setTime(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(CreateDate));
	}
}
