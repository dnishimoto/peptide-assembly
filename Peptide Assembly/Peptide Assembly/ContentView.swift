
/*
The current peptide-assembly model can be understood as a controlled molecular
workshop in which a peptide is assembled inside a computational environment.
The peptide is the object being constructed, the cellular automaton is the
workshop floor surrounding it, the QRTL drive is a controllable source of
modeled excitation, and the local QRTL field represents the influence that
the driven lattice produces around the molecular structure. The important
feature of the current implementation is that these components are not
completely independent demonstrations. They are connected through explicit
state variables and calculations. The molecular configuration influences the
cellular automaton, the cellular automaton provides local quantities used by
the QRTL calculations, the QRTL drive changes the modeled QRTL current and
field, and those quantities participate in the local transition calculation
used to determine whether the modeled peptide coupling condition is satisfied.
At the same time, the current implementation should be understood as a
computational model rather than as an experimentally established description
of molecular physics. Several quantities have not been assigned physical SI
units, and the QRTL relationships remain model assumptions unless they are
independently derived or experimentally validated.

The process begins with a controlled initial condition. The QRTL current starts
at zero, the QRTL field is initially absent, and the QRTL energy contribution
is initially zero. This starting condition is important because it provides a
control state. In the workshop analogy, this is equivalent to setting up the
molecular assembly bench before turning on the special power source. The
peptide environment can therefore be examined first without a QRTL drive and
then examined again with the drive enabled. This distinction becomes
particularly important later when the model compares QRTL-on and QRTL-off
conditions. A zero QRTL contribution at the beginning is therefore not a
statement that the chemical system contains no energy. It means that the
specific QRTL contribution represented by the model has not yet been applied.

The molecular program currently consists of four glycine residues. The
programmed sequence is Gly-Gly-Gly-Gly, and the model constructs the
corresponding amino-acid units as the assembly progresses. Each glycine is
represented by the modeled structure NH2–CH2–COOH. The residues are assigned
positions within the computational coordinate system and are subsequently
oriented relative to their neighboring residues. In the workshop analogy,
these four glycines are four molecular components placed on the assembly
bench in the order in which they are intended to become connected. The model
does not begin by randomly inventing a peptide. Instead, it has a programmed
molecular sequence and progressively evaluates the conditions required to
connect those components.

Surrounding the molecular components is a cellular-automaton lattice. The
current implementation creates a 5 × 5 × 3 lattice containing 75 cells. Each
cell represents a local computational region and stores quantities such as
position, energy, density, QRTL field, phase, coherence, twist speed, twist
current, energy flow, bonding availability, and cellular state. The lattice is
therefore the computational environment in which the local model evolves.
Instead of treating the entire peptide as one mathematical point with one
energy and one phase, the model distributes state information across many
locations. In the workshop analogy, the lattice is the floor and surrounding
workspace of the molecular assembly bench. Each section of the workspace can
have its own local conditions, and neighboring sections can exchange modeled
information.

The lattice is initialized before the QRTL drive is applied. Each cell begins
with its defined position and initial state. Neighbor relationships are
determined from spatial separation, allowing nearby cells to participate in
the cellular-automaton and neighbor-flow calculations. This means that the
lattice has spatial structure rather than being simply a list of unrelated
numbers. A change occurring in one region can therefore influence neighboring
regions through the rules implemented by the model. The computational
environment is consequently capable of representing localized conditions
rather than only one global molecular state.

The QRTL drive is controlled through the modeled QRTL current. The default
drive amplitude is currently 6.0, while the actual QRTL current begins at
zero. Applying the drive causes the model to calculate a nonzero QRTL current
and subsequently a QRTL field. This is one of the most important causal
relationships in the current implementation. The drive is not itself the
bond, and it does not directly declare that a peptide bond exists. Instead,
the drive provides an input that propagates through the model. In the
workshop analogy, turning the power source to level 6 does not automatically
assemble the molecular components. It supplies the operating condition from
which the local machinery calculates whether coupling can occur.

The modeled QRTL field depends on several factors. The current implementation
uses QRTL current, QRTL field gain, global coherence, a resonance-response
factor, and spatial distance from the selected field center. The field is
therefore not simply assigned as one identical value throughout the lattice.
Instead, the field is spatially distributed. Cells closer to the modeled
field center receive a stronger contribution while cells farther away receive
a reduced contribution according to the spatial response implemented in the
code. This gives the simulation a localized field structure.

The resonance response in the current implementation should be interpreted
carefully. The model contains a resonanceFrequency input and compares it with
a reference frequency to generate a response factor. That response controls
how strongly the QRTL current contributes to the modeled field. It is useful
for studying the behavior of the simulation under different resonance
conditions, but it is not currently a derivation of a physical molecular
resonance spectrum. The code therefore has a resonance-dependent response,
but that should not be confused with having independently calculated the
physical resonance frequencies of glycine or a peptide.

Once the QRTL field exists, the model calculates local QRTL energy. The
current implementation combines the local QRTL field with cell coherence,
phase, density, and a QRTL energy coupling coefficient. The result is a
modeled local QRTL energy contribution. The important distinction is that
this quantity is currently a simulation quantity rather than a dimensionally
calibrated physical energy. The code does not presently establish that the
result is measured in joules, electron-volts, or kilojoules per mole. The
energy terminology describes the role of the quantity within the model, but
the numerical value should not automatically be interpreted as a laboratory
measurement.

Chemical energy is calculated separately. The current chemical-energy
calculation uses the modeled density and bonding-availability state of the
cells. QRTL energy and chemical energy are then combined to produce the
modeled effective molecular energy. This separation is important because it
allows the simulation to ask a specific question: what happens to the modeled
molecular state when a QRTL contribution is present compared with the
condition in which that contribution is removed? In the workshop analogy,
chemical energy describes the ordinary molecular assembly conditions, while
QRTL energy represents the additional modeled influence produced by the
special operating field.

The cellular automaton then evolves. Each cell examines its previous state and
the states of its neighbors and generates a new state. The implementation
uses synchronous evolution, meaning that the new state is calculated from the
previous lattice state rather than allowing an early-updated cell to
immediately modify another cell during the same update. Local energy,
density, coherence, phase, and neighboring information participate in this
process. This is important because it creates an actual evolving cellular
system rather than a static grid used only for visualization.

Neighbor-flow processing provides another connection between cells. The
current implementation examines pairs of neighboring cells and calculates
modeled flow from differences in their twist speeds. Opposing changes are
applied to the two participating cells. The model then compares the aggregate
twist-speed quantity before and after the update and reports a global
flow-conservation error. In the workshop analogy, this is similar to
circulation between adjacent sections of the workspace: if one region sends
modeled rotational influence toward another, the receiving and sending
regions receive corresponding updates.

However, the current neighbor-flow conservation calculation should not be
interpreted as proof that physical energy is conserved. What the implementation
currently checks is conservation of the particular modeled aggregate
twist-speed quantity used by the flow calculation. A physically meaningful
energy-conservation law would require a dimensionally defined energy variable,
an explicit energy-transport equation, and appropriate source, sink, and
boundary terms. The distinction is important because numerical conservation
of one model variable does not automatically establish conservation of a
physical quantity.

After the lattice has evolved, the model organizes the cells into molecular
states. Atomic organization assigns modeled elemental states to lattice cells,
and subsequent stages identify functional groups and form the programmed
amino-acid units. These stages transform the initially generic computational
cells into a representation of the intended molecular assembly. The result
is still a model representation rather than an atom-by-atom quantum chemical
calculation.

The glycine residues are then positioned and oriented. The current model
places the four residues in a linear arrangement and determines the orientation
of each residue relative to the following residue. This means that the model
can determine whether a residue points in a compatible direction for the
candidate connection. It is important to distinguish this from a complete
atomistic rotational description. The orientation currently represents the
relationship between residues; it does not yet calculate every rotational
degree of freedom of every NH2, CH2, and COOH group.

The central transition calculation occurs when the model evaluates whether two
neighboring amino-acid units satisfy the conditions required for the modeled
peptide coupling. The current implementation uses the Gly1-to-Gly2 transition
as the primary controlled bond-formation test. Several factors participate in
this calculation, including residue distance, residue orientation, local
energy density, local QRTL field, phase difference, coherence, QRTL current,
pressure-like balance, and model-defined coupling parameters.

Distance is treated as an important geometric condition. The implementation
uses a Gaussian-like distance response centered on the preferred modeled
separation. When the residues are near the preferred distance, the distance
factor becomes stronger. When they move farther away, the factor decreases.
Orientation is handled separately. The orientation of one residue is compared
with the direction toward the other residue, producing an orientation
compatibility factor. In the workshop analogy, this is similar to two
components needing to be close enough and facing the correct way before a
joining mechanism can engage.

The QRTL current calculation then combines several conditions. The QRTL drive
amplitude is modified by distance compatibility, orientation compatibility,
coherence, phase alignment, pressure balance, and the modeled transported
energy condition. The resulting value represents the QRTL current available
to the candidate transition. This is an important feature because it prevents
the drive amplitude from being treated as the only determining factor. A
large drive does not automatically guarantee successful coupling if the
geometric or phase conditions are unfavorable.

The local QRTL field is then evaluated around the candidate bond. Instead of
using only a global field value, the model examines the local region around
the two residues and their midpoint. The local energy density and local field
are combined with coherence and phase alignment to produce the current
bond-formation score. The implemented relationship is:

bondEnergy =
    localEnergyDensity × localField × coherence × phaseFactor

The name bondEnergy should be understood carefully. In the current
implementation this is a model-defined bond-formation metric, not a calibrated
chemical bond energy. The calculation does not currently establish units of
joules, electron-volts, or kilojoules per mole. The quantity is nevertheless
useful computationally because it provides a scalar measure that can be used
to determine whether the modeled QRTL-assisted coupling condition is strong
enough to pass the bond-formation gate.

This also explains an important observation in the simulation. If the QRTL
drive is zero, the QRTL current is zero. The calculated QRTL field consequently
becomes zero, and because the bond-formation metric is multiplicative, the
QRTL-derived bond score becomes zero. Therefore a measured zero at drive zero
does not mean that the chemical bond has zero physical energy or that the
molecular system is chemically free. It means that the QRTL-derived
contribution represented by this particular metric is zero under the control
condition.

This distinction is similar to turning off a machine in the workshop. If the
machine is switched off, its output is zero. That does not mean the material
being worked on has no physical properties. It only means that the machine is
not contributing its output at that moment. In the same way, a zero QRTL bond
score indicates that the modeled QRTL contribution is absent. It does not
measure the actual thermodynamic free energy of a peptide bond.

The model currently uses minimumBondEnergy = 0.10 as a bond-formation
threshold. This threshold is a computational criterion. It tells the program
how large the modeled bond-formation score must become before that particular
gate can be satisfied. It is not a published peptide-bond energy and should
not be interpreted as 0.10 eV, 0.10 joules, or any other physical energy unit.
The threshold is therefore best understood as a model parameter that can be
studied, varied, and eventually calibrated if a defensible physical mapping
is developed.

The candidate transition also includes pressure-like quantities. These are
calculated from local energy density and local QRTL field and are used to
evaluate whether the modeled local conditions are sufficiently balanced. These
quantities currently function as computational pressure-like variables. They
are not presently expressed as calibrated pascals or another physical pressure
unit. Their role is to provide another local condition in the bond-formation
decision.

Coherence is calculated from phase relationships. The current implementation
uses a cosine-based phase relationship, so coherence increases when the
relevant modeled phases become more closely aligned. Phase alignment also
enters the QRTL current and bond calculations. A phase difference that produces
a favorable cosine contributes positively, while an unfavorable relationship
reduces or eliminates the positive contribution. This gives phase a direct
computational role rather than making it merely a visualization parameter.

The candidate bond is accepted only when the required model gates are
satisfied. These include pressure balance, minimum bond-formation score,
minimum coherence, allowable phase difference, transition probability,
orientation compatibility, and distance compatibility. This is analogous to
a safety interlock in the molecular workshop. Several switches must be in the
correct state before the coupling mechanism is permitted to engage. A strong
QRTL drive alone does not bypass all of the other conditions.

The transition probability is calculated from a logistic relationship using
the modeled effective transition energy. The effective transition quantity
combines a chemical contribution with a QRTL contribution. The resulting
number is a model probability used by the simulation's decision logic. It
should not currently be interpreted as a directly measured chemical reaction
probability or as a quantitatively validated kinetic prediction.

When a coupling attempt succeeds, the molecular state is updated. The peptide
bond count increases, the participating residue is marked as bonded, and
relevant lattice cells are assigned peptide-bond state information. The
condensation and chain-growth stages then update the modeled representation of
the peptide. These stages currently represent molecular assembly as state
changes in the computational model. They do not yet simulate every atom,
electron, orbital, solvent molecule, or reaction intermediate involved in a
real peptide-condensation mechanism.

The programmed sequence can subsequently be completed by evaluating the
adjacent glycine pairs. Successful modeled coupling determines the represented
peptide length. This provides a clear computational progression from
individual molecular units toward the Gly4 peptide representation.

The model then applies a conformational stage. The current implementation
assigns a modeled folded geometry to the glycine residues and calculates a
conformation energy from residue positions, bond distances, environmental
terms, and a QRTL contribution. This is useful for exploring how the modeled
QRTL state changes the calculated conformational quantity, but it should not
be described as a complete molecular-dynamics simulation or quantum-chemical
conformational search. The present implementation does not yet search every
possible molecular configuration and prove that the selected geometry is the
global physical minimum.

Stabilization similarly represents a modeled stability assessment. The system
recalculates the relevant quantities and evaluates the resulting state using
the implemented criteria. This can identify a stable state according to the
simulation's rules, but it is not equivalent to experimentally demonstrating
that the actual peptide is thermodynamically stable.

One of the most useful parts of the current architecture is the QRTL control
comparison. The model evaluates the transition under the driven condition and
then evaluates it again after setting QRTL current to zero. The resulting
transition probabilities can be compared. This provides a direct computational
experiment: hold the molecular model and relevant conditions as constant as
possible, change the QRTL drive, and observe how the calculated transition
condition changes.

This control experiment gives the model a much stronger structure than simply
reporting a single successful bond. A single successful result does not show
which part of the model caused the success. A controlled comparison can show
whether the calculated transition changes when the QRTL contribution is
removed. If the driven and control states produce different results, that
difference becomes a measurable property of the simulation. It is still a
model result, but it is a more informative model result because the variable
being tested is explicitly controlled.

The overall computational chain can therefore be understood as a workshop
with feedback. The molecular components establish the initial arrangement.
The lattice establishes the computational environment. The QRTL drive
establishes an excitation input. The drive produces modeled current. The
current produces a spatial field. The field contributes to local QRTL energy.
Chemical and QRTL contributions combine into an effective modeled energy.
The cellular automaton evolves local states and neighbor relationships.
Molecular orientation and distance establish geometric compatibility.
Coherence and phase establish synchronization conditions. The local QRTL field
and energy density then contribute to the bond-formation score. The transition
calculation determines whether the modeled coupling gates are satisfied. If
the coupling succeeds, the molecular state changes, and the changed molecular
state can alter the subsequent lattice and QRTL calculations.

The key relationship is therefore not that QRTL energy directly creates a
peptide bond. Instead, the current model represents QRTL as an influence on
the local conditions under which the modeled transition is evaluated. The
QRTL drive changes current. Current changes the field. The local field
contributes to the bond-formation metric. Coherence and phase determine how
effectively that contribution participates. Geometry determines whether the
molecular components are positioned compatibly. The transition probability
and gating rules then determine whether the simulated coupling is accepted.

The current model deliberately stops short of claiming that all of these
quantities already correspond to experimentally measured physical quantities.
The QRTL current, QRTL field, QRTL energy, chemical energy, effective energy,
bond-formation score, pressure-like quantities, and transition probability are
currently model quantities unless a dimensional calibration has been added.
The resonanceFrequency is also currently a model input used in the field
response rather than a frequency independently discovered from the cellular
automaton.

This distinction is especially important for interpreting numerical results.
For example, if increasing the drive from zero to a nonzero value increases
the bond-formation score, the simulation has demonstrated that the implemented
equations produce that response. It has not yet demonstrated that a physical
peptide in nature will respond by exactly the same numerical amount. The
computational result establishes behavior within the model. Physical
validation would require a defensible mapping from the model variables to
measurable quantities and then comparison with experimental observations.

The current architecture therefore provides a framework for controlled
hypothesis testing. One can vary the QRTL drive, phase, coherence, distance,
orientation, coupling parameters, resonance input, and other model variables
and observe how the calculated peptide-assembly outcome changes. The control
condition provides a baseline. The driven condition provides the QRTL-assisted
case. The difference between them can then be studied without confusing the
QRTL contribution with the existence of the underlying chemical molecule.

The workshop analogy also explains why the cellular automaton is important.
The QRTL drive is like the power supplied to the workshop, but the power does
not independently determine the final product. The lattice represents the
workspace through which local interactions occur. Each cell is like a small
station in the workspace. Neighboring stations communicate through the
implemented flow and state-update rules. Phase represents coordination between
stations, coherence represents how consistently those stations remain
coordinated, and the local QRTL field represents the distributed influence
created by the driven system. The molecular residues are the components being
assembled. A peptide bond is accepted only when the relevant local conditions
satisfy the model's requirements.

This analogy also makes clear why a zero QRTL bond score should not be
interpreted as a zero chemical bond energy. If the workshop's special machine
is switched off, its output disappears, but the material on the workbench does
not cease to exist. Likewise, when qrtlCurrent is zero, the modeled QRTL field
goes to zero and the QRTL-derived bond score goes to zero. That is a statement
about the QRTL contribution, not a measurement of the intrinsic chemical
energy of the peptide bond.

The primary computational chain currently implemented can therefore be
summarized as follows: controlled initial condition leads to QRTL drive; the
drive establishes QRTL current; QRTL current produces a spatial QRTL field;
the field contributes to local QRTL energy; chemical and QRTL contributions
produce effective modeled energy; the cellular automaton evolves; molecular
states and glycine residues are organized; residue orientation and distance
are evaluated; the candidate transition is calculated; local QRTL current and
field are evaluated at the transition; local energy density, coherence, and
phase alignment produce the bond-formation score; the transition probability
is calculated; the peptide-bond gates are applied; successful coupling
produces chain growth; the resulting structure is subjected to modeled
conformational analysis; and finally the QRTL-on condition can be compared
with the QRTL-off control condition.

The defining principle of the current implementation is therefore causal
continuity within the computational model. A downstream quantity should be
traceable to upstream quantities rather than appearing as an unrelated
number. The QRTL field comes from the modeled current and field-response
relationship. Local QRTL energy comes from the local field and local cell
state. The bond-formation score comes from local energy density, local field,
coherence, and phase alignment. Transition probability comes from the
modeled transition-energy calculation. Bond acceptance comes from the defined
gates. The resulting molecular state can then become the starting point for
subsequent calculations.

At the same time, causal continuity within a simulation should not be confused
with physical validation. A mathematically connected program can consistently
produce results even when some of its underlying equations or parameter values
are hypotheses. The purpose of the current architecture is therefore to make
the proposed mechanism explicit, reproducible, inspectable, and testable. The
model exposes the intermediate variables instead of hiding the entire process
behind a single final answer.

The current peptide-assembly engine is consequently best understood as a
controlled computational experiment. The molecular sequence is specified,
the lattice is initialized, the QRTL drive can be turned on or off, local
states evolve, candidate peptide coupling is evaluated, and the resulting
state can be inspected. The simulation can answer questions about how its own
equations behave under controlled changes. It cannot, by itself, establish
that QRTL exists physically, that the modeled field corresponds to a known
physical field, or that the numerical bond-formation score is a measured
chemical energy.

The next level of development would therefore be dimensional calibration and
independent validation. The model quantities would need explicit definitions
of units, physical constants where appropriate, experimentally measurable
observables, and equations connecting the computational variables to those
observables. Once such a mapping exists, quantities such as the modeled
QRTL contribution, transition probability, and response to the drive could be
compared quantitatively with experimental data. Until then, the most
appropriate interpretation is that the engine provides a connected
computational representation of a proposed QRTL-assisted peptide-assembly
mechanism.

In summary, the current model begins with four programmed glycine residues
and a controlled lattice environment. It creates a 75-cell computational
field, establishes local molecular and lattice states, applies a controllable
QRTL drive, calculates QRTL current and a spatial QRTL field, derives modeled
local QRTL energy, evolves neighboring cellular states, organizes molecular
units, determines residue orientation, and evaluates a candidate peptide
coupling. The coupling calculation depends on distance, orientation, local
energy density, local field, coherence, phase alignment, QRTL current, and
other defined model conditions. The bond-formation metric is explicitly a
model score rather than a calibrated chemical energy. A zero value under the
QRTL-off condition means that the modeled QRTL contribution is absent; it does
not mean that the chemical bond itself has zero physical energy. The model
then applies transition gates, updates successful bonds, grows the programmed
peptide, applies a modeled conformational state, and compares the driven
condition with the control condition.

The result is a computational pipeline in which the QRTL drive influences the
local molecular transition rather than directly declaring that a bond exists.
The cellular automaton supplies the local computational environment, the QRTL
drive supplies a controlled excitation, the field and phase relationships
supply local transition conditions, and the bond-formation logic determines
whether the simulated coupling is accepted. The architecture is therefore
useful as a framework for investigating the proposed mechanism, provided that
its numerical outputs are interpreted according to what the code actually
calculates and are not treated as experimentally established physical
quantities until the necessary dimensional calibration and validation have
been performed.
*/


import SwiftUI
import SceneKit
import UIKit
import Combine

// MARK: - ContentView

struct ContentView: View {
    @State private var showingAbout = false
    @StateObject private var engine = PeptideAssemblyEngine()
    @State private var showingBondFailureAlert = false

    var body: some View {
        NavigationStack{
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
            .toolbar {
                           ToolbarItem(placement: .topBarTrailing) {
                               Button {
                                   showingAbout = true
                               } label: {
                                   Image(systemName: "info.circle")
                               }
                               .accessibilityLabel("About")
                           }
                       }
        }
       
                   .sheet(isPresented: $showingAbout) {
                       AboutView()
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
                    metric(
                        "QRTL Activation",
                        engine.normalizedActivation,
                        "%.5f"
                    )

                    metric(
                        "Chemical Energy (kJ/mol)",
                        engine.chemicalEnergyKJPerMol,
                        "%.3f"
                    )

                    metric(
                        "Chemical Energy (eV)",
                        engine.chemicalEnergyEV,
                        "%.5f"
                    )

                    metric(
                        "Energy / Molecule (J)",
                        engine.chemicalEnergyJoulesPerMolecule,
                        "%.4e"
                    )
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








