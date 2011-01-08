/* Source file for the R3 material class */



/* Include files */

#include "R3Graphics.h"



/* Public variables */

R3Material R3null_material;
R3Material R3black_material;
R3Material R3red_material;
R3Material R3green_material;
R3Material R3blue_material;
R3Material R3yellow_material;
R3Material R3cyan_material;
R3Material R3magenta_material;
R3Material R3white_material;
R3Material R3gray_material;
R3Material R3shiny_black_material;
R3Material R3shiny_red_material;
R3Material R3shiny_green_material;
R3Material R3shiny_blue_material;
R3Material R3shiny_yellow_material;
R3Material R3shiny_cyan_material;
R3Material R3shiny_magenta_material;
R3Material R3shiny_white_material;
R3Material R3shiny_gray_material;
R3Material R3default_material;



/* Public functions */

int 
R3InitMaterial()
{
    /* Initialize public variables */
    R3null_material = R3Material(&R3null_brdf);
    R3black_material = R3Material(&R3black_brdf);
    R3red_material = R3Material(&R3red_brdf);
    R3green_material = R3Material(&R3green_brdf);
    R3blue_material = R3Material(&R3blue_brdf);
    R3yellow_material = R3Material(&R3yellow_brdf);
    R3cyan_material = R3Material(&R3cyan_brdf);
    R3magenta_material = R3Material(&R3magenta_brdf);
    R3white_material = R3Material(&R3white_brdf);
    R3gray_material = R3Material(&R3gray_brdf);
    R3shiny_black_material = R3Material(&R3shiny_black_brdf);
    R3shiny_red_material = R3Material(&R3shiny_red_brdf);
    R3shiny_green_material = R3Material(&R3shiny_green_brdf);
    R3shiny_blue_material = R3Material(&R3shiny_blue_brdf);
    R3shiny_yellow_material = R3Material(&R3shiny_yellow_brdf);
    R3shiny_cyan_material = R3Material(&R3shiny_cyan_brdf);
    R3shiny_magenta_material = R3Material(&R3shiny_magenta_brdf);
    R3shiny_white_material = R3Material(&R3shiny_white_brdf);
    R3shiny_gray_material = R3Material(&R3shiny_gray_brdf);
    R3default_material = R3Material(&R3default_brdf);
    
    /* Return success */
    return TRUE;
}



void 
R3StopMaterial()
{
}



R3Material::
R3Material(void)
{
}



R3Material::
R3Material(const R3Material& material)
    : brdf(material.brdf),
      texture(material.texture),
      flags(material.flags)
{
}



R3Material::
R3Material(const R3Brdf *brdf)
    : brdf(brdf),
      texture(&R2null_texture)
{
    // Update material
    Update();
}



R3Material::
R3Material(const R2Texture *texture)
    : brdf(&R3white_brdf),
      texture(texture)
{
    // Update material
    Update();
}



R3Material::
R3Material(const R3Brdf *brdf, 
	   const R2Texture *texture)
    : brdf(brdf),
      texture(texture)
{
    // Update material
    Update();
}



void R3Material::
Update(void)
{
    // Update flags
    this->flags = RN_NO_FLAGS;
    if ((brdf) && (brdf->ID() != 0)) 
	this->flags.Add(R3_MATERIAL_BRDF_FLAG | brdf->Flags());
    if ((texture) && (texture->ID() != 0)) 
	this->flags.Add(R3_MATERIAL_TEXTURE_FLAG | texture->Flags());
}




void R3Material::
Draw(void) const
{
    // Check if same material
    static const R3Material *R3current_material = NULL;
    if (this == R3current_material) return;

    // Draw material
    if (brdf) brdf->Draw();

    // Draw texture
    if (texture) texture->Draw();

    // Remember material
    R3current_material = this;
}























