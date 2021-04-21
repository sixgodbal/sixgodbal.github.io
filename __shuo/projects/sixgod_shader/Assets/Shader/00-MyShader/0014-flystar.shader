Shader "0014-flystar" {
    Properties {
        _Star1("Star 1", 2D) = "write" {}
        _Scale("Star Scale", Range(0,20)) = 4
        _RotateSpeed("Rotate Speed", Range(-360, 360)) = 90
        _TimeScale("Time Scale", Range(-1, 1)) = 1
        _CullBlack("Black BG", Range(0, 3)) = 0
        _AlphaScale("Alpha Scale", Range(0,3)) = 1
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

            struct a2v {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
                fixed   _y : COLOR0;
            };

            
            fixed2 getStarUV(fixed2 uv, fixed _x, fixed _y, float angle)
            {
                fixed2 tempuv = uv.xy + fixed2(_x, _y) - 0.5;
                fixed2 resultUV = fixed2(tempuv.x * cos(angle) - tempuv.y * sin(angle), tempuv.x * sin(angle) + tempuv.y * cos(angle)) * _Scale + 0.5;
                return resultUV;
            }

            v2f vert (a2v v)
            {
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);

                float Time = _Time.y;
                fixed Time_decimal = Time * _TimeScale - floor(Time * _TimeScale);
                
                float angle = radians(_RotateSpeed * _Time.y);

                fixed _x = Time_decimal * 0.5 - 0.25;
                fixed _y = Time_decimal - 0.5;

                fixed2 uv_1 = getStarUV(v.uv.xy, _x, _y, angle);
                
                f.uv = uv_1;

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