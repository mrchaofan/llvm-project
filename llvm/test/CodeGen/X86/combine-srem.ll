; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

; fold (srem undef, x) -> 0
define <4 x i32> @combine_vec_srem_undef0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_undef0:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_undef0:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = srem <4 x i32> undef, %x
  ret <4 x i32> %1
}

; fold (srem x, undef) -> undef
define <4 x i32> @combine_vec_srem_undef1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_undef1:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_undef1:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, undef
  ret <4 x i32> %1
}

; TODO fold (srem x, x) -> 0
define i32 @combine_srem_dupe(i32 %x) {
; SSE-LABEL: combine_srem_dupe:
; SSE:       # %bb.0:
; SSE-NEXT:    movl %edi, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %edi
; SSE-NEXT:    movl %edx, %eax
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_srem_dupe:
; AVX:       # %bb.0:
; AVX-NEXT:    movl %edi, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %edi
; AVX-NEXT:    movl %edx, %eax
; AVX-NEXT:    retq
  %1 = srem i32 %x, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_srem_dupe(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_dupe:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrd $1, %xmm0, %ecx
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    movl %edx, %ecx
; SSE-NEXT:    movd %xmm0, %esi
; SSE-NEXT:    movl %esi, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %esi
; SSE-NEXT:    movd %edx, %xmm1
; SSE-NEXT:    pinsrd $1, %ecx, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %ecx
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    pinsrd $2, %edx, %xmm1
; SSE-NEXT:    pextrd $3, %xmm0, %ecx
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    cltd
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    pinsrd $3, %edx, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_dupe:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    movl %edx, %ecx
; AVX-NEXT:    vmovd %xmm0, %esi
; AVX-NEXT:    movl %esi, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %esi
; AVX-NEXT:    vmovd %edx, %xmm1
; AVX-NEXT:    vpinsrd $1, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %ecx
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    vpinsrd $2, %edx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    cltd
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    vpinsrd $3, %edx, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, %x
  ret <4 x i32> %1
}

; fold (srem x, y) -> (urem x, y) iff x and y are positive
define <4 x i32> @combine_vec_srem_by_pos0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pos0:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_srem_by_pos0:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_srem_by_pos0:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastss {{.*#+}} xmm1 = [3,3,3,3]
; AVX2-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = srem <4 x i32> %1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_srem_by_pos1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pos1:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_pos1:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = srem <4 x i32> %1, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %2
}
