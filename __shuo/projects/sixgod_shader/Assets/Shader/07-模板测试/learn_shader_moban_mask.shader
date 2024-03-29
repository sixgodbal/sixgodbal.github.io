﻿Shader "Hidden/learn_shader_moban_mask"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskValue("MaskValue",Int) = 1
    }
    SubShader
    {
        // No culling or depth
        //Cull Off ZWrite Off ZTest Always
        Blend SrcAlpha OneMinusSrcAlpha
        Stencil {
                Ref[_MaskValue]
                Comp always  //总是通过
                Pass replace //通过后替换
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                return fixed4(0,0,0,0);
            }
            ENDCG
        }
    }
}
