
import SwiftUI

struct AboutView: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Introduction

                    informationPanel(
                        title: "About Peptide Assembly",
                        icon: "atom",
                        text: """
                        This simulation presents a conceptual model for assembling a peptide from individual molecular components.

                        The process begins with atoms and molecular building blocks, organizes them into amino-acid structures, evaluates their local energy and interactions, and then progressively connects the amino acids into a peptide chain.

                        The QRTL model is used as a proposed mechanism for describing local energy, coupling, phase, pressure, and structural interactions during molecular assembly.
                        """
                    )

                    // MARK: - Overall Pipeline

                    informationPanel(
                        title: "Assembly Pipeline",
                        icon: "arrow.triangle.branch",
                        text: """
                        The assembly pipeline moves through a sequence of physical and molecular stages.

                        First, the system establishes the initial state of the molecular components. The components are then organized and evaluated. When neighboring molecular groups satisfy the required conditions, the simulation allows a molecular transition and possible bond formation.

                        The process continues as additional amino acids are connected. Once the chain is complete, the simulation examines its three-dimensional structure and searches for a stable configuration.
                        """
                    )

                    // MARK: - Stage 1

                    stagePanel(
                        number: 1,
                        title: "Initialization",
                        text: """
                        The simulation creates the starting atoms and molecular components.

                        Each component receives an initial position and state so the assembly process has a defined starting point.
                        """
                    )

                    // MARK: - Stage 2

                    stagePanel(
                        number: 2,
                        title: "Energy Shell Organization",
                        text: """
                        The atoms are organized according to their modeled energy states.

                        This provides the foundation for determining how the particles can interact during later stages of assembly.
                        """
                    )

                    // MARK: - Stage 3

                    stagePanel(
                        number: 3,
                        title: "QRTL Field",
                        text: """
                        The proposed QRTL field provides a local interaction environment for the molecular components.

                        The field is used by the simulation to represent relationships between nearby particles and to track how local energy is distributed through the system.
                        """
                    )

                    // MARK: - Stage 4

                    stagePanel(
                        number: 4,
                        title: "Particle Coupling",
                        text: """
                        Nearby particles are evaluated for their ability to interact.

                        Coupling describes how strongly the modeled state of one particle can influence another particle.
                        """
                    )

                    // MARK: - Stage 5

                    stagePanel(
                        number: 5,
                        title: "Molecular Configuration",
                        text: """
                        The atoms are positioned into organized molecular groups.

                        Their positions, orientations, and local energy states are evaluated as the molecular structure develops.
                        """
                    )

                    // MARK: - Stage 6

                    stagePanel(
                        number: 6,
                        title: "Amino-Acid Formation",
                        text: """
                        The required atoms are organized into amino-acid building blocks.

                        Each building block must have the appropriate molecular arrangement before it can participate in peptide assembly.
                        """
                    )

                    // MARK: - Stage 7

                    stagePanel(
                        number: 7,
                        title: "Orientation",
                        text: """
                        The simulation evaluates the relative orientation of neighboring molecular groups.

                        Proper orientation is important because two groups must be positioned appropriately before the model allows them to move toward a bonding transition.
                        """
                    )

                    // MARK: - Stage 8

                    stagePanel(
                        number: 8,
                        title: "Local Energy Evaluation",
                        text: """
                        The simulation evaluates the energy surrounding a potential molecular transition.

                        Local energy density helps determine whether sufficient energy is present at the proposed interaction site.
                        """
                    )

                    // MARK: - Stage 9

                    stagePanel(
                        number: 9,
                        title: "Pressure and Structural Conditions",
                        text: """
                        The local pressure and structural environment are evaluated before a bond transition is accepted.

                        These checks prevent the simulation from treating every nearby molecular contact as an automatic bond.
                        """
                    )

                    // MARK: - Stage 10

                    stagePanel(
                        number: 10,
                        title: "Coherence Evaluation",
                        text: """
                        The simulation evaluates how consistently the interacting molecular components are behaving.

                        Greater coherence represents a more compatible local state for the proposed transition.
                        """
                    )

                    // MARK: - Stage 11

                    stagePanel(
                        number: 11,
                        title: "Bond Transition",
                        text: """
                        When the required local conditions are satisfied, the simulation permits a transition toward bond formation.

                        The transition represents the modeled connection between two molecular building blocks.
                        """
                    )

                    // MARK: - Stage 12

                    stagePanel(
                        number: 12,
                        title: "Peptide-Bond Formation",
                        text: """
                        The compatible amino-acid groups are connected to form a peptide bond.

                        This is the key step that changes separate amino-acid building blocks into a growing peptide chain.
                        """
                    )

                    // MARK: - Stage 13

                    stagePanel(
                        number: 13,
                        title: "Chain Growth",
                        text: """
                        Additional amino acids are introduced and evaluated for connection to the existing chain.

                        The same assembly process is repeated as the peptide grows.
                        """
                    )

                    // MARK: - Stage 14

                    stagePanel(
                        number: 14,
                        title: "Sequence Completion",
                        text: """
                        The simulation continues until the requested amino-acid sequence has been assembled.

                        For the demonstration, the target is a four-glycine peptide, commonly represented as Gly4.
                        """
                    )

                    // MARK: - Stage 15

                    stagePanel(
                        number: 15,
                        title: "Conformational Search",
                        text: """
                        After the peptide chain is assembled, the simulation explores possible three-dimensional arrangements.

                        A peptide chain can adopt different shapes, so the model examines alternative configurations rather than assuming that one arrangement is automatically correct.
                        """
                    )

                    // MARK: - Stage 16

                    stagePanel(
                        number: 16,
                        title: "Folding and Stability",
                        text: """
                        The candidate structures are evaluated for their modeled stability.

                        The purpose is to identify configurations that remain structurally consistent under the conditions represented by the simulation.
                        """
                    )

                    // MARK: - Stage 17

                    stagePanel(
                        number: 17,
                        title: "Final Verification",
                        text: """
                        The completed peptide is checked to confirm that the intended molecular sequence and connections have been produced.

                        The final state provides the basis for examining the resulting structure and the calculated QRTL-related properties.
                        """
                    )

                    // MARK: - Demonstration

                    informationPanel(
                        title: "Gly4 Demonstration",
                        icon: "circle.grid.cross",
                        text: """
                        The demonstration assembles a tetrapeptide containing four glycine units.

                        The resulting structure is represented as a chain with an amino end, four glycine-derived units, peptide connections between the units, and a carboxyl end.

                        The simulation uses this simple peptide as a test case for demonstrating the complete molecular-assembly pipeline.
                        """
                    )

                    // MARK: - Why QRTL Is Used

                    informationPanel(
                        title: "Why QRTL Is Used",
                        icon: "waveform.path.ecg",
                        text: """
                        In this conceptual model, QRTL provides a way to organize and evaluate local interactions during molecular assembly.

                        Instead of treating bond formation as an immediate rule based only on distance, the model considers several local properties together, including energy, pressure, coupling, orientation, and coherence.

                        This allows the simulation to represent bond formation as a transition that occurs when the modeled local environment becomes sufficiently compatible.
                        """
                    )

                    // MARK: - What the Equations Do

                    informationPanel(
                        title: "What the Model Calculates",
                        icon: "function",
                        text: """
                        The underlying simulation contains calculations that determine local energy, energy density, field behavior, pressure differences, coupling, coherence, transition conditions, and structural stability.

                        Those calculations remain part of the simulation engine. They are not displayed here as equations because the purpose of this screen is to explain the process in understandable terms.

                        The About screen describes what the calculations accomplish rather than requiring the user to understand the mathematics behind them.
                        """
                    )

                    // MARK: - Interpretation

                    informationPanel(
                        title: "How to Interpret the Simulation",
                        icon: "info.circle",
                        text: """
                        The simulation is a computational and conceptual model. Its results describe what happens within the assumptions and rules implemented by the program.

                        A successful simulated bond or stable peptide structure means that the modeled conditions were satisfied. It does not by itself establish that the proposed QRTL mechanism has been experimentally demonstrated.
                        """
                    )
                }
                .padding()
            }
            .navigationTitle("About Peptide Assembly")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Information Panel

    private func informationPanel(
        title: String,
        icon: String,
        text: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.headline)
            }

            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.secondary.opacity(0.10))
        )
    }

    // MARK: - Stage Panel

    private func stagePanel(
        number: Int,
        title: String,
        text: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 12) {

                Text("\(number)")
                    .font(.headline)
                    .frame(
                        width: 32,
                        height: 32
                    )
                    .background(
                        Circle()
                            .fill(Color.accentColor.opacity(0.15))
                    )

                Text(title)
                    .font(.headline)
                    .padding(.top, 5)
            }

            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

#Preview {
    AboutView()
}

