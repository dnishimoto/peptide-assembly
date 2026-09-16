//
//  File.swift
//  Peptide Assembly
//
//  Created by David Nishimoto on 9/15/26.
//

import Foundation
import SwiftUI

// MARK: - AboutView
//
// A professional "About" screen for the QRTL Peptide Assembly simulator.
// It is built directly from the same PeptideAssemblyEngine pipeline that
// drives the live simulation, so the stage descriptions shown here can
// never drift out of sync with the model the user is actually watching.

struct AboutView: View {
    @ObservedObject var engine: PeptideAssemblyEngine
    @Environment(\.dismiss) private var dismiss

    @State private var expandedStageID: PeptideStage.ID?

    private let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    private let buildNumber = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color(red: 0.05, green: 0.08, blue: 0.11)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 22) {
                        heroHeader
                        overviewCard
                        metricsStrip
                        pipelineSection
                        disclaimerCard
                        creditsFooter
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                    .padding(.bottom, 28)
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: Hero header

    private var heroHeader: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.cyan.opacity(0.35), Color.cyan.opacity(0.0)],
                            center: .center,
                            startRadius: 2,
                            endRadius: 60
                        )
                    )
                    .frame(width: 108, height: 108)

                Circle()
                    .strokeBorder(Color.cyan.opacity(0.5), lineWidth: 1.2)
                    .frame(width: 84, height: 84)

                Image(systemName: "atom")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.top, 6)

            VStack(spacing: 5) {
                Text("QRTL Peptide Assembly")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text("A CONTROLLED SIMULATION OF QUARK-TWISTER RESONANCE\nLATTICE COUPLING TO MOLECULAR ASSEMBLY")
                    .font(.system(size: 9.5, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }

            HStack(spacing: 6) {
                Image(systemName: "number")
                    .font(.system(size: 9, weight: .bold))
                Text("Version \(appVersion) (\(buildNumber))")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
            }
            .foregroundStyle(.white.opacity(0.75))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Overview

    private var overviewCard: some View {
        SectionCard(title: "Overview", icon: "text.alignleft") {
            VStack(alignment: .leading, spacing: 10) {
                Text("This app models a proposed causal chain linking a controlled Quark-Twister Resonance Lattice (QRTL) field to peptide-bond formation and folding.")
                    .aboutBody()

                Text("A coarse-grained molecular lattice, an energy shell, and a resonance field are updated together at every step, so the same connected pipeline governs assembly and folding rather than two independent demonstrations.")
                    .aboutBody()

                Text("Every value shown during the simulation — field strength, resonance, coherence, chemical and QRTL energy, transition probability, and bond count — is produced by that single pipeline and can be traced back to the preceding stage.")
                    .aboutBody()
            }
        }
    }

    // MARK: Metrics strip

    private var metricsStrip: some View {
        HStack(spacing: 10) {
            aboutMetric(value: "\(engine.stages.count)", label: "PIPELINE\nSTAGES")
            aboutMetric(value: "\(engine.programmedSequence.count)", label: "PROGRAMMED\nRESIDUES")
            aboutMetric(value: "27", label: "COUPLED\nEQUATIONS")
        }
    }

    private func aboutMetric(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.cyan)
            Text(label)
                .font(.system(size: 8, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    // MARK: Pipeline

    private var pipelineSection: some View {
        SectionCard(title: "How the Pipeline Works", icon: "point.3.connected.trianglepath.dotted") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Every run advances through the same \(engine.stages.count) stages, in order. Tap a stage to see its governing equation and why it matters.")
                    .aboutBody()
                    .padding(.bottom, 4)

                VStack(spacing: 8) {
                    ForEach(engine.stages) { stage in
                        StageDisclosureRow(
                            stage: stage,
                            isExpanded: expandedStageID == stage.id
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                expandedStageID = expandedStageID == stage.id ? nil : stage.id
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: Disclaimer

    private var disclaimerCard: some View {
        SectionCard(title: "Model Status", icon: "exclamationmark.triangle.fill", accent: .yellow) {
            VStack(alignment: .leading, spacing: 8) {
                Text("QRTL is a proposed, dimensionless coupling term, not an established physical mechanism. Every energy value in the simulation is a model unit until it is calibrated against a real experiment.")
                    .aboutBody()

                Text("The app always reports a control comparison — the predicted outcome with the QRTL term disabled — alongside the QRTL-enabled result, so a causal claim is never based on a single run.")
                    .aboutBody()

                Text("Folded structures shown here are local minima of a simplified conformational model, not experimentally validated biological structures.")
                    .aboutBody()
            }
        }
    }

    // MARK: Credits

    private var creditsFooter: some View {
        VStack(spacing: 10) {
            Divider().opacity(0.15)

            HStack(spacing: 8) {
                techBadge("SwiftUI")
                techBadge("SceneKit")
                techBadge("Combine")
            }

            Text("Built by David Nishimoto")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))

            Text("© \(currentYear) · All simulation results are theoretical.")
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }

    private func techBadge(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold, design: .monospaced))
            .foregroundStyle(.cyan.opacity(0.9))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.cyan.opacity(0.25), lineWidth: 1))
    }

    private var currentYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }
}

// MARK: - Reusable section card

private struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    var accent: Color = .cyan
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(accent)
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .tracking(0.5)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
}

// MARK: - Stage row

private struct StageDisclosureRow: View {
    let stage: PeptideStage
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(alignment: .center, spacing: 10) {
                    Text(stage.number)
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.black)
                        .frame(width: 26, height: 26)
                        .background(Color.cyan, in: Circle())

                    Text(stage.title)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.92))
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 9) {
                    Text(stage.whatHappened)
                        .aboutBody()

                    VStack(alignment: .leading, spacing: 3) {
                        Text("EQUATION")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.secondary)
                        Text(stage.equation)
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.cyan)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("WHY IT MATTERS")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.secondary)
                        Text(stage.whyItMatters)
                            .aboutBody()
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 36)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(12)
        .background(.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 13))
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Shared text style

private extension View {
    func aboutBody() -> some View {
        self
            .font(.system(size: 11.5, weight: .regular, design: .rounded))
            .foregroundStyle(.white.opacity(0.82))
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview

#Preview {
    AboutView(engine: PeptideAssemblyEngine())
}
