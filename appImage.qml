import QtQuick 2.4
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.0

Rectangle {
    id: app
    width: 1600
    height: 900

    property alias timer: timer
    property var imageList: []
    property var index: 0

    Timer {
        id: timer

        // Start the timer and execute the provided callback on every X milliseconds
        function startTimer(callback, milliseconds) {
            timer.interval = milliseconds;
            timer.repeat = true;
            timer.triggered.connect(callback);
            timer.start();
        }

        // Stop the timer and unregister the callback
        function stopTimer(callback) {
            timer.stop();
            timer.triggered.disconnect(callback);
        }
    }

    Rectangle {
        id: rectangle
        color: "#083142"
        anchors.fill: parent

        Image {
            id: dataImage
            y: 252
            width: 795
            height: 596
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            source: "img/empty.png"
            anchors.bottomMargin: 60
            anchors.leftMargin: 60
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: appName
            x: 445
            y: 59
            width: 778
            height: 51
            color: "#F9F871"
            text: qsTr("Distracted Driver Detection")
            anchors.horizontalCenter: parent.horizontalCenter
            font.weight: Font.Bold
            font.bold: true
            font.pointSize: 30
            font.family: "Verdana"
        }

        Label {
            id: statusLabel
            x: 1124
            y: 244
            width: 224
            height: 51
            color: "#3aeb64"
            text: qsTr("STATUS")
            font.pointSize: 30
            font.bold: true
            font.family: "Verdana"
            font.weight: Font.Bold
        }

        Label {
            id: predLabel
            x: 967
            y: 447
            width: 517
            height: 190
            color: "#ffffff"
            text: qsTr("")
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 32
            font.family: "Verdana"
        }

        RoundButton {
            id: startButton
            x: 1276
            y: 776
            width: 232
            height: 64
            radius: 5
            text: qsTr("Start")
            font.pointSize: 15
            font.family: "Verdana"
            highlighted: true

            onClicked: {
                if (text === qsTr("Start")) {
                    text = qsTr("Stop")
                    highlighted = true
                    Material.background = Material.Red
                    imageList = con.getImageList()
                    timer.startTimer(predImage, 2000)
                } else {
                    text = qsTr("Start")
                    highlighted = true
                    Material.background = Material.Teal
                    timer.stopTimer(predImage)
                    index = 0
                }
            }
        }

        RoundButton {
            id: chooseImageButton
            x: 957
            y: 776
            width: 232
            height: 64
            radius: 5
            text: qsTr("Choose Image")
            font.pointSize: 12
            font.family: "Verdana"

            onClicked: {
                fileDialog.visible = true
            }
        }

        RoundButton {
            id: backButton
            x: 60
            y: 59
            width: 161
            height: 64
            radius: 5
            text: qsTr("Back")
            font.pointSize: 15
            font.family: "Verdana"
            highlighted: true
            Material.background: Material.Blue

            onClicked: {
                mainLoader.source = "appOption.qml"
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.desktop
        nameFilters: "Image files (*.jpg *.png)"

        onAccepted: {
            dataImage.source = fileDialog.fileUrls.toString()
            predLabel.text = con.getImagePred(fileDialog.fileUrls.toString().replace(/^(file:\/{3})/,""))
        }

        Component.onCompleted: visible = false
    }

    function predImage() {
        if (index < imageList.length) {
            dataImage.source = imageList[index]
            predLabel.text = con.getImagePred(imageList[index].replace(/^(file:\/{3})/,""))
            index = index + 1
        } else {
            button.clicked()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}
}
##^##*/
