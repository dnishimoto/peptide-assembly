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
    @State private var showingBondFailureAlert = false

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
        .onReceive(engine.$bondFailureMessage) { message in
            showingBondFailureAlert = message != nil
        }
        .alert("Peptide Bond Formation Blocked", isPresented: $showingBondFailureAlert) {
            Button("OK", role: .cancel) { engine.clearBondFailure() }
        } message: {
            Text(engine.bondFailureMessage ?? "The calculated bond conditions were not satisfied.")
        }
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
                    metric("Current", engine.qrtlCurrent, "%.3f")
                    metric("Resonance Frequency", engine.resonanceFrequency, "%.3f")
                    metric("Coherence", engine.coherence, "%.3f")
                    metric("B_Q", engine.fieldValue, "%.3f")
                }

                HStack(spacing: 10) {
                    metric("Chemical Energy", engine.chemicalEnergy, "%.4f")
                    metric("Energy", engine.qrtlEnergy, "%.4f")
                    metric("Effective Energy", engine.effectiveEnergy, "%.4f")
                    metric("Transition Probability", engine.transitionProbability, "%.4f")
                }

                HStack(spacing: 10) {
                    metric("Atoms", Double(engine.organizedAtomCount), "%.0f")
                    metric("Amino acids", Double(engine.aminoAcidCount), "%.0f")
                    metric("Bonds", Double(engine.peptideBondCount), "%.0f")
                    metric("Chain", Double(engine.peptideLength), "%.0f")
                }

                if let diagnostic = engine.latestBondDiagnostic {
                    PeptideBondDiagnosticCard(diagnostic: diagnostic)
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








