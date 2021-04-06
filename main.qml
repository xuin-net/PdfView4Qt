import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Window {
    id: rootwin
    visible: true
    width: 1280
    height: 960
    title: qsTr("Pdf View")

    Button {
        text: qsTr("打开PDF")
        onClicked: {
            if (Qt.platform.os === "osx") {
                PdfProvider.loadFile("../../../210207_Client@xuin.pdf",
                                    rootwin.width, rootwin.height, 0)
            } else {
                PdfProvider.loadFile("210207_Client@xuin.pdf",
                                    rootwin.width, rootwin.height, 0)
            }

            pdfModel.clear()
            for (var i=0;i<PdfProvider.pageCnt;++i) {
                pdfModel.append({"page": i})
            }
            pdfView.visible = true;
        }
    }

    ListModel {
        id: pdfModel;
    }

    Rectangle {
        id: pdfView
        visible: false
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#E4E7ED"
        clip: true

        ListView {
            width: parent.width
            height: parent.height
            topMargin: 32
            bottomMargin: 32
            spacing: 24

            model: pdfModel
            delegate: Item {
                id: content
                width: 953;height: 1347
                anchors.horizontalCenter: parent.horizontalCenter

                RectangularGlow {
                    id: effect
                    anchors.centerIn: content;
                    width: content.width - glowRadius - glowRadius * spread
                    height: content.height - glowRadius - glowRadius * spread
                    glowRadius: 80
                    spread: 0.02
                    color: "#CFCFCF"
                    cornerRadius: 0
                }

                Image {
                    anchors.fill: parent;
                    fillMode: Image.PreserveAspectFit
                    source: "image://pdfpage/" + String(page)
                }
            }

            ScrollBar.vertical: ScrollBar { width: 16 }
        }
    }

}
