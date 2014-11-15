#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

HV* find_uniq_pixels(SV* pixels_ref){
    HV* found_colors = newHV();
    SV* binary_string = SvRV(pixels_ref);
    STRLEN len;
    U32 *pixels_ptr;
    U32 i;

    pixels_ptr = (U32*) SvPV(binary_string, len);
    for (i = 0; i < len/4; i++) {
        bool has_value = hv_exists(found_colors, (const char*)pixels_ptr, sizeof(U32));
        if (!has_value) {
            U32 u_value = *pixels_ptr;
            SV* value = newSVuv(u_value);
            /* fprintf(stderr, "found pattern color: %X\n", u_value); */
            hv_store(found_colors, (const char*)pixels_ptr, sizeof(U32), value, 0);
        }
        pixels_ptr++;
    }
    return found_colors;
}

AV* find_matching_pixels(SV* pixels_ref, AV* pattern) {
	dTHX;
    SV* binary_string = SvRV(pixels_ref);
    STRLEN len;
    U32 *pixels_ptr;
    pixels_ptr = (U32*) SvPV(binary_string, len);
    U32 i,j;

    SSize_t max_pattern_idx = av_top_index(pattern);
    if (max_pattern_idx <=0) {
        Perl_croak( aTHX_ "Wrong pattern size");
    }

    U32* u_pattern = malloc(sizeof(U32)*(max_pattern_idx+1));
    U32* found_marks = malloc(sizeof(U32)*(max_pattern_idx+1));
    for (i = 0; i <= max_pattern_idx ; i++) {
        SV** value = av_fetch(pattern, i, 0);
        if (!value) {
            Perl_croak( aTHX_ "Undefined values in pattern are not allowed");
        }
        u_pattern[i] = SvUV(*value);
        found_marks[i] = 0;
    }

    for (i = 0; i < len/4; i++) {
        U32 color = *pixels_ptr++;
        for (j = 0; j <= max_pattern_idx; j++ ) {
            if (u_pattern[j] == color) {
                found_marks[j] = 1;
            }
        }
    }
    AV* result = newAV();
    for (i = 0; i <= max_pattern_idx ; i++) {
        if (found_marks[i]) {
            SV* value = newSVuv(u_pattern[i]);
            av_push(result, value);
        }
    }
    free(u_pattern);
    free(found_marks);

    return result;
}

MODULE = Iston::XS::Utils            PACKAGE = Iston::XS::Utils

HV*
find_uniq_pixels(pixels_ref)
  SV* pixels_ref
  PROTOTYPE: $

AV*
find_matching_pixels(pixels_ref, pattern)
  SV* pixels_ref
  AV* pattern
  PROTOTYPE: $$

