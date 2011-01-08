/* Include file for the R2 texture class */



/* Initialization functions */

int R2InitTexture();
void R2StopTexture();



/* Class definition */

class R2Texture {
    public:
        // Constructor functions
	R2Texture(void);
	R2Texture(const R2Texture& texture);
        R2Texture(const R2Image *image);
	R2Texture(const char *filename);
        ~R2Texture(void);

        // Property functions/operators
        const R2Image *Image(void) const;
	const RNBoolean IsTransparent(void) const;
        const RNFlags Flags(void) const;
	const int ID(void) const;

	// Manipulation functions/operations
        void SetImage(const R2Image *image);

	// Draw functions/operations
        void Load(void) const;
        void Unload(void) const;
        void Draw(void) const;

    protected:
        // Upkeep functions/operators
        void Update(void);
        void UpdateFlags(const RNFlags flags);
	void InternalDraw(void) const;

    private:
        const R2Image *image;
	RNFlags flags;
        int id; // 0=null, <0=unloaded, >0=loaded
};



/* Flag mask definitions */

#define R2_TEXTURE_FLAGS                0x00000700
#define R2_TEXTURE_TRANSPARENCY_FLAG    0x00000100
#define R2_TEXTURE_LOADED_FLAG          0x00000400



/* Public variables */

extern R2Texture R2null_texture;
#define R2default_texture R2null_texture



/* Inline functions */

inline const R2Image *R2Texture::
Image(void) const
{
    // Return image
    return image;
}



inline const RNBoolean R2Texture::
IsTransparent(void) const
{
    // Return whether has transparency
    return flags[R2_TEXTURE_TRANSPARENCY_FLAG];
}



inline const RNFlags R2Texture::
Flags(void) const
{
    // Return flags
    return flags;
}



inline const int R2Texture::
ID(void) const
{
    // Return id
    return id;
}




