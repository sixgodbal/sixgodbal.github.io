---
layout: post
title:  "UntiyShader 语义"
date:   2021-04-15 14:27:54
categories: 编程
tags: UnityShader
---
## >>UnityShader 语义
* content
{:toc}
**作用:告诉系统用户需要的输入值、输出值, 限定来源和作用**

#### **顶点着色器输入语义**

POSITION 顶点位置(模型空间)

TEXCOORDn 纹理坐标输入0~N(模型空间)

NORMAL 法线(模型空间)

TANGENT 切线(模型空间)

COLOR 顶点颜色(模型空间)

#### **顶点着色器输出/片元着色器输入语义**

SV_POSITION 裁剪空间中的顶点坐标

COLOR0、COLOR1 传递任意值

TEXCOORDn 传递任意值

#### **片元着色器输出语义**

SV_TARGET 输出颜色值存储到渲染目标