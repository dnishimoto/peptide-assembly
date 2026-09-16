//
// MolecularAssemblyPipeline.swift
// Peptide Assembly
//
// Implements the generalized molecular-assembly diagnostic pipeline.
//
// Peptide target used by the diagnostic:
// Gly–Gly–Gly–Gly
//
// Final structure when all three peptide bonds form:
//
// NH₂–CH₂–CO–NH–CH₂–CO–NH–CH₂–CO–NH–CH₂–COOH
//
// The QRTL quantities in this file are model quantities. They should not
// be represented as experimentally established physical laws without
// experimental validation.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Molecular Assembly Stages

enum MolecularAssemblyStage: Int, CaseIterable, Identifiable {
case peptideBuildingBlocks = 1
case drugIntermediate = 2
case api = 3
case nucleotide = 4
case oligonucleotide = 5
case heterocycle = 6
case chirality = 7
case specialtyCompound = 8

var id: Int {
    rawValue
}

var title: String {
    switch self {
    case .peptideBuildingBlocks:
        return "Peptide Building Blocks"

    case .drugIntermediate:
        return "Drug Intermediate"

    case .api:
        return "Active Pharmaceutical Ingredient"

    case .nucleotide:
        return "Nucleoside / Nucleotide"

    case .oligonucleotide:
        return "Oligonucleotide"

    case .heterocycle:
        return "Complex Heterocycle"

    case .chirality:
        return "Chiral Molecule"

    case .specialtyCompound:
        return "Specialty Pharmaceutical Compound"
    }
}

}

// MARK: - Peptide Residue

struct PeptideResidue: Identifiable, Hashable {

let id = UUID()

let name: String
let residueFormula: String

init(
    name: String,
    residueFormula: String
) {
    self.name = name
    self.residueFormula = residueFormula
}

static let glycine = PeptideResidue(
    name: "Gly",
    residueFormula: "–CH₂–"
)

}

// MARK: - Bond Formation Result

struct BondEvaluation {

let formed: Bool
let failureReason: String?

}

// MARK: - Peptide Bond Diagnostic

struct PeptideBondDiagnostic: Identifiable {

let id = UUID()

let bondNumber: Int

let firstResidue: String
let secondResidue: String

// Cellular-automaton energy transport
let initialEnergy: Double
let finalEnergy: Double
let transportedEnergy: Double

// Local QRTL state
let localEnergyDensity: Double
let qrtlField: Double
let coherence: Double
let phaseDifference: Double

// QRTL pressure
let pressureA: Double
let pressureB: Double
let deltaPressure: Double

// Bond condition
let bondEnergy: Double

// Final result
let formed: Bool
let failureReason: String?

}

// MARK: - Molecular Stage Diagnostic

struct MolecularStageDiagnostic: Identifiable {

let id = UUID()

let stage: MolecularAssemblyStage
let status: String

let details: [String: String]

let passed: Bool

}

// MARK: - QRTL Bond Evaluation

func evaluateQRTLBondFormation(
deltaPressure: Double,
allowableDeltaPressure: Double,

bondEnergy: Double,
minimumBondEnergy: Double,

coherence: Double,
minimumCoherence: Double,

phaseDifference: Double,
maximumPhaseDifference: Double

) -> BondEvaluation {

// ---------------------------------------------------------
// 1. ΔP gate
// ---------------------------------------------------------

guard abs(deltaPressure) <= allowableDeltaPressure else {

    return BondEvaluation(
        formed: false,
        failureReason:
            "ΔP is outside the allowable bond-formation range."
    )
}

// ---------------------------------------------------------
// 2. Local bond-energy gate
// ---------------------------------------------------------

guard bondEnergy >= minimumBondEnergy else {

    return BondEvaluation(
        formed: false,
        failureReason:
            "Local bond energy is below the configured threshold."
    )
}

// ---------------------------------------------------------
// 3. Coherence gate
// ---------------------------------------------------------

guard coherence >= minimumCoherence else {

    return BondEvaluation(
        formed: false,
        failureReason:
            "QRTL coherence is below the configured threshold."
    )
}

// ---------------------------------------------------------
// 4. Phase gate
// ---------------------------------------------------------

guard abs(phaseDifference) <= maximumPhaseDifference else {

    return BondEvaluation(
        formed: false,
        failureReason:
            "Phase difference exceeds the configured tolerance."
    )
}

return BondEvaluation(
    formed: true,
    failureReason: nil
)

}

// MARK: - Molecular Assembly Pipeline

@MainActor
final class MolecularAssemblyPipeline: ObservableObject {

// ---------------------------------------------------------
// Published state
// ---------------------------------------------------------

@Published private(set) var stageDiagnostics:
    [MolecularStageDiagnostic] = []

@Published private(set) var peptideBondDiagnostics:
    [PeptideBondDiagnostic] = []

@Published private(set) var currentStage:
    MolecularAssemblyStage = .peptideBuildingBlocks

@Published private(set) var finalMolecule:
    String = ""

@Published private(set) var isPeptide:
    Bool = false

@Published private(set) var status:
    String = "Not Started"

// ---------------------------------------------------------
// Bond-formation thresholds
//
// These are explicit MODEL thresholds.
// They are not experimental constants.
// ---------------------------------------------------------

var allowableDeltaPressure: Double = 0.50

var minimumBondEnergy: Double = 0.10

var minimumCoherence: Double = 0.70

var maximumPhaseDifference: Double = .pi / 4

// ---------------------------------------------------------
// Initialization
// ---------------------------------------------------------

init() {

    buildStageDiagnostics()
}

// MARK: Reset

func reset() {

    stageDiagnostics.removeAll()

    peptideBondDiagnostics.removeAll()

    currentStage = .peptideBuildingBlocks

    finalMolecule = ""

    isPeptide = false

    status = "Not Started"

    buildStageDiagnostics()
}

// MARK: Complete Gly4 Diagnostic

/// Runs the complete diagnostic pipeline for:
///
/// Gly–Gly–Gly–Gly
///
/// The CA implementation remains external to this pipeline.
/// ContentView / PeptideSimulationEngine supplies the callbacks
/// for energy transport and QRTL calculations.
func runGly4Diagnostic(

    transportEnergy:
        @escaping () -> (
            initial: Double,
            final: Double
        ),

    localEnergyDensity:
        @escaping (Int) -> Double,

    qrtlField:
        @escaping (Int) -> Double,

    coherence:
        @escaping (Int) -> Double,

    phaseDifference:
        @escaping (Int) -> Double,

    pressure:
        @escaping (
            Int,
            Int
        ) -> Double,

    createBond:
        @escaping (Int) -> Void
) {

    reset()

    status = "Running"

    currentStage =
        .peptideBuildingBlocks

    // -----------------------------------------------------
    // STAGE 1
    // Building blocks
    // -----------------------------------------------------

    let residues =
        Array(
            repeating: PeptideResidue.glycine,
            count: 4
        )

    // -----------------------------------------------------
    // CELLULAR AUTOMATON
    //
    // The CA transports / redistributes the supplied energy.
    // -----------------------------------------------------

    let energy = transportEnergy()

    let initialEnergy =
        energy.initial

    let finalEnergy =
        energy.final

    let transportedEnergy =
        abs(finalEnergy - initialEnergy)

    // Energy must be available to continue the diagnostic.
    guard transportedEnergy >= 0 else {

        status =
            "Cellular-automaton energy transport failed"

        return
    }

    // -----------------------------------------------------
    // THREE PEPTIDE BONDS
    // -----------------------------------------------------

    for bondIndex in 0..<3 {

        currentStage =
            .peptideBuildingBlocks

        // -------------------------------------------------
        // Local QRTL energy density
        // -------------------------------------------------

        let density =
            localEnergyDensity(
                bondIndex
            )

        // -------------------------------------------------
        // QRTL field
        // -------------------------------------------------

        let field =
            qrtlField(
                bondIndex
            )

        // -------------------------------------------------
        // Coherence
        // -------------------------------------------------

        let bondCoherence =
            coherence(
                bondIndex
            )

        // -------------------------------------------------
        // Phase difference
        // -------------------------------------------------

        let phase =
            phaseDifference(
                bondIndex
            )

        // -------------------------------------------------
        // QRTL pressure on each side of the bond
        //
        // side = -1 → left
        // side = +1 → right
        // -------------------------------------------------

        let pressureA =
            pressure(
                bondIndex,
                -1
            )

        let pressureB =
            pressure(
                bondIndex,
                1
            )

        // -------------------------------------------------
        // Pressure difference
        // -------------------------------------------------

        let deltaP =
            pressureA - pressureB

        // -------------------------------------------------
        // Model bond-energy calculation
        // -------------------------------------------------

        let bondEnergy =
            density *
            field *
            bondCoherence *
            max(
                0,
                cos(phase)
            )

        // -------------------------------------------------
        // Bond formation gate
        // -------------------------------------------------

        let evaluation =
            evaluateQRTLBondFormation(

                deltaPressure:
                    deltaP,

                allowableDeltaPressure:
                    allowableDeltaPressure,

                bondEnergy:
                    bondEnergy,

                minimumBondEnergy:
                    minimumBondEnergy,

                coherence:
                    bondCoherence,

                minimumCoherence:
                    minimumCoherence,

                phaseDifference:
                    phase,

                maximumPhaseDifference:
                    maximumPhaseDifference
            )

        // -------------------------------------------------
        // Create diagnostic card data
        // -------------------------------------------------

        let diagnostic =
            PeptideBondDiagnostic(

                bondNumber:
                    bondIndex + 1,

                firstResidue:
                    residues[bondIndex].name,

                secondResidue:
                    residues[bondIndex + 1].name,

                initialEnergy:
                    initialEnergy,

                finalEnergy:
                    finalEnergy,

                transportedEnergy:
                    transportedEnergy,

                localEnergyDensity:
                    density,

                qrtlField:
                    field,

                coherence:
                    bondCoherence,

                phaseDifference:
                    phase,

                pressureA:
                    pressureA,

                pressureB:
                    pressureB,

                deltaPressure:
                    deltaP,

                bondEnergy:
                    bondEnergy,

                formed:
                    evaluation.formed,

                failureReason:
                    evaluation.failureReason
            )

        peptideBondDiagnostics.append(
            diagnostic
        )

        // -------------------------------------------------
        // BLOCKED BOND
        // -------------------------------------------------

        guard evaluation.formed else {

            status =
                "BLOCKED at peptide bond \(bondIndex + 1)"

            finalMolecule =
                residues
                    .prefix(bondIndex + 1)
                    .map { $0.name }
                    .joined(
                        separator: "–"
                    )

            isPeptide =
                peptideBondDiagnostics
                    .contains {
                        $0.formed
                    }

            buildStageDiagnostics()

            return
        }

        // -------------------------------------------------
        // FORM ACTUAL MOLECULAR CONNECTION
        // -------------------------------------------------

        createBond(
            bondIndex
        )
    }

    // -----------------------------------------------------
    // ALL THREE BONDS FORMED
    // -----------------------------------------------------

    currentStage =
        .specialtyCompound

    finalMolecule =
        "NH₂–CH₂–CO–NH–CH₂–CO–NH–CH₂–CO–NH–CH₂–COOH"

    isPeptide =
        peptideBondDiagnostics.count == 3 &&
        peptideBondDiagnostics.allSatisfy {
            $0.formed
        }

    status =
        isPeptide
        ? "Complete: Gly–Gly–Gly–Gly tetrapeptide"
        : "Incomplete"

    buildStageDiagnostics()
}

// MARK: Stage Diagnostics

private func buildStageDiagnostics() {

    let peptideComplete =
        peptideBondDiagnostics.count == 3 &&
        peptideBondDiagnostics.allSatisfy {
            $0.formed
        }

    stageDiagnostics = [

        // -------------------------------------------------
        // 1
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .peptideBuildingBlocks,

            status:
                "READY",

            details: [

                "Target":
                    "Gly–Gly–Gly–Gly",

                "Building block":
                    "H₂N–CH₂–COOH",

                "Building blocks":
                    "4 glycine residues",

                "Peptide bonds required":
                    "3",

                "Sequence":
                    "Gly–Gly–Gly–Gly"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 2
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .drugIntermediate,

            status:
                "CHECKPOINT",

            details: [

                "Role":
                    "General molecular-assembly checkpoint",

                "Gly₄ relevance":
                    "Not required for the peptide test"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 3
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .api,

            status:
                "CHECKPOINT",

            details: [

                "Role":
                    "API classification checkpoint",

                "Gly₄ result":
                    "Not an API by this test"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 4
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .nucleotide,

            status:
                "NOT APPLICABLE",

            details: [

                "Target":
                    "Peptide",

                "Nucleotide structure":
                    "Not required"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 5
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .oligonucleotide,

            status:
                "NOT APPLICABLE",

            details: [

                "Target":
                    "Peptide",

                "Nucleotide sequence":
                    "Not required"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 6
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .heterocycle,

            status:
                "NOT APPLICABLE",

            details: [

                "Target":
                    "Gly₄",

                "Required ring":
                    "None"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 7
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .chirality,

            status:
                "CHECKED",

            details: [

                "Residue":
                    "Glycine",

                "Alpha-carbon chirality":
                    "Achiral",

                "Stereochemical ambiguity":
                    "None at the glycine alpha carbon"
            ],

            passed:
                true
        ),

        // -------------------------------------------------
        // 8
        // -------------------------------------------------

        MolecularStageDiagnostic(

            stage:
                .specialtyCompound,

            status:
                peptideComplete
                ? "COMPLETE"
                : "INCOMPLETE",

            details: [

                "Final structure":
                    peptideComplete
                    ? finalMolecule
                    : (
                        finalMolecule.isEmpty
                        ? "Not completed"
                        : finalMolecule
                    ),

                "Classification":
                    peptideComplete
                    ? "Tetrapeptide"
                    : "Incomplete peptide chain",

                "Peptide bonds formed":
                    "\(peptideBondDiagnostics.filter { $0.formed }.count) / 3",

                "Experimental validation":
                    "Not established by this simulation"
            ],

            passed:
                peptideComplete
        )
    ]
}

}

// MARK: - Diagnostic Card

struct MolecularAssemblyDiagnosticCard: View {

let diagnostic:
    MolecularStageDiagnostic

var body: some View {

    VStack(
        alignment: .leading,
        spacing: 8
    ) {

        HStack {

            Text(
                "Stage \(diagnostic.stage.rawValue)"
            )
            .font(.headline)

            Spacer()

            Text(
                diagnostic.status
            )
            .font(.caption.bold())
        }

        Text(
            diagnostic.stage.title
        )
        .font(.subheadline)

        Divider()

        ForEach(
            diagnostic.details.sorted(
                by: {
                    $0.key < $1.key
                }
            ),
            id: \.key
        ) { item in

            HStack(
                alignment: .top
            ) {

                Text(
                    item.key
                )

                Spacer()

                Text(
                    item.value
                )
                .multilineTextAlignment(
                    .trailing
                )
            }
            .font(.caption)
        }

        Divider()

        Text(
            diagnostic.passed
            ? "STATUS: PASS"
            : "STATUS: BLOCKED"
        )
        .font(.headline)
    }
    .padding()
    .background(
        .regularMaterial
    )
    .clipShape(
        RoundedRectangle(
            cornerRadius: 12
        )
    )
}


}

// MARK: - Peptide Bond Diagnostic Card

struct PeptideBondDiagnosticCard: View {


let diagnostic:
    PeptideBondDiagnostic

private func format(
    _ value: Double
) -> String {

    String(
        format: "%.6g",
        value
    )
}

var body: some View {

    VStack(
        alignment: .leading,
        spacing: 8
    ) {

        // -------------------------------------------------
        // Header
        // -------------------------------------------------

        HStack {

            Text(
                "Peptide Bond \(diagnostic.bondNumber)"
            )
            .font(.headline)

            Spacer()

            Text(
                diagnostic.formed
                ? "FORMED"
                : "BLOCKED"
            )
            .fontWeight(.bold)
        }

        Text(
            "\(diagnostic.firstResidue) → \(diagnostic.secondResidue)"
        )
        .font(.subheadline)

        Divider()

        // -------------------------------------------------
        // CA transport
        // -------------------------------------------------

        Text(
            "CELLULAR AUTOMATON"
        )
        .font(.caption.bold())

        diagnosticRow(
            "Initial energy",
            format(
                diagnostic.initialEnergy
            )
        )

        diagnosticRow(
            "Final energy",
            format(
                diagnostic.finalEnergy
            )
        )

        diagnosticRow(
            "Transported / redistributed energy",
            format(
                diagnostic.transportedEnergy
            )
        )

        Divider()

        // -------------------------------------------------
        // Local QRTL state
        // -------------------------------------------------

        Text(
            "LOCAL QRTL STATE"
        )
        .font(.caption.bold())

        diagnosticRow(
            "Energy density",
            format(
                diagnostic.localEnergyDensity
            )
        )

        diagnosticRow(
            "QRTL field",
            format(
                diagnostic.qrtlField
            )
        )

        diagnosticRow(
            "Coherence",
            format(
                diagnostic.coherence
            )
        )

        diagnosticRow(
            "Phase difference",
            format(
                diagnostic.phaseDifference
            )
        )

        Divider()

        // -------------------------------------------------
        // Pressure
        // -------------------------------------------------

        Text(
            "QRTL PRESSURE"
        )
        .font(.caption.bold())

        diagnosticRow(
            "Pressure A",
            format(
                diagnostic.pressureA
            )
        )

        diagnosticRow(
            "Pressure B",
            format(
                diagnostic.pressureB
            )
        )

        diagnosticRow(
            "ΔP",
            format(
                diagnostic.deltaPressure
            )
        )

        Divider()

        // -------------------------------------------------
        // Bond result
        // -------------------------------------------------

        Text(
            "BOND-FORMATION TEST"
        )
        .font(.caption.bold())

        diagnosticRow(
            "Bond energy",
            format(
                diagnostic.bondEnergy
            )
        )

        HStack {

            Text(
                "Result"
            )

            Spacer()

            Text(
                diagnostic.formed
                ? "PEPTIDE BOND FORMED"
                : "PEPTIDE BOND BLOCKED"
            )
            .fontWeight(.bold)
        }

        if let reason =
            diagnostic.failureReason {

            Text(
                reason
            )
            .font(.caption)
        }
    }
    .padding()
    .background(
        .regularMaterial
    )
    .clipShape(
        RoundedRectangle(
            cornerRadius: 12
        )
    )
}

private func diagnosticRow(
    _ title: String,
    _ value: String
) -> some View {

    HStack {

        Text(
            title
        )

        Spacer()

        Text(
            value
        )
        .monospacedDigit()
    }
    .font(.caption)
}


}

// MARK: - Complete Diagnostic View

struct MolecularAssemblyDiagnosticList: View {

@ObservedObject
var pipeline:
    MolecularAssemblyPipeline

var body: some View {

    ScrollView {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text(
                "Molecular Assembly Diagnostics"
            )
            .font(.title2.bold())

            Text(
                pipeline.status
            )
            .font(.headline)

            // -------------------------------------------------
            // Eight molecular-assembly stage cards
            // -------------------------------------------------

            ForEach(
                pipeline.stageDiagnostics
            ) { diagnostic in

                MolecularAssemblyDiagnosticCard(
                    diagnostic:
                        diagnostic
                )
            }

            // -------------------------------------------------
            // Individual peptide-bond cards
            // -------------------------------------------------

            ForEach(
                pipeline.peptideBondDiagnostics
            ) { diagnostic in

                PeptideBondDiagnosticCard(
                    diagnostic:
                        diagnostic
                )
            }

            // -------------------------------------------------
            // Final molecule
            // -------------------------------------------------

            if pipeline.isPeptide {

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text(
                        "FINAL MOLECULE"
                    )
                    .font(.headline)

                    Text(
                        pipeline.finalMolecule
                    )
                    .font(
                        .body.monospaced()
                    )

                    Text(
                        "Classification: Tetrapeptide"
                    )
                    .font(.headline)

                    Text(
                        "Three peptide bonds formed."
                    )
                    .font(.caption)
                }
                .padding()
                .background(
                    .regularMaterial
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
            }
        }
        .padding()
    }
}

}
