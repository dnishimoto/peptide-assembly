
//
//  ContentView.swift
//  QRTL Peptide Assembly
//
//  Equation-driven peptide assembly simulation
//
//  Pipeline:
//  IDP
//    → Energy Shells
//    → QRTL Coupling
//    → Molecular Configuration
//    → Amino Acid Assembly
//    → Peptide Bond Formation
//    → Peptide Chain
//    → Conformation
//    → Validation
//
//  IMPORTANT:
//  The QRTL terms below are a proposed computational model.
//  They are not established experimental molecular physics.
//

import SwiftUI
import SceneKit
import UIKit
import Combine

// MARK: - Pipeline

enum PeptideStage: Int, CaseIterable {
    case independentParticles
    case energyShells
    case qrtlCoupling
    case molecularConfiguration
    case aminoAcidAssembly
    case peptideBond
    case peptideChain
    case conformation
    case validation

    var title: String {
        switch self {
        case .independentParticles:
            return "Independent Particles"
        case .energyShells:
            return "QRTL Energy Shells"
        case .qrtlCoupling:
            return "QRTL Coupling"
        case .molecularConfiguration:
            return "Molecular Configuration"
        case .aminoAcidAssembly:
            return "Amino Acid Assembly"
        case .peptideBond:
            return "Peptide Bond"
        case .peptideChain:
            return "Peptide Chain"
        case .conformation:
            return "3D Conformation"
        case .validation:
            return "Validation"
        }
    }

    var explanation: String {
        switch self {
        case .independentParticles:
            return "Constituent atoms begin as independent particles."
        case .energyShells:
            return "Each atom receives a proposed QRTL internal energy-shell state."
        case .qrtlCoupling:
            return "Distance, frequency, phase, and orientation determine coupling."
        case .molecularConfiguration:
            return "The coupled system is evaluated as an energy landscape."
        case .aminoAcidAssembly:
            return "Atoms are organized into amino-acid molecular structures."
        case .peptideBond:
            return "Neighboring amino-acid reactive regions are evaluated for bonding."
        case .peptideChain:
            return "Accepted peptide bonds create the molecular chain."
        case .conformation:
            return "The chain explores candidate three-dimensional conformations."
        case .validation:
            return "Calculated structures and energies are compared against model targets."
        }
    }
}

// MARK: - Elements

enum ElementType: String, CaseIterable {
    case hydrogen = "H"
    case carbon = "C"
    case nitrogen = "N"
    case oxygen = "O"
    case sulfur = "S"

    var atomicNumber: Int {
        switch self {
        case .hydrogen: return 1
        case .carbon: return 6
        case .nitrogen: return 7
        case .oxygen: return 8
        case .sulfur: return 16
        }
    }

    var radius: Float {
        switch self {
        case .hydrogen: return 0.18
        case .carbon: return 0.30
        case .nitrogen: return 0.28
        case .oxygen: return 0.27
        case .sulfur: return 0.35
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

// MARK: - Engine

@MainActor
final class PeptideSimulationEngine: ObservableObject {

    @Published private(set) var stage: PeptideStage = .independentParticles

    @Published private(set) var atoms: [AtomicConfiguration] = []

    @Published private(set) var aminoAcids: [AminoAcidState] = []

    @Published private(set) var peptideBonds: [PeptideBondResult] = []

    @Published private(set) var bQ: Double = 0

    @Published private(set) var qrtlEnergy: Double = 0

    @Published private(set) var effectiveEnergy: Double = 0

    @Published private(set) var coupling: Double = 0

    @Published private(set) var phaseError: Double = Double.pi / 2

    @Published private(set) var stability: Double = 0

    @Published private(set) var progress: Double = 0

    @Published var parameters = PeptideParameters()

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

    init() {
        reset()
    }

    // MARK: Reset

    func reset() {

        stage = .independentParticles

        atoms.removeAll()
        aminoAcids.removeAll()
        peptideBonds.removeAll()

        bQ = 0
        qrtlEnergy = 0
        effectiveEnergy = 0
        coupling = 0
        phaseError = Double.pi / 2
        stability = 0
        progress = 0

        makeIndependentAtoms()
    }

    // MARK: Pipeline Control

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
            progress = 0.72

        case .peptideChain:
            evaluateConformation()
            stage = .conformation

        case .conformation:
            validateModel()
            stage = .validation

        case .validation:
            reset()
        }

        progress = Double(stage.rawValue) /
            Double(PeptideStage.allCases.count - 1)
    }

    func previous() {

        guard stage.rawValue > 0 else {
            return
        }

        stage = PeptideStage(
            rawValue: stage.rawValue - 1
        ) ?? .independentParticles

        progress = Double(stage.rawValue) /
            Double(PeptideStage.allCases.count - 1)
    }

    // MARK: Independent Particle State

    private func makeIndependentAtoms() {

        atoms = [

            AtomicConfiguration(
                id: 0,
                element: .nitrogen,
                position: SIMD3(-3.0, 0.0, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 1.00,
                phase: 0
            ),

            AtomicConfiguration(
                id: 1,
                element: .carbon,
                position: SIMD3(-2.2, 0.0, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 0.96,
                phase: 0.20
            ),

            AtomicConfiguration(
                id: 2,
                element: .oxygen,
                position: SIMD3(-1.4, 0.8, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 1.03,
                phase: 0.45
            ),

            AtomicConfiguration(
                id: 3,
                element: .carbon,
                position: SIMD3(-1.2, -0.8, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 0.92,
                phase: 0.60
            ),

            AtomicConfiguration(
                id: 4,
                element: .nitrogen,
                position: SIMD3(0.0, 0.0, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 1.01,
                phase: 0.82
            ),

            AtomicConfiguration(
                id: 5,
                element: .carbon,
                position: SIMD3(0.9, 0.0, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 0.98,
                phase: 1.00
            ),

            AtomicConfiguration(
                id: 6,
                element: .oxygen,
                position: SIMD3(1.7, 0.7, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 1.04,
                phase: 1.20
            ),

            AtomicConfiguration(
                id: 7,
                element: .carbon,
                position: SIMD3(1.8, -0.8, 0.0),
                shellEnergy: 0,
                characteristicFrequency: 0.94,
                phase: 1.40
            ),

            AtomicConfiguration(
                id: 8,
                element: .hydrogen,
                position: SIMD3(-2.7, 0.8, 0.6),
                shellEnergy: 0,
                characteristicFrequency: 1.08,
                phase: 0.35
            ),

            AtomicConfiguration(
                id: 9,
                element: .hydrogen,
                position: SIMD3(-2.5, -0.8, -0.5),
                shellEnergy: 0,
                characteristicFrequency: 0.97,
                phase: 0.55
            ),

            AtomicConfiguration(
                id: 10,
                element: .hydrogen,
                position: SIMD3(0.2, 0.9, 0.5),
                shellEnergy: 0,
                characteristicFrequency: 1.02,
                phase: 0.95
            ),

            AtomicConfiguration(
                id: 11,
                element: .hydrogen,
                position: SIMD3(1.1, -0.9, -0.5),
                shellEnergy: 0,
                characteristicFrequency: 1.06,
                phase: 1.35
            )
        ]
    }

    // MARK: Energy Shells

    private func calculateShellState() {

        for index in atoms.indices {

            let atom = atoms[index]

            let shellEnergy =
                Double(atom.element.atomicNumber) *
                atom.characteristicFrequency *
                parameters.resonance

            atoms[index].shellEnergy = shellEnergy
        }
    }

    // MARK: QRTL Coupling

    private func calculateCoupling() {

        guard atoms.count >= 2 else {
            return
        }

        var totalBQ = 0.0
        var totalQRTLEnergy = 0.0
        var totalEffectiveEnergy = 0.0

        var pairCount = 0

        for i in 0..<(atoms.count - 1) {

            let a = atoms[i]
            let b = atoms[i + 1]

            let dx = Double(a.position.x - b.position.x)
            let dy = Double(a.position.y - b.position.y)
            let dz = Double(a.position.z - b.position.z)

            let distance = max(
                sqrt(dx * dx + dy * dy + dz * dz),
                0.001
            )

            // Distance compatibility
            let distanceFactor =
                exp(-0.35 * distance)

            // Frequency compatibility
            let frequencyDifference =
                abs(
                    a.characteristicFrequency -
                    b.characteristicFrequency
                )

            let frequencyCompatibility =
                exp(-0.55 * frequencyDifference)

            // Phase compatibility
            let deltaPhi =
                abs(
                    a.phase -
                    b.phase
                )

            let phaseCompatibility =
                0.5 + 0.5 * cos(deltaPhi)

            // Orientation contribution
            let orientationCompatibility =
                0.5 +
                0.5 * parameters.phaseAlignment

            // Canonical QRTL balance quantity
            let pairBQ =
                parameters.qrtlCurrent *
                parameters.resonance *
                distanceFactor *
                frequencyCompatibility *
                phaseCompatibility *
                orientationCompatibility

            let boundedBQ =
                min(max(pairBQ, 0), 1)

            let qrtlPairEnergy =
                -parameters.interactionStrength *
                boundedBQ *
                parameters.coherence *
                cos(deltaPhi) *
                parameters.density

            let classicalEnergy =
                distance * 0.10

            let pairEffectiveEnergy =
                classicalEnergy +
                qrtlPairEnergy

            totalBQ += boundedBQ
            totalQRTLEnergy += qrtlPairEnergy
            totalEffectiveEnergy += pairEffectiveEnergy

            pairCount += 1
        }

        guard pairCount > 0 else {
            return
        }

        bQ = totalBQ / Double(pairCount)

        qrtlEnergy =
            totalQRTLEnergy /
            Double(pairCount)

        effectiveEnergy =
            totalEffectiveEnergy /
            Double(pairCount)

        coupling = bQ

        phaseError =
            Double.pi *
            (1.0 - bQ)

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

    // MARK: Molecular Configuration

    private func calculateMolecularConfiguration() {

        guard !atoms.isEmpty else {
            return
        }

        // Move the system toward the coupled equilibrium
        // without introducing a second independent energy calculation.

        let contraction =
            Float(
                min(
                    max(
                        0.04 * bQ,
                        0
                    ),
                    0.12
                )
            )

        for index in atoms.indices {

            var p = atoms[index].position

            p.x *= (1.0 - contraction)
            p.y *= (1.0 - contraction)
            p.z *= (1.0 - contraction)

            atoms[index].position = p
        }

        calculateCoupling()
    }

    // MARK: Amino Acid Assembly

    private func buildAminoAcids() {

        aminoAcids.removeAll()

        let spacing: Float = 2.4

        for index in sequence.indices {

            let definition = sequence[index]

            let center = SIMD3<Float>(
                Float(index) * spacing - 3.6,
                0,
                0
            )

            let state = AminoAcidState(
                definition: definition,
                center: center,
                internalEnergy:
                    Double(index + 1) * 0.25,
                qrtlEnergy:
                    qrtlEnergy,
                assembled: true
            )

            aminoAcids.append(state)
        }

        progress = 0.45
    }

    // MARK: Peptide Bond Formation

    private func formPeptideBonds() {

        peptideBonds.removeAll()

        guard aminoAcids.count >= 2 else {
            return
        }

        for index in 0..<(aminoAcids.count - 1) {

            let first = aminoAcids[index]
            let second = aminoAcids[index + 1]

            let dx =
                Double(first.center.x - second.center.x)

            let dy =
                Double(first.center.y - second.center.y)

            let dz =
                Double(first.center.z - second.center.z)

            let distance =
                sqrt(
                    dx * dx +
                    dy * dy +
                    dz * dz
                )

            let localCoupling =
                bQ *
                parameters.resonance *
                parameters.coherence

            let energyChange =
                qrtlEnergy *
                localCoupling

            let accepted =
                localCoupling >=
                parameters.bondThreshold

            peptideBonds.append(
                PeptideBondResult(
                    firstResidue: index,
                    secondResidue: index + 1,
                    distance: distance,
                    coupling: localCoupling,
                    energyChange: energyChange,
                    accepted: accepted
                )
            )
        }

        progress = 0.60
    }

    // MARK: Conformation

    private func evaluateConformation() {

        guard !aminoAcids.isEmpty else {
            return
        }

        var candidates: [SIMD3<Float>] = []

        for index in aminoAcids.indices {

            let x =
                Float(index) * 1.8 - 2.7

            let y =
                sin(
                    Float(index) * 0.9
                ) * 0.65

            let z =
                cos(
                    Float(index) * 0.7
                ) * 0.45

            candidates.append(
                SIMD3(x, y, z)
            )
        }

        for index in aminoAcids.indices {
            aminoAcids[index].center =
                candidates[index]
        }

        calculateCoupling()

        stability =
            min(
                max(
                    0.55 * bQ +
                    0.45 * parameters.coherence,
                    0
                ),
                1
            )

        progress = 0.82
    }

    // MARK: Validation

    private func validateModel() {

        let bondFraction: Double

        if peptideBonds.isEmpty {
            bondFraction = 0
        } else {

            let accepted =
                peptideBonds.filter {
                    $0.accepted
                }.count

            bondFraction =
                Double(accepted) /
                Double(peptideBonds.count)
        }

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
    }
}

// MARK: - SceneKit

struct PeptideSceneView: UIViewRepresentable {

    @ObservedObject var engine: PeptideSimulationEngine

   
        func makeUIView(
            context: Context
        ) -> SCNView {

            let view = SCNView()

            view.backgroundColor =
                UIColor.black

            view.allowsCameraControl = true
            view.autoenablesDefaultLighting = true

            let scene = SCNScene()
            view.scene = scene

            // Camera belongs to the scene hierarchy,
            // but pointOfView belongs to SCNView.
            let cameraNode = addCamera(
                to: scene
            )

            view.pointOfView =
                cameraNode

            // Single visualization container.
            let container = SCNNode()
            container.name = "peptideContent"

            scene.rootNode.addChildNode(
                container
            )

            updateContentNode(
                container
            )

            return view
        }

        // MARK: - Update View

        func updateUIView(
            _ view: SCNView,
            context: Context
        ) {

            guard let scene = view.scene else {
                return
            }

            // Ensure the view always has a camera.
            if view.pointOfView == nil {

                let cameraNode = addCamera(
                    to: scene
                )

                view.pointOfView =
                    cameraNode
            }

            // Remove the old peptide visualization.
            scene.rootNode.childNodes
                .filter {
                    $0.name == "peptideContent"
                }
                .forEach {
                    $0.removeFromParentNode()
                }

            // Create one canonical visualization container.
            let container = SCNNode()
            container.name = "peptideContent"

            scene.rootNode.addChildNode(
                container
            )

            updateContentNode(
                container
            )
        }

        // MARK: - Content

        private func updateContentNode(
            _ container: SCNNode
        ) {

            if engine.stage.rawValue >=
                PeptideStage.aminoAcidAssembly.rawValue {

                addAminoAcids(
                    to: container
                )

            } else {

                addAtoms(
                    to: container
                )
            }

            if engine.stage.rawValue >=
                PeptideStage.peptideBond.rawValue {

                addAcceptedBonds(
                    to: container
                )
            }
        }

        // MARK: - Camera

        private func addCamera(
            to scene: SCNScene
        ) -> SCNNode {

            let cameraNode = SCNNode()

            let camera = SCNCamera()

            camera.zNear = 0.01
            camera.zFar = 100.0

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

            return cameraNode
        }

        // MARK: - Atoms

        private func addAtoms(
            to parent: SCNNode
        ) {

            for atom in engine.atoms {

                let sphere =
                    SCNSphere(
                        radius:
                            CGFloat(
                                atom.element.radius
                            )
                    )

                let material =
                    SCNMaterial()

                material.diffuse.contents =
                    elementColor(
                        atom.element
                    )

                sphere.materials = [
                    material
                ]

                let node =
                    SCNNode(
                        geometry: sphere
                    )

                node.position =
                    SCNVector3(
                        atom.position.x,
                        atom.position.y,
                        atom.position.z
                    )

                parent.addChildNode(
                    node
                )
            }
        }

        // MARK: - Amino Acids

        private func addAminoAcids(
            to parent: SCNNode
        ) {

            for aminoAcid in engine.aminoAcids {

                let sphere =
                    SCNSphere(
                        radius: 0.55
                    )

                let material =
                    SCNMaterial()

                let brightness =
                    0.25 +
                    0.65 *
                    CGFloat(
                        min(
                            max(
                                engine.bQ,
                                0.0
                            ),
                            1.0
                        )
                    )

                material.diffuse.contents =
                    UIColor(
                        white: brightness,
                        alpha: 1.0
                    )

                sphere.materials = [
                    material
                ]

                let node =
                    SCNNode(
                        geometry: sphere
                    )

                node.position =
                    SCNVector3(
                        aminoAcid.center.x,
                        aminoAcid.center.y,
                        aminoAcid.center.z
                    )

                parent.addChildNode(
                    node
                )
            }
        }

        // MARK: - Accepted Peptide Bonds

        private func addAcceptedBonds(
            to parent: SCNNode
        ) {

            for bond in engine.peptideBonds
            where bond.accepted {

                guard
                    bond.firstResidue >= 0,
                    bond.firstResidue <
                        engine.aminoAcids.count,
                    bond.secondResidue >= 0,
                    bond.secondResidue <
                        engine.aminoAcids.count
                else {
                    continue
                }

                let a =
                    engine.aminoAcids[
                        bond.firstResidue
                    ].center

                let b =
                    engine.aminoAcids[
                        bond.secondResidue
                    ].center

                addBond(
                    from: a,
                    to: b,
                    parent: parent
                )
            }
        }

        // MARK: - Bond Geometry

        private func addBond(
            from a: SIMD3<Float>,
            to b: SIMD3<Float>,
            parent: SCNNode
        ) {

            let dx =
                b.x - a.x

            let dy =
                b.y - a.y

            let dz =
                b.z - a.z

            let distance =
                sqrt(
                    dx * dx +
                    dy * dy +
                    dz * dz
                )

            guard distance > 0.001 else {
                return
            }

            let cylinder =
                SCNCylinder(
                    radius: 0.08,
                    height:
                        CGFloat(distance)
                )

            let material =
                SCNMaterial()

            material.diffuse.contents =
                UIColor.white

            cylinder.materials = [
                material
            ]

            let node =
                SCNNode(
                    geometry: cylinder
                )

            node.position =
                SCNVector3(
                    (a.x + b.x) / 2,
                    (a.y + b.y) / 2,
                    (a.z + b.z) / 2
                )

            // SCNCylinder's longitudinal axis
            // is Y. Rotate that axis toward
            // the bond direction.
            let direction =
                SCNVector3(
                    dx,
                    dy,
                    dz
                )

            let length =
                sqrt(
                    direction.x * direction.x +
                    direction.y * direction.y +
                    direction.z * direction.z
                )

            guard length > 0.001 else {
                return
            }

            let normalized =
                SCNVector3(
                    direction.x / length,
                    direction.y / length,
                    direction.z / length
                )

            let up =
                SCNVector3(
                    0,
                    1,
                    0
                )

            let dot =
                up.x * normalized.x +
                up.y * normalized.y +
                up.z * normalized.z

            // Already aligned with Y.
            if dot > 0.9999 {

                node.eulerAngles =
                    SCNVector3(
                        0,
                        0,
                        0
                    )

            // Pointing opposite Y.
            } else if dot < -0.9999 {

                node.eulerAngles =
                    SCNVector3(
                        Float.pi,
                        0,
                        0
                    )

            } else {

                let axis =
                    SCNVector3(
                        up.y * normalized.z -
                        up.z * normalized.y,

                        up.z * normalized.x -
                        up.x * normalized.z,

                        up.x * normalized.y -
                        up.y * normalized.x
                    )

                let axisLength =
                    sqrt(
                        axis.x * axis.x +
                        axis.y * axis.y +
                        axis.z * axis.z
                    )

                guard axisLength > 0.0001 else {
                    parent.addChildNode(node)
                    return
                }

                let normalizedAxis =
                    SCNVector3(
                        axis.x / axisLength,
                        axis.y / axisLength,
                        axis.z / axisLength
                    )

                let angle =
                    acos(
                        max(
                            -1.0,
                            min(
                                1.0,
                                dot
                            )
                        )
                    )

                node.rotation =
                    SCNVector4(
                        normalizedAxis.x,
                        normalizedAxis.y,
                        normalizedAxis.z,
                        angle
                    )
            }

            parent.addChildNode(
                node
            )
        }

        // MARK: - Element Colors

        private func elementColor(
            _ element: ElementType
        ) -> UIColor {

            switch element {

            case .hydrogen:
                return .white

            case .carbon:
                return .gray

            case .nitrogen:
                return .blue

            case .oxygen:
                return .red

            case .sulfur:
                return .yellow
            }
        }

}

// MARK: - Content View

struct ContentView: View {

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

                    PeptideSceneView(
                        engine: engine
                    )
                    .frame(
                        height: 360
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                    )

                    stageCard

                    equationCard

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
            alignment: .leading,
            spacing: 6
        ) {

            Text(
                "Equation-Driven Molecular Assembly"
            )
            .font(
                .title2.bold()
            )

            Text(
                "Independent particles → molecular structure → peptide chain"
            )
            .font(
                .subheadline
            )
            .foregroundStyle(
                .secondary
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: Pipeline

    private var pipeline: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text("PIPELINE")
                .font(
                    .caption.bold()
                )

            ForEach(
                PeptideStage.allCases,
                id: \.self
            ) { stage in

                HStack {

                    Image(
                        systemName:
                            stage.rawValue <=
                            engine.stage.rawValue
                            ? "checkmark.circle.fill"
                            : "circle"
                    )

                    Text(
                        stage.title
                    )

                    Spacer()

                    if stage ==
                        engine.stage {

                        Text("CURRENT")
                            .font(
                                .caption2.bold()
                            )
                    }
                }
                .foregroundStyle(
                    stage.rawValue <=
                    engine.stage.rawValue
                    ? .primary
                    : .secondary
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.secondary
                    .opacity(0.10)
            )
        )
    }

    // MARK: Stage

    private var stageCard: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(
                engine.stage.title
            )
            .font(
                .title3.bold()
            )

            Text(
                engine.stage.explanation
            )
            .foregroundStyle(
                .secondary
            )

            ProgressView(
                value: engine.progress
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.secondary
                    .opacity(0.10)
            )
        )
    }

    // MARK: Equations

    private var equationCard: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text("QRTL EQUATIONS")
                .font(
                    .headline
                )

            Text(
                "B_Q = I_Q · R · D · F · P · O"
            )
            .font(
                .system(.body, design: .monospaced)
            )

            Text(
                "E_QRTL = −B_Q · C · cos(Δφ) · ρ"
            )
            .font(
                .system(.body, design: .monospaced)
            )

            Text(
                "E_effective = E_classical + E_QRTL"
            )
            .font(
                .system(.body, design: .monospaced)
            )

            Text(
                "The QRTL terms are model assumptions used by this simulation."
            )
            .font(
                .caption
            )
            .foregroundStyle(
                .secondary
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.secondary
                    .opacity(0.10)
            )
        )
    }

    // MARK: Metrics

    private var metricsCard: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("LIVE MODEL STATE")
                .font(
                    .headline
                )

            metric(
                "B_Q",
                engine.bQ
            )

            metric(
                "QRTL Energy",
                engine.qrtlEnergy
            )

            metric(
                "Effective Energy",
                engine.effectiveEnergy
            )

            metric(
                "Coupling",
                engine.coupling
            )

            metric(
                "Phase Error",
                engine.phaseError
            )

            metric(
                "Stability",
                engine.stability
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.secondary
                    .opacity(0.10)
            )
        )
    }

    private func metric(
        _ name: String,
        _ value: Double
    ) -> some View {

        HStack {

            Text(name)

            Spacer()

            Text(
                String(
                    format: "%.4f",
                    value
                )
            )
            .font(
                .system(
                    .body,
                    design: .monospaced
                )
            )
        }
    }

    // MARK: Validation

    private var validationCard: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text("VALIDATION")
                .font(
                    .headline
                )

            Text(
                "A valid simulation result requires accepted coupling, stable molecular configuration, and accepted peptide-bond candidates."
            )

            Text(
                "Residues: \(engine.aminoAcids.count)"
            )

            Text(
                "Candidate bonds: \(engine.peptideBonds.count)"
            )

            Text(
                "Accepted bonds: \(engine.peptideBonds.filter { $0.accepted }.count)"
            )

            Text(
                "Final stability: " +
                String(
                    format: "%.3f",
                    engine.stability
                )
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.secondary
                    .opacity(0.10)
            )
        )
    }

    // MARK: Controls

    private var controls: some View {

        HStack {

            Button("Reset") {
                engine.reset()
            }

            Button("Previous") {
                engine.previous()
            }
            .disabled(
                engine.stage == .independentParticles
            )

            Spacer()

            Button(
                engine.stage == .validation
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

// MARK: - Preview

#Preview {
    ContentView()
}

