Shader "SixGodSdf/0005 EquilateralTriangle" {
    Properties {
        _Center_X("Center_X", Range(0,1)) = 0.5
        _Center_Y("Center_Y", Range(0,1)) = 0.5
        _R("R", Range(0,1)) = 0.8
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
            float _R;
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

            //r是边长的一半
            float getEquilateralTriangleLength(float2 p, float r)
            {
                float k = sqrt(3);
                p.x = abs(p.x);
                if(p.x + k * p.y > 0)
                {
                    p = float2(p.x - k * p.y, -k * p.x - p.y) / 2;
                }
                p.x -= r;
                p.y += r/k;
                p.x -= clamp(p.x, -2 * r, 0);
                return -length(p) * sign(p.y);
            }
         
            fixed4 frag (v2f f) : SV_TARGET
            {
               fixed2 p = (f.uv - fixed2(_Center_X, _Center_Y)) * _Rate;
               fixed len = (1 - clamp(getEquilateralTriangleLength(p, _R), 0, 1));
               return fixed4(len, len, len, 1);
            }
            ENDCG
        }
    }
}