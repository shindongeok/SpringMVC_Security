package kr.bit.entity;

import lombok.Data;

@Data
public class MemberAuth {
    private int no;
    private String memberID;
    private String auth;
}
