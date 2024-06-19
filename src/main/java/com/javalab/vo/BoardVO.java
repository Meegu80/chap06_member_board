package com.javalab.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
@ToString
public class BoardVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int bno;
	private String title;
	private String content;
	private String memberId;
	private Date regDate;
	private int hitNo;

}
