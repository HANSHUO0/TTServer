package com.yy.entity;

import lombok.Data;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月22日 下午2:20:24
* 类说明
*/
@Data
public class AddFile {

	private String id;
	private String ticketID;
	private String attName;
	private String fileName;
	private String fileSize;
}
