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



### 3.优化

影响性能的因素：

CPU：

1.物理模拟 

2.复杂的代码算法 

3.Draw Calls

减少DrawCall

GPU：

1.顶点数量,运算量

LOD

遮挡剔除

2.像素量,OverDraws,运算量 

减少实时光照：Lightmaps(提前存储光照信息) GodRays(通过透明纹理模拟光源)

减少OverDraw

控制绘制顺序(深度测试)

3.(带宽)尺寸大且未压缩的纹理,分辨率过高的framebuffer

减少纹理大小

利用[硬件缩放技术](http://www.xuanyusong.com/archives/3205?gqfuho=kav211)