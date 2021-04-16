Shader "Hidden/003"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert //顶点着色器 方法名
            #pragma fragment frag //片段着色器 方法名

            #include "UnityCG.cginc" //引用库文件

            struct appdata //结构体  信息来自于模型文件
            {
                float4 vertex : POSITION; //顶点
                float2 uv : TEXCOORD0; //第一个uv坐标 TEXCOORD1 TEXCOORD2 TEXCOORD3
				//NORMAL 顶点法线  TANGENT 切线矢量  Color 每顶点颜色(float4)
            };

            struct v2f //结构体
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //顶点位置坐标转换成相机坐标   局部-世界-相对于相机的局部坐标
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                // col.rgb = 1 - col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
