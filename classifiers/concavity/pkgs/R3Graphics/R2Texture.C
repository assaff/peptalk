/* Source file for the R2 texture class */



/* Include files */

#include "R3Graphics.h"



/* Public variables */

R2Texture R2null_texture;



/* Public functions */

int 
R2InitTexture()
{
    /* Return success */
    return TRUE;
}



void 
R2StopTexture()
{
}



R2Texture::
R2Texture(void)
    : image(NULL),
      flags(0),
      id(0)
{
}



R2Texture::
R2Texture(const R2Texture& texture)
  : image(texture.image),
    flags(texture.flags),
    id(-1)
{
    // Update texture
    Update();
}



R2Texture::
R2Texture(const R2Image *image)
  : image(image),
    flags(RN_NO_FLAGS),
    id(-1)
{
    // Update texture
    Update();
}



R2Texture::
R2Texture(const char *filename)
    : image(NULL),
      flags(RN_NO_FLAGS),
      id(-1)
{
    // Create image
    image = new R2Image(filename);
    assert(image);

    // Update texture
    Update();
}



R2Texture::
~R2Texture(void)
{
    // Unload texture
    if (flags[R2_TEXTURE_LOADED_FLAG]) Unload();
}



void R2Texture::
SetImage(const R2Image *image)
{
    // Set image
    flags.Remove(R2_TEXTURE_TRANSPARENCY_FLAG);
    if ((image) && ((image->NComponents() == 2) || (image->NComponents() == 4)))
	flags.Add(R2_TEXTURE_TRANSPARENCY_FLAG);
    this->image = image;
}



void R2Texture::
Update (void)
{
    // Update flags
    UpdateFlags(RN_NO_FLAGS);
}



void R2Texture::
UpdateFlags (const RNFlags flags)
{
    // Update flags
    this->flags = flags;
    if ((image) && ((image->NComponents() == 2) || (image->NComponents() == 4)))
	this->flags.Add(R2_TEXTURE_TRANSPARENCY_FLAG);
}



void R2Texture::
Load(void) const
{
}



void R2Texture::
Unload(void) const
{
}



void R2Texture::
Draw(void) const
{
}








