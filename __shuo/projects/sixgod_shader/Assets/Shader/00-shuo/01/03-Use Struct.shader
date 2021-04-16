Shader "Liusu/03 Use Struct"{
    SubShader{
        Pass{
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag

            struct a2v {
                float4 vertex : POSITION; //语义 模型空间下的顶点坐标
                float3 normal : NORMAL;   //语义 模型空间下的法线
                float4 texcoord : TEXCOORD0; //语义 贴图1的位置坐标
            };

            struct v2f {
                float4 position:SV_POSITION;
                float3 temp : COLOR0; //语义 颜色
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.temp = v.normal;
                return f;
            }
            fixed4 frag(v2f f):SV_TARGET
            {
                return fixed4(f.temp, 1);
                //return fixed4(0.2,0.8,0.6,1);
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}