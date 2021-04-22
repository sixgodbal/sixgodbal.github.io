Shader "SixGodSdf/0004 Diamond" {
    Properties {
        _Center_X("Center_X", Range(0,1)) = 0.5
        _Center_Y("Center_Y", Range(0,1)) = 0.5
        _X("X", Range(0,1)) = 0.8
        _Y("Y", Range(0,1)) = 0.7
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
            float _X;
            float _Y;
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

            float getDiamondLength(float2 q, float2 b)
            {
               float2 a = float2(0, b.y); // 与y轴交点
               float2 c = float2(b.x, 0);
               float2 pa = q-a;
               float2 ba = c-a;
               float h = clamp( dot(pa, ba) / dot(ba, ba), 0.0, 1.0 );
               float d = length( pa - ba*h );
               return d * sign( q.x * b.y + q.y * b.x - b.x * b.y );
            }
         
            fixed4 frag (v2f f) : SV_TARGET
            {
               fixed2 q = abs(f.uv - fixed2(_Center_X, _Center_Y));
               fixed2 b = fixed2(_X, _Y);
               fixed len = (1 - getDiamondLength(q, b)) * _Rate;
               return fixed4(len, len, len, 1);
            }
            ENDCG
        }
    }
}