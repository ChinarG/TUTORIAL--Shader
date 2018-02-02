Shader "Tutorial/Shader13-透明"
{
    Properties
	{
		_MainTex("纹理",2D) = "white"{}
		_Color("颜色",Color) = (1,1,1,1)
		_NormalMap("法线贴图",2D) = "bump"{}//使用自带法线,使用的是切线空间
		_BumpScale("凹凸比例",Float) = 1
		_AlphaScale("透明度比例",Float) = 1
	}
	SubShader
	{
	    Tags{"Queue" = "Transparent" "IgnorProjector" = "True" "RenderType" = "Transparent"}
	    Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			ZWrite off//关闭深度写入
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;//定义图片
			float4 _MainTex_ST;//定义偏移控制 缩放S/偏移T
			fixed4 _Color;
			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			float _BumpScale;
			float _AlphaScale;

			struct a2v
			{
			    float4 vertex:POSITION;
				float3 normal:NORMAL;//切线空间的确定，是通过法线和切线来确定
				float4 tangent:TANGENT;//tangent.w 是用来确定切线空间中坐标轴的方向
				float4 texcoord:TEXCOORD0;

			};

			struct v2f
			{
			    float4 svPos:SV_POSITION;
				float4 uv:TEXCOORD1;//xy用来存储 MainTex的纹理坐标  zw 用来存储法线贴图NormalMap的纹理坐标
				float3 lightDir:TEXCOORD0;//切线空间下的 平行光的方向

			};

										
			v2f vert(a2v v)
			{
			    v2f f;
				f.svPos = mul(UNITY_MATRIX_MVP,v.vertex);//模型空间-世界空间的顶点位置
				f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;//传递顶点 - 片元/  乘以XY，就相当于倍数       加上 偏移 zw
				f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;

				TANGENT_SPACE_ROTATION;//调用这个宏之后，会得到一个矩阵 rotation ,用来完成，把模型空间下的方向转换成切线空间下

				f.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));//模型空间，乘以光的模型空间方向 = 切线空间方向//ObjSpaceLightDir(v.vertex)//这里是模型空间下的平行光方向
				return f;

			}//把所有跟法线方向有关的方向，都放在切线空间下
			 //从法线贴图里取得的法线方向，是在切线空间下


			fixed4 frag(v2f f):SV_Target
			{

				fixed4 normalColor = tex2D(_NormalMap,f.uv.zw);

				fixed3 tangentNormal = normalize(UnpackNormal(normalColor));//UnpackNormal(normalColor) 是Unity内置方法

				tangentNormal.xy=tangentNormal.xy*_BumpScale;

				fixed3 lightDir = normalize(f.lightDir);

				fixed4 texColor = tex2D(_MainTex,f.uv.xy)*_Color;

			    fixed3 diffuse = _LightColor0.rgb*texColor.rgb*max(0,dot(tangentNormal,lightDir));

				fixed3 tempColor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb*texColor;

				return fixed4 (tempColor,_AlphaScale*texColor.a);
			}

			ENDCG
		}
	}
	Fallback"Specular"
}