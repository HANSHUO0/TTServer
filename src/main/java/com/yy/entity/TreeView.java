package com.yy.entity;

import java.util.List;

import lombok.Data;

@Data
public class TreeView {
	private Integer id;
	private String title;
	private List<TreeView> children;
	private boolean checked;
	private boolean spread = true;
	
}