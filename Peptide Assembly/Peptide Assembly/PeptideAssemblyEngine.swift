//
//  File.swift
//  Peptide Assembly
//
//  Created by David Nishimoto on 9/16/26.
//

import Foundation
import Combine
import SwiftUI
import SceneKit

final class PeptideAssemblyEngine: ObservableObject {

    // Controlled inputs.
    // These are dimensionless model controls until experimentally calibrated.
    @Published var qrtlCurrent: Double = 0.0 {
        didSet { recalculate() }
    }

    @Published var resonanceFrequency: Double = 1.0 {
        didSet { recalculate() }
    }

    @Published var coherence: Double = 0.50 {
        didSet { recalculate() }
    }

    @Published private(set) var stageIndex = 0
    @Published private(set) var running = false
    @Published private(set) var cells: [LatticeCell] = []
    @Published private(set) var aminoAcids: [AminoAcidUnit] = []

    @Published private(set) var fieldValue = 0.0
    @Published private(set) var qrtlEnergy = 0.0
    @Published private(set) var chemicalEnergy = 0.0
    @Published private(set) var effectiveEnergy = 0.0
    @Published private(set) var transitionProbability = 0.0
    @Published private(set) var foldingEnergy = 0.0

    // Neighbor-flow diagnostics. This confidence describes the implementation
    // of the computational conservation mechanism, not physical validation of QRTL.
    @Published private(set) var neighborFlowConfidence = 0.90
    @Published private(set) var totalTwistCurrent = 0.0
    @Published private(set) var globalFlowConservationError = 0.0

    @Published private(set) var organizedAtomCount = 0
    @Published private(set) var aminoAcidCount = 0
    @Published private(set) var peptideBondCount = 0
    @Published private(set) var peptideLength = 0

    @Published private(set) var statusMessage =
        "QRTL is currently off. The control condition is established."

    @Published private(set) var latestBondDiagnostic: PeptideBondDiagnostic?
    @Published var bondFailureMessage: String?

    let allowableDeltaPressure = 0.50
    let minimumBondEnergy = 0.10
    let minimumBondCoherence = 0.70
    let maximumPhaseDifference = Double.pi / 4.0

    let temperature = 298.15
    let boltzmannConstant = 1.380649e-23

    // Normalized energy scale. The app explicitly does not claim
    // these values are joules. A calibrated implementation must replace
    // this with experimentally defined energy units.
    let modelKBT = 1.0

    // Proposed/model-defined QRTL coefficients.
    var qrtlFieldGain = 1.0
    var qrtlEnergyCoupling = 0.25
    var phaseCoupling = 0.20
    var densityCoupling = 0.10
    
    var qrtlDriveAmplitude = 6.0
    var minimumTransportEnergy = 0.001


    // Neighbor-flow transport controls. The flow is antisymmetric between
    // each pair, so a transfer out of one cell is the same transfer into the other.
    // These are dimensionless model controls until experimentally calibrated.
    var neighborFlowCoupling = 0.12
    var neighborFlowDecay = 0.42
    var neighborFlowTimeStep = 0.10

    // Coarse-grained chemical terms for visualization.
    // They are not a molecular force field.
    var chemicalBondScale = 0.35
    var orientationPenalty = 0.40
    var distancePenalty = 0.30

    private var timer: Timer?

    let programmedSequence = ["Gly", "Gly", "Gly", "Gly"]

    let stages: [PeptideStage] = [
        PeptideStage(
            number: "01", title: "Controlled Initial Condition",
            equation: "I_QRTL = 0  →  B_Q = 0  →  E_QRTL = 0",
            whatHappened: "The control system begins with the proposed QRTL contribution disabled. The chemical model is isolated from the QRTL term.",
            whyItMatters: "A control condition provides the baseline against which a QRTL-enabled calculation can be compared.",
            analogy: "The orchestra begins before the conductor gives the timing signal."
        ),
        PeptideStage(
            number: "02", title: "Apply QRTL Current",
            equation: "I_QRTL  →  B_Q(r,t)",
            whatHappened: "A controlled QRTL current is applied as an input to the model-defined QRTL field.",
            whyItMatters: "The current must have a defined relationship to the field before any molecular effect can be attributed to QRTL.",
            analogy: "The conductor raises the baton and establishes the timing environment."
        ),
        PeptideStage(
            number: "03", title: "Establish Resonance",
            equation: "R = g(f_QRTL, φ_QRTL, C)",
            whatHappened: "The field is given a controlled resonance frequency, phase relationship, and coherence.",
            whyItMatters: "The proposed mechanism is supposed to depend on controlled current and resonance, so these variables remain explicit rather than hidden.",
            analogy: "The musicians synchronize to a common tempo."
        ),
        PeptideStage(
            number: "04", title: "Calculate QRTL Field",
            equation: "B_Q(r,t) = G(I_QRTL, r) · R",
            whatHappened: "Each lattice location receives a model-defined field value based on current, position, resonance, and coherence.",
            whyItMatters: "The field becomes a spatial input to local energy rather than a command to create a molecule.",
            analogy: "The timing signal reaches each section of the orchestra."
        ),
        PeptideStage(
            number: "05", title: "Local QRTL Energy",
            equation: "E_QRTL = f(B_Q, C, Δφ, ρ)",
            whatHappened: "The local field, coherence, phase relationship, and molecular density are combined into the QRTL energy contribution.",
            whyItMatters: "This is the first point where the proposed QRTL mechanism produces a quantitative energetic consequence.",
            analogy: "The conductor changes how strongly nearby notes reinforce one another."
        ),
        PeptideStage(
            number: "06", title: "Chemical Energy",
            equation: "E_chemical = Σ E_local + E_interaction",
            whatHappened: "The coarse-grained chemical model evaluates local molecular energies and neighboring interactions independently of QRTL.",
            whyItMatters: "The QRTL contribution must be distinguishable from ordinary chemistry.",
            analogy: "Each musician still has ordinary musical rules."
        ),
        PeptideStage(
            number: "07", title: "Effective Molecular Energy",
            equation: "E_effective = E_chemical + E_QRTL",
            whatHappened: "Chemical and QRTL contributions are combined into the model's effective energy landscape.",
            whyItMatters: "This equation establishes the causal bridge between the proposed QRTL term and molecular state evolution.",
            analogy: "The ordinary score and the conductor's timing now operate together."
        ),
        PeptideStage(
            number: "08", title: "Cellular-Automaton Evolution",
            equation: "S_i(t+Δt)=F[S_i,S_neighbors,E_chemical,E_QRTL,orientation]",
            whatHappened: "Each lattice cell evaluates its current state and neighboring states and updates its configuration from the calculated energy landscape.",
            whyItMatters: "The automaton is an evolution mechanism, not a hard-coded peptide generator.",
            analogy: "The score reader checks every nearby musician before the next note."
        ),
        PeptideStage(
            number: "09", title: "Atomic Organization",
            equation: "S_i → {C,H,N,O,S} according to local state energy",
            whatHappened: "The coarse-grained lattice populates carbon, hydrogen, nitrogen, oxygen, and sulfur states.",
            whyItMatters: "Atomic identities are retained; the QRTL term modifies the modeled energy landscape rather than replacing atomic structure.",
            analogy: "Individual notes settle into compatible positions."
        ),
        PeptideStage(
            number: "10", title: "Functional Groups",
            equation: "atomic configuration → amino/carboxyl functional groups",
            whatHappened: "Compatible atomic neighborhoods are grouped into model functional groups used by the peptide-assembly layer.",
            whyItMatters: "Peptide coupling depends on specific chemical groups, not simply on atoms being close.",
            analogy: "Notes become recognizable musical motifs."
        ),
        PeptideStage(
            number: "11", title: "Amino-Acid Formation",
            equation: "C,H,N,O,S configuration → amino-acid state",
            whatHappened: "The model recognizes programmed amino-acid-compatible configurations and creates coarse-grained amino-acid units.",
            whyItMatters: "The peptide stage must begin with identifiable amino-acid building blocks.",
            analogy: "Individual motifs combine into chords."
        ),
        PeptideStage(
            number: "12", title: "Molecular Orientation",
            equation: "O_i · O_j → orientation compatibility",
            whatHappened: "Adjacent amino acids are oriented so their modeled termini can approach with a defined geometry.",
            whyItMatters: "Correct chemical identity alone is insufficient; relative geometry matters.",
            analogy: "Two musicians synchronize their entrances."
        ),
        PeptideStage(
            number: "13", title: "Chemical Free-Energy Difference",
            equation: "ΔG_chemical = G_product − G_reactants",
            whatHappened: "The model evaluates the chemical free-energy difference between the current and candidate coupled states.",
            whyItMatters: "A transition must be evaluated energetically rather than selected merely because the sequence requests it.",
            analogy: "The orchestra checks whether the next transition fits the score."
        ),
        PeptideStage(
            number: "14", title: "QRTL Energy Difference",
            equation: "ΔE_QRTL = E_QRTL(product) − E_QRTL(reactants)",
            whatHappened: "The proposed QRTL contribution is recalculated for the candidate transition and compared with the reactant state.",
            whyItMatters: "This isolates the predicted QRTL effect on the transition.",
            analogy: "The conductor changes the timing pressure on the transition."
        ),
        PeptideStage(
            number: "15", title: "Effective Free Energy",
            equation: "ΔG_effective = ΔG_chemical + ΔE_QRTL",
            whatHappened: "Chemical and QRTL free-energy changes are combined.",
            whyItMatters: "This is the quantity that directly controls the transition probability in the proposed model.",
            analogy: "The musical transition is judged by both score and synchronization."
        ),
        PeptideStage(
            number: "16", title: "Transition Probability",
            equation: "P = 1 / [1 + exp(ΔG_effective / k_B T)]",
            whatHappened: "The effective free-energy difference is converted into a bounded transition probability.",
            whyItMatters: "Changing QRTL current or resonance therefore produces a measurable predicted change in transition probability.",
            analogy: "A well-synchronized transition becomes more likely to occur."
        ),
        PeptideStage(
            number: "17", title: "Controlled Peptide Coupling",
            equation: "P_transition + geometry + availability → peptide bond",
            whatHappened: "A coupling event is permitted only when the energy probability and geometric/bonding conditions meet the model threshold.",
            whyItMatters: "The peptide bond is an output of the calculated transition, not an unconditional command.",
            analogy: "Two compatible musical phrases become connected."
        ),
        PeptideStage(
            number: "18", title: "Condensation Product",
            equation: "amino acid + amino acid → peptide bond + H₂O",
            whatHappened: "A successful peptide-coupling event records the corresponding condensation product as water in the model.",
            whyItMatters: "The assembly step corresponds to the chemical concept of condensation rather than merely drawing a connecting line.",
            analogy: "The completed connection releases a small residual note."
        ),
        PeptideStage(
            number: "19", title: "Chain Growth",
            equation: "P_n + P_1 → P_(n+1)",
            whatHappened: "The coupled amino-acid units become a longer peptide chain, and the process can be repeated for the next programmed residue.",
            whyItMatters: "A peptide is a sequence of repeated coupling events rather than a single bond.",
            analogy: "A chord becomes a phrase, then a longer musical passage."
        ),
        PeptideStage(
            number: "20", title: "Repeat the Controlled Cycle",
            equation: "field → energy → CA → orientation → ΔG → P → bond",
            whatHappened: "The same equations are recalculated after each controlled assembly step.",
            whyItMatters: "A defensible model must preserve the same causal pipeline instead of switching to a different rule after the first bond.",
            analogy: "The orchestra repeatedly listens and adjusts."
        ),
        PeptideStage(
            number: "21", title: "Complete Programmed Sequence",
            equation: "P₁ + P₂ + … + P_n → programmed peptide",
            whatHappened: "The programmed sequence is complete when every required coupling event has been accepted.",
            whyItMatters: "The final chain is an accumulated result of individual transitions.",
            analogy: "The complete musical phrase has been performed."
        ),
        PeptideStage(
            number: "22", title: "Conformational Search",
            equation: "G_total = G_chemical + G_electrostatic + G_environment + G_QRTL",
            whatHappened: "The completed chain explores candidate three-dimensional conformations using multiple energy contributions.",
            whyItMatters: "Assembly and folding are distinct problems and should not be conflated.",
            analogy: "The full orchestra experiments with different arrangements."
        ),
        PeptideStage(
            number: "23", title: "Energy Ranking",
            equation: "G_total(q) → rank{q₁,q₂,…,q_n}",
            whatHappened: "Candidate conformations are ranked by the total modeled energy.",
            whyItMatters: "The visualization can show why one modeled conformation is preferred without claiming it is experimentally proven.",
            analogy: "Different performances are compared for stability and coherence."
        ),
        PeptideStage(
            number: "24", title: "Peptide Folding",
            equation: "q(t+Δt) → lower G_total(q) subject to constraints",
            whatHappened: "The chain is moved through a simplified conformational landscape toward lower-energy configurations.",
            whyItMatters: "Folding is an energy-landscape problem rather than a predetermined final drawing.",
            analogy: "The musicians settle into the most stable arrangement."
        ),
        PeptideStage(
            number: "25", title: "Stable Modeled Structure",
            equation: "∂G_total/∂q ≈ 0  and  ΔG > 0 for local perturbations",
            whatHappened: "The displayed conformation is treated as a local minimum of the simplified model.",
            whyItMatters: "The result is a modeled stable state, not proof of a real biological structure.",
            analogy: "The orchestra reaches a stable interpretation."
        ),
        PeptideStage(
            number: "26", title: "QRTL Control Comparison",
            equation: "ΔP = P(I_QRTL,f_QRTL,C) − P(0,f_QRTL,C)",
            whatHappened: "The model compares the predicted transition probability with QRTL enabled against the corresponding control.",
            whyItMatters: "A causal claim requires a control comparison rather than observing a single successful run.",
            analogy: "The same passage is played with and without the conductor's timing signal."
        ),
        PeptideStage(
            number: "27", title: "Experimental Prediction",
            equation: "measured ΔP ≈ modeled ΔP  ?",
            whatHappened: "The final panel states what would have to be measured before the proposed QRTL contribution could be considered experimentally supported.",
            whyItMatters: "The simulation becomes falsifiable only when its parameters and predictions can be compared with measurements.",
            analogy: "The orchestra's predicted effect is checked against a real performance."
        )
    ]

    var stage: PeptideStage {
        stages[stageIndex]
    }

    func start() {
        guard timer == nil else { return }
        reset()
        running = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            DispatchQueue.main.async { self?.advance() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        running = false
    }

    func toggleRunning() {
        if running { stop() } else { start() }
    }

    func reset() {
        stageIndex = 0
        cells = makeLattice()
        aminoAcids = []
        fieldValue = 0
        qrtlEnergy = 0
        chemicalEnergy = 0
        effectiveEnergy = 0
        transitionProbability = 0
        foldingEnergy = 0
        neighborFlowConfidence = 0.90
        totalTwistCurrent = 0
        globalFlowConservationError = 0
        organizedAtomCount = 0
        aminoAcidCount = 0
        peptideBondCount = 0
        peptideLength = 0
        latestBondDiagnostic = nil
        bondFailureMessage = nil
        statusMessage = "QRTL is currently off. The control condition is established."
        recalculate()
    }

    func previousStage() {
        stageIndex = max(0, stageIndex - 1)
        applyStage()
    }

    func nextStage() {
        stageIndex = min(stages.count - 1, stageIndex + 1)
        applyStage()
    }

    private func advance() {
        guard stageIndex < stages.count - 1 else {
            stop()
            return
        }
        stageIndex += 1
        applyStage()
    }

    // MARK: Pipeline calculations

    private func applyStage() {
        switch stageIndex {
        case 0: controlOff()
        case 1: applyCurrent()
        case 2: establishResonance()
        case 3: calculateField()
        case 4: calculateQRTLEnergy()
        case 5: calculateChemicalEnergy()
        case 6: calculateEffectiveEnergy()
        case 7: evolveCA()
        case 8: organizeAtoms()
        case 9: formFunctionalGroups()
        case 10: formAminoAcids()
        case 11: orientAminoAcids()
        case 12: calculateChemicalDeltaG()
        case 13: calculateQRTLDeltaE()
        case 14: calculateEffectiveDeltaG()
        case 15: calculateTransition()
        case 16: attemptCoupling()
        case 17: recordCondensation()
        case 18: growChain()
        case 19: repeatCycle()
        case 20: completeSequence()
        case 21: conformationalSearch()
        case 22: rankConformations()
        case 23: fold()
        case 24: stabilize()
        case 25: compareControl()
        case 26: prepareExperimentalPrediction()
        default: break
        }
        recalculate()
    }
    
    func calculateQRTLCurrent(
        distanceFactor: Double,
        orientationFactor: Double,
        coherence: Double,
        phaseDifference: Double,
        deltaPressure: Double,
        allowableDeltaPressure: Double,
        transportedEnergy: Double,
        minimumTransportEnergy: Double,
        qrtlDriveAmplitude: Double
    ) -> QRTLCurrentResult {
        let safeDistanceFactor =
            min(
                max(distanceFactor, 0.0),
                1.0
            )

        let safeOrientationFactor =
            min(
                max(orientationFactor, 0.0),
                1.0
            )

        let safeCoherence =
            min(
                max(coherence, 0.0),
                1.0
            )

        let phaseFactor =
            max(
                0.0,
                cos(phaseDifference)
            )

        let pressureBalanceFactor: Double

        if allowableDeltaPressure > 0 {
            pressureBalanceFactor =
                min(
                    max(
                        1.0 - abs(deltaPressure) / allowableDeltaPressure,
                        0.0
                    ),
                    1.0
                )
        } else {
            pressureBalanceFactor =
                abs(deltaPressure) <= 1.0e-12 ? 1.0 : 0.0
        }

        let transportFactor: Double

        if minimumTransportEnergy > 0 {
            transportFactor =
                min(
                    max(
                        transportedEnergy / minimumTransportEnergy,
                        0.0
                    ),
                    1.0
                )
        } else {
            transportFactor =
                transportedEnergy > 0 ? 1.0 : 0.0
        }

        let current =
            max(
                0.0,
                qrtlDriveAmplitude
            ) *
            safeDistanceFactor *
            safeOrientationFactor *
            safeCoherence *
            phaseFactor *
            pressureBalanceFactor *
            transportFactor

        return QRTLCurrentResult(
            current: current,
            driveAmplitude: qrtlDriveAmplitude,
            distanceFactor: safeDistanceFactor,
            orientationFactor: safeOrientationFactor,
            coherenceFactor: safeCoherence,
            phaseFactor: phaseFactor,
            pressureBalanceFactor: pressureBalanceFactor,
            transportFactor: transportFactor
        )
    }
    private func applyCurrent() {
        qrtlCurrent = qrtlDriveAmplitude

        calculateField()

        statusMessage =
            "Controlled QRTL source current applied to the model-defined field."
    }
    private func controlOff() {
        qrtlCurrent = 0.0
        fieldValue = 0.0
        qrtlEnergy = 0.0

        statusMessage =
            "Control: QRTL contribution disabled."
    }
   

  

    private func establishResonance() {
        calculateField()
        statusMessage = "Resonance and coherence are now explicit model inputs."
    }

    private func calculateField() {
        let resonanceResponse = exp(-pow((resonanceFrequency - 1.0) / 0.20, 2.0))
        fieldValue = qrtlCurrent * qrtlFieldGain * (0.25 + 0.75 * coherence) * resonanceResponse
        for i in cells.indices {
            let r = max(0.001, simd_length(cells[i].position))
            let spatial = 1.0 / (1.0 + r * r)
            cells[i].qrtlField = fieldValue * spatial
            cells[i].phase = 2.0 * Double.pi * resonanceFrequency * (r / 3.0)
            cells[i].coherence = coherence
        }
    }

    private func calculateQRTLEnergy() {
        calculateField()
        for i in cells.indices {
            let c = cells[i]
            let phaseTerm = 0.5 + 0.5 * cos(c.phase)
            cells[i].energy =
                qrtlEnergyCoupling *
                c.qrtlField *
                c.coherence *
                phaseTerm *
                (1.0 + densityCoupling * c.density)
        }
        qrtlEnergy = cells.reduce(0) { $0 + $1.energy }
    }

    private func calculateChemicalEnergy() {
        let local = cells.reduce(0.0) { partial, cell in
            partial + cell.density * 0.05 + cell.bondingAvailability * 0.02
        }
        chemicalEnergy = local
        statusMessage = "Chemical baseline calculated independently of the QRTL term."
    }

    private func calculateEffectiveEnergy() {
        calculateChemicalEnergy()
        calculateQRTLEnergy()
        effectiveEnergy = chemicalEnergy + qrtlEnergy
        statusMessage = "Eeffective now combines chemical and QRTL contributions."
    }

    private func evolveCA() {
        calculateEffectiveEnergy()

        // QRTL neighbor transport is evaluated before the CA state update.
        // The transport step is synchronous and pairwise antisymmetric: every
        // transfer removed from one cell is added to its neighbor. This avoids
        // the order-dependent in-place correction used by the earlier proposal.
        enforceNeighborFlowBalance()

        var next = cells
        for i in cells.indices {
            let neighbors = neighborIndices(i)
            let neighborEnergy = neighbors.reduce(0.0) { $0 + cells[$1].energy }
            let average = neighbors.isEmpty ? 0 : neighborEnergy / Double(neighbors.count)
            let alignment = max(0, min(1, 0.5 + cells[i].orientation.y * 0.5))
            let score = cells[i].energy + 0.25 * average + 0.10 * alignment

            next[i].energy = score
            next[i].bondingAvailability = max(0, min(1, 0.35 + score + coherence * 0.2))
        }

        cells = next
        statusMessage = String(format:
            "Cell states evolved with synchronous neighbor-flow conservation. Local balance error %.5f; global conservation error %.5e.",
            cells.map(\.flowBalanceError).reduce(0, +) / Double(max(cells.count, 1)),
            globalFlowConservationError
        )
    }

    // MARK: - Neighbor-Flow Balance / Local Conservation

    /// Computes pairwise twist-current transfer without imposing phase closure
    /// or moving cells toward a preferred structure.
    ///
    /// For every neighbor pair (i,j), the signed flow is computed once:
    ///     J_ij = k * (v_i - v_j) * exp(-decay * d_ij)
    ///
    /// The same transfer is then applied with opposite signs:
    ///     Δv_i = -J_ij * Δt
    ///     Δv_j = +J_ij * Δt
    ///
    /// Therefore the pair contributes zero net change to Σv. The method uses
    /// the old state for all pair calculations and commits the new state only
    /// after the complete transport field has been accumulated.
    ///
    /// This establishes computational conservation of the defined model
    /// quantity (twistSpeed); it does NOT establish physical QRTL conservation.
    private func enforceNeighborFlowBalance() {
        guard cells.count > 1 else {
            totalTwistCurrent = 0
            globalFlowConservationError = 0
            if let only = cells.first {
                cells[0].twistCurrentIn = 0
                cells[0].twistCurrentOut = 0
                cells[0].flowBalanceError = 0
            }
            return
        }

        let old = cells
        var delta = Array(repeating: 0.0, count: old.count)
        var inflow = Array(repeating: 0.0, count: old.count)
        var outflow = Array(repeating: 0.0, count: old.count)

        // Keep the total conserved quantity explicit so the implementation
        // can be checked after the synchronous update.
        let totalBefore = old.reduce(0.0) { $0 + $1.twistSpeed }

        for i in old.indices {
            let neighbors = neighborIndicesForState(i, state: old)
            for j in neighbors where j > i {
                let distance = simd_distance(old[i].position, old[j].position)
                guard distance > 0 else { continue }

                let weight = exp(-neighborFlowDecay * distance)
                let signedFlow = neighborFlowCoupling
                    * (old[i].twistSpeed - old[j].twistSpeed)
                    * weight

                if signedFlow > 0 {
                    outflow[i] += signedFlow
                    inflow[j] += signedFlow
                } else if signedFlow < 0 {
                    let magnitude = -signedFlow
                    inflow[i] += magnitude
                    outflow[j] += magnitude
                }

                // Pairwise antisymmetric transfer. No net twistSpeed is
                // created or destroyed by this pair.
                delta[i] -= signedFlow * neighborFlowTimeStep
                delta[j] += signedFlow * neighborFlowTimeStep
            }
        }

        var totalAfter = 0.0
        for i in old.indices {
            cells[i].twistCurrentIn = inflow[i]
            cells[i].twistCurrentOut = outflow[i]
            cells[i].flowBalanceError = abs(inflow[i] - outflow[i])

            cells[i].twistSpeed = old[i].twistSpeed + delta[i]
            totalAfter += cells[i].twistSpeed
        }

        totalTwistCurrent = cells.reduce(0.0) {
            $0 + $1.twistCurrentIn + $1.twistCurrentOut
        }

        // Numerical conservation residual. For the pairwise scheme this
        // should be at floating-point roundoff, not a model-sized correction.
        globalFlowConservationError = abs(totalAfter - totalBefore)
    }

    private func neighborIndicesForState(_ index: Int, state: [LatticeCell]) -> [Int] {
        let p = state[index].position
        return state.indices.filter {
            $0 != index && simd_distance(p, state[$0].position) <= 0.80
        }
    }

    private func organizeAtoms() {
        let states: [CellState] = [.carbon, .hydrogen, .nitrogen, .oxygen, .sulfur]
        for i in cells.indices {
            cells[i].state = states[i % states.count]
            cells[i].density = 1.0 / Double(states.count)
            cells[i].bondingAvailability = 0.45 + 0.5 * coherence
        }
        organizedAtomCount = cells.count
        statusMessage = "C/H/N/O/S atomic states are organized in the coarse-grained lattice."
    }

    private func formFunctionalGroups() {
        for i in cells.indices {
            if i % 3 == 0 || i % 5 == 0 {
                cells[i].state = .functionalGroup
            }
        }
        statusMessage = "Compatible atomic neighborhoods are represented as functional groups."
    }


    private func formAminoAcids() {
        if aminoAcids.isEmpty {
            aminoAcids = programmedSequence.enumerated().map { index, name in

                let glycine = name == "Gly"

                return AminoAcidUnit(
                    name: glycine ? "Gly" : name,
                    code: glycine ? "G" : "G",
                    position: SIMD3<Double>(
                        Double(index) * 1.20 - 1.80,
                        0,
                        0
                    ),
                    orientation: SIMD3<Double>(1, 0, 0),
                    chemicalEnergy: -0.20,
                    bondedToNext: false
                )
            }
        }

        for i in cells.indices {
            cells[i].state = .aminoAcid
        }

        aminoAcidCount = aminoAcids.count

        statusMessage =
            "Glycine building blocks formed: NH₂–CH₂–COOH."
    }



    private func orientAminoAcids() {
        guard aminoAcids.count > 1 else { return }
        for i in aminoAcids.indices {
            if i < aminoAcids.count - 1 {
                let d = aminoAcids[i + 1].position - aminoAcids[i].position
                let n = simd_length(d)
                if n > 0 { aminoAcids[i].orientation = d / n }
            }
        }
        for i in cells.indices { cells[i].state = .orientedAminoAcid }
        statusMessage = "Amino and carboxyl termini are represented with explicit relative orientation. Orient Simple Amino Acids simply determines which direction each glycine should face in the peptide chain by looking at the position of the next glycine, calculating the direction between them, and storing that direction as its orientation. In your current Gly₄ model, the four glycines are arranged in a straight line, so each one points toward the next: Gly₁ → Gly₂ → Gly₃ → Gly₄. It then marks the cellular-automaton cells as .orientedAminoAcid and updates the status message. It is important that this function currently represents overall residue-to-residue orientation, not the detailed rotation of the actual NH₂–CH₂–COOH groups."
    }
/*
 "Glycine 1 and Glycine 2 are positioned and oriented well enough to form a bond. It first makes sure there are at least two amino acids, then measures the distance between them and compares it with the ideal distance of 1.20; it also checks whether Glycine 1 is pointing toward Glycine 2. Those two checks produce a distance factor and orientation factor. It then calculates a coarse chemical energy penalty, adds the model's QRTL energy contribution, and combines them into an effective energy difference. That energy is converted into a probability using the logistic equation, and the bond is accepted only if probability ≥ 50%, orientation ≥ 70%, and distance ≥ 65%."
 */
    private func evaluateTransition() -> TransitionEvaluation {
        guard aminoAcids.count >= 2 else {
            return TransitionEvaluation(
                deltaGChemical: 0,
                deltaEqrtl: 0,
                deltaGEffective: 0,
                probability: 0,
                orientationFactor: 0,
                distanceFactor: 0,
                accepted: false
            )
        }

        // -------------------------------------------------
        // GLY1 → GLY2
        // -------------------------------------------------

        let a = aminoAcids[0]
        let b = aminoAcids[1]

        // -------------------------------------------------
        // DISTANCE
        // -------------------------------------------------

        let delta =
            b.position - a.position

        let distance =
            simd_length(delta)

        let idealDistance = 1.20

        let distanceFactor =
            exp(
                -pow(
                    (distance - idealDistance) / 0.45,
                    2.0
                )
            )

        // -------------------------------------------------
        // ORIENTATION
        // -------------------------------------------------

        let direction =
            distance > 1.0e-12
            ? delta / distance
            : SIMD3<Double>(1, 0, 0)

        let dot =
            max(
                -1.0,
                min(
                    1.0,
                    simd_dot(
                        a.orientation,
                        direction
                    )
                )
            )

        let orientationFactor =
            0.5 + 0.5 * dot

        // -------------------------------------------------
        // COARSE CHEMICAL ENERGY
        // -------------------------------------------------

        let deltaChemical =
            chemicalBondScale +
            distancePenalty * (1.0 - distanceFactor) +
            orientationPenalty * (1.0 - orientationFactor)

        // -------------------------------------------------
        // LOCAL CA / QRTL STATE
        // -------------------------------------------------

        let totalCellEnergy =
            cells.reduce(0.0) {
                $0 + $1.energy
            }

        let localEnergyDensity =
            totalCellEnergy /
            Double(
                max(
                    cells.count,
                    1
                )
            )

        let localField =
            cells.isEmpty
            ? 0.0
            : cells.reduce(0.0) {
                $0 + $1.qrtlField
            } /
            Double(cells.count)

        let phaseDifference =
            cells.count >= 2
            ? abs(
                cells[0].phase -
                cells[1].phase
            )
            : 0.0

        let pressureA =
            localEnergyDensity *
            (1.0 + localField)

        let pressureB =
            localEnergyDensity *
            (1.0 + localField)

        let deltaPressure =
            pressureA - pressureB

        // -------------------------------------------------
        // QRTL CURRENT
        //
        // This is the required calculation step. It creates
        // the current for this Gly1 → Gly2 transition.
        //
        // Keep this as a local value. Do not write to
        // self.qrtlCurrent here, because its didSet invokes
        // recalculate(), which calls evaluateTransition().
        // -------------------------------------------------

        let qrtlResult =
            calculateQRTLCurrent(
                distanceFactor: distanceFactor,
                orientationFactor: orientationFactor,
                coherence: coherence,
                phaseDifference: phaseDifference,
                deltaPressure: deltaPressure,
                allowableDeltaPressure: allowableDeltaPressure,
                transportedEnergy: totalCellEnergy,
                minimumTransportEnergy: minimumTransportEnergy,
                qrtlDriveAmplitude: qrtlDriveAmplitude
            )

        let transitionQRTLCurrent =
            qrtlResult.current

        // -------------------------------------------------
        // QRTL ENERGY DIFFERENCE
        //
        // In this model, a positive coherent QRTL resonance
        // is a favorable reduction in the bond barrier.
        // -------------------------------------------------

        let candidateResonance =
            transitionQRTLCurrent *
            qrtlEnergyCoupling *
            coherence

        let reactantResonance = 0.0

        let qrtlBarrierReduction =
            candidateResonance -
            reactantResonance

        // Formal sign convention:
        //
        // ΔE_QRTL = E_product - E_reactants
        //
        // Favorable stabilization is negative.
        let deltaQRTL =
            -qrtlBarrierReduction

        let deltaEffective =
            deltaChemical +
            deltaQRTL

        // -------------------------------------------------
        // TRANSITION PROBABILITY
        // -------------------------------------------------

        let reduced =
            max(
                -60.0,
                min(
                    60.0,
                    deltaEffective / modelKBT
                )
            )

        let probability =
            1.0 /
            (
                1.0 +
                exp(reduced)
            )

        let accepted =
            probability >= 0.50 &&
            orientationFactor >= 0.70 &&
            distanceFactor >= 0.65

        // -------------------------------------------------
        // DEBUG OUTPUT
        // -------------------------------------------------

        print("""
        ══════════════════════════════════════════════
        🔬 QRTL GLY1 → GLY2 TRANSITION DEBUG
        ══════════════════════════════════════════════

        AMINO ACIDS
        A: \(a.name) (\(a.code))
        B: \(b.name) (\(b.code))

        POSITIONS
        A position: \(a.position)
        B position: \(b.position)
        Delta: \(delta)

        DISTANCE
        Actual distance: \(distance)
        Ideal distance: \(idealDistance)
        Distance factor: \(distanceFactor)
        Required: >= 0.65
        Distance gate: \(distanceFactor >= 0.65 ? "PASS" : "FAIL")

        ORIENTATION
        A orientation: \(a.orientation)
        Direction A → B: \(direction)
        Dot product: \(dot)
        Orientation: \(orientationFactor)
        Required: >= 0.70
        Orientation gate: \(orientationFactor >= 0.70 ? "PASS" : "FAIL")

        CHEMICAL ENERGY
        Chemical bond scale: \(chemicalBondScale)
        Distance penalty: \(distancePenalty)
        Orientation penalty: \(orientationPenalty)
        ΔG chemical: \(deltaChemical)

        QRTL ENERGY
        QRTL drive amplitude: \(qrtlDriveAmplitude)
        Total CA energy: \(totalCellEnergy)
        Local energy density: \(localEnergyDensity)
        Local QRTL field: \(localField)
        Pressure A: \(pressureA)
        Pressure B: \(pressureB)
        ΔP: \(deltaPressure)
        QRTL current: \(transitionQRTLCurrent)
        QRTL coupling: \(qrtlEnergyCoupling)
        Coherence: \(coherence)
        Phase difference: \(phaseDifference)
        Phase factor: \(qrtlResult.phaseFactor)
        Pressure balance factor: \(qrtlResult.pressureBalanceFactor)
        Transport factor: \(qrtlResult.transportFactor)
        Candidate resonance: \(candidateResonance)
        Reactant resonance: \(reactantResonance)
        QRTL barrier reduction: \(qrtlBarrierReduction)
        ΔE QRTL: \(deltaQRTL)

        EFFECTIVE ENERGY
        ΔG effective: \(deltaEffective)
        Model kBT: \(modelKBT)
        Reduced energy: \(reduced)

        TRANSITION
        Probability: \(probability)
        Required: >= 0.50
        Probability gate: \(probability >= 0.50 ? "PASS" : "FAIL")

        FINAL RESULT
        Accepted: \(accepted ? "✅ YES" : "❌ NO")

        ══════════════════════════════════════════════
        """)

        statusMessage =
            accepted
            ? "Glycine 1 and Glycine 2 passed the modeled transition gates."
            : "Glycine 1 and Glycine 2 did not pass all modeled transition gates."

        return TransitionEvaluation(
            deltaGChemical: deltaChemical,
            deltaEqrtl: deltaQRTL,
            deltaGEffective: deltaEffective,
            probability: probability,
            orientationFactor: orientationFactor,
            distanceFactor: distanceFactor,
            accepted: accepted
        )
    }
    
    

    private func calculateChemicalDeltaG() {
        let e = evaluateTransition()
        chemicalEnergy = e.deltaGChemical
        statusMessage = "Chemical free-energy difference evaluated for the candidate coupling."
    }

    private func calculateQRTLDeltaE() {
        let e = evaluateTransition()
        qrtlEnergy = e.deltaEqrtl
        statusMessage = "The QRTL contribution is evaluated as a difference between candidate and reactant states."
    }

    private func calculateEffectiveDeltaG() {
        let e = evaluateTransition()
        chemicalEnergy = e.deltaGChemical
        qrtlEnergy = e.deltaEqrtl
        effectiveEnergy = e.deltaGEffective
        statusMessage = "ΔGeffective = ΔGchemical + ΔEQRTL."
    }

    private func calculateTransition() {
        let e = evaluateTransition()
        chemicalEnergy = e.deltaGChemical
        qrtlEnergy = e.deltaEqrtl
        effectiveEnergy = e.deltaGEffective
        transitionProbability = e.probability
        statusMessage = "Transition probability calculated from the effective free-energy difference."
    }

    private func attemptCoupling() {
        let e = evaluateTransition()
        chemicalEnergy = e.deltaGChemical
        qrtlEnergy = e.deltaEqrtl
        effectiveEnergy = e.deltaGEffective
        transitionProbability = e.probability

        guard aminoAcids.count >= 2 else {
            statusMessage = "Bond test requires two amino-acid units."
            return
        }

        // CA transports / redistributes energy before the bond test.
        enforceNeighborFlowBalance()

        let initialEnergy = cells.reduce(0.0) { $0 + $1.energy }
        let transportedEnergy = cells.reduce(0.0) { $0 + $1.energy }
        let localEnergyDensity = transportedEnergy / Double(max(cells.count, 1))

        // Local QRTL field and phase state.
        let localField = cells.isEmpty ? 0.0 :
            cells.reduce(0.0) { $0 + $1.qrtlField } / Double(cells.count)
        let phaseDifference = cells.count >= 2
            ? abs(cells[0].phase - cells[1].phase)
            : 0.0

        // Pressure is a model-defined quantity derived from local energy density.
        let pressureA = localEnergyDensity * (1.0 + localField)
        let pressureB = localEnergyDensity * (1.0 + localField)
        let deltaPressure = pressureA - pressureB

        let phaseFactor = max(0.0, cos(phaseDifference))
        let bondEnergy = localEnergyDensity * localField * coherence * phaseFactor

        var failures: [String] = []
        if abs(deltaPressure) > allowableDeltaPressure {
            failures.append(String(format: "ΔP %.5f exceeds allowed %.5f.", abs(deltaPressure), allowableDeltaPressure))
        }
        if bondEnergy < minimumBondEnergy {
            failures.append(String(format: "Bond energy %.5f is below minimum %.5f.", bondEnergy, minimumBondEnergy))
        }
        if coherence < minimumBondCoherence {
            failures.append(String(format: "Coherence %.5f is below required %.5f.", coherence, minimumBondCoherence))
        }
        if phaseDifference > maximumPhaseDifference {
            failures.append(String(format: "Phase difference %.5f exceeds allowed %.5f.", phaseDifference, maximumPhaseDifference))
        }
        if e.probability < 0.50 { failures.append("Transition probability is below 0.50.") }
        if e.orientationFactor < 0.70 { failures.append("Orientation compatibility is below 0.70.") }
        if e.distanceFactor < 0.65 { failures.append("Distance compatibility is below 0.65.") }

        let formed = failures.isEmpty
        let reason = formed ? "All model bond-formation gates passed." : failures.joined(separator: " ")

        latestBondDiagnostic = PeptideBondDiagnostic(
            bondNumber: max(1, peptideBondCount + 1),
            firstResidue: aminoAcids[0].name,
            secondResidue: aminoAcids[1].name,
            initialEnergy: initialEnergy,
            finalEnergy: transportedEnergy,
            transportedEnergy: transportedEnergy - initialEnergy,
            localEnergyDensity: localEnergyDensity,
            qrtlField: localField,
            coherence: coherence,
            phaseDifference: phaseDifference,
            pressureA: pressureA,
            pressureB: pressureB,
            deltaPressure: deltaPressure,
            bondEnergy: bondEnergy,
            formed: formed,
            failureReason: reason
        )
        


        if formed {
            peptideBondCount = max(peptideBondCount, 1)
            aminoAcids[0].bondedToNext = true
            for i in cells.indices { cells[i].state = .peptideBond }
            bondFailureMessage = nil
            statusMessage = "Controlled coupling accepted: CA transport → local QRTL density → field → pressure → bond gate passed."
        } else {
            bondFailureMessage = "Peptide bond formation was blocked.\n\n" + reason
            statusMessage = "Controlled coupling rejected by the diagnostic bond-formation gate."
        }
        
        print("""
        ══════════════════════════════════════════════
        ⚡ PEPTIDE BOND-ENERGY DEBUG
        ══════════════════════════════════════════════
        Local energy density: \(localEnergyDensity)
        Local QRTL field: \(localField)
        Coherence: \(coherence)
        Phase difference: \(phaseDifference)
        Phase factor: \(phaseFactor)
        Bond energy: \(bondEnergy)
        Minimum bond energy: \(minimumBondEnergy)
        Energy ratio: \(bondEnergy / minimumBondEnergy)
        ══════════════════════════════════════════════
        """)
        
    }

    func clearBondFailure() {
        bondFailureMessage = nil
    }

    private func recordCondensation() {
        if peptideBondCount > 0 {
            statusMessage = "Successful coupling records a peptide bond and H₂O as the condensation product."
        } else {
            statusMessage = "No coupling event has been accepted; no peptide bond is recorded."
        }
    }

    private func growChain() {
        if peptideBondCount > 0 {
            peptideLength = 2
            if aminoAcids.count > 1 {
                aminoAcids[0].bondedToNext = true
            }
            for i in cells.indices { cells[i].state = .peptideChain }
            statusMessage = "The first accepted bond extends the modeled chain."
        } else {
            statusMessage = "Chain growth is held until a coupling transition is accepted."
        }
    }

    private func repeatCycle() {
        if aminoAcids.count > 2 {
            for pair in 0..<(aminoAcids.count - 1) {
                _ = pair
            }
        }
        statusMessage = "The same field → energy → CA → orientation → ΔG → P → bond cycle is retained."
    }

    private func completeSequence() {
        // For a controlled demonstration, each bond is evaluated independently.
        // We do not silently force success: the result depends on the same
        // transition calculation.
        var successful = 0

        if aminoAcids.count > 1 {
            for i in 0..<(aminoAcids.count - 1) {
                let left = aminoAcids[i]
                let right = aminoAcids[i + 1]
                let d = right.position - left.position
                let distance = simd_length(d)
                let distanceFactor = exp(-pow((distance - 1.20) / 0.45, 2.0))
                let direction = distance > 0 ? d / distance : SIMD3<Double>(1,0,0)
                let orientationFactor = 0.5 + 0.5 * max(-1.0, min(1.0, simd_dot(left.orientation, direction)))
                let dg = chemicalBondScale
                    + distancePenalty * (1 - distanceFactor)
                    + orientationPenalty * (1 - orientationFactor)
                    - qrtlCurrent * qrtlEnergyCoupling * coherence * (1 - orientationFactor)

                let p = 1 / (1 + exp(max(-60, min(60, dg / modelKBT))))

                if p >= 0.50 && orientationFactor >= 0.70 && distanceFactor >= 0.65 {
                    successful += 1
                    aminoAcids[i].bondedToNext = true
                }
            }
        }

        peptideBondCount = successful
        peptideLength = successful + 1
        statusMessage = "Sequence evaluation complete: \(successful) of \(max(0, aminoAcids.count - 1)) modeled couplings accepted."
    }

    private func conformationalSearch() {
        guard !aminoAcids.isEmpty else { return }
        foldingEnergy = conformationEnergy(for: aminoAcids)
        statusMessage = "The assembled chain now enters a separate conformational-energy calculation."
    }

    private func rankConformations() {
        foldingEnergy = conformationEnergy(for: aminoAcids)
        statusMessage = "Candidate conformations are ranked by the combined model energy."
    }

    private func fold() {
        guard !aminoAcids.isEmpty else { return }

        for i in aminoAcids.indices {
            let t = Double(i)
            aminoAcids[i].position.y = 0.55 * sin(t * 1.15)
            aminoAcids[i].position.z = 0.35 * cos(t * 0.90)
        }

        foldingEnergy = conformationEnergy(for: aminoAcids)
        for i in cells.indices { cells[i].state = .folded }
        statusMessage = "A simplified conformational search has moved the chain toward a lower modeled-energy arrangement."
    }

    private func stabilize() {
        foldingEnergy = conformationEnergy(for: aminoAcids)
        statusMessage = "The displayed structure is a local minimum of this simplified model, not an experimentally validated peptide structure."
    }

    private func compareControl() {
        let on = evaluateTransition().probability
        let saved = qrtlCurrent
        qrtlCurrent = 0
        calculateField()
        let off = evaluateTransition().probability
        qrtlCurrent = saved
        calculateField()
        transitionProbability = on
        statusMessage = String(format: "Control comparison: P(QRTL on)=%.4f, P(control)=%.4f, ΔP=%.4f.", on, off, on - off)
    }

    private func prepareExperimentalPrediction() {
        statusMessage =
            "Prediction to test: varying controlled QRTL current/resonance should change measured transition kinetics if the proposed QRTL coupling is physically real."
    }

    // MARK: Folding model

    private func conformationEnergy(for chain: [AminoAcidUnit]) -> Double {
        guard !chain.isEmpty else { return 0 }

        var chemical = 0.0
        var electrostatic = 0.0
        var environmental = 0.0
        var qrtl = 0.0

        for i in chain.indices {
            let p = chain[i].position
            chemical += 0.03 * simd_length(p)

            if i < chain.count - 1 {
                let d = simd_distance(p, chain[i + 1].position)
                chemical += 0.15 * pow(d - 1.20, 2)
            }

            electrostatic += 0.02 * abs(p.y)

            environmental += 0.015 * simd_length(p)

            qrtl -=
                qrtlCurrent *
                qrtlEnergyCoupling *
                coherence *
                (0.5 + 0.5 * cos(Double(i) * resonanceFrequency))
        }

        return chemical + electrostatic + environmental + qrtl
    }

    // MARK: Helpers

    private func makeLattice() -> [LatticeCell] {
        var result: [LatticeCell] = []
        let spacing = 0.72

        for x in -2...2 {
            for y in -2...2 {
                for z in -1...1 {
                    result.append(
                        LatticeCell(
                            state: .empty,
                            position: SIMD3<Double>(
                                Double(x) * spacing,
                                Double(y) * spacing,
                                Double(z) * spacing
                            ),
                            energy: 0,
                            qrtlField: 0,
                            coherence: coherence,
                            phase: 0,
                            density: 0,
                            orientation: SIMD3<Double>(1, 0, 0),
                            bondingAvailability: 0,
                            twistSpeed: 0,
                            twistCurrentIn: 0,
                            twistCurrentOut: 0,
                            flowBalanceError: 0
                        )
                    )
                }
            }
        }
        return result
    }

    private func neighborIndices(_ index: Int) -> [Int] {
        let p = cells[index].position
        return cells.indices.filter {
            $0 != index && simd_distance(p, cells[$0].position) <= 0.80
        }
    }

    private func recalculate() {
        guard !cells.isEmpty else { return }
        calculateField()
        calculateQRTLEnergy()

        if stageIndex >= 5 {
            calculateChemicalEnergy()
        }

        if stageIndex >= 6 {
            effectiveEnergy = chemicalEnergy + qrtlEnergy
        }

        if stageIndex >= 10 && aminoAcids.isEmpty {
            formAminoAcids()
        }

        if stageIndex >= 11 {
            orientAminoAcids()
        }

        if stageIndex >= 15 {
            let e = evaluateTransition()
            chemicalEnergy = e.deltaGChemical
            qrtlEnergy = e.deltaEqrtl
            effectiveEnergy = e.deltaGEffective
            transitionProbability = e.probability
        }

        if stageIndex >= 18 {
            peptideLength = max(peptideLength, peptideBondCount + 1)
        }

        if stageIndex >= 22 && !aminoAcids.isEmpty {
            foldingEnergy = conformationEnergy(for: aminoAcids)
        }
    }
}

extension AminoAcidUnit {
    /// Explicit molecular representation used by the peptide model and SceneKit.
    ///
    /// Glycine:
    /// NH₂–CH₂–COOH
    var displayStructure: String {
        switch name {
        case "Gly":
            return "NH₂–CH₂–COOH"
        default:
            return name
        }
    }
}

