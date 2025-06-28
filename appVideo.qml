import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.0

Rectangle {
    id: app
    width: 1600
    height: 900
    color: "#083142"

    property alias timer: timer
    property var imageVidList: []
    property var predIndex: 0

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

    Image {
        id: videoImage
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
        id: chooseVideoButton
        x: 1120
        y: 776
        width: 232
        height: 64
        radius: 5
        text: qsTr("Choose Video")
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

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.desktop
        nameFilters: "Video files (*.mp4)"

        onAccepted: {
            imageVidList = con.prepareVideo(fileDialog.fileUrls.toString().replace(/^(file:\/{3})/,""))
            timer.startTimer(predVideo, 500)
        }

        Component.onCompleted: visible = false
    }


    function predVideo() {
        if (predIndex < imageVidList.length) {
            videoImage.source = imageVidList[predIndex]
            predLabel.text = con.getImagePred(imageVidList[predIndex].replace(/^(file:\/{3})/,""))
            predIndex = predIndex + 1
        }
    }

}
