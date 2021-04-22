---
layout: post
title:  "UnityShader 剔除和深度测试"
date:   2021-04-15 14:28:54
categories: UnityShader
tags: 编程
---
## >>UnityShader 剔除和深度测试
* content
{:toc}
**作用:确保在场景中仅绘制 深度最小 的表面对象**

#### **语法**
Cull Back  不渲染背离观察者的多边形
Cull Front 不渲染面向观察者的多边形
Cull Off     禁用剔除,绘制所有面

ZWrite On|Off 是否写入深度缓存(默认On)
如果要绘制实体对象，请将其保留为 on; 如果要绘制半透明效果，请切换到 ZWrite Off

ZTest (Less|Greater|LEqual|GEqual|Equal|NotEqual|Always) 深度测试方式(默认LEqual)
