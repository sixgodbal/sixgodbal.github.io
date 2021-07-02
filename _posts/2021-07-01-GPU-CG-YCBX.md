---
layout: post
title:  "GPU CG之阳春白雪"
date:   2021-07-01 15:41:00
categories: Shader
tags: 编程
excerpt: true
---


* content
{:toc}
应用程序阶段、几何阶段、光栅阶段

在 GPU 的顶点程序中必须将法向量转换到 world space 中才能使用

当前的顶点程序还不能处理纹理信息，纹理信息只能在片断程序中读入。

（a < 0）?(b = a) :( c = a); 

k = (h < float3(0.0,0.0,0.0))?(i):(g);  x,y,z分别比较,赋值

POSITION，PSIZE，FOG,COLOR0-COLOR1,  TEXCOORD0-TEXCOORD7



abs(x) 绝对值

acos(x) 反余切 输入[-1,1] 返回[0,兀]

all(x) 输入0返回false 否则返回true

any(x) 

degrees(x) 弧度转为角度

exp(x) e的x次幂 e = 2.7182818284594523536

exp2(x) 2的x次幂

fmod(x, y) x/y的余数 若y=0,结果不可预料

frac(x) 返回小数部分 [0,1)

