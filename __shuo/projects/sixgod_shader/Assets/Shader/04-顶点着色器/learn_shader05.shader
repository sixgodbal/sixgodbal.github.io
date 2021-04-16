Shader "Hidden/learn_shader05"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _A("A",Float) = 1 //幅度
    }
    SubShader
    {


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

            float _A;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.y += _A * sin( _Time.y + v.vertex.x ); //时间t  _Time .x=t/20  .y=t  .z=t*2  .w=t*3
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv); //根据uv获取纹理
                // just invert the colors
                // col.rgb = 1 - col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
