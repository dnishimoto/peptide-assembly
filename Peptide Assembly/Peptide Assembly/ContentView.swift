/*

 The peptide pipeline begins with the complete molecular definition. The system first establishes the peptide sequence, identifies every amino acid residue, identifies the peptide bonds connecting the residues, identifies the atoms belonging to every residue, establishes the termini, assigns the molecular coordinates, and records the connectivity between all atoms. The starting molecular structure becomes the canonical molecular state. Every subsequent stage operates on this same structure so that geometry, energy, resonance, tunneling, and reaction calculations remain connected. The pipeline does not create separate molecular representations for different calculations.

 The second stage establishes the three dimensional molecular geometry. Every atom receives a position in space, every bond receives its corresponding length and orientation, and every residue receives its local structural environment. The system identifies backbone atoms, side chains, hydrogen-bonding relationships, charged regions, polar regions, nonpolar regions, and other structural features represented by the model. The resulting geometry establishes the spatial framework in which every later QRTL calculation occurs.

 The third stage establishes the molecular coordinate system. The peptide is placed into a defined three dimensional coordinate space, and the coordinate system is used consistently by the molecular lattice, energy shell, twister field, visualization, and transition calculations. The system determines the spatial extent of the peptide and creates the computational region surrounding it. The computational region must extend beyond the molecular surface because the modeled energy shell and QRTL field exist around the peptide rather than only at the atomic coordinates.

 The fourth stage creates the molecular lattice. The computational volume is divided into connected locations surrounding and intersecting the peptide. Each lattice location stores the local quantities required by the QRTL model. These quantities include local energy, density, phase, rotational state, twist-current, energy flow, coupling, resonance state, and neighboring relationships. The lattice provides the continuous computational environment through which the modeled QRTL state evolves.

 The fifth stage maps the peptide onto the lattice. Atomic positions are transferred into nearby lattice locations, and the influence of each atom and residue is distributed according to the spatial rules of the model. Regions containing molecular matter receive corresponding structural information. Empty regions remain part of the computational field because they provide the space through which the modeled QRTL field propagates. This prevents the calculation from becoming limited to the atoms themselves.

 The sixth stage calculates local molecular density. The system determines how much molecular structure is present around each lattice location. Density is influenced by the locations of atoms and the spatial distribution of the peptide. The density field becomes one of the inputs to the QRTL field. High-density molecular regions and low-density surrounding regions therefore produce different local field conditions.

 The seventh stage constructs the energy shell. The local molecular density is converted into the initial energy-shell distribution according to the model's defined relationship. The energy shell surrounds the molecular structure and provides the spatial field in which the subsequent QRTL calculations occur. The shell is continuously updated when the peptide moves or when its internal state changes. It therefore represents the current molecular environment rather than a fixed background.

 The eighth stage establishes the local energy state. Each lattice location receives an initial energy value based on the molecular configuration, local density, neighboring structure, and the energy-shell rules. The system distinguishes local energy from total molecular energy. Local energy belongs to individual regions of the computational field, while total energy is obtained by integrating or aggregating the relevant local contributions.

 The ninth stage initializes the quark-twister field. Each relevant lattice location receives a modeled rotational state. The state contains a rotational magnitude, rotational direction, phase, and associated local energy or twist-current. The twister field is connected to the molecular lattice rather than being an independent visualization layer. A change in the molecular environment therefore changes the conditions experienced by the local twister states.

 The tenth stage establishes the initial twister orientation. The model determines the starting rotational direction of each local twister according to the molecular geometry and initialization rules. Neighboring locations are given related but not necessarily identical orientations. This allows the model to begin with a distributed rotational field rather than assuming that the entire peptide is initially perfectly synchronized.

 The eleventh stage establishes twister magnitude. Each local rotational state receives a magnitude representing the strength of its modeled rotational activity. Magnitude can vary across the molecular structure according to density, energy, resonance conditions, and local interactions. The magnitude is subsequently allowed to evolve rather than remaining permanently fixed.

 The twelfth stage establishes the initial phase field. Every active lattice location receives a phase value. Phase is treated as a continuously evolving state that can differ between neighboring locations. The initial phase distribution provides the starting condition for the synchronization calculation.

 The thirteenth stage identifies neighboring lattice locations. Each lattice point is connected to the surrounding locations defined by the model. The system determines which neighboring cells contribute to local flow, phase comparison, energy exchange, and twister interaction. Neighbor relationships remain consistent throughout the calculation unless the lattice itself is intentionally rebuilt.

 The fourteenth stage calculates neighbor phase differences. The phase of each location is compared with the phases of its connected neighbors. The resulting differences establish the local phase-disagreement field. A region in which neighboring phases are similar has low phase error, while a region with large phase differences has high phase error.

 The fifteenth stage calculates neighbor twist-current. The system determines the directional transfer of modeled rotational information between neighboring locations. The twist-current depends on the local twister states and their differences from neighboring states. The current establishes a mechanism by which rotational information can propagate through the lattice.

 The sixteenth stage calculates local energy flow. Energy movement between neighboring locations is evaluated from the local energy states and the defined QRTL flow rules. The system determines incoming and outgoing flow at every location. This produces a local energy-flow field rather than treating every lattice point as energetically isolated.

 The seventeenth stage applies local conservation. Incoming and outgoing modeled flow are compared at each lattice location. The difference represents local accumulation or depletion unless the location contains an explicitly represented source, sink, boundary interaction, or reaction event. This prevents the lattice from generating arbitrary energy without a corresponding mechanism in the model.

 The eighteenth stage establishes boundary conditions. The system determines how twist-current, energy flow, phase, and the QRTL field behave at the computational boundaries. The boundary rules prevent artificial behavior at the edge of the lattice from being mistaken for molecular behavior. The same boundary conditions must be applied consistently during every iteration.

 The nineteenth stage calculates the local phase-error field. The current phase of every region is compared with the phase required for the desired coherent state. The difference becomes the local phase error. This value is used by the phase-correction process and provides a direct measurement of how far the system is from phase synchronization.

 The twentieth stage calculates phase correction. The system uses local coupling, neighbor phase differences, twister state, and phase error to determine the direction and magnitude of phase correction. The correction moves the system toward compatibility rather than simply assigning a target phase. The correction is recalculated at every iteration.

 The twenty-first stage performs phase synchronization. Neighboring locations progressively move toward compatible rotational states. Synchronization is evaluated across the connected lattice rather than at one selected point. The system therefore distinguishes local synchronization from global synchronization.

 The twenty-second stage evaluates phase coherence. The model calculates how consistently the peptide's active regions maintain compatible phase relationships. Coherence increases when neighboring and connected regions remain phase-aligned and decreases when phase disorder develops. Coherence becomes an input to resonance and QRTL coupling.

 The twenty-third stage evaluates phase closure. The system follows the relevant rotational pathway through the molecular lattice and determines whether the accumulated phase relationship returns to a compatible state. Closure requires the complete pathway to satisfy the defined phase condition. A local region cannot be considered globally closed merely because two neighboring points have similar phases.

 The twenty-fourth stage establishes the discrete resonance shells. The model determines which combinations of rotational state, phase, energy, and spatial configuration satisfy the resonance condition. These permitted states form discrete resonance shells within the continuous molecular field. The resonance shells identify the states in which the modeled QRTL system can maintain coherent oscillation.

 The twenty-fifth stage calculates resonance frequency. The local rotational state is converted into its corresponding modeled resonance frequency. The frequency is compared with the available molecular and QRTL energy states. Only states satisfying the defined resonance relationship contribute to the resonant population.

 The twenty-sixth stage calculates resonance energy. Each permitted resonance state receives its corresponding energy. The system compares this energy with the local energy available within the peptide's field. This determines whether a particular region can occupy the resonance shell.

 The twenty-seventh stage calculates resonance occupancy. The model determines how strongly each molecular region participates in the available resonance state. Occupancy depends on energy compatibility, phase coherence, local coupling, density, and the resonance condition. The occupancy field identifies where coherent QRTL behavior is strongest.

 The twenty-eighth stage performs resonance matching. Neighboring resonance states are compared to determine whether they can participate in a common coherent structure. Compatible states reinforce the resonant pathway, while incompatible states reduce the effective coherence. This produces a connected resonance network rather than a collection of unrelated resonance points.

 The twenty-ninth stage calculates resonance propagation. Resonant information is propagated through neighboring regions according to the lattice connectivity. The system determines whether resonance remains localized or develops into a larger coherent pathway across the peptide.

 The thirtieth stage calculates QRTL coupling. Coupling is derived from the current phase relationship, resonance occupancy, twister alignment, neighbor connectivity, energy flow, and local molecular conditions. Stronger compatibility produces stronger effective coupling. Poor phase alignment and weak resonance participation reduce coupling.

 The thirty-first stage calculates coupling propagation. The local coupling values are transferred through the connected lattice so that a strongly coupled region can influence adjacent regions. This establishes the spatial extent of the QRTL interaction.

 The thirty-second stage calculates the QRTL field. The coupled twister, resonance, phase, density, and energy states are combined to produce the current QRTL field. The field is spatially distributed around the peptide and changes as the molecular configuration changes.

 The thirty-third stage calculates the QRTL field gradient. The system determines how the QRTL field changes from one region to another. The gradient identifies the direction in which the modeled field changes most strongly and provides the basis for calculating its influence on the molecular energy landscape.

 The thirty-fourth stage calculates the QRTL binding contribution. The model determines how the coherent QRTL state contributes to the effective binding environment of the peptide. This contribution is derived from the current QRTL state rather than independently specified.

 The thirty-fifth stage calculates effective molecular energy. The conventional molecular contributions represented by the model are combined with the QRTL contribution. The result is the effective energy landscape used by the subsequent stability, transition, and tunneling calculations.

 The thirty-sixth stage calculates the energy gradient. The system determines how effective energy varies throughout the molecular structure. Regions where energy changes rapidly become important for molecular transitions and tunneling because they represent portions of the energy landscape with significant energetic differences.

 The thirty-seventh stage identifies energy barriers. The model determines the energetic barriers separating the current molecular configuration from possible alternative configurations. Each barrier is associated with a particular transition pathway rather than being treated as one universal peptide value.

 The thirty-eighth stage identifies possible conformational transitions. The peptide geometry is examined for allowed structural changes. The system identifies which bonds, angles, residue relationships, or larger conformational arrangements can participate in the transition represented by the model.

 The thirty-ninth stage calculates the transition pathway. The model establishes the sequence of molecular states required to move from the starting configuration toward the target configuration. The pathway determines how the energy barrier evolves rather than assuming that the peptide jumps directly from one state to another.

 The fortieth stage calculates the transition-state condition. The system identifies the region along the transition pathway where the effective energetic barrier reaches its relevant maximum or otherwise satisfies the model's transition-state definition. The transition state is therefore derived from the current energy landscape.

 The forty-first stage calculates the tunneling conditions. The system evaluates the barrier width, barrier energy, available molecular energy, effective QRTL contribution, coupling, and other parameters required by the tunneling model. The calculation determines whether the transition has a classically inaccessible region that can be evaluated by the model's tunneling mechanism.

 The forty-second stage calculates tunneling probability. The tunneling calculation uses the actual barrier produced by the current peptide state. If the barrier changes because the peptide geometry, QRTL field, resonance, or coupling changes, the tunneling probability changes as well. The tunneling result is therefore connected to the preceding pipeline.

 The forty-third stage calculates transition probability. Tunneling and non-tunneling contributions represented by the model are combined with the transition-state conditions to determine the probability of the modeled molecular transition.

 The forty-fourth stage calculates the QRTL-generated transition rate. The transition probability is converted into the corresponding modeled transition rate using the defined temporal relationship. The rate must originate from the calculated QRTL and molecular state rather than from a separate hard-coded reaction rate.

 The forty-fifth stage applies the transition to the molecular state. If the calculated transition satisfies the model's transition criterion, the molecular configuration is advanced toward the resulting state. The peptide geometry, energy shell, twister field, phase field, resonance state, coupling, and energy landscape must then be recalculated because the molecular state has changed.

 The forty-sixth stage begins the feedback cycle. The new molecular geometry changes density. The changed density changes the energy shell. The changed energy shell changes the local QRTL environment. The changed QRTL environment changes twister states, neighbor flow, phase, resonance, coupling, and effective energy. The new energy landscape changes the transition calculation. The pipeline therefore becomes a closed feedback system rather than a one-time calculation.

 The forty-seventh stage performs iterative relaxation. The complete pipeline is repeatedly evaluated until the molecular and QRTL states approach a stable solution. Every iteration uses the previous iteration's complete state and produces a new complete state. This prevents disconnected calculations from appearing to converge when the underlying fields remain inconsistent.

 The forty-eighth stage evaluates convergence. The system compares the current state with the previous state. Molecular displacement, energy change, phase change, coupling change, resonance change, and other relevant quantities are evaluated against defined convergence criteria. The calculation stops only when the required conditions have converged or when the maximum permitted number of iterations has been reached.

 The forty-ninth stage evaluates stability. The final candidate state is tested for molecular stability, energy stability, phase coherence, phase closure, resonance consistency, coupling consistency, and neighbor-flow conservation. A state that satisfies only one of these conditions is not automatically classified as stable.

 The fiftieth stage evaluates conservation. The complete lattice is checked for unexplained energy creation or destruction and for unexplained twist-current imbalance. Any permitted source, sink, reaction, or boundary transfer is explicitly accounted for. The purpose is to ensure that the final state is internally consistent with the conservation rules of the model.

 The fifty-first stage evaluates numerical validity. Every calculated quantity is checked for undefined values, infinite values, invalid square roots, invalid logarithms, division by zero, uncontrolled exponential growth, and other numerical failures. Invalid intermediate values are rejected or handled according to explicit numerical rules rather than being allowed to propagate into the final result.

 The fifty-second stage performs residue-level analysis. The final QRTL state is mapped back onto individual residues. Each residue can be evaluated according to its local energy, phase coherence, resonance occupancy, coupling, energy-flow balance, and contribution to the transition pathway. This identifies which parts of the peptide participate most strongly in the modeled process.

 The fifty-third stage performs pathway analysis. The system identifies the connected molecular and QRTL regions that contribute to the transition. The pathway includes structural connectivity, energy-flow connectivity, phase connectivity, resonance connectivity, and coupling connectivity. This provides a complete description of how the modeled influence travels through the peptide.

 The fifty-fourth stage generates the final three dimensional field representation. The molecular structure is displayed together with the energy shell, QRTL field, twister orientations, phase state, resonance shells, coupling regions, energy barriers, and transition pathway. The visualization uses the calculated state rather than generating independent visual values.

 The fifty-fifth stage generates the final molecular measurements. The system reports the final molecular energy, QRTL energy contribution, effective energy, phase coherence, phase error, closure state, resonance occupancy, coupling, energy-flow balance, barrier characteristics, tunneling probability, transition probability, and QRTL-generated transition rate. Each reported value must be traceable to the same canonical pipeline.

 The fifty-sixth stage performs final cross-checking. The reported values are compared against the internal state to ensure that the visualization, numerical calculations, and final summaries all describe the same molecular configuration. The system verifies that a displayed resonance state corresponds to the calculated resonance state, that a displayed energy corresponds to the calculated energy, and that a displayed transition corresponds to the calculated transition pathway.

 The fifty-seventh stage establishes the final peptide state. The final state consists of the molecular geometry together with its energy shell, density field, quark-twister field, neighbor-flow field, phase field, phase error, phase coherence, phase closure, discrete resonance shells, resonance occupancy, coupling field, QRTL field, QRTL energy, effective molecular energy, energy barriers, transition pathway, tunneling probability, transition probability, and QRTL-generated transition rate.

 The complete pipeline therefore operates as one connected chain. The peptide structure creates the molecular geometry. The molecular geometry creates the density distribution. The density distribution creates the energy shell. The energy shell establishes the QRTL environment. The QRTL environment establishes the quark-twister states. The twister states create neighbor flow. Neighbor flow establishes local conservation and energy transport. Neighbor relationships establish phase differences. Phase differences establish phase error. Phase error produces phase correction. Phase correction produces synchronization. Synchronization produces coherence. Coherence permits phase closure. Phase closure establishes discrete resonance compatibility. Resonance compatibility produces resonance occupancy. Resonance occupancy produces coupling. Coupling generates the QRTL field. The QRTL field modifies the effective molecular energy landscape. The effective landscape establishes barriers and transition pathways. The transition pathway establishes tunneling conditions. Tunneling produces transition probability. Transition probability produces the QRTL-generated transition rate. The resulting transition changes the molecular state, which feeds back into the density, energy shell, twister, phase, resonance, coupling, and energy calculations.

 The defining rule of the entire pipeline is therefore continuity. No major result should be calculated independently from the state that supposedly produces it. The energy must come from the energy field. The energy field must come from the molecular and QRTL state. The QRTL state must come from the twister, flow, phase, resonance, and coupling calculations. The tunneling probability must come from the resulting barrier. The transition probability must come from the tunneling and transition-state calculation. The reaction or transition rate must come from that calculated probability. The visualization must display those same values. When the peptide changes, the entire connected chain must be capable of responding to that change.

 This architecture turns the peptide model into a complete computational pipeline rather than a collection of separate demonstrations. The molecular structure is the input, the evolving QRTL field is the intermediate physical state represented by the model, and the final molecular energy, resonance, stability, tunneling, and transition results are outputs of the same connected calculation. Every intermediate state can therefore be inspected, validated, and traced back to the preceding stage.

 */

import SwiftUI
import SceneKit
import UIKit
import Combine

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var engine = PeptideAssemblyEngine()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            QRTLPeptideSceneView(engine: engine)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Spacer()
                informationPanel
                controls
            }
            .padding(.horizontal, 14)
            .padding(.top, 10)
            .padding(.bottom, 12)
        }
        .preferredColorScheme(.dark)
        .onAppear { engine.start() }
    }

    private var header: some View {
        VStack(spacing: 5) {
            HStack {
                Text("QRTL PEPTIDE")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                Spacer()
                Text("\(engine.stageIndex + 1)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                Text("/")
                    .foregroundStyle(.secondary)
                Text("\(engine.stages.count)")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("CONTROLLED CURRENT • RESONANCE • MOLECULAR ASSEMBLY")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
                Circle()
                    .fill(engine.running ? .green : .gray)
                    .frame(width: 7, height: 7)
                Text(engine.running ? "RUNNING" : "PAUSED")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var informationPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text(engine.stage.title)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                    Spacer()
                    Text(engine.stage.number)
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                Text(engine.stage.whatHappened)
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.86))

                HStack(alignment: .top, spacing: 14) {
                    infoColumn("WHY IT MATTERS", engine.stage.whyItMatters)
                    infoColumn("ANALOGY", engine.stage.analogy)
                }

                Divider().opacity(0.3)

                equationView

                Divider().opacity(0.3)

                HStack(spacing: 10) {
                    metric("I_QRTL", engine.qrtlCurrent, "%.3f")
                    metric("f_QRTL", engine.resonanceFrequency, "%.3f")
                    metric("C", engine.coherence, "%.3f")
                    metric("B_Q", engine.fieldValue, "%.3f")
                }

                HStack(spacing: 10) {
                    metric("Echem", engine.chemicalEnergy, "%.4f")
                    metric("EQRTL", engine.qrtlEnergy, "%.4f")
                    metric("Eeff", engine.effectiveEnergy, "%.4f")
                    metric("P", engine.transitionProbability, "%.4f")
                }

                HStack(spacing: 10) {
                    metric("Atoms", Double(engine.organizedAtomCount), "%.0f")
                    metric("Amino acids", Double(engine.aminoAcidCount), "%.0f")
                    metric("Bonds", Double(engine.peptideBondCount), "%.0f")
                    metric("Chain", Double(engine.peptideLength), "%.0f")
                }

                Text(engine.statusMessage)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(.cyan.opacity(0.9))
            }
            .padding(13)
        }
        .frame(maxHeight: 300)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }

    private func infoColumn(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 8, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
            Text(text)
                .font(.system(size: 10, design: .rounded))
                .foregroundStyle(.white.opacity(0.78))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var equationView: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("ACTIVE EQUATION")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(.secondary)
            Text(engine.stage.equation)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func metric(_ name: String, _ value: Double, _ format: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.system(size: 7, weight: .medium))
                .foregroundStyle(.secondary)
            Text(String(format: format, value))
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var controls: some View {
        VStack(spacing: 7) {
            HStack(spacing: 8) {
                Button { engine.previousStage() } label: {
                    Image(systemName: "backward.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button { engine.toggleRunning() } label: {
                    Image(systemName: engine.running ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button { engine.nextStage() } label: {
                    Image(systemName: "forward.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button { engine.reset() } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            HStack(spacing: 14) {
                slider("QRTL current", value: $engine.qrtlCurrent, range: 0...1)
                slider("Resonance", value: $engine.resonanceFrequency, range: 0.5...1.5)
                slider("Coherence", value: $engine.coherence, range: 0...1)
            }
        }
        .padding(11)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }

    private func slider(_ title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 8, weight: .semibold))
            Slider(value: value, in: range)
        }
        .frame(maxWidth: .infinity)
    }
}

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

// MARK: - Engine

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

    @Published private(set) var organizedAtomCount = 0
    @Published private(set) var aminoAcidCount = 0
    @Published private(set) var peptideBondCount = 0
    @Published private(set) var peptideLength = 0

    @Published private(set) var statusMessage =
        "QRTL is currently off. The control condition is established."


    // Normalized energy scale. The app explicitly does not claim
    // these values are joules. A calibrated implementation must replace
    // this with experimentally defined energy units.
    let modelKBT = 1.0

    // Proposed/model-defined QRTL coefficients.
    var qrtlFieldGain = 1.0
    var qrtlEnergyCoupling = 0.25
    var densityCoupling = 0.10

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
        organizedAtomCount = 0
        aminoAcidCount = 0
        peptideBondCount = 0
        peptideLength = 0
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

    private func controlOff() {
        qrtlCurrent = 0
        fieldValue = 0
        qrtlEnergy = 0
        statusMessage = "Control: QRTL contribution disabled."
    }

    private func applyCurrent() {
        calculateField()
        statusMessage = "Controlled QRTL current applied to the model-defined field."
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
        statusMessage = "Cell states evolved from local and neighboring calculated values."
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
                AminoAcidUnit(
                    name: name,
                    code: "G",
                    position: SIMD3<Double>(Double(index) * 1.20 - 1.80, 0, 0),
                    orientation: SIMD3<Double>(1, 0, 0),
                    chemicalEnergy: -0.20,
                    bondedToNext: false
                )
            }
        }
        for i in cells.indices { cells[i].state = .aminoAcid }
        aminoAcidCount = aminoAcids.count
        statusMessage = "The atomic layer has produced coarse-grained amino-acid building blocks."
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
        statusMessage = "Amino and carboxyl termini are represented with explicit relative orientation."
    }

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

        let a = aminoAcids[0]
        let b = aminoAcids[1]

        let delta = b.position - a.position
        let distance = simd_length(delta)
        let idealDistance = 1.20
        let distanceFactor = exp(-pow((distance - idealDistance) / 0.45, 2.0))

        let direction = distance > 0 ? delta / distance : SIMD3<Double>(1,0,0)
        let dot = max(-1.0, min(1.0, simd_dot(a.orientation, direction)))
        let orientationFactor = 0.5 + 0.5 * dot

        // Coarse-grained chemical term: not a force field.
        let deltaChemical =
            chemicalBondScale
            + distancePenalty * (1.0 - distanceFactor)
            + orientationPenalty * (1.0 - orientationFactor)

        // Explicit QRTL difference:
        // ΔEQRTL = EQRTL(product) - EQRTL(reactants)
        //
        // In this model, a more coherent, better-aligned candidate receives
        // a lower QRTL energy by an explicit coupling term. This is a
        // hypothesis parameter, not an established physical law.
        let candidateResonance =
            qrtlCurrent *
            qrtlEnergyCoupling *
            (0.5 + 0.5 * coherence) *
            (0.5 + 0.5 * orientationFactor)

        let reactantResonance =
            qrtlCurrent *
            qrtlEnergyCoupling *
            (0.5 + 0.5 * coherence)

        let deltaQRTL = candidateResonance - reactantResonance

        let deltaEffective = deltaChemical + deltaQRTL

        // The requested expression is dimensionally meaningful only when
        // ΔG and kBT share units. Here all energies are reduced by kBT,
        // so the exponent is dimensionless:
        //
        // P = 1 / [1 + exp(ΔG_effective / kBT)]
        let reduced = max(-60.0, min(60.0, deltaEffective / modelKBT))
        let probability = 1.0 / (1.0 + exp(reduced))

        let accepted =
            probability >= 0.50 &&
            orientationFactor >= 0.70 &&
            distanceFactor >= 0.65

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

        if e.accepted {
            peptideBondCount = max(peptideBondCount, 1)
            for i in cells.indices { cells[i].state = .peptideBond }
            statusMessage = "Controlled coupling accepted: energy probability and geometry passed."
        } else {
            statusMessage = "Controlled coupling rejected: the calculated energy/geometry conditions were not sufficient."
        }
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
                            bondingAvailability: 0
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

// MARK: - SceneKit bridge

struct QRTLPeptideSceneView: UIViewRepresentable {
    @ObservedObject var engine: PeptideAssemblyEngine

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = makeScene()
        view.backgroundColor = .black
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = false
        return view
    }

    func updateUIView(_ view: SCNView, context: Context) {
        guard let scene = view.scene else { return }

        scene.rootNode.childNode(withName: "DynamicSystem", recursively: false)?
            .removeFromParentNode()

        let root = SCNNode()
        root.name = "DynamicSystem"
        scene.rootNode.addChildNode(root)

        addQRTLField(to: root, engine: engine)
        addAtoms(to: root, engine: engine)
        addPeptide(to: root, engine: engine)
        addLabels(to: root, engine: engine)
    }

    private func makeScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        // MARK: - Camera

        let cameraNode = SCNNode()
        let camera = SCNCamera()

        camera.fieldOfView = 60
        camera.zNear = 0.01
        camera.zFar = 1000

        cameraNode.camera = camera

        // Pull the camera farther back so the complete peptide
        // can fit inside the initial frame.
        cameraNode.position = SCNVector3(0, 1.0, 10.0)

        // Look toward the center of the peptide.
        cameraNode.look(at: SCNVector3(0, -1, 0))

        scene.rootNode.addChildNode(cameraNode)

        // MARK: - Key light

        let key = SCNNode()
        let keyLight = SCNLight()

        keyLight.type = .omni
        keyLight.intensity = 1200

        key.light = keyLight
        key.position = SCNVector3(6, 8, 10)

        scene.rootNode.addChildNode(key)

        // MARK: - Fill light

        let fill = SCNNode()
        let fillLight = SCNLight()

        fillLight.type = .omni
        fillLight.intensity = 700

        fill.light = fillLight
        fill.position = SCNVector3(-6, 4, 8)

        scene.rootNode.addChildNode(fill)

        // MARK: - Ambient light

        let ambient = SCNNode()
        let ambientLight = SCNLight()

        ambientLight.type = .ambient
        ambientLight.intensity = 350

        ambient.light = ambientLight

        scene.rootNode.addChildNode(ambient)

        return scene
    }

    private func addQRTLField(to root: SCNNode, engine: PeptideAssemblyEngine) {
        let radius = CGFloat(1.7 + engine.fieldValue * 1.0)
        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 36

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.cyan.withAlphaComponent(
            CGFloat(min(0.18, 0.035 + engine.fieldValue * 0.12))
        )
        material.emission.contents = UIColor.cyan.withAlphaComponent(0.15)
        material.transparency = 0.28
        material.isDoubleSided = true
        sphere.firstMaterial = material

        let node = SCNNode(geometry: sphere)
        node.name = "QRTLField"
        root.addChildNode(node)

        if engine.qrtlCurrent > 0.001 {
            let ring = SCNTorus(
                ringRadius: CGFloat(1.1 + engine.fieldValue),
                pipeRadius: 0.018
            )
            ring.firstMaterial = material
            let ringNode = SCNNode(geometry: ring)
            ringNode.eulerAngles.x = .pi / 2
            ringNode.runAction(
                SCNAction.repeatForever(
                    SCNAction.rotateBy(x: 0, y: .pi * 2, z: 0, duration: 2.0)
                )
            )
            root.addChildNode(ringNode)
        }
    }

    private func addAtoms(to root: SCNNode, engine: PeptideAssemblyEngine) {
        for (index, cell) in engine.cells.enumerated() {
            let radius: CGFloat
            let material: SCNMaterial

            switch cell.state {
            case .carbon:
                radius = 0.16
                material = atomMaterial(.gray)
            case .hydrogen:
                radius = 0.09
                material = atomMaterial(.white)
            case .nitrogen:
                radius = 0.14
                material = atomMaterial(.blue)
            case .oxygen:
                radius = 0.14
                material = atomMaterial(.red)
            case .sulfur:
                radius = 0.17
                material = atomMaterial(.yellow)
            case .functionalGroup:
                radius = 0.18
                material = atomMaterial(.orange)
            default:
                continue
            }

            let sphere = SCNSphere(radius: radius)
            sphere.segmentCount = 18
            sphere.firstMaterial = material

            let node = SCNNode(geometry: sphere)
            node.name = "Atom_\(index)"
            node.position = SCNVector3(
                Float(cell.position.x),
                Float(cell.position.y),
                Float(cell.position.z)
            )

            root.addChildNode(node)

            if cell.qrtlField > 0.001 {
                let halo = SCNSphere(radius: radius * 1.7)
                halo.firstMaterial = haloMaterial(cell.qrtlField)
                let haloNode = SCNNode(geometry: halo)
                node.addChildNode(haloNode)
            }
        }
    }

    private func addPeptide(to root: SCNNode, engine: PeptideAssemblyEngine) {
        guard !engine.aminoAcids.isEmpty else { return }

        for i in engine.aminoAcids.indices {
            let aa = engine.aminoAcids[i]
            addAminoAcid(aa, index: i, to: root)

            if i < engine.aminoAcids.count - 1 {
                let next = engine.aminoAcids[i + 1]
                let active = i < engine.peptideBondCount

                let bond = cylinder(
                    from: scenePosition(aa.position),
                    to: scenePosition(next.position),
                    radius: active ? 0.055 : 0.018,
                    material: active
                        ? atomMaterial(.white)
                        : atomMaterial(.gray)
                )

                root.addChildNode(bond)

                if active {
                    addWaterProduct(
                        midpoint(
                            aa.position,
                            next.position
                        ),
                        to: root,
                        index: i
                    )
                }
            }
        }
    }

    private func addAminoAcid(
        _ aa: AminoAcidUnit,
        index: Int,
        to root: SCNNode
    ) {
        let group = SCNNode()
        group.name = "AminoAcid_\(index)"
        group.position = scenePosition(aa.position)

        let carbon = atom(.gray, 0.19)
        group.addChildNode(carbon)

        let nitrogen = atom(.blue, 0.13)
        nitrogen.position = SCNVector3(-0.25, 0.16, 0)
        group.addChildNode(nitrogen)

        let oxygen = atom(.red, 0.13)
        oxygen.position = SCNVector3(0.28, 0.16, 0)
        group.addChildNode(oxygen)

        let hydrogen = atom(.white, 0.075)
        hydrogen.position = SCNVector3(-0.25, -0.18, 0.12)
        group.addChildNode(hydrogen)

        let sideChain = atom(.gray, 0.12)
        sideChain.position = SCNVector3(0, -0.28, -0.12)
        group.addChildNode(sideChain)

        root.addChildNode(group)
    }

    private func addWaterProduct(
        _ position: SIMD3<Double>,
        to root: SCNNode,
        index: Int
    ) {
        let water = SCNNode()
        water.name = "Water_\(index)"
        water.position = scenePosition(position)
        water.scale = SCNVector3(0.45, 0.45, 0.45)

        let oxygen = atom(.red, 0.16)
        water.addChildNode(oxygen)

        let h1 = atom(.white, 0.08)
        h1.position = SCNVector3(0.18, 0.13, 0)
        water.addChildNode(h1)

        let h2 = atom(.white, 0.08)
        h2.position = SCNVector3(-0.18, 0.13, 0)
        water.addChildNode(h2)

        water.runAction(
            SCNAction.repeatForever(
                SCNAction.sequence([
                    SCNAction.moveBy(x: 0, y: 0.10, z: 0, duration: 0.7),
                    SCNAction.moveBy(x: 0, y: -0.10, z: 0, duration: 0.7)
                ])
            )
        )

        root.addChildNode(water)
    }

    private func addLabels(
        to root: SCNNode,
        engine: PeptideAssemblyEngine
    ) {
        let text = SCNText(
            string: engine.stage.title,
            extrusionDepth: 0.002
        )
        text.font = UIFont.systemFont(ofSize: 0.13, weight: .semibold)
        text.firstMaterial = atomMaterial(.white)

        let node = SCNNode(geometry: text)
        node.position = SCNVector3(-2.3, 2.0, 0)
        node.scale = SCNVector3(0.55, 0.55, 0.55)

        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .all
        node.constraints = [constraint]

        root.addChildNode(node)
    }

    private func atom(_ color: UIColor, _ radius: CGFloat) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 18
        sphere.firstMaterial = atomMaterial(color)
        return SCNNode(geometry: sphere)
    }

    private func atomMaterial(_ color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.lightingModel = .physicallyBased
        material.metalness.contents = 0.1
        material.roughness.contents = 0.35
        return material
    }
    
    private func haloMaterial(_ value: Double) -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.cyan.withAlphaComponent(CGFloat(min(0.22, value * 0.4)))
        m.emission.contents = UIColor.cyan.withAlphaComponent(CGFloat(min(0.15, value * 0.25)))
        m.transparency = 0.55
        return m
    }

    private func scenePosition(_ p: SIMD3<Double>) -> SCNVector3 {
        SCNVector3(Float(p.x), Float(p.y), Float(p.z))
    }

    private func midpoint(_ a: SIMD3<Double>, _ b: SIMD3<Double>) -> SIMD3<Double> {
        (a + b) / 2.0
    }

    private func cylinder(
        from: SCNVector3,
        to: SCNVector3,
        radius: CGFloat,
        material: SCNMaterial
    ) -> SCNNode {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        let length = sqrt(dx * dx + dy * dy + dz * dz)

        let geometry = SCNCylinder(radius: radius, height: CGFloat(length))
        geometry.radialSegmentCount = 12
        geometry.firstMaterial = material

        let node = SCNNode(geometry: geometry)
        node.position = SCNVector3(
            (from.x + to.x) / 2,
            (from.y + to.y) / 2,
            (from.z + to.z) / 2
        )

        let vector = SCNVector3(dx, dy, dz)
        node.rotation = rotationBetween(SCNVector3(0, 1, 0), vector)
        return node
    }

    private func rotationBetween(_ a: SCNVector3, _ b: SCNVector3) -> SCNVector4 {
        let aa = normalize(a)
        let bb = normalize(b)

        let cross = SCNVector3(
            aa.y * bb.z - aa.z * bb.y,
            aa.z * bb.x - aa.x * bb.z,
            aa.x * bb.y - aa.y * bb.x
        )

        let dot = max(-1.0, min(1.0,
            aa.x * bb.x + aa.y * bb.y + aa.z * bb.z
        ))

        let angle = acos(dot)
        let n = sqrt(cross.x * cross.x + cross.y * cross.y + cross.z * cross.z)

        if n < 0.00001 {
            return SCNVector4(1, 0, 0, 0)
        }

        return SCNVector4(
            cross.x / n,
            cross.y / n,
            cross.z / n,
            angle
        )
    }

    private func normalize(_ v: SCNVector3) -> SCNVector3 {
        let n = sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
        if n < 0.00001 { return SCNVector3(0, 1, 0) }
        return SCNVector3(v.x / n, v.y / n, v.z / n)
    }
}

// MARK: - SceneKit camera helper

private extension SCNNode {
    func lookAt(_ target: SCNVector3) {
        let d = SCNVector3(
            target.x - position.x,
            target.y - position.y,
            target.z - position.z
        )

        let horizontal = sqrt(d.x * d.x + d.z * d.z)

        eulerAngles = SCNVector3(
            -atan2(d.y, horizontal),
            atan2(d.x, d.z),
            0
        )
    }
}
