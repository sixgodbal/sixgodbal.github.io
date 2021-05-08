---
layout: post
title:  "CSharp_Problems"
date:   2021-05-08 10:29:00
categories: CSharp
tags: 编程
excerpt: true
---


* content
{:toc}


### 1.Dictionary取值优化

```
if(myDictionary.Contains(oneKey)) myValue = myDictionary[oneKey];//冗余访问
if(myDictionary.TryGetValue(oneKey, out myValue)){}//减少冗余的哈希次数
```

