---
layout: post
title:  "UnityShader 模板测试"
date:   2021-04-15 14:29:54
categories: UnityShader
tags: 编程
---
## >>UnityShader 模板测试
* content
{:toc}
[大神原文传送门：https://blog.csdn.net/u011047171/article/details/46928463](https://blog.csdn.net/u011047171/article/details/46928463)

#### **模板缓冲区**

**可用做一般目的的每像素遮罩，以便保存或丢弃像素**

**通常是每像素8位整数。该值可以写入、递增或递减    在后续调用中根据该值进行测试**

#### **模板测试概要**

stencil与颜色缓冲区和深度缓冲区类似，模板缓冲区可以为屏幕上的每个像素点保存一个无符号整数值(通常的话是个8位整数)。这个值的具体意义视程序的具体应用而定。在渲染的过程中，可以用这个值与一个预先设定的参考值相比较，根据比较的结果来决定是否更新相应的像素点的颜色值。这个比较的过程被称为模板测试。模板测试发生在透明度测试（alpha test）之后，深度测试（depth test）之前。如果模板测试通过，则相应的像素点更新，否则不更新。

#### **语法**

```
stencil{
	Ref referenceValue
	ReadMask  readMask
	WriteMask writeMask
	Comp comparisonFunction
	Pass stencilOperation
	Fail stencilOperation
	ZFail stencilOperation
}
```

##### **Ref referenceValue**

设定参考值

##### **ReadMask readMask**

```
if(referenceValue&readMask comparisonFunction stencilBufferValue&readMask)通过像素
```

##### **WriteMask writeMask**

掩码操作后,修改stencilBufferValue值

##### **Comp comparisonFunction**

比较 参考值 和 缓冲区的值(默认always)

##### **Pass stencilOperation**

模板、深度测试通过后,对 缓冲区 内容的处理方式(默认keep)

##### **Fail stencilOperation**

模板、深度测试失败后,对 缓冲区 内容的处理方式(默认keep)

##### **ZFail stencilOperation**

模板通过、深度失败后,对 缓冲区 内容的处理方式(默认keep)

#### **模板缓冲值**

| 关键字   | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| Keep     | 保留当前缓冲中的内容，即stencilBufferValue不变               |
| Zero     | 将0写入缓冲，即stencilBufferValue值变为0                     |
| Replace  | 将参考值写入缓冲，即将referenceValue赋值给stencilBufferValue |
| IncrSat  | stencilBufferValue加1，超过255则保留                         |
| DecrSat  | stencilBufferValue减1，超过0则保留                           |
| Invert   | 将当前模板缓冲值（stencilBufferValue）按位取反               |
| IncrWrap | 当前缓冲的值加1，如果缓冲值超过255了，那么变成0，（然后继续自增） |
| DecrWrap | 当前缓冲的值减1，如果缓冲值已经为0，那么变成255，（然后继续自减） |

