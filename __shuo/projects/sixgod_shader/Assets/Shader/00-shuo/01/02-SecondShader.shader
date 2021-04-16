// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Liusu/02 SecondShader"{
    SubShader{
        Pass{
            CGPROGRAM
//顶点函数 声明函数名 顶点坐标转换到裁剪空间（转换为相机相对坐标）
#pragma vertex vert
//片元函数 声明函数名 返回模型对应屏幕上每一个像素颜色值
#pragma fragment frag
            //通过语义，告诉系统参数的作用
            //POSITION:需要顶点坐标
            //SV_POSITION:解释说明返回值，返回值是裁剪空间下的顶点坐标
            float4 vert(float4 v:POSITION):SV_POSITION 
            {
                return UnityObjectToClipPos(v);
            }
            fixed4 frag():SV_TARGET
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}