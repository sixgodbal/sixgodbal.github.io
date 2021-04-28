Shader "SixGodSdf/0007 CommonTriangle" {
    Properties {
        _Center_X("Center_X", Range(0,1)) = 0.5
        _Center_Y("Center_Y", Range(0,1)) = 0.5
        _X1("X1", Range(-1,1)) = 0
        _Y1("Y1", Range(-1,1)) = 0.8
        _X2("X2", Range(-1,1)) = 0.2
        _Y2("Y2", Range(-1,1)) = 0.4
        _X3("X3", Range(-1,1)) = -0.3
        _Y3("Y3", Range(-1,1)) = 0.6
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
            float _X1;
            float _Y1;
            float _X2;
            float _Y2;
            float _X3;
            float _Y3;
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

            //三个顶点向量
            float getCommonTriangleLength(float2 p, float2 p0, float2 p1, float2 p2)
            {
                float2 e0 = p1 - p0; float2 e1 = p2 - p1; float2 e2 = p0 - p2;
                float2 v0 = p - p0;  float2 v1 = p - p1;  float2 v2 = p - p2;
                float2 pq0 = v0 - e0 * clamp(dot(v0, e0) / dot(e0, e0), 0, 1);
                float2 pq1 = v1 - e1 * clamp(dot(v1, e1) / dot(e1, e1), 0, 1);
                float2 pq2 = v2 - e2 * clamp(dot(v2, e2)  / dot(e2, e2), 0, 1);
                float s = sign(e0.x * e2.y - e0.y * e2.x);//-1逆时针
                float2 d = min(min(float2(dot(pq0, pq0), s * (v0.x * e0.y - v0.y * e0.x)),
                                   float2(dot(pq1, pq1), s * (v1.x * e1.y - v1.y * e1.x))),
                                   float2(dot(pq2, pq2), s * (v2.x * e2.y - v2.y * e2.x)));

                return -sqrt(d.x) * sign(d.y);
            }
         
            fixed4 frag (v2f f) : SV_TARGET
            {
               fixed2 p = (f.uv - fixed2(_Center_X, _Center_Y)) * _Rate;
               fixed len = (1 - clamp(getCommonTriangleLength(p, float2(_X1, _Y1), float2(_X2, _Y2), float2(_X3, _Y3)), 0, 1));
               return fixed4(len, len, len, 1);
            }
            ENDCG
        }
    }
}