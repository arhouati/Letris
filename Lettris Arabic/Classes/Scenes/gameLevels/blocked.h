// ---------------------------------------
// Sprite definitions for blocked
// Generated with TexturePacker 3.2.1
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

#ifndef __BLOCKED_ATLAS__
#define __BLOCKED_ATLAS__

// ------------------------
// name of the atlas bundle
// ------------------------
#define BLOCKED_ATLAS_NAME @"blocked"

// ------------
// sprite names
// ------------
#define BLOCKED_SPR_BLOCKED    @"blocked"
#define BLOCKED_SPR_BLOCKED_01 @"blocked_01"
#define BLOCKED_SPR_BLOCKED_02 @"blocked_02"

// --------
// textures
// --------
#define BLOCKED_TEX_BLOCKED    [SKTexture textureWithImageNamed:@"blocked"]
#define BLOCKED_TEX_BLOCKED_01 [SKTexture textureWithImageNamed:@"blocked_01"]
#define BLOCKED_TEX_BLOCKED_02 [SKTexture textureWithImageNamed:@"blocked_02"]

// ----------
// animations
// ----------
#define BLOCKED_ANIM_BLOCKED @[ \
        [SKTexture textureWithImageNamed:@"blocked_01"], \
        [SKTexture textureWithImageNamed:@"blocked_02"]  \
    ]


#endif // __BLOCKED_ATLAS__
