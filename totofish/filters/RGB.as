/*
<languageVersion: 1.0;>

kernel RGB
<
    namespace: "totofish.filters";
    vendor: "";
    version: 1;
    description: "RGB channel";
>
{
    parameter int3 RGBChannel
    <
    minValue:     int3(0, 0, 0);
    maxValue:     int3(1, 1, 1);
    defaultValue: int3(1, 1, 1);
    >;
    
    input image4 src;
    output pixel4 dst;
    
    void evaluatePixel()
    {
        float4 rgba;
        float r, g, b, a;
        
        // sample pixel value
        rgba = sampleNearest(src, outCoord());
        
        // 色版質
        if(RGBChannel[0] == 1)
            r = rgba.r;
        else
            r = 1.0;
            
        if(RGBChannel[1] == 1)
            g = rgba.g;
        else
            g = 1.0;
        
        if(RGBChannel[2] == 1)
            b = rgba.b;
        else
            b = 1.0;
            
        // set output pixel
        dst = float4(r, g, b, rgba.a);
    }
}
// RGB色版分離的Shader效果
*/
package totofish.filters
{
	import flash.filters.ShaderFilter;
	import flash.display.Shader;
	import flash.utils.ByteArray;
	import org.phprpc.util.Base64;
	
	public class RGB extends ShaderFilter
	{
		// static initializer
		{
			PBJ64 = Base64.decode('eNp1j7FOwzAQhn87GVAUlewoUkZGVFFWIjowIjGwIit21UipXdlOxehHSQu8R18J9QW4kFIyUHu4+z/dp9N9MgAfEZ4fH7pUi5Vya1EpeOPNonZLdOlGaWks0F1slHW10WBEpXKVrde+z+QW1VJorRpsGQfS16fWz42xknLCwoQm5seBXbKq9YtoWoXhERBvA2A/f5dItRBt48fwHbGzFbY8ZriUzuOG4wvIkEc4cFxhykLW33LNQmBhj5yHgADcEuNUc6CIqJ8d104p3xO/+81/fnnGzyKUYz874xf/+hwhInDyKY/9PO6nQ19LYN/Xgg+c9lJmOMR05zdCDVH6');
			PBJ64.uncompress();
			PBJ64.position = 0;
			
			SHADER = new Shader( PBJ64 );
		}
		
		private static var PBJ64:ByteArray;
		public static var SHADER:Shader;
		public function RGB( inArray:Array=null )
		{
			super( SHADER );
			RGBChannel = inArray || [1, 1, 1];
		}
	
		/*
		 * Get RGBChannel
		 * @return Array [ int3 ]
		 */
		public function get RGBChannel( ):Array
		{
			return SHADER.data.RGBChannel.value;
		}
		
		/*
		 * Set RGBChannel
		 * <p>
		 * <p>- DefaultValue: [ 1,1,1 ]		 
		 * <p>- MaxValue: [ 1,1,1 ]
		 * <p>- MinValue: [ 0,0,0 ]
		 * @param inArray Array [ int3 ]
		 */					
		public function set RGBChannel( inArray:Array ):void
		{
			SHADER.data.RGBChannel.value = inArray;
		}
	
	}
}