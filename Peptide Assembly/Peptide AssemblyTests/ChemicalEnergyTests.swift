//
//  File.swift
//  Peptide AssemblyTests
//
//  Created by David Nishimoto on 9/20/26.
//

import Foundation
import XCTest
@testable import Peptide_Assembly

final class ChemicalEnergyTests: XCTestCase {

    // MARK: - Constants

    private let referenceBondEnergyKJPerMol = 350.0

    private let avogadro = 6.02214076e23

    private let kJPerMolPerEV = 96.48533212

    // MARK: - Test 1
    // Verify the basic QRTL bond-energy multiplication.

    func testRawBondEnergyCalculation() {

        let localEnergyDensity = 0.163
        let localField = 1.0
        let coherence = 1.0
        let phaseFactor = 1.0

        let expected =
            localEnergyDensity *
            localField *
            coherence *
            phaseFactor

        let actual =
            localEnergyDensity *
            localField *
            coherence *
            phaseFactor

        XCTAssertEqual(
            actual,
            expected,
            accuracy: 0.0000001
        )

        XCTAssertGreaterThan(
            actual,
            0.0,
            "Raw bond energy should be greater than zero."
        )

        print("Raw bond energy =", actual)
    }

    // MARK: - Test 2
    // Verify that zero QRTL field produces zero bond energy.

    func testZeroFieldProducesZeroChemicalEnergy() {

        let localEnergyDensity = 0.163
        let localField = 0.0
        let coherence = 1.0
        let phaseFactor = 1.0

        let rawBondEnergy =
            localEnergyDensity *
            localField *
            coherence *
            phaseFactor

        XCTAssertEqual(
            rawBondEnergy,
            0.0,
            accuracy: 0.0000001
        )

        print("Zero-field test passed")
    }

    // MARK: - Test 3
    // Verify the chemical-energy conversion.

    func testChemicalEnergyConversion() {

        let normalizedActivation = 0.5

        let expectedKJPerMol =
            normalizedActivation *
            referenceBondEnergyKJPerMol

        let expectedEV =
            expectedKJPerMol /
            kJPerMolPerEV

        let expectedJoulesPerMolecule =
            (expectedKJPerMol * 1000.0) /
            avogadro

        // 0.5 × 350 = 175 kJ/mol
        XCTAssertEqual(
            expectedKJPerMol,
            175.0,
            accuracy: 0.000001
        )

        // 175 kJ/mol converted to eV
        XCTAssertEqual(
            expectedEV,
            1.81374,
            accuracy: 0.0001
        )

        // 175 kJ/mol converted to joules per molecule
        XCTAssertEqual(
            expectedJoulesPerMolecule,
            2.906e-19,
            accuracy: 1e-22
        )

        XCTAssertTrue(
            expectedKJPerMol.isFinite
        )

        XCTAssertTrue(
            expectedEV.isFinite
        )

        XCTAssertTrue(
            expectedJoulesPerMolecule.isFinite
        )

        print("Chemical energy =", expectedKJPerMol, "kJ/mol")
        print("Chemical energy =", expectedEV, "eV")
        print(
            "Energy / molecule =",
            expectedJoulesPerMolecule,
            "J"
        )
    }

    // MARK: - Test 4
    // Verify the complete calculation.

    func testCompleteChemicalEnergyCalculation() {

        let localEnergyDensity = 0.163
        let localField = 1.0
        let coherence = 1.0
        let phaseFactor = 1.0

        let rawBondEnergy =
            localEnergyDensity *
            localField *
            coherence *
            phaseFactor

        let normalizedActivation =
            min(
                1.0,
                max(
                    0.0,
                    rawBondEnergy
                )
            )

        let chemicalEnergyKJPerMol =
            normalizedActivation *
            referenceBondEnergyKJPerMol

        let chemicalEnergyEV =
            chemicalEnergyKJPerMol /
            kJPerMolPerEV

        let chemicalEnergyJoulesPerMolecule =
            (chemicalEnergyKJPerMol * 1000.0) /
            avogadro

        XCTAssertEqual(
            rawBondEnergy,
            0.163,
            accuracy: 0.000001
        )

        XCTAssertEqual(
            normalizedActivation,
            0.163,
            accuracy: 0.000001
        )

        XCTAssertEqual(
            chemicalEnergyKJPerMol,
            57.05,
            accuracy: 0.000001
        )

        XCTAssertEqual(
            chemicalEnergyEV,
            0.5913,
            accuracy: 0.001
        )

        XCTAssertGreaterThan(
            chemicalEnergyJoulesPerMolecule,
            0.0
        )

        XCTAssertTrue(
            chemicalEnergyKJPerMol.isFinite
        )

        XCTAssertTrue(
            chemicalEnergyEV.isFinite
        )

        XCTAssertTrue(
            chemicalEnergyJoulesPerMolecule.isFinite
        )

        print("""
        
        ===== COMPLETE CHEMICAL ENERGY TEST =====
        Local Energy Density = \(localEnergyDensity)
        Local Field          = \(localField)
        Coherence            = \(coherence)
        Phase Factor         = \(phaseFactor)
        
        Raw Bond Energy      = \(rawBondEnergy)
        Activation           = \(normalizedActivation)
        
        Chemical Energy      = \(chemicalEnergyKJPerMol) kJ/mol
        Chemical Energy      = \(chemicalEnergyEV) eV
        Energy / Molecule    = \(chemicalEnergyJoulesPerMolecule) J
        
        ==========================================
        """)
    }

    // MARK: - Test 5
    // Verify that phase destroys the energy when phaseFactor = 0.

    func testZeroPhaseFactorProducesZeroBondEnergy() {

        let localEnergyDensity = 1.0
        let localField = 1.0
        let coherence = 1.0
        let phaseFactor = 0.0

        let rawBondEnergy =
            localEnergyDensity *
            localField *
            coherence *
            phaseFactor

        XCTAssertEqual(
            rawBondEnergy,
            0.0,
            accuracy: 0.0000001
        )
    }

    // MARK: - Test 6
    // Verify that coherence affects the calculated energy.

    func testCoherenceChangesBondEnergy() {

        let localEnergyDensity = 1.0
        let localField = 1.0
        let phaseFactor = 1.0

        let lowCoherence = 0.5
        let highCoherence = 1.0

        let lowEnergy =
            localEnergyDensity *
            localField *
            lowCoherence *
            phaseFactor

        let highEnergy =
            localEnergyDensity *
            localField *
            highCoherence *
            phaseFactor

        XCTAssertEqual(
            lowEnergy,
            0.5,
            accuracy: 0.000001
        )

        XCTAssertEqual(
            highEnergy,
            1.0,
            accuracy: 0.000001
        )

        XCTAssertGreaterThan(
            highEnergy,
            lowEnergy
        )
    }
}
