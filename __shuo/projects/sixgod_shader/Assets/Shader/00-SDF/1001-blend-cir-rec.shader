Shader "SixGodSdf/1001 blend-cir-rec" {
    Properties {
        _Center_X("Center_X", Range(0,1)) = 0.5
        _Center_Y("Center_Y", Range(0,1)) = 0.5
        _RightTop_X("RightTop_X", Range(0,1)) = 0.8
        _RightTop_Y("RightTop_Y", Range(0,1)) = 0.7
        _Rate("Rate", Range(0, 2)) = 1

        
       _CycleX("CycleX", Range(0,1)) = 0.5
       _CycleY("CycleY", Range(0,1)) = 0.5
       _Radius("Radius", Range(-1, 1)) = 0.2

       _Power("Power", Range(0, 30)) = 1
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
            
         float _CycleX;
         float _CycleY;
         float _Radius;

         float _Power;

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
            
            float getCycle(float2 p, float r)
            {
                return length(p) - r;
            }
            float getRectangleLength(float2 p, float2 b)
            {
                float2 d = abs(p) - b;
                return length(max(d, 0)) + min( max(d.x, d.y), 0);
            }
         
            fixed4 frag (v2f f) : SV_TARGET
            {
                float len1 = getRectangleLength(f.uv.xy - float2(_Center_X, _Center_Y), float2(_RightTop_X, _RightTop_Y));
                float len2 = getCycle(f.uv.xy - fixed2(_CycleX, _CycleY), _Radius);
                float len3 = (len1 + len2) / 2;
                fixed c1 = 1 - clamp(len1, 0, 1);
                fixed c2 = 1 - clamp(len2, 0, 1);
                fixed c3 = 1 - clamp(len3, 0, 1);
                fixed c = pow(c3, _Power);
                
                return fixed4(c, c, c, 1);
            }
            ENDCG
        }
    }
}