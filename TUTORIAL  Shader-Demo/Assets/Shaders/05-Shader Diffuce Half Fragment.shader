
Shader"Tutorial/Shader05-片元漫反射半兰伯特"
{
    Properties
	{
		_Diffuse("漫反射颜色",Color) =(1,1,1,1)
	}
	SubShader
	{
        Pass
		{
		    Tags{"LightMode"="ForwardBase"}
		    CGPROGRAM
			#include "Lighting.cginc"//取得直射光的颜色 _LightColor0
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Diffuse;


			struct a2v
			{
				float4 vertex:POSITION;   //告诉Unity把模型空间下的 顶点坐标填充给vertex
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float4 position:SV_POSITION;
				fixed3 worldNormalDir:COLOR0;
			};

			v2f vert(a2v v)
			{
				v2f f;

				f.position=mul(UNITY_MATRIX_MVP,v.vertex);//UNITY_MATRIX_MVP,v);//利用矩阵，来完成坐标的空间转换

				f.worldNormalDir = mul(v.normal,(float3x3)unity_WorldToObject);//模型空间，转到世界空间

				return f;
			}

			fixed4 frag(v2f f):SV_Target
			{
			    
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光

				fixed3 normalDir = normalize(f.worldNormalDir);//_World2object 利用矩阵，把方向从世界空间，转换到模型空间。只需要变换2者位置

				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//第一个直射光的方向，不同顶点取到的位置不同，因为是平行光

				float halfLambert =  dot(normalDir,lightDir)*0.5+0.5;//半兰伯特光照模型

				fixed3 diffuce=	_LightColor0.rgb *halfLambert*_Diffuse.rgb;//取得漫反射的颜色

				fixed3 tempColor = diffuce + ambient;//漫反射光照 + 环境光

			    return fixed4 (tempColor,1);//返回颜色，交给系统
			}

			ENDCG
		}	    
	}
    Fallback"Diffuse"
}