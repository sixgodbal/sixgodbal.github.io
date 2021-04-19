---
layout: post
title:  "UnityShader 语义"
date:   2021-04-18 14:27:54
categories: 编程
tags: UnityShader
---
# >>UnityShader 知识点

* content
{:toc}
## 1.Tiling、Offset 缩放和偏移

```
//_MainTex纹理 _MainTex_ST.zw偏移  _MainTex_ST.xy缩放
f.uv = v.texcoord.xy * _MainTex_ST.xy - _MainTex_ST.zw;
```

