Shader"Tutorial/Shader06-高光反色-顶点"
{
    Properties
	{
		_Diffuse("漫反射颜色",Color) =(1,1,1,1)
		_Gloss("高光参数",Range(8,200)) = 10
		_Specular("高光颜色",Color) = (1,1,1,1)
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
			half _Gloss;
			float4 _Specular;

			struct a2v
			{
				float4 vertex:POSITION;   //告诉Unity把模型空间下的 顶点坐标填充给vertex
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float4 position:SV_POSITION;
				fixed3 color:COLOR;
			};

			v2f vert(a2v v)
			{
				v2f f;//定义返回值变量

				f.position = mul(UNITY_MATRIX_MVP,v.vertex);//UNITY_MATRIX_MVP,v);//利用矩阵，来完成坐标的空间转换

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光

				fixed3 normalDir = normalize(mul(v.normal,(float3x3)unity_WorldToObject));//_World2object 利用矩阵，把方向从世界空间，转换到模型空间。只需要变换2者位置

				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//第一个直射光的方向，不同顶点取到的位置不同，因为是平行光

				fixed3 diffuce=	_LightColor0.rgb * max(dot(normalDir,lightDir),0)*_Diffuse.rgb;//取得漫反射的颜色

				fixed3 reflectDir = normalize(reflect(-lightDir,normalDir));//反射光向量

				fixed3 viewDir = normalize( _WorldSpaceCameraPos.xyz - mul(v.vertex,unity_WorldToObject).xyz);//相机位置向量

				fixed3 specular = _LightColor0.rgb *_Specular.rgb* pow(max(dot(reflectDir,viewDir),0),_Gloss);//反射光

				f.color = diffuce + ambient + specular;//漫反射光照 + 环境光

				return f;
			}

			fixed4 frag(v2f f):SV_Target
			{
			    return fixed4(f.color,1);
			}

			ENDCG
		}	    
	}
    Fallback"VertexLit"
}