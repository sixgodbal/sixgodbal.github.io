Shader "SixGodShader/0012 GrayBase"
{
    Properties{
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
	    _Color("Tint", Color) = (1, 1, 1, 1)
        _Rate("Rate", Range(0, 1)) = 0.88
    }
    SubShader{
        Blend One OneMinusSrcAlpha
        Pass{
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

            struct a2v {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };
            struct v2f{
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };
            sampler2D _MainTex;
            fixed4 _Color;
            half _Rate;
            v2f vert(a2v v)
            {
                v2f f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.texcoord = v.texcoord;
                f.color = v.color * _Color;
                return f;
            }
            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed4 c = tex2D(_MainTex, f.texcoord) * f.color;
                c.xyz *= c.a;
                float va = dot(c.xyz, float3(0.299, 0.587, 0.114));
                va *= _Rate;
                c.xyz = float3(va,va,va);
                return c;
            }
            ENDCG
        }
    }
}