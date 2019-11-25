//===- TriCoreBaseInfo.h - Top level definitions for TriCore MC -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains small standalone enum definitions for the TriCore target
// useful for the compiler back-end and the MC libraries.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_LIB_TARGET_TRICORE_MCTARGETDESC_TRICOREBASEINFO_H
#define LLVM_LIB_TARGET_TRICORE_MCTARGETDESC_TRICOREBASEINFO_H

namespace llvm {

// TriCoreII - This namespace holds all of the target specific flags that
// instruction info tracks. All definitions must match TriCoreInstrFormats.td.
namespace TriCoreII {
enum {
  Pseudo = 0,
  SBFrm = 1,
  SBCFrm = 2,
  SBRFrm = 3,
  SBRNFrm = 4,
  SCFrm = 5,
  SLRFrm = 6,
  SLROFrm = 7,
  SRFrm = 8,
  SRCFrm = 9,
  SROFrm = 10,
  SRRFrm = 11,
  SRRSFrm = 12,
  SSRFrm = 13,
  SSROFrm = 14,
  ABSFrm = 15,
  ABSBFrm = 16,
  BFrm = 17,
  BITFrm = 18,
  BOFrm = 19,
  BOLFrm = 20,
  BRCFrm = 21,
  BRNFrm = 22,
  BRRFrm = 23,
  RCFrm = 24,
  RCPWFrm = 25,
  RCRFrm = 26,
  RCRRFrm = 27,
  RCRWFrm = 28,
  RLCFrm = 29,
  RRFrm = 30,
  RR1Frm = 31,
  RR2Frm = 32,
  RRPWFrm = 33,
  RRRFrm = 34,
  RRR1Frm = 35,
  RRR2Frm = 36,
  RRRRFrm = 37,
  RRRWFrm = 38,
  SYSFrm = 39,

  // the mask to apply to TSFlags
  InstrFormatMask = 0x3f
};

} // namespace TriCoreII

} // namespace llvm
#endif
