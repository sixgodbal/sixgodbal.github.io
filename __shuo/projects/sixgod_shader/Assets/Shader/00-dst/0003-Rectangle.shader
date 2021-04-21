Shader "SixGodSdf/0003 Rectangle" {
    Properties {
        _Center_X("Center_X", Range(0,1)) = 0.5
        _Center_Y("Center_Y", Range(0,1)) = 0.5
        _RightTop_X("RightTop_X", Range(0,1)) = 0.8
        _RightTop_Y("RightTop_Y", Range(0,1)) = 0.7
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

            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
     
            float _Center_X;
            float _Center_Y;
            float _RightTop_X;
            float _RightTop_Y;
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
         
            fixed4 frag (v2f f) : SV_TARGET
            {
                fixed2 d = abs(f.uv.xy - fixed2(_Center_X, _Center_Y)) - fixed2(_RightTop_X, _RightTop_Y);
                fixed len = (1 - max( min(length(max(d, 0)) + min(max(d.x, d.y), 0), 1), 0 )) * _Rate;
                return fixed4(len, len, len, 1);
            }
            ENDCG
        }
    }
}