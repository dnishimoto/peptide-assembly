
import Foundation
import SwiftUI
import SceneKit

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

        scene.rootNode
            .childNode(withName: "DynamicSystem", recursively: false)?
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

        let cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.fieldOfView = 60
        camera.zNear = 0.01
        camera.zFar = 1000

        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 1.0, 10.0)
        cameraNode.look(at: SCNVector3(0, -0.8, 0))

        scene.rootNode.addChildNode(cameraNode)

        let key = SCNNode()
        let keyLight = SCNLight()
        keyLight.type = .omni
        keyLight.intensity = 1200
        key.light = keyLight
        key.position = SCNVector3(4, 5, 5)
        scene.rootNode.addChildNode(key)

        let fill = SCNNode()
        let fillLight = SCNLight()
        fillLight.type = .omni
        fillLight.intensity = 600
        fill.light = fillLight
        fill.position = SCNVector3(-4, 2, 3)
        scene.rootNode.addChildNode(fill)

        let ambient = SCNNode()
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 350
        ambient.light = ambientLight
        scene.rootNode.addChildNode(ambient)

        return scene
    }

    private func addQRTLField(
        to root: SCNNode,
        engine: PeptideAssemblyEngine
    ) {
        let radius = CGFloat(1.7 + engine.fieldValue)

        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 36

        let material = SCNMaterial()
        material.diffuse.contents =
            UIColor.cyan.withAlphaComponent(
                CGFloat(min(0.18, 0.035 + engine.fieldValue * 0.12))
            )
        material.emission.contents =
            UIColor.cyan.withAlphaComponent(0.15)
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
                    SCNAction.rotateBy(
                        x: 0,
                        y: .pi * 2,
                        z: 0,
                        duration: 2.0
                    )
                )
            )

            root.addChildNode(ringNode)
        }
    }

    private func addAtoms(
        to root: SCNNode,
        engine: PeptideAssemblyEngine
    ) {
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

    private func addPeptide(
        to root: SCNNode,
        engine: PeptideAssemblyEngine
    ) {
        guard !engine.aminoAcids.isEmpty else {
            return
        }

        for i in engine.aminoAcids.indices {
            let aa = engine.aminoAcids[i]

            addAminoAcid(
                aa,
                index: i,
                to: root
            )

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

    // MARK: - Explicit Glycine

    private func addAminoAcid(
        _ aa: AminoAcidUnit,
        index: Int,
        to root: SCNNode
    ) {
        let group = SCNNode()
        group.name = "Glycine_\(index)"
        group.position = scenePosition(aa.position)

        /*
         Glycine is explicitly represented as:

                 H
                 |
             H - N
                 |
                 C
                / \
               H   H
                   |
                   C
                  / \
                 O   O-H

         Linear chemical notation:

             NH₂–CH₂–COOH
        */

        let alphaCarbon = atom(.gray, 0.19)
        alphaCarbon.name = "Gly_\(index)_CH2"
        group.addChildNode(alphaCarbon)

        // Amino nitrogen: NH2
        let nitrogen = atom(.blue, 0.14)
        nitrogen.name = "Gly_\(index)_N"
        nitrogen.position = SCNVector3(-0.38, 0.0, 0)
        group.addChildNode(nitrogen)

        // Two hydrogens attached to nitrogen.
        let aminoHydrogen1 = atom(.white, 0.075)
        aminoHydrogen1.name = "Gly_\(index)_NH2_H1"
        aminoHydrogen1.position = SCNVector3(
            -0.55,
            0.18,
            0.08
        )
        group.addChildNode(aminoHydrogen1)

        let aminoHydrogen2 = atom(.white, 0.075)
        aminoHydrogen2.name = "Gly_\(index)_NH2_H2"
        aminoHydrogen2.position = SCNVector3(
            -0.55,
            -0.18,
            0.08
        )
        group.addChildNode(aminoHydrogen2)

        // Two hydrogens on the glycine CH2 group.
        let alphaHydrogen1 = atom(.white, 0.075)
        alphaHydrogen1.name = "Gly_\(index)_CH2_H1"
        alphaHydrogen1.position = SCNVector3(
            -0.02,
            0.22,
            0.12
        )
        group.addChildNode(alphaHydrogen1)

        let alphaHydrogen2 = atom(.white, 0.075)
        alphaHydrogen2.name = "Gly_\(index)_CH2_H2"
        alphaHydrogen2.position = SCNVector3(
            0.02,
            -0.22,
            -0.12
        )
        group.addChildNode(alphaHydrogen2)

        // Carboxyl carbon.
        let carboxylCarbon = atom(.gray, 0.17)
        carboxylCarbon.name = "Gly_\(index)_COOH_C"
        carboxylCarbon.position = SCNVector3(
            0.48,
            0,
            0
        )
        group.addChildNode(carboxylCarbon)

        // Carbonyl oxygen: C=O.
        let carbonylOxygen = atom(.red, 0.13)
        carbonylOxygen.name = "Gly_\(index)_C_O"
        carbonylOxygen.position = SCNVector3(
            0.68,
            0.25,
            0
        )
        group.addChildNode(carbonylOxygen)

        // Hydroxyl oxygen: C–OH.
        let hydroxylOxygen = atom(.red, 0.13)
        hydroxylOxygen.name = "Gly_\(index)_OH_O"
        hydroxylOxygen.position = SCNVector3(
            0.68,
            -0.25,
            0
        )
        group.addChildNode(hydroxylOxygen)

        // Hydroxyl hydrogen.
        let hydroxylHydrogen = atom(.white, 0.075)
        hydroxylHydrogen.name = "Gly_\(index)_OH_H"
        hydroxylHydrogen.position = SCNVector3(
            0.88,
            -0.38,
            0
        )
        group.addChildNode(hydroxylHydrogen)

        // Explicit molecular bonds inside Gly.
        addBond(
            from: SCNVector3(-0.25, 0, 0),
            to: SCNVector3(-0.12, 0, 0),
            radius: 0.025,
            to: group
        )

        addBond(
            from: SCNVector3(0.19, 0, 0),
            to: SCNVector3(0.31, 0, 0),
            radius: 0.025,
            to: group
        )

        addBond(
            from: SCNVector3(-0.40, 0.08, 0),
            to: SCNVector3(-0.49, 0.15, 0.05),
            radius: 0.018,
            to: group
        )

        addBond(
            from: SCNVector3(-0.40, -0.08, 0),
            to: SCNVector3(-0.49, -0.15, 0.05),
            radius: 0.018,
            to: group
        )

        addBond(
            from: SCNVector3(0.06, 0.15, 0.08),
            to: SCNVector3(0.02, 0.20, 0.10),
            radius: 0.018,
            to: group
        )

        addBond(
            from: SCNVector3(0.06, -0.15, -0.08),
            to: SCNVector3(0.02, -0.20, -0.10),
            radius: 0.018,
            to: group
        )

        // C=O represented with two parallel cylinders.
        addDoubleBond(
            from: SCNVector3(0.58, 0.08, 0),
            to: SCNVector3(0.65, 0.20, 0),
            to: group
        )

        addBond(
            from: SCNVector3(0.58, -0.08, 0),
            to: SCNVector3(0.65, -0.20, 0),
            radius: 0.025,
            to: group
        )

        addBond(
            from: SCNVector3(0.77, -0.27, 0),
            to: SCNVector3(0.86, -0.34, 0),
            radius: 0.018,
            to: group
        )

        // Formula label.
        addStructureLabel(
            "NH₂–CH₂–COOH",
            position: SCNVector3(-0.75, 0.62, 0),
            to: group
        )

        root.addChildNode(group)
    }

    // MARK: - Water

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
                    SCNAction.moveBy(
                        x: 0,
                        y: 0.10,
                        z: 0,
                        duration: 0.7
                    ),
                    SCNAction.moveBy(
                        x: 0,
                        y: -0.10,
                        z: 0,
                        duration: 0.7
                    )
                ])
            )
        )

        root.addChildNode(water)
    }

    // MARK: - Labels

    private func addLabels(
        to root: SCNNode,
        engine: PeptideAssemblyEngine
    ) {
        let title = SCNText(
            string: engine.stage.title,
            extrusionDepth: 0.002
        )

        title.font = UIFont.systemFont(
            ofSize: 0.13,
            weight: .semibold
        )

        title.firstMaterial = atomMaterial(.white)

        let node = SCNNode(geometry: title)
        node.position = SCNVector3(-2.3, 2.0, 0)
        node.scale = SCNVector3(0.55, 0.55, 0.55)

        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .all
        node.constraints = [constraint]

        root.addChildNode(node)

        // Explicitly identify the programmed molecular sequence.
        let sequenceText = SCNText(
            string: "Gly₄: NH₂–CH₂–COOH × 4",
            extrusionDepth: 0.001
        )

        sequenceText.font = UIFont.systemFont(
            ofSize: 0.10,
            weight: .regular
        )

        sequenceText.firstMaterial = atomMaterial(.white)

        let sequenceNode = SCNNode(geometry: sequenceText)
        sequenceNode.position = SCNVector3(-2.3, 1.72, 0)
        sequenceNode.scale = SCNVector3(0.45, 0.45, 0.45)

        let sequenceConstraint = SCNBillboardConstraint()
        sequenceConstraint.freeAxes = .all
        sequenceNode.constraints = [sequenceConstraint]

        root.addChildNode(sequenceNode)
    }

    private func addStructureLabel(
        _ textString: String,
        position: SCNVector3,
        to parent: SCNNode
    ) {
        let text = SCNText(
            string: textString,
            extrusionDepth: 0.001
        )

        text.font = UIFont.systemFont(
            ofSize: 0.08,
            weight: .medium
        )

        text.firstMaterial = atomMaterial(.white)

        let node = SCNNode(geometry: text)
        node.position = position
        node.scale = SCNVector3(0.45, 0.45, 0.45)

        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .all
        node.constraints = [constraint]

        parent.addChildNode(node)
    }

    // MARK: - Bonds

    private func addBond(
        from: SCNVector3,
        to: SCNVector3,
        radius: CGFloat,
        to parent: SCNNode
    ) {
        let bond = cylinder(
            from: from,
            to: to,
            radius: radius,
            material: atomMaterial(.white)
        )

        parent.addChildNode(bond)
    }

    private func addDoubleBond(
        from: SCNVector3,
        to: SCNVector3,
        to parent: SCNNode
    ) {
        let offset: Float = 0.025

        let bond1 = cylinder(
            from: SCNVector3(
                from.x,
                from.y,
                from.z + offset
            ),
            to: SCNVector3(
                to.x,
                to.y,
                to.z + offset
            ),
            radius: 0.018,
            material: atomMaterial(.white)
        )

        let bond2 = cylinder(
            from: SCNVector3(
                from.x,
                from.y,
                from.z - offset
            ),
            to: SCNVector3(
                to.x,
                to.y,
                to.z - offset
            ),
            radius: 0.018,
            material: atomMaterial(.white)
        )

        parent.addChildNode(bond1)
        parent.addChildNode(bond2)
    }

    // MARK: - Atom Helpers

    private func atom(
        _ color: UIColor,
        _ radius: CGFloat
    ) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 18
        sphere.firstMaterial = atomMaterial(color)
        return SCNNode(geometry: sphere)
    }

    private func atomMaterial(
        _ color: UIColor
    ) -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = color
        m.metalness.contents = 0.1
        m.roughness.contents = 0.35
        return m
    }

    private func haloMaterial(
        _ value: Double
    ) -> SCNMaterial {
        let m = SCNMaterial()

        m.diffuse.contents =
            UIColor.cyan.withAlphaComponent(
                CGFloat(min(0.22, value * 0.4))
            )

        m.emission.contents =
            UIColor.cyan.withAlphaComponent(
                CGFloat(min(0.15, value * 0.25))
            )

        m.transparency = 0.55

        return m
    }

    // MARK: - Geometry

    private func scenePosition(
        _ p: SIMD3<Double>
    ) -> SCNVector3 {
        SCNVector3(
            Float(p.x),
            Float(p.y),
            Float(p.z)
        )
    }

    private func midpoint(
        _ a: SIMD3<Double>,
        _ b: SIMD3<Double>
    ) -> SIMD3<Double> {
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

        let length = sqrt(
            dx * dx +
            dy * dy +
            dz * dz
        )

        let geometry = SCNCylinder(
            radius: radius,
            height: CGFloat(length)
        )

        geometry.radialSegmentCount = 12
        geometry.firstMaterial = material

        let node = SCNNode(geometry: geometry)

        node.position = SCNVector3(
            (from.x + to.x) / 2,
            (from.y + to.y) / 2,
            (from.z + to.z) / 2
        )

        let vector = SCNVector3(
            dx,
            dy,
            dz
        )

        node.rotation = rotationBetween(
            SCNVector3(0, 1, 0),
            vector
        )

        return node
    }

    private func rotationBetween(
        _ a: SCNVector3,
        _ b: SCNVector3
    ) -> SCNVector4 {

        let aa = normalize(a)
        let bb = normalize(b)

        let cross = SCNVector3(
            aa.y * bb.z - aa.z * bb.y,
            aa.z * bb.x - aa.x * bb.z,
            aa.x * bb.y - aa.y * bb.x
        )

        let dot = max(
            -1.0,
            min(
                1.0,
                aa.x * bb.x +
                aa.y * bb.y +
                aa.z * bb.z
            )
        )

        let angle = acos(dot)

        let n = sqrt(
            cross.x * cross.x +
            cross.y * cross.y +
            cross.z * cross.z
        )

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

    private func normalize(
        _ v: SCNVector3
    ) -> SCNVector3 {

        let n = sqrt(
            v.x * v.x +
            v.y * v.y +
            v.z * v.z
        )

        if n < 0.00001 {
            return SCNVector3(0, 1, 0)
        }

        return SCNVector3(
            v.x / n,
            v.y / n,
            v.z / n
        )
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

        let horizontal = sqrt(
            d.x * d.x +
            d.z * d.z
        )

        eulerAngles = SCNVector3(
            -atan2(d.y, horizontal),
            atan2(d.x, d.z),
            0
        )
    }
}



