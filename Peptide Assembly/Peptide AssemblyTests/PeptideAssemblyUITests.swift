import XCTest
@testable import Peptide_Assembly


final class UIBackboneDisplayTests: XCTestCase {
  func testStage27BackbonePattern() throws {
    var engine = PeptideAssemblyEngine()
    engine.reset()
    for _ in 0..<26 {
      engine.nextStage()
    }
    let uiText = [
      engine.stage.title,
      engine.stage.equation,
      engine.stage.whatHappened,
      engine.stage.whyItMatters,
      engine.stage.analogy
    ].joined(separator: " ")
    let expected = "NH2–CH2–CO–NH–CH2–CO–NH–CH2–CO–NH–CH2–COOH"
    XCTAssertTrue(uiText.contains(expected), "Expected UI to display backbone pattern at stage 27.")
  }
}
