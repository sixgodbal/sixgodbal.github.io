Shader "Hidden/shoushang"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blood("Blood",2D) = "white"{}
        _Alpha("Alpha",Range(0,1)) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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
            sampler2D _Blood;
            Float _Alpha;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                _Alpha = abs( sin(_Time.z));

                fixed4 blood = tex2D(_Blood, i.uv);
                blood.a *= _Alpha;
                col.rgb = col.rgb * (1-blood.a) + blood.rgb * blood.a;

                return col;
            }
            ENDCG
        }
    }
}
