Shader "SixGod/l_002"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
		
		Lighting On//打开光照
		Material{
			Diffuse[_Color] //开启漫反射 (反射的颜色，即本身的颜色)
			Ambient[_Color] //开启环境光
		}

        Pass
        {
			//设置纹理
			SetTexture[_MainTex]{
				combine Texture * Previous
			}
        }
    }
}
