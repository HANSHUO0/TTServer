package com.yy.entity;
/**
* @author 陈籽伟
* @version 创建时间：2020年9月8日 下午2:53:52
* 类说明
*/

import java.sql.Date;

import lombok.Data;

@Data
public class User {

	private String ID;
	private String EMCode;
	private String PasswordMD5;
	private String mobilePhone;
	private String psnName;
	private String emName;
	private String signature;
	private String sex;
	private String HeadImageData;
	private Date birthday;
	private String address;
 	private Integer IsDel;
 	private String qq;
	private Date CreateDate;
	private String identity;
	private String email;
	private String marriage;
	private String sosName;
	private String sosPhone;
	private String depID;
}
