Shader "Liusu/01 myShader"{
    
    Properties{
        _Color("Color",Color) = (1,1,1,1)
        _Vector("Vector",Vector) = (1,2,3,4)
        _Int("Int",Int) = 1
        _Float("Float",Float) = 1.2
        _Range("Range",Range(5,20)) = 10
        _2D("Texture",2D) = "red" {}
        _Cube("Cube",Cube) = "white" {}
        _3D("Texture",3D) = "black" {}
    }
    //SubShader可以有多个，从第一个SubShader开始，若不支持则寻找下一个
    SubShader{
        //至少有一个Pass
        Pass{
            //在这里编写Shader HLSLPROGRAM
            CGPROGRAM
            //使用CG语言编写Shader代码
            fixed4 _Color; //float4 half4 fixed4
            float4 _Vector;
            float _Int;
            float _Float;
            float _Range;
            sampler2D _2D;
            samplerCUBE _Cube;
            sampler3D _3D;
            //float32位存储  half16位存储  fixed11位存储(-2~2)

            ENDCG
        }
    }
    //都无法实现时启用
    Fallback "VertexLit"
}