Shader"Tutorial/Shader01"
{//Shader名字可以自定义，不要求和文件名保持一致。“/”代表目录，后边跟子选项

     Properties
	 {   
	     //可调节属性
	     _Color("颜色",Color)=(1,1,1,1)//属性名（Inspector面板中显示的名字，类型）=（RGB值）
	     _Vector("四维向量",Vector)=(1,2,3,4)
	     _Int("整数",Int)=666
	     _Float("浮点数",Float)=6.6
	     _Range("范围",Range(1,10))=6
	     _2D("图片",2D)="red"{}//指定一个2D图片=后边的命名格式为“指定默认颜色”+{图片}。在没有图片的情况下，显示默认颜色
	     _Cube("立方体纹理",Cube)="white"{}//一般来控制天空盒
	     _3D("3D纹理",3D)="black"{}
	 }

	 SubShader{//子Shader,可以有很多个：为了运行兼容性更好
	           //当显卡去处理效果的时候，会从第一个SubShader开始，然后开始逐一的判断。
			   //如果第一个可以实现效果，那么就用第一个Subshader
			   //如果第一个不可以实现效果，会自动执行第二个

			   Pass{//相当于方法，至少有一个。在这里编写方法
			       CGPROGRAM
				   //使用CG语言编写代码，如果需要用其他图形编程接口，例如：OpenGL的GLSL 和DirectX的HLSL
				   //属性的定义，只定义需要用到的属性
				   float4 _Color;//float4 就是四个值，对应颜色的值（1,1,1,1）/ 也可以使用 half fixed
				   float4 _Vector;//也是对应4个值
				   float _Int;
				   float _Float;
				   float Range;
				   sampler2D _2D;
				   samplerCube _Cube;
				   sampler3D _3D;
				   //float 二进制，32位来存储 —— 具体用哪个来存储数据，可自己定义。不同之处，在于消耗GPU的性能不一样。如果用到的值小范围是0-1.那么用float就消耗一些不必要的内存
				   //half 二进制，16位来存储 只能是-6万~6万之间
				   //fixed 二进制，11位来存储 -2~2之间
				   ENDCG
			   }
	 }
	 Fallback "VertexLit"//后备方案，指定一个后备Shader
}