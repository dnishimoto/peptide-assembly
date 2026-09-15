
//
//  ContentView.swift
//  QRTL Peptide Assembly
//
//  QRTL-driven peptide assembly visualization.
//
//  IMPORTANT:
//  This is a proposed computational QRTL model.
//  QRTL terms in this simulation are model assumptions,
//  not experimentally established molecular physics.
//

import SwiftUI
import SceneKit
import UIKit
import Combine

// MARK: - Pipeline

enum PeptideStage: Int, CaseIterable, Identifiable {
    case independentParticles
    case energyShells
    case qrtlCoupling
    case molecularConfiguration
    case aminoAcidAssembly
    case peptideBond
    case peptideChain
    case conformation
    case validation

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .independentParticles: return "Independent Particles"
        case .energyShells: return "Energy Shells"
        case .qrtlCoupling: return "QRTL Coupling"
        case .molecularConfiguration: return "Molecular Configuration"
        case .aminoAcidAssembly: return "Amino Acid Assembly"
        case .peptideBond: return "Peptide Bond Formation"
        case .peptideChain: return "Peptide Chain"
        case .conformation: return "Conformation"
        case .validation: return "Validation"
        }
    }

    var explanation: String {
        switch self {
        case .independentParticles:
            return "Atoms begin as independent particles."

        case .energyShells:
            return "Each atom is assigned a proposed QRTL energy-shell state."

        case .qrtlCoupling:
            return "Nearby atoms are evaluated for distance, frequency, phase, and spatial compatibility."

        case .molecularConfiguration:
            return "Calculated QRTL forces act on the atoms and drive their positions toward a lower-energy configuration."

        case .aminoAcidAssembly:
            return "Atom groups organize into amino-acid structures."

        case .peptideBond:
            return "QRTL forces act between reactive carbon and nitrogen regions to test a candidate peptide bond."

        case .peptideChain:
            return "Accepted peptide-bond interactions connect the residues sequentially."

        case .conformation:
            return "Candidate three-dimensional conformations are compared using the same energy model."

        case .validation:
            return "The final model is checked for internal consistency."
        }
    }

    var shortName: String {
        switch self {
        case .independentParticles: return "IDP"
        case .energyShells: return "Shells"
        case .qrtlCoupling: return "Coupling"
        case .molecularConfiguration: return "Configuration"
        case .aminoAcidAssembly: return "Amino Acid"
        case .peptideBond: return "Peptide Bond"
        case .peptideChain: return "Chain"
        case .conformation: return "Conformation"
        case .validation: return "Validation"
        }
    }
}

// MARK: - Elements

enum ElementType: String, CaseIterable, Identifiable {
    case hydrogen = "H"
    case carbon = "C"
    case nitrogen = "N"
    case oxygen = "O"
    case sulfur = "S"

    var id: String { rawValue }

    var atomicNumber: Int {
        switch self {
        case .hydrogen: return 1
        case .carbon: return 6
        case .nitrogen: return 7
        case .oxygen: return 8
        case .sulfur: return 16
        }
    }

    var radius: CGFloat {
        switch self {
        case .hydrogen: return 0.18
        case .carbon: return 0.32
        case .nitrogen: return 0.30
        case .oxygen: return 0.29
        case .sulfur: return 0.38
        }
    }

    var characteristicFrequency: Double {
        switch self {
        case .hydrogen: return 1.00
        case .carbon: return 0.72
        case .nitrogen: return 0.80
        case .oxygen: return 0.86
        case .sulfur: return 0.58
        }
    }

    var displayColor: UIColor {
        switch self {
        case .hydrogen:
            return .white
        case .carbon:
            return .gray
        case .nitrogen:
            return .systemBlue
        case .oxygen:
            return .systemRed
        case .sulfur:
            return .systemYellow
        }
    }
}

// MARK: - Atomic Configuration

struct AtomicConfiguration: Identifiable {
    let id: Int
    let element: ElementType

    var position: SIMD3<Float>
    var shellEnergy: Double
    var characteristicFrequency: Double
    var phase: Double
}

// MARK: - QRTL Coupling

struct QRTLCouplingResult {
    let distanceFactor: Double
    let frequencyCompatibility: Double
    let phaseCompatibility: Double
    let orientationCompatibility: Double
    let bQ: Double
    let qrtlEnergy: Double
    let effectiveEnergy: Double
}

// MARK: - QRTL Force

struct QRTLForceResult {
    let pair: (Int, Int)

    let coupling: Double
    let qrtlEnergy: Double

    let forceVector: SIMD3<Float>
    let magnitude: Double

    let phaseError: Double

    let distanceFactor: Double
    let frequencyCompatibility: Double
    let phaseCompatibility: Double
    let orientationCompatibility: Double
}

// MARK: - Amino Acids

struct AminoAcidDefinition: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let sideChain: String
}

struct AminoAcidState: Identifiable {
    let id = UUID()

    let definition: AminoAcidDefinition

    var center: SIMD3<Float>
    var internalEnergy: Double
    var qrtlEnergy: Double
    var assembled: Bool
}

// MARK: - Peptide Bond

struct PeptideBondResult: Identifiable {
    let id = UUID()

    let firstResidue: Int
    let secondResidue: Int

    let distance: Double
    let coupling: Double
    let energyChange: Double

    let accepted: Bool
}

// MARK: - Parameters

struct PeptideParameters {

    var qrtlCurrent: Double = 0.82
    var resonance: Double = 0.88
    var coherence: Double = 0.91

    var phaseAlignment: Double = 0.84
    var density: Double = 1.0

    var interactionStrength: Double = 1.0

    var bondThreshold: Double = 0.55

    var temperature: Double = 298.15
    var solventFactor: Double = 1.0
    var pressure: Double = 1.0
    var pH: Double = 7.0
}

// MARK: - Simulation Engine

@MainActor
final class PeptideSimulationEngine: ObservableObject {

    // MARK: Published state

    @Published private(set) var stage: PeptideStage = .independentParticles

    @Published private(set) var atoms: [AtomicConfiguration] = []

    @Published private(set) var aminoAcids: [AminoAcidState] = []

    @Published private(set) var peptideBonds: [PeptideBondResult] = []

    @Published private(set) var bQ: Double = 0
    @Published private(set) var qrtlEnergy: Double = 0
    @Published private(set) var effectiveEnergy: Double = 0

    @Published private(set) var coupling: Double = 0
    @Published private(set) var phaseError: Double = 0
    @Published private(set) var stability: Double = 0

    @Published private(set) var progress: Double = 0

    @Published private(set) var qrtlForces: [QRTLForceResult] = []

    @Published private(set) var activeForceMagnitude: Double = 0

    @Published private(set) var activeForceDescription: String =
        "No active QRTL interactions"

    @Published private(set) var validationMessage: String = ""

    @Published var parameters = PeptideParameters()

    // MARK: Sequence

    let sequence: [AminoAcidDefinition] = [
        AminoAcidDefinition(
            name: "Glycine",
            code: "G",
            sideChain: "H"
        ),

        AminoAcidDefinition(
            name: "Alanine",
            code: "A",
            sideChain: "CH₃"
        ),

        AminoAcidDefinition(
            name: "Serine",
            code: "S",
            sideChain: "CH₂OH"
        ),

        AminoAcidDefinition(
            name: "Glycine",
            code: "G",
            sideChain: "H"
        )
    ]

    // MARK: Initialization

    init() {
        reset()
    }

    // MARK: Reset

    func reset() {

        stage = .independentParticles

        bQ = 0
        qrtlEnergy = 0
        effectiveEnergy = 0

        coupling = 0
        phaseError = 0
        stability = 0

        progress = 0

        qrtlForces = []

        activeForceMagnitude = 0
        activeForceDescription = "No active QRTL interactions"

        peptideBonds = []
        aminoAcids = []

        validationMessage = ""

        atoms = makeInitialAtoms()
    }

    // MARK: Initial atoms

    private func makeInitialAtoms()
        -> [AtomicConfiguration] {

        let elements: [ElementType] = [
            .nitrogen,
            .hydrogen,
            .carbon,
            .hydrogen,
            .carbon,
            .oxygen,
            .hydrogen,
            .carbon,
            .oxygen,
            .hydrogen,
            .carbon,
            .nitrogen,
            .hydrogen,
            .oxygen,
            .hydrogen,
            .carbon,
            .hydrogen
        ]

        return elements.enumerated().map { index, element in

            let angle =
                Double(index) * 0.71

            let radius: Float =
                2.2 +
                Float(index % 3) * 0.65

            let x =
                cos(angle) * Double(radius)

            let y =
                sin(angle) * Double(radius) * 0.55

            let z =
                cos(angle * 0.63) * 1.5

            return AtomicConfiguration(
                id: index,
                element: element,
                position: SIMD3<Float>(
                    Float(x),
                    Float(y),
                    Float(z)
                ),
                shellEnergy: 0,
                characteristicFrequency:
                    element.characteristicFrequency,
                phase:
                    Double(index) * 0.37
            )
        }
    }

    // MARK: Advance

    func advance() {

        switch stage {

        case .independentParticles:

            calculateShellState()

            stage = .energyShells

        case .energyShells:

            calculateCoupling()

            stage = .qrtlCoupling

        case .qrtlCoupling:

            calculateMolecularConfiguration()

            stage = .molecularConfiguration

        case .molecularConfiguration:

            buildAminoAcids()

            stage = .aminoAcidAssembly

        case .aminoAcidAssembly:

            formPeptideBonds()

            stage = .peptideBond

        case .peptideBond:

            stage = .peptideChain

        case .peptideChain:

            evaluateConformation()

            stage = .conformation

        case .conformation:

            validateModel()

            stage = .validation

        case .validation:

            reset()

            return
        }

        progress =
            Double(stage.rawValue) /
            Double(
                PeptideStage.allCases.count - 1
            )
    }

    // MARK: Previous

    func previous() {

        guard stage.rawValue > 0 else {
            return
        }

        let previousRaw =
            stage.rawValue - 1

        guard
            let previousStage =
                PeptideStage(
                    rawValue: previousRaw
                )
        else {
            return
        }

        stage = previousStage

        progress =
            Double(stage.rawValue) /
            Double(
                PeptideStage.allCases.count - 1
            )
    }

    // MARK: Shell State

    private func calculateShellState() {

        atoms = atoms.map { atom in

            let shellEnergy =
                Double(atom.element.atomicNumber) *
                atom.characteristicFrequency *
                parameters.resonance

            return AtomicConfiguration(
                id: atom.id,
                element: atom.element,
                position: atom.position,
                shellEnergy: shellEnergy,
                characteristicFrequency:
                    atom.characteristicFrequency,
                phase: atom.phase
            )
        }

        progress = 0.12
    }

    // MARK: Canonical pair coupling

    private func calculatePairCoupling(
        _ a: AtomicConfiguration,
        _ b: AtomicConfiguration,
        center: SIMD3<Float>
    ) -> QRTLCouplingResult? {

        let delta =
            b.position - a.position

        let rawDistance =
            simd_length(delta)

        guard rawDistance > 0.001 else {
            return nil
        }

        let distance =
            max(rawDistance, 0.001)

        let distanceFactor =
            exp(-0.35 * Double(distance))

        let frequencyDifference =
            abs(
                a.characteristicFrequency -
                b.characteristicFrequency
            )

        let frequencyCompatibility =
            exp(-0.55 * frequencyDifference)

        let rawPhaseDifference =
            a.phase - b.phase

        let wrappedPhaseDifference =
            atan2(
                sin(rawPhaseDifference),
                cos(rawPhaseDifference)
            )

        let phaseCompatibility =
            0.5 +
            0.5 *
            cos(wrappedPhaseDifference)

        let aRadial =
            a.position - center

        let bRadial =
            b.position - center

        let aLength =
            simd_length(aRadial)

        let bLength =
            simd_length(bRadial)

        let orientationCompatibility: Double

        if aLength > 0.001 &&
            bLength > 0.001 {

            let aDirection =
                aRadial / aLength

            let bDirection =
                bRadial / bLength

            let orientationDot =
                simd_dot(
                    aDirection,
                    bDirection
                )

            orientationCompatibility =
                0.5 +
                0.5 *
                Double(abs(orientationDot))

        } else {

            orientationCompatibility = 0.5
        }

        let pairBQ =
            parameters.qrtlCurrent *
            parameters.resonance *
            distanceFactor *
            frequencyCompatibility *
            phaseCompatibility *
            orientationCompatibility

        let boundedBQ =
            min(
                max(pairBQ, 0),
                1
            )

        let pairQRTLEnergy =
            -parameters.interactionStrength *
            boundedBQ *
            parameters.coherence *
            cos(wrappedPhaseDifference) *
            parameters.density

        let classicalEnergy =
            Double(distance) * 0.10

        let pairEffectiveEnergy =
            classicalEnergy +
            pairQRTLEnergy

        return QRTLCouplingResult(
            distanceFactor:
                distanceFactor,

            frequencyCompatibility:
                frequencyCompatibility,

            phaseCompatibility:
                phaseCompatibility,

            orientationCompatibility:
                orientationCompatibility,

            bQ:
                boundedBQ,

            qrtlEnergy:
                pairQRTLEnergy,

            effectiveEnergy:
                pairEffectiveEnergy
        )
    }

    // MARK: Coupling and forces

    private func calculateCoupling() {

        guard atoms.count > 1 else {
            qrtlForces = []
            bQ = 0
            qrtlEnergy = 0
            effectiveEnergy = 0
            coupling = 0
            phaseError = 0
            stability = 0
            activeForceMagnitude = 0
            return
        }

        let interactionCutoff: Float = 4.0

        let center =
            atoms.reduce(
                SIMD3<Float>(repeating: 0)
            ) {
                $0 + $1.position
            } / Float(atoms.count)

        var results: [QRTLForceResult] = []

        var totalBQ = 0.0
        var totalQRTLEnergy = 0.0
        var totalEffectiveEnergy = 0.0
        var totalPhaseError = 0.0

        for i in 0..<atoms.count {

            for j in (i + 1)..<atoms.count {

                let a = atoms[i]
                let b = atoms[j]

                let delta =
                    b.position - a.position

                let distance =
                    simd_length(delta)

                guard distance > 0.001,
                      distance <= interactionCutoff
                else {
                    continue
                }

                guard let couplingResult =
                    calculatePairCoupling(
                        a,
                        b,
                        center: center
                    )
                else {
                    continue
                }

                let direction =
                    delta / distance

                /*
                 QRTL force magnitude.

                 The spatial coupling term decreases with
                 separation, so the force is derived from
                 the spatial dependence of that coupling.

                 This is a proposed model force, not an
                 experimentally established molecular force.
                */
                let radialForceMagnitude =
                    parameters.interactionStrength *
                    couplingResult.bQ *
                    parameters.coherence *
                    0.35

                /*
                 Preferred separation prevents the
                 visualization from collapsing all atoms
                 into the same point.
                */
                let preferredDistance: Float = 1.35

                let restoringComponent =
                    Double(
                        distance -
                        preferredDistance
                    ) * 0.08

                let netMagnitude =
                    radialForceMagnitude -
                    restoringComponent

                let forceVector =
                    direction *
                    Float(netMagnitude)

                let forceMagnitude =
                    Double(
                        simd_length(forceVector)
                    )

                let rawPhaseDifference =
                    a.phase -
                    b.phase

                let wrappedPhaseDifference =
                    atan2(
                        sin(rawPhaseDifference),
                        cos(rawPhaseDifference)
                    )

                results.append(
                    QRTLForceResult(
                        pair:
                            (a.id, b.id),

                        coupling:
                            couplingResult.bQ,

                        qrtlEnergy:
                            couplingResult.qrtlEnergy,

                        forceVector:
                            forceVector,

                        magnitude:
                            forceMagnitude,

                        phaseError:
                            abs(
                                wrappedPhaseDifference
                            ),

                        distanceFactor:
                            couplingResult.distanceFactor,

                        frequencyCompatibility:
                            couplingResult.frequencyCompatibility,

                        phaseCompatibility:
                            couplingResult.phaseCompatibility,

                        orientationCompatibility:
                            couplingResult.orientationCompatibility
                    )
                )

                totalBQ +=
                    couplingResult.bQ

                totalQRTLEnergy +=
                    couplingResult.qrtlEnergy

                totalEffectiveEnergy +=
                    couplingResult.effectiveEnergy

                totalPhaseError +=
                    abs(
                        wrappedPhaseDifference
                    )
            }
        }

        guard !results.isEmpty else {

            qrtlForces = []

            bQ = 0
            qrtlEnergy = 0
            effectiveEnergy = 0
            coupling = 0
            phaseError = 0
            stability = 0
            activeForceMagnitude = 0

            activeForceDescription =
                "No active QRTL interactions"

            return
        }

        let count =
            Double(results.count)

        bQ =
            totalBQ / count

        qrtlEnergy =
            totalQRTLEnergy / count

        effectiveEnergy =
            totalEffectiveEnergy / count

        coupling =
            bQ

        phaseError =
            totalPhaseError / count

        qrtlForces =
            results

        activeForceMagnitude =
            results.map(\.magnitude).max() ?? 0

        activeForceDescription =
            "\(results.count) active QRTL interactions"

        stability =
            min(
                max(
                    0.5 * bQ +
                    0.5 * parameters.coherence,
                    0
                ),
                1
            )
    }

    // MARK: Force integration

    private func integrateQRTLForces(
        timeStep: Float = 0.08
    ) {

        guard !qrtlForces.isEmpty else {
            return
        }

        var forces =
            Array(
                repeating:
                    SIMD3<Float>(
                        repeating: 0
                    ),
                count: atoms.count
            )

        for result in qrtlForces {

            guard
                let firstIndex =
                    atoms.firstIndex(
                        where: {
                            $0.id == result.pair.0
                        }
                    ),

                let secondIndex =
                    atoms.firstIndex(
                        where: {
                            $0.id == result.pair.1
                        }
                    )
            else {
                continue
            }

            forces[firstIndex] +=
                result.forceVector

            forces[secondIndex] -=
                result.forceVector
        }

        atoms = atoms.map { atom in

            guard
                let index =
                    atoms.firstIndex(
                        where: {
                            $0.id == atom.id
                        }
                    )
            else {
                return atom
            }

            var newPosition =
                atom.position +
                forces[index] *
                timeStep

            newPosition.x =
                min(
                    max(newPosition.x, -8),
                    8
                )

            newPosition.y =
                min(
                    max(newPosition.y, -5),
                    5
                )

            newPosition.z =
                min(
                    max(newPosition.z, -5),
                    5
                )

            return AtomicConfiguration(
                id: atom.id,
                element: atom.element,
                position: newPosition,
                shellEnergy: atom.shellEnergy,
                characteristicFrequency:
                    atom.characteristicFrequency,
                phase: atom.phase
            )
        }

        calculateCoupling()
    }

    // MARK: Molecular configuration

    private func calculateMolecularConfiguration() {

        /*
         IMPORTANT:

         There is no arbitrary "contract everything toward
         the origin" operation here.

         The molecular configuration is produced by
         repeatedly applying the calculated QRTL force field.
        */

        let iterations = 18

        for _ in 0..<iterations {

            calculateCoupling()

            guard !qrtlForces.isEmpty else {
                break
            }

            integrateQRTLForces(
                timeStep: 0.08
            )
        }

        calculateCoupling()

        progress = 0.45
    }

    // MARK: Amino acid assembly

    private func buildAminoAcids() {

        aminoAcids.removeAll()

        let spacing: Float = 2.4

        for index in sequence.indices {

            let center =
                SIMD3<Float>(
                    Float(index) *
                    spacing -
                    3.6,
                    0,
                    0
                )

            let internalEnergy =
                Double(index + 1) *
                0.25

            aminoAcids.append(
                AminoAcidState(
                    definition:
                        sequence[index],

                    center:
                        center,

                    internalEnergy:
                        internalEnergy,

                    qrtlEnergy:
                        qrtlEnergy,

                    assembled:
                        true
                )
            )
        }

        progress = 0.56
    }

    // MARK: Peptide bonds

    private func formPeptideBonds() {

        peptideBonds.removeAll()

        guard aminoAcids.count > 1 else {
            return
        }

        for index in 0..<(aminoAcids.count - 1) {

            let first =
                aminoAcids[index]

            let second =
                aminoAcids[index + 1]

            let delta =
                second.center -
                first.center

            let distance =
                Double(
                    simd_length(delta)
                )

            let localCoupling =
                min(
                    max(
                        bQ *
                        parameters.resonance *
                        parameters.coherence,
                        0
                    ),
                    1
                )

            let energyChange =
                qrtlEnergy *
                localCoupling

            let accepted =
                localCoupling >=
                    parameters.bondThreshold &&
                energyChange < 0

            peptideBonds.append(
                PeptideBondResult(
                    firstResidue:
                        index,

                    secondResidue:
                        index + 1,

                    distance:
                        distance,

                    coupling:
                        localCoupling,

                    energyChange:
                        energyChange,

                    accepted:
                        accepted
                )
            )
        }

        progress = 0.67
    }

    // MARK: Conformation

    private func evaluateConformation() {

        /*
         Candidate conformations are generated from the
         existing residue structure rather than using the
         previous fixed sine/cosine display.

         Each candidate is scored with the current QRTL
         coupling model.
        */

        guard !aminoAcids.isEmpty else {
            return
        }

        let candidates: [
            [SIMD3<Float>]
        ] = [
            aminoAcids.enumerated().map {
                index, residue in

                let x =
                    Float(index) *
                    1.8 -
                    2.7

                let y =
                    Float(index % 2) *
                    0.35

                let z =
                    Float(index % 3) *
                    0.25

                return SIMD3<Float>(
                    x,
                    y,
                    z
                )
            },

            aminoAcids.enumerated().map {
                index, residue in

                let angle =
                    Float(index) *
                    0.75

                return SIMD3<Float>(
                    cos(angle) * 2.6,
                    sin(angle) * 0.9,
                    sin(angle * 0.5) * 1.2
                )
            },

            aminoAcids.enumerated().map {
                index, residue in

                return SIMD3<Float>(
                    Float(index) * 1.55 - 2.3,
                    sin(
                        Float(index) * 0.8
                    ) * 0.65,
                    cos(
                        Float(index) * 0.6
                    ) * 0.55
                )
            }
        ]

        var best =
            candidates[0]

        var bestScore =
            Double.infinity

        for candidate in candidates {

            var score = 0.0

            for i in 0..<candidate.count {

                for j in (i + 1)..<candidate.count {

                    let distance =
                        Double(
                            simd_distance(
                                candidate[i],
                                candidate[j]
                            )
                        )

                    let pairEnergy =
                        distance * 0.10

                    score += pairEnergy
                }
            }

            if score < bestScore {
                bestScore = score
                best = candidate
            }
        }

        aminoAcids = aminoAcids.enumerated().map {
            index,
            residue in

            var updated = residue

            updated.center =
                best[index]

            return updated
        }

        stability =
            min(
                max(
                    0.55 * bQ +
                    0.45 * parameters.coherence,
                    0
                ),
                1
            )

        progress = 0.84
    }

    // MARK: Validation

    private func validateModel() {

        let candidateCount =
            peptideBonds.count

        let acceptedCount =
            peptideBonds.filter {
                $0.accepted
            }.count

        let bondFraction =
            candidateCount > 0
            ? Double(acceptedCount) /
              Double(candidateCount)
            : 0

        stability =
            min(
                max(
                    0.40 * bQ +
                    0.30 * parameters.coherence +
                    0.30 * bondFraction,
                    0
                ),
                1
            )

        progress = 1.0

        validationMessage =
            """
            Internal model consistency:
            \(acceptedCount)/\(candidateCount) candidate peptide bonds accepted.
            QRTL coupling = \(String(format: "%.3f", bQ)).
            Stability score = \(String(format: "%.3f", stability)).

            This is computational model validation,
            not experimental validation.
            """
    }
}

// MARK: - Scene Controller

@MainActor
final class PeptideSceneController {

    private weak var view: SCNView?

    private let scene =
        SCNScene()

    private let contentNode =
        SCNNode()

    private let atomContainer =
        SCNNode()

    private let shellContainer =
        SCNNode()

    private let forceContainer =
        SCNNode()

    private let couplingContainer =
        SCNNode()

    private let residueContainer =
        SCNNode()

    private let bondContainer =
        SCNNode()

    private var atomNodes:
        [Int: SCNNode] = [:]

    private var shellNodes:
        [Int: SCNNode] = [:]

    private var lastStage:
        PeptideStage?

    init() {

        contentNode.name =
            "peptideContent"

        atomContainer.name =
            "atoms"

        shellContainer.name =
            "energyShells"

        forceContainer.name =
            "qrtlForces"

        couplingContainer.name =
            "qrtlCoupling"

        residueContainer.name =
            "residues"

        bondContainer.name =
            "peptideBonds"

        contentNode.addChildNode(
            atomContainer
        )

        contentNode.addChildNode(
            shellContainer
        )

        contentNode.addChildNode(
            forceContainer
        )

        contentNode.addChildNode(
            couplingContainer
        )

        contentNode.addChildNode(
            residueContainer
        )

        contentNode.addChildNode(
            bondContainer
        )

        scene.rootNode.addChildNode(
            contentNode
        )
    }

    func attach(
        to view: SCNView
    ) {

        self.view = view

        view.scene = scene

        view.backgroundColor =
            .black

        view.allowsCameraControl =
            true

        view.autoenablesDefaultLighting =
            true

        if view.pointOfView == nil {

            let cameraNode =
                SCNNode()

            let camera =
                SCNCamera()

            camera.zNear =
                0.01

            camera.zFar =
                100

            cameraNode.camera =
                camera

            cameraNode.position =
                SCNVector3(
                    0,
                    2,
                    12
                )

            scene.rootNode.addChildNode(
                cameraNode
            )

            view.pointOfView =
                cameraNode
        }
    }

    func update(
        engine: PeptideSimulationEngine
    ) {

        reconcileAtoms(
            engine: engine
        )

        updateShells(
            engine: engine
        )

        updateCoupling(
            engine: engine
        )

        updateForces(
            engine: engine
        )

        updateResidues(
            engine: engine
        )

        updateBonds(
            engine: engine
        )

        if lastStage != engine.stage {

            animateToStage(
                engine.stage
            )

            lastStage =
                engine.stage
        }
    }

    // MARK: Atoms

    private func reconcileAtoms(
        engine: PeptideSimulationEngine
    ) {

        var activeIDs =
            Set<Int>()

        for atom in engine.atoms {

            activeIDs.insert(
                atom.id
            )

            let node: SCNNode

            if let existing =
                atomNodes[atom.id] {

                node = existing

            } else {

                let sphere =
                    SCNSphere(
                        radius:
                            atom.element.radius
                    )

                sphere.firstMaterial =
                    atomMaterial(
                        element:
                            atom.element
                    )

                node =
                    SCNNode(
                        geometry:
                            sphere
                    )

                atomNodes[atom.id] =
                    node

                atomContainer.addChildNode(
                    node
                )
            }

            let target =
                SCNVector3(
                    atom.position.x,
                    atom.position.y,
                    atom.position.z
                )

            SCNTransaction.begin()

            SCNTransaction.animationDuration =
                0.35

            node.position =
                target

            SCNTransaction.commit()
        }

        for (id, node) in atomNodes {

            if !activeIDs.contains(id) {

                node.removeFromParentNode()

                atomNodes.removeValue(
                    forKey: id
                )
            }
        }
    }

    // MARK: Shells

    private func updateShells(
        engine: PeptideSimulationEngine
    ) {

        shellContainer
            .childNodes
            .forEach {
                $0.removeFromParentNode()
            }

        guard engine.stage.rawValue >=
                PeptideStage.energyShells.rawValue
        else {
            return
        }

        for atom in engine.atoms {

            let shell =
                SCNTorus(
                    ringRadius:
                        atom.element.radius *
                        1.7,

                    pipeRadius:
                        0.018
                )

            shell.firstMaterial =
                shellMaterial()

            let node =
                SCNNode(
                    geometry:
                        shell
                )

            node.position =
                SCNVector3(
                    atom.position.x,
                    atom.position.y,
                    atom.position.z
                )

            shellContainer.addChildNode(
                node
            )

            let pulse =
                SCNAction.sequence([
                    SCNAction.scale(
                        to: 1.15,
                        duration: 0.45
                    ),

                    SCNAction.scale(
                        to: 0.92,
                        duration: 0.45
                    )
                ])

            node.runAction(
                SCNAction.repeatForever(
                    pulse
                )
            )

            shellNodes[atom.id] =
                node
        }
    }

    // MARK: Coupling lines

    private func updateCoupling(
        engine: PeptideSimulationEngine
    ) {

        couplingContainer
            .childNodes
            .forEach {
                $0.removeFromParentNode()
            }

        guard engine.stage.rawValue >=
                PeptideStage.qrtlCoupling.rawValue
        else {
            return
        }

        for force in engine.qrtlForces {

            guard
                let a =
                    engine.atoms.first(
                        where: {
                            $0.id ==
                            force.pair.0
                        }
                    ),

                let b =
                    engine.atoms.first(
                        where: {
                            $0.id ==
                            force.pair.1
                        }
                    )
            else {
                continue
            }

            let line =
                makeCylinder(
                    from:
                        a.position,

                    to:
                        b.position,

                    radius:
                        CGFloat(
                            0.015 +
                            force.coupling *
                            0.045
                        )
                )

            line.geometry?.firstMaterial = couplingMaterial(
                strength: force.coupling
            )

            couplingContainer.addChildNode(
                line
            )
        }
    }

    // MARK: QRTL Force arrows

    private func updateForces(
        engine: PeptideSimulationEngine
    ) {

        forceContainer
            .childNodes
            .forEach {
                $0.removeFromParentNode()
            }

        guard engine.stage.rawValue >=
                PeptideStage.qrtlCoupling.rawValue
        else {
            return
        }

        for force in engine.qrtlForces {

            guard
                let a =
                    engine.atoms.first(
                        where: {
                            $0.id ==
                            force.pair.0
                        }
                    ),

                let b =
                    engine.atoms.first(
                        where: {
                            $0.id ==
                            force.pair.1
                        }
                    )
            else {
                continue
            }

            addForceArrow(
                from:
                    a.position,

                vector:
                    force.forceVector,

                magnitude:
                    force.magnitude,

                to:
                    forceContainer
            )

            addForceArrow(
                from:
                    b.position,

                vector:
                    -force.forceVector,

                magnitude:
                    force.magnitude,

                to:
                    forceContainer
            )
        }
    }

    private func addForceArrow(
        from start: SIMD3<Float>,
        vector: SIMD3<Float>,
        magnitude: Double,
        to container: SCNNode
    ) {

        let length =
            simd_length(vector)

        guard length > 0.0001 else {
            return
        }

        let direction =
            vector / length

        let arrowLength =
            max(
                0.12,
                min(
                    1.2,
                    Float(magnitude) * 2.0
                )
            )

        let cylinder =
            SCNCylinder(
                radius: 0.028,
                height:
                    CGFloat(arrowLength)
            )

        cylinder.firstMaterial =
            forceMaterial(
                magnitude:
                    magnitude
            )

        let node =
            SCNNode(
                geometry:
                    cylinder
            )

        let yAxis =
            SIMD3<Float>(
                0,
                1,
                0
            )

        let dot =
            max(
                -1,
                min(
                    1,
                    simd_dot(
                        yAxis,
                        direction
                    )
                )
            )

        let angle =
            acos(dot)

        let axis =
            simd_cross(
                yAxis,
                direction
            )

        if simd_length(axis) >
            0.0001 {

            node.rotation =
                SCNVector4(
                    axis.x,
                    axis.y,
                    axis.z,
                    angle
                )

        } else if dot < 0 {

            node.rotation =
                SCNVector4(
                    1,
                    0,
                    0,
                    Float.pi
                )
        }

        node.position =
            SCNVector3(
                start.x +
                    direction.x *
                    arrowLength *
                    0.5,

                start.y +
                    direction.y *
                    arrowLength *
                    0.5,

                start.z +
                    direction.z *
                    arrowLength *
                    0.5
            )

        container.addChildNode(
            node
        )

        let pulse =
            SCNAction.sequence([
                SCNAction.scale(
                    to: 1.3,
                    duration: 0.22
                ),

                SCNAction.scale(
                    to: 0.85,
                    duration: 0.22
                )
            ])

        node.runAction(
            SCNAction.repeatForever(
                pulse
            )
        )
    }

    // MARK: Residues

    private func updateResidues(
        engine: PeptideSimulationEngine
    ) {

        residueContainer
            .childNodes
            .forEach {
                $0.removeFromParentNode()
            }

        guard engine.stage.rawValue >=
                PeptideStage.aminoAcidAssembly.rawValue
        else {
            return
        }

        for (index, residue)
            in engine.aminoAcids.enumerated() {

            let sphere =
                SCNSphere(
                    radius:
                        0.55
                )

            sphere.firstMaterial =
                residueMaterial(
                    coupling:
                        engine.bQ
                )

            let node =
                SCNNode(
                    geometry:
                        sphere
                )

            node.position =
                SCNVector3(
                    residue.center.x,
                    residue.center.y,
                    residue.center.z
                )

            node.opacity =
                0.38

            residueContainer.addChildNode(
                node
            )

            if engine.stage ==
                .aminoAcidAssembly {

                let pulse =
                    SCNAction.sequence([
                        SCNAction.scale(
                            to: 1.2,
                            duration: 0.3
                        ),

                        SCNAction.scale(
                            to: 0.95,
                            duration: 0.3
                        )
                    ])

                node.runAction(
                    SCNAction.repeatForever(
                        pulse
                    )
                )
            }
        }
    }

    // MARK: Bonds

    private func updateBonds(
        engine: PeptideSimulationEngine
    ) {

        bondContainer
            .childNodes
            .forEach {
                $0.removeFromParentNode()
            }

        guard engine.stage.rawValue >=
                PeptideStage.peptideBond.rawValue
        else {
            return
        }

        for bond in engine.peptideBonds {

            guard bond.accepted,
                  bond.firstResidue <
                    engine.aminoAcids.count,
                  bond.secondResidue <
                    engine.aminoAcids.count
            else {
                continue
            }

            let first =
                engine.aminoAcids[
                    bond.firstResidue
                ]

            let second =
                engine.aminoAcids[
                    bond.secondResidue
                ]

            let node =
                makeCylinder(
                    from:
                        first.center,

                    to:
                        second.center,

                    radius:
                        0.10
                )

            node.geometry?.firstMaterial =
                bondMaterial()
            
            bondContainer.addChildNode(
                node
            )
        }
    }

    // MARK: Stage animation

    private func animateToStage(
        _ stage: PeptideStage
    ) {

        switch stage {

        case .independentParticles:

            contentNode.opacity =
                1

            atomContainer.opacity =
                1

            shellContainer.opacity =
                0

            forceContainer.opacity =
                0

            couplingContainer.opacity =
                0

            residueContainer.opacity =
                0

            bondContainer.opacity =
                0

        case .energyShells:

            shellContainer.opacity =
                1

            forceContainer.opacity =
                0

            couplingContainer.opacity =
                0

        case .qrtlCoupling:

            shellContainer.opacity =
                1

            couplingContainer.opacity =
                1

            forceContainer.opacity =
                1

        case .molecularConfiguration:

            shellContainer.opacity =
                1

            couplingContainer.opacity =
                1

            forceContainer.opacity =
                1

        case .aminoAcidAssembly:

            residueContainer.opacity =
                1

            couplingContainer.opacity =
                0.6

            forceContainer.opacity =
                0.8

        case .peptideBond:

            residueContainer.opacity =
                1

            forceContainer.opacity =
                1

            bondContainer.opacity =
                1

        case .peptideChain:

            residueContainer.opacity =
                1

            bondContainer.opacity =
                1

            forceContainer.opacity =
                0.5

        case .conformation:

            residueContainer.opacity =
                1

            bondContainer.opacity =
                1

            forceContainer.opacity =
                0.35

        case .validation:

            residueContainer.opacity =
                1

            bondContainer.opacity =
                1

            forceContainer.opacity =
                0.2
        }
    }

    // MARK: Geometry

    private func makeCylinder(
        from start: SIMD3<Float>,
        to end: SIMD3<Float>,
        radius: CGFloat
    ) -> SCNNode {

        let vector =
            end - start

        let length =
            simd_length(vector)

        let cylinder =
            SCNCylinder(
                radius:
                    radius,

                height:
                    CGFloat(length)
            )

        let node =
            SCNNode(
                geometry:
                    cylinder
            )

        let midpoint =
            (start + end) *
            0.5

        node.position =
            SCNVector3(
                midpoint.x,
                midpoint.y,
                midpoint.z
            )

        let direction =
            vector / max(length, 0.0001)

        let yAxis =
            SIMD3<Float>(
                0,
                1,
                0
            )

        let dot =
            max(
                -1,
                min(
                    1,
                    simd_dot(
                        yAxis,
                        direction
                    )
                )
            )

        let angle =
            acos(dot)

        let axis =
            simd_cross(
                yAxis,
                direction
            )

        if simd_length(axis) >
            0.0001 {

            node.rotation =
                SCNVector4(
                    axis.x,
                    axis.y,
                    axis.z,
                    angle
                )

        } else if dot < 0 {

            node.rotation =
                SCNVector4(
                    1,
                    0,
                    0,
                    Float.pi
                )
        }

        return node
    }

    // MARK: Materials

    private func atomMaterial(
        element: ElementType
    ) -> SCNMaterial {

        let material =
            SCNMaterial()

        material.diffuse.contents =
            element.displayColor

        material.specular.contents =
            UIColor.white

        material.shininess =
            0.8

        return material
    }

    private func shellMaterial()
        -> SCNMaterial {

        let material =
            SCNMaterial()

        material.diffuse.contents =
            UIColor.systemPurple.withAlphaComponent(
                0.45
            )

        material.emission.contents =
            UIColor.systemPurple

        material.transparency =
            0.55

        return material
    }

    private func couplingMaterial(
        strength: Double
    ) -> SCNMaterial {

        let material =
            SCNMaterial()

        let alpha =
            CGFloat(
                0.20 +
                min(
                    max(
                        strength,
                        0
                    ),
                    1
                ) *
                0.65
            )

        material.diffuse.contents =
            UIColor.systemCyan.withAlphaComponent(
                alpha
            )

        material.emission.contents =
            UIColor.systemCyan

        material.transparency =
            alpha

        return material
    }

    private func forceMaterial(
        magnitude: Double
    ) -> SCNMaterial {

        let material =
            SCNMaterial()

        let normalized =
            min(
                max(
                    magnitude,
                    0
                ),
                1
            )

        material.diffuse.contents =
            UIColor.systemOrange.withAlphaComponent(
                CGFloat(
                    0.35 +
                    normalized *
                    0.60
                )
            )

        material.emission.contents =
            UIColor.systemOrange

        return material
    }

    private func residueMaterial(
        coupling: Double
    ) -> SCNMaterial {

        let material =
            SCNMaterial()

        let alpha =
            CGFloat(
                0.25 +
                min(
                    max(
                        coupling,
                        0
                    ),
                    1
                ) *
                0.55
            )

        material.diffuse.contents =
            UIColor.systemGreen.withAlphaComponent(
                alpha
            )

        return material
    }

    private func bondMaterial()
        -> SCNMaterial {

        let material =
            SCNMaterial()

        material.diffuse.contents =
            UIColor.systemOrange

        material.emission.contents =
            UIColor.systemOrange

        return material
    }
}

// MARK: - SceneKit View

struct PeptideSceneView:
    UIViewRepresentable {

    @ObservedObject
    var engine:
        PeptideSimulationEngine

    func makeCoordinator()
        -> Coordinator {

        Coordinator(
            engine:
                engine
        )
    }

    func makeUIView(
        context:
            Context
    ) -> SCNView {

        let view =
            SCNView()

        context.coordinator
            .controller
            .attach(
                to:
                    view
            )

        return view
    }

    func updateUIView(
        _ view: SCNView,
        context:
            Context
    ) {

        context.coordinator
            .controller
            .update(
                engine:
                    engine
            )
    }

    final class Coordinator {

        let controller:
            PeptideSceneController

        init(
            engine:
                PeptideSimulationEngine
        ) {

            controller =
                PeptideSceneController()
        }
    }
}

// MARK: - Content View

struct ContentView:
    View {

    @StateObject
    private var engine =
        PeptideSimulationEngine()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(
                    spacing: 18
                ) {

                    header

                    pipeline

                    ZStack(
                        alignment:
                            .topLeading
                    ) {

                        PeptideSceneView(
                            engine:
                                engine
                        )
                        .frame(
                            height:
                                390
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:
                                    18
                            )
                        )

                        stageOverlay
                    }

                    stageCard

                    equationCard

                    forceCard

                    metricsCard

                    if engine.stage ==
                        .validation {

                        validationCard
                    }

                    controls
                }
                .padding()
            }
            .navigationTitle(
                "QRTL Peptide Assembly"
            )
        }
    }

    // MARK: Header

    private var header: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                6
        ) {

            Text(
                "QRTL-Driven Molecular Assembly"
            )
            .font(
                .title2.bold()
            )

            Text(
                "The animation shows the calculated QRTL interaction acting on the molecular system before each transition."
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
    }

    // MARK: Pipeline

    private var pipeline: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                4
        ) {

            ForEach(
                PeptideStage.allCases
            ) { item in

                HStack(
                    spacing:
                        8
                ) {

                    Circle()
                        .fill(
                            item.rawValue <
                                engine.stage.rawValue
                            ? Color.green
                            : item ==
                                engine.stage
                            ? Color.orange
                            : Color.gray.opacity(
                                0.35
                            )
                        )
                        .frame(
                            width:
                                10,
                            height:
                                10
                        )

                    Text(
                        item.shortName
                    )
                    .font(
                        .caption
                    )
                    .fontWeight(
                        item ==
                            engine.stage
                        ? .bold
                        : .regular
                    )

                    if item ==
                        engine.stage {

                        Text(
                            "CURRENT"
                        )
                        .font(
                            .caption2.bold()
                        )
                        .foregroundStyle(
                            .orange
                        )
                    }
                }
            }
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding()
        .background(
            Color.secondary.opacity(
                0.10
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    14
            )
        )
    }

    // MARK: Stage overlay

    private var stageOverlay: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                4
        ) {

            Text(
                "STEP \(engine.stage.rawValue + 1) / \(PeptideStage.allCases.count)"
            )
            .font(
                .caption.bold()
            )

            Text(
                engine.stage.title
            )
            .font(
                .headline.bold()
            )

            Text(
                engine.stage.explanation
            )
            .font(
                .caption
            )
            .fixedSize(
                horizontal:
                    false,
                vertical:
                    true
            )
        }
        .foregroundStyle(
            .white
        )
        .padding(
            12
        )
        .background(
            Color.black.opacity(
                0.72
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    12
            )
        )
        .padding(
            12
        )
    }

    // MARK: Stage card

    private var stageCard: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            Text(
                "What is happening now"
            )
            .font(
                .headline
            )

            Text(
                stageDescription
            )
            .font(
                .body
            )

            ProgressView(
                value:
                    engine.progress
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding()
        .background(
            Color.secondary.opacity(
                0.10
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    14
            )
        )
    }

    private var stageDescription: String {

        switch engine.stage {

        case .independentParticles:
            return "The atoms are separated. No QRTL force is being applied yet."

        case .energyShells:
            return "QRTL shell energy has been assigned to each atom."

        case .qrtlCoupling:
            return "The QRTL field is evaluating which nearby atoms can interact. Force arrows now show the direction of the calculated interaction."

        case .molecularConfiguration:
            return "The calculated QRTL force is moving the atoms. The positions are changing because of the force calculation."

        case .aminoAcidAssembly:
            return "The force-organized atoms are being grouped into the amino-acid structures."

        case .peptideBond:
            return "The reactive regions are being evaluated for a favorable peptide-bond interaction."

        case .peptideChain:
            return "Accepted peptide-bond interactions connect the residues into a chain."

        case .conformation:
            return "The assembled chain is evaluated in candidate three-dimensional configurations."

        case .validation:
            return "The final structure and energy relationships are checked for internal model consistency."
        }
    }

    // MARK: Equation card

    private var equationCard: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                10
        ) {

            Text(
                "QRTL Equations"
            )
            .font(
                .headline
            )

            Text(
                "B_Q = I_Q · R · D · F · P · O"
            )
            .font(
                .system(
                    .body,
                    design:
                        .monospaced
                )
            )

            Text(
                "E_QRTL = −B_Q · C · cos(Δφ) · ρ"
            )
            .font(
                .system(
                    .body,
                    design:
                        .monospaced
                )
            )

            Text(
                "E_effective = E_classical + E_QRTL"
            )
            .font(
                .system(
                    .body,
                    design:
                        .monospaced
                )
            )

            Divider()

            Text(
                "The QRTL force is calculated from the spatial dependence of the coupling and is then applied to the atom positions."
            )
            .font(
                .caption
            )

            Text(
                "QRTL terms are proposed computational model assumptions, not established experimental molecular physics."
            )
            .font(
                .caption2
            )
            .foregroundStyle(
                .secondary
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding()
        .background(
            Color.secondary.opacity(
                0.10
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    14
            )
        )
    }

    // MARK: Force card

    private var forceCard: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            Text(
                "QRTL Force Field"
            )
            .font(
                .headline
            )

            HStack {

                metric(
                    title:
                        "Active Interactions",

                    value:
                        "\(engine.qrtlForces.count)"
                )

                metric(
                    title:
                        "Max Force",

                    value:
                        String(
                            format:
                                "%.4f",
                            engine.activeForceMagnitude
                        )
                )
            }

            Text(
                engine.activeForceDescription
            )
            .font(
                .caption
            )

            if engine.stage.rawValue >=
                PeptideStage.qrtlCoupling.rawValue {

                Text(
                    "Orange arrows show the instantaneous QRTL force direction. The arrows act on the atoms; the resulting position change is then recalculated into the next QRTL state."
                )
                .font(
                    .caption
                )
                .foregroundStyle(
                    .secondary
                )
            }
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding()
        .background(
            Color.orange.opacity(
                0.10
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    14
            )
        )
    }

    // MARK: Metrics

    private var metricsCard: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            Text(
                "Live Metrics"
            )
            .font(
                .headline
            )

            HStack {

                metric(
                    title:
                        "B_Q",

                    value:
                        String(
                            format:
                                "%.3f",
                            engine.bQ
                        )
                )

                metric(
                    title:
                        "QRTL Energy",

                    value:
                        String(
                            format:
                                "%.3f",
                            engine.qrtlEnergy
                        )
                )
            }

            HStack {

                metric(
                    title:
                        "Effective Energy",

                    value:
                        String(
                            format:
                                "%.3f",
                            engine.effectiveEnergy
                        )
                )

                metric(
                    title:
                        "Coupling",

                    value:
                        String(
                            format:
                                "%.3f",
                            engine.coupling
                        )
                )
            }

            HStack {

                metric(
                    title:
                        "Phase Error",

                    value:
                        String(
                            format:
                                "%.3f",
                            engine.phaseError
                        )
                )

                metric(
                    title:
                        "Stability",

                    value:
                        String(
                            format:
                                "%.3f",
                            engine.stability
                        )
                )
            }
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding()
        .background(
            Color.secondary.opacity(
                0.10
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    14
            )
        )
    }

    private func metric(
        title:
            String,

        value:
            String
    ) -> some View {

        VStack(
            alignment:
                .leading
        ) {

            Text(
                title
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )

            Text(
                value
            )
            .font(
                .system(
                    .body,
                    design:
                        .monospaced
                )
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
    }

    // MARK: Validation

    private var validationCard: some View {

        VStack(
            alignment:
                .leading,
            spacing:
                8
        ) {

            Text(
                "Model Validation"
            )
            .font(
                .headline
            )

            Text(
                engine.validationMessage
            )
            .font(
                .caption
            )
        }
        .frame(
            maxWidth:
                .infinity,
            alignment:
                .leading
        )
        .padding()
        .background(
            Color.green.opacity(
                0.10
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    14
            )
        )
    }

    // MARK: Controls

    private var controls: some View {

        HStack(
            spacing:
                12
        ) {

            Button(
                "Reset"
            ) {

                engine.reset()
            }

            Button(
                "Previous"
            ) {

                engine.previous()
            }
            .disabled(
                engine.stage ==
                    .independentParticles
            )

            Button(
                engine.stage ==
                    .validation
                ? "Restart"
                : "Advance"
            ) {

                engine.advance()
            }
            .buttonStyle(
                .borderedProminent
            )
        }
    }
}
