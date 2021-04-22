---
layout: post
title:  "shaderExample 01"
date:   2021-04-21 14:27:54
categories: UnityShader
tags: 编程
excerpt: true
---


* content
{:toc}
#### 1.流星

**通过矩阵变换变换实现**

```
Shader "0014-flystar" {
    Properties {
        _Star1("Star 1", 2D) = "write" {}
        _Scale("Star Scale", Range(0,20)) = 4
        _RotateSpeed("Rotate Speed", Range(-360, 360)) = 90
        _TimeScale("Time Scale", Range(-1, 1)) = 1
        _CullBlack("Black BG", Range(0, 3)) = 0
        _AlphaScale("Alpha Scale", Range(0,3)) = 1
        _OffSetX("OffSet X", Range(-1, 1)) = 0
        _OffSetY("OffSet Y", Range(-1, 1)) = 0
        _ScaleX("Scale X", Range(-2, 2)) = 0
        _ScaleY("Scale Y", Range(-2, 2)) = 0
    }
    SubShader
    {
        Tags {
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent"
        }
        pass
        {
            Zwrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
     
            sampler2D _Star1;
            float _Scale;
            float _RotateSpeed;
            float _TimeScale;
            float _CullBlack;
            float _AlphaScale;
            float _ScaleX;
            float _ScaleY;
            float _OffSetX;
            float _OffSetY;

            struct a2v {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
                fixed   _y : COLOR0;
            };

            fixed2 getTran(fixed2 uv, fixed _x, fixed _y, float angle, float scale)
            {
                return mul(float3x3(cos(angle), -sin(angle), 0, sin(angle), cos(angle), 0, 0, 0, 1), 
                       mul(float3x3(scale, 0, 0, 0, scale, 0, 0, 0, 1), 
                       mul(float3x3(1, 0, _x, 0, 1, _y, 0, 0, 1), float3(uv - 0.5, 1)))).xy + 0.5;
            }

            v2f vert (a2v v)
            {
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);

                float Time = _Time.y;
                fixed Time_decimal = frac(Time);
                
                float angle = radians(_RotateSpeed * _Time.y);
                fixed _x = (Time_decimal - 0.5) * _ScaleX;
                fixed _y = (Time_decimal - 0.5) * _ScaleY;
                f.uv = getTran(v.uv.xy, _x, _y, angle, _Scale);
                f._y = _y;
                return f;
            }
         
            fixed4 frag (v2f f) : SV_TARGET
            {
                fixed4 c = tex2D(_Star1, f.uv);
                
                c.xyz *= pow(c.a, 1);
                c.a = (0.5 - f._y) * _AlphaScale;
                if(c.r + c.g + c.b <= _CullBlack)  
                    c.a = 0;  
                return fixed4(c);
            }
            ENDCG
        }
    }
}
```

