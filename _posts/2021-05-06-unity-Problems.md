---
layout: post
title:  "Unity_Problems"
date:   2021-05-07 12:10:54
categories: Unity
tags: 编程
excerpt: true
---


* content
{:toc}


### 1.UI与粒子特效穿插

1.图片使用Sprite,控制特效Order in Layer的数值 在两Sprite数值之间

2.添加Canvas组件来控制Order in Layer



### 2.unity中 sprite&image的区别

|          | sprite                                       | image                                      |
| -------- | -------------------------------------------- | ------------------------------------------ |
| 渲染网格 | 匹配形状的多边形网格，裁剪透明部分（顶点多） | 紧密的矩形网格（片元多，易造成Overdraw管理 |
| 管理     | 单独控制，不便于挂载文本等操作               | 在Canvas下统一管理，便于控制               |



