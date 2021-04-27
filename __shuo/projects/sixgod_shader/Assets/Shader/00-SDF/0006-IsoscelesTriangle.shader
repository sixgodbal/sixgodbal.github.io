Shader "SixGodSdf/0006 IsoscelesTriangle" {
    Properties {
        _Center_X("Center_X", Range(0,1)) = 0.5
        _Center_Y("Center_Y", Range(0,1)) = 0.5
        _RightX("RightX", Range(0,1)) = 0
        _RightY("RightY", Range(-1,1)) = 0.8
        _Rate("Rate", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags {
            "Queue"="AlphaTest" 
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
     
            float _Center_X;
            float _Center_Y;
            float _RightX;
            float _RightY;
            float _Rate;

            struct a2v {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            };

            v2f vert (a2v v)
            {
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);
                f.uv = v.uv;
                return f;
            }

            //q是右腰向量
            float getIsoscelesTriangleLength(float2 p, float2 q)
            {
                p.x = abs(p.x);
                float2 a = p - q * clamp(dot(p, q) / dot(q, q), 0, 1);
                float2 b = p - q * float2(clamp(p.x / q.x, 0, 1), 1);
                float k = sign(q.y);
                float d = min(dot(a, a), dot(b, b));
                float s = max(k * (p.x * q.y - p.y * q.x), k * (p.y - q.y));
                return sqrt(d) * sign(s);
            }
         
            fixed4 frag (v2f f) : SV_TARGET
            {
               fixed2 p = (f.uv - fixed2(_Center_X, _Center_Y)) * _Rate;
               fixed len = (1 - clamp(getIsoscelesTriangleLength(p, float2(_RightX, _RightY)), 0, 1));
               return fixed4(len, len, len, 1);
            }
            ENDCG
        }
    }
}