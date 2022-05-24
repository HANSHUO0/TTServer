package com.yy.util;

import java.util.UUID;

/**
* @author 陈籽伟
* @version 创建时间：2020年8月25日 上午11:27:06
* 类说明
*/
public class Code {

	public static String getCode() {
		
		//产生GUID
		UUID uuid = UUID.randomUUID();
		
		// 转换为大写
		String a = uuid.toString().toUpperCase();
		
		return a;
	}
	
	//8位随机数
	public static String getRandom() {
		String result = "";
		
		while (result.length() < 8) {
			String str = String.valueOf((int) (Math.random() * 10));
			if (result.indexOf(str) == -1) {
				result += str;
			}
		}
		return result;
	}
// public static void main(String args[]) {
//	 System.out.println(getCode());
// } 
}
