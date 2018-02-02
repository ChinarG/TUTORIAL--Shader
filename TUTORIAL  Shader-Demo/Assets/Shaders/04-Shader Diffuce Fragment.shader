
Shader"Tutorial/Shader04-片元漫反射"
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
			/*
			  光照模型：就是一个公式，用来显示某个点上的光照效果

			  标准光照模型：
			  1-自发光：到相机的亮度都是一样的
			  2-高光反射：像镜子一样，反射光很亮
			  3-漫反射：像石头一样：反射光很不明显，向四周扩散
			           Diffuce = 直射光颜色 * max（0，cos夹角）

					   max（0，cos夹角），用来取得参数中，最大的参数

					   dot() 用来取得两个向量的点乘

					   cos0 = 光方向 （点乘） 法线方向

					   _WorldSpaceLightPos() 取得平行光位置

					   _LightColor0 平行光颜色
					   （光和法线的夹角，是从1到0的值。也就是如果光线和法线的夹角是0的话，颜色就会变黑。）
					   也就是从直光照射，到背光。颜色自然从1-0的一个过渡效果
			  4-环境光：
			*/

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
			    
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;//环境光

				fixed3 normalDir = normalize(f.worldNormalDir);//_World2object 利用矩阵，把方向从世界空间，转换到模型空间。只需要变换2者位置

				//normalize （） 用来吧一个向量，单位化 —— 就是原来方向保持不变，长度为1。所以可以用fiexed3 来保存
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//第一个直射光的方向，不同顶点取到的位置不同，因为是平行光

				fixed3 diffuce=	_LightColor0.rgb * max(dot(normalDir,lightDir),0)*_Diffuse.rgb;//取得漫反射的颜色

				fixed3 tempColor = diffuce;//漫反射光照 + 环境光

			    return fixed4 (tempColor,1);//返回颜色，交给系统
			}

			ENDCG
		}	    
	}
    Fallback"Diffuse"
}