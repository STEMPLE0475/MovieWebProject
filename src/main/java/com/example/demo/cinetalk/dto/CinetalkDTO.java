package com.example.demo.cinetalk.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class CinetalkDTO {
    private Long talkId;
    private String title;
    private String content;
    private String userId;
    private Integer readCount;
    private LocalDateTime regDt;


}