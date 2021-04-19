---
layout: post
title:  "UnityShader 混合"
date:   2021-04-18 14:27:54
categories: 编程
tags: UnityShader
---
# 

* content
{:toc}
[风宇冲原文传送门：](http://blog.sina.com.cn/s/blog_471132920101d8z5.html)

**用于生成透明对象**

| 渲染流程                  |                    |                 |            |          |
| ------------------------- | ------------------ | --------------- | ---------- | -------- |
| Transform,TexGen,Lighting |                    | Texturing,Fog   |            |          |
|                           | Culling,Depth Test |                 | Alpha Test | Blending |
| Vertex Shader             |                    | Fragment Shader |            |          |

### 语法

Blend Off 关闭混合

Blend SrcFactor DstFactor 配置并启用混合

```
生成的颜色 * SrcFactor + 屏幕已有颜色 * DstFactor
```



| SrcFactor,DstFactor上填写的属性 |                      |
| ------------------------------- | -------------------- |
| one                             | 1                    |
| zero                            | 0                    |
| SrcColor                        | 源的RGB(0.5,0.5,0.1) |
| SrcAlpha                        | 源的A值              |
| DstColor                        | 混合目标RGB          |
| DstAlpha                        | 混合目标A值          |
| OneMinusSrcColor                | (1,1,1)-SrcColor     |
| OneMinusSrcAlpha                | 1-SrcAlpha           |
| OneMinusDstColor                | (1,1,1)-DstColor     |
| OneMinusDstAlpha                | 1-DstAlpha           |

### 实例

Blend zero one 仅显示背景的RGB部分,无Alpha透明通道处理

Blend one zero 仅显示贴图的RGB部分,无Alpha透明通道处理。A通道为0 即本应该透明的地方也渲染了

Blend one one  贴图和背景叠加,无Alpha透明通道处理。仅颜色的叠加使rgb值趋近于1(白色)

Blend SrcAlpha zero 仅显示贴图，贴图含Alpha透明通道处理。但贴图的透明部分显示黑色:
```
(源A)0 * 源RGB + (zero)0 * 目标RGB = (0,0,0)(黑色)
```

Blend SrcAlpha OneMinusSrcAlpha  最常用混合模式,A越高显示越实

```
源RGB * 源A + 目标RGB * (1 - 源A)
```