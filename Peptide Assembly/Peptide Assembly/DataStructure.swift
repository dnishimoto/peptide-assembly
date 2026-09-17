//
//  DataStructure.swift
//  Peptide Assembly
//
//  Created by David Nishimoto on 9/16/26.
//

import Foundation
// MARK: - Pipeline

struct PeptideStage: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let equation: String
    let whatHappened: String
    let whyItMatters: String
    let analogy: String
}

// MARK: - Coarse-grained molecular model

enum CellState: String {
    case empty
    case carbon
    case hydrogen
    case nitrogen
    case oxygen
    case sulfur
    case functionalGroup
    case aminoAcid
    case orientedAminoAcid
    case transition
    case peptideBond
    case peptideChain
    case folded
}

struct LatticeCell {
    var state: CellState
    var position: SIMD3<Double>
    var energy: Double
    var qrtlField: Double
    var coherence: Double
    var phase: Double
    var density: Double
    var orientation: SIMD3<Double>
    var bondingAvailability: Double

    // QRTL neighbor-flow state. These quantities are model-defined and
    // are updated by a synchronous, pairwise-conservative transport step.
    var twistSpeed: Double
    var twistCurrentIn: Double
    var twistCurrentOut: Double
    var flowBalanceError: Double
}

struct AminoAcidUnit {
    let name: String
    let code: String
    var position: SIMD3<Double>
    var orientation: SIMD3<Double>
    var chemicalEnergy: Double
    var bondedToNext: Bool
}

struct TransitionEvaluation {
    let deltaGChemical: Double
    let deltaEqrtl: Double
    let deltaGEffective: Double
    let probability: Double
    let orientationFactor: Double
    let distanceFactor: Double
    let accepted: Bool
}
struct QRTLCurrentResult {
    let current: Double
    let driveAmplitude: Double
    let distanceFactor: Double
    let orientationFactor: Double
    let coherenceFactor: Double
    let phaseFactor: Double
    let pressureBalanceFactor: Double
    let transportFactor: Double
}

