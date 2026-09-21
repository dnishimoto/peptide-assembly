//
//  DataStructure.swift
//  Peptide Assembly
//
//  Created by David Nishimoto on 9/16/26.
//

import Foundation

private func determineBondFormation(
    distance: Double,
    orientation: Double,
    chemicalDeltaG: Double,
    qrtlDeltaE: Double,
    coherence: Double,
    phaseDifference: Double,
    minimumDistanceFactor: Double = 0.65,
    minimumOrientation: Double = 0.70,
    minimumProbability: Double = 0.50,
    kBT: Double = 1.0
) -> BondEvaluation {

    // Distance compatibility
    let distanceFactor =
        max(
            0.0,
            min(
                1.0,
                1.0 - abs(distance - 1.2) / 1.2
            )
        )

    guard distanceFactor >= minimumDistanceFactor else {
        return BondEvaluation(
            formed: false,
            failureReason: "Distance gate failed"
        )
    }

    // Orientation compatibility
    guard orientation >= minimumOrientation else {
        return BondEvaluation(
            formed: false,
            failureReason: "Orientation gate failed"
        )
    }

    // Coherence
    let boundedCoherence =
        max(0.0, min(1.0, coherence))

    // Phase factor
    let phaseFactor =
        max(
            0.0,
            min(
                1.0,
                (1.0 + cos(phaseDifference)) / 2.0
            )
        )

    // Effective free energy
    let effectiveDeltaG =
        chemicalDeltaG + qrtlDeltaE

    // Transition probability
    let probability =
        1.0 /
        (
            1.0 +
            exp(effectiveDeltaG / max(kBT, 0.0000001))
        )

    // Probability gate
    guard probability >= minimumProbability else {
        return BondEvaluation(
            formed: false,
            failureReason:
                "Transition probability too low: \(probability)"
        )
    }

    // Bond forms
    return BondEvaluation(
        formed: true,
        failureReason: nil
    )
}
struct ChemicalEnergyCalibration {

    // Reference chemical energy for a peptide-bond-scale event.
    //
    // This is a CALIBRATION CONSTANT for the QRTL model.
    // The CA calculation itself remains dimensionless.
    //
    // Units:
    //     kJ/mol
    //
    // Do not interpret this as a first-principles derivation
    // of peptide-bond thermochemistry.
    static let referenceBondEnergyKJPerMol: Double = 350.0

    // NIST conversion:
    // 1 eV = 96.4853 kJ/mol
    static let kJPerMolPerEV: Double = 96.4853

    static let joulesPerMolePerEV: Double =
        kJPerMolPerEV * 1000.0

    static func eV(fromKJPerMol energy: Double) -> Double {
        energy / kJPerMolPerEV
    }

    static func joulesPerMolecule(fromKJPerMol energy: Double) -> Double {
        let avogadro = 6.02214076e23
        return (energy * 1000.0) / avogadro
    }

    static func kJPerMol(fromNormalizedBondEnergy value: Double)
        -> Double
    {
        max(0.0, value) * referenceBondEnergyKJPerMol
    }
}

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

