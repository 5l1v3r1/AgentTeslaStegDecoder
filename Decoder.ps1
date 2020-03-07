# Author: Zane Gittins

$Assemblies = @(
"c:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\System.Drawing.dll"
)

$Source = @"
using System;
using System.Drawing;
using System.Collections;

public class Decode {

    public static byte[] FromBitmap(Bitmap cor23)
    {
	    ArrayList arrayList = new ArrayList();
	    checked
	    {
		    int num = cor23.Size.Width - 1;
		    for (int i = 0; i <= num; i++)
		    {
			    int num2 = cor23.Size.Height - 1;
			    for (int j = 0; j <= num2; j++)
			    {
				    Color pixel = cor23.GetPixel(i, j);
				    Color color = Color.FromArgb(0, 0, 0, 0);
				    bool flag = !pixel.Equals(color);
				    if (flag)
				    {
					    arrayList.InsertRange(arrayList.Count, new byte[]
					    {
						    pixel.R,
						    pixel.G,
						    pixel.B
					    });
				    }
			    }
		    }
		    return (byte[])arrayList.ToArray(typeof(byte));
	    }
    }

    public static byte[] XOR(byte[] cor30)
    {
		    byte[] array = new byte[cor30.Length - 16 - 1 + 1];
		    Array.Copy(cor30, 16, array, 0, array.Length);
		    int num = array.Length - 1;
		    for (int i = 0; i <= num; i++)
		    {
			    byte[] array2 = array;
			    int num2 = i;
			    array2[num2] ^= cor30[i % 16];
		    }
		    return array;
    }

}
"@

Add-Type -ReferencedAssemblies $Assemblies -TypeDefinition $Source -Language CSharp
Add-Type -AssemblyName System.Drawing

[System.Drawing.Bitmap]$Bitmap = [System.Drawing.Image]::FromFile("embedded_image.png")
$ByteArray = [Decode]::FromBitmap($Bitmap)
$Decoded = [Decode]::XOR($ByteArray)

$Decoded | Set-Content "out.exe" -Encoding Byte