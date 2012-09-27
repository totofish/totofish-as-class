/*
<languageVersion: 1.0;>
 
kernel pixelate
<   namespace : "AIF";
    vendor : "Adobe Systems";
    version : 2;
    description : "pixelate an image"; >
{

    parameter int dimension
    <minValue: 1;
     maxValue: 100;
     defaultValue: 1;>;

    input image4 inputImage;
    output pixel4 outputPixel;

    void
    evaluatePixel()
    {
        float dimAsFloat = float(dimension);
        float2 sc = floor(outCoord() / float2(dimAsFloat, dimAsFloat));
        sc *= dimAsFloat;
        outputPixel = sampleNearest(inputImage, sc);
    }
}
// 點陣化的Shader效果
*/

package totofish.filters{
	import flash.filters.ShaderFilter;
	import flash.display.Shader;
	import flash.utils.ByteArray;
	import org.phprpc.util.Base64;
	
	public class Pixelate extends ShaderFilter
	{
		// static initializer
		{
			PBJ64 = Base64.decode('eNpNjUFKAzEYhV8ys8hioF1XinOEegNLodBVBcGtxOZXApNkmCSl7uYoo7Z7j6A3UryASUuhm//xvfd4/4EB2Au0ekeNDDRUVhryrdwQ5qslhmpLVrkOc+WeqL5/9YGMxyC21HntLHiqKPKbTrch83molrbWRr4Q3hgHqsd1DAvnOpVYsF4obcgeF96F0fZBNpHAMsjdCVQCRc8yNuGcfqDUto1hdRrmJcPIxZCcu/wW10DNemAKjIEeU54OvrLeZi05bniKiqS5MuH45vjM+YX/g1mB36PP8FfgCv+42U0u');
			PBJ64.uncompress();
			PBJ64.position = 0;
			
			SHADER = new Shader( PBJ64 );
		}
		
		private static var PBJ64:ByteArray;
		public static var SHADER:Shader;
		public function Pixelate(value:Number=NaN)
		{
			super( SHADER );
			if (value >= 0 && !isNaN(value)) dimension = int(value);
		}
	
		/*
		 * Get dimension
		 * @return int [ int ]
		 */
		public function get dimension():int
		{
			return SHADER.data.dimension.value[0];
		}
		
		/*
		 * Set dimension
		 * <p>
		 * <p>- DefaultValue: [ 1 ]		 
		 * <p>- MaxValue: [ 100 ]
		 * <p>- MinValue: [ 1 ]
		 * @param int0 int [ int ]
		 */					
		public function set dimension( int0:int ):void
		{
			SHADER.data.dimension.value = [ int0 ];
		}
	
	}
}